import sys
import argparse

NUMBER_OF_BITS = 16
INTERRUPT_ADDRESS = 1


class Assembler(object):
    ZERO_OPERAND_INST = 0
    ONE_OPERAND_INST = 1
    TWO_OPERAND_INST = 2
    THREE_OPERAND_INST = 3

    def hexToBinary(self,hex_num):
        hex_as_int = int(hex_num, 16)
        binary_num = bin(hex_as_int)
        binary_num = binary_num[2:].zfill(16)

        return binary_num

    def hexToBinaryShift(self,hex_num):
        hex_as_int = int(hex_num, 16)
        binary_num = bin(hex_as_int)
        binary_num = binary_num[2:].zfill(4)

        return binary_num        

    def __init__(self, path, code_output_path, data_output_path):
        self.path = path
        self.code_output_path = code_output_path
        self.data_output_path = data_output_path

        self.registers = {'r0': '000', 'r1': '001', 'r2': '010', 'r3': '011', 'r4': '100', 'r5': '101',
                          'r6': '110', 'r7': '111'}

        self.file_lines = []
        self.code_seg_start_line = 0

        self.current_code_mem_location = 0
        self.current_data_mem_location = 0

        self.variables = {}

        self.binary_code = {}
        self.instructions = self.__read_dict("instructions_dictionary.txt", ' ')

    def parse(self):
        self.__read_code_file()
        self.__parse_data_seg()
        self.__scan_code()
        self.__save_instructions()
        self.__save_data()

    # Get the instruction information (Type, number of operands, size in RAM file, etc)
    def __get_instruction_info(self, line):
        # Return instruction info and operands count
        words = line.split(" ", 1)
        # Remove all spaces.
        words[0] = words[0].replace(" ", "")
        if len(words) > 1: 
            words[1] = words[1].replace(" ", "")
            if (len(words[1]) == 0):
                words = [words[0]]

        ir = ''
        category = -1
        size = 1
        ir = self.instructions[words[0]]

        if len(words) == 1:  # No operand instructions.
            category = Assembler.ZERO_OPERAND_INST
            if words[0] == 'rti' or words[0] == 'ret':
                ir += '00000000100'
            else:
                ir += '00000000000'        
            print (words, "NO OPERAND", size, ir)

        elif len(words[1].split(",")) < 3:

            if len(words[1].split(",")) == 1:  # One operand instructions.
                category = Assembler.ONE_OPERAND_INST

                if words[0][0] == "j":  # Branch instructions
                    src = words[1]
                    ir += "000" + self.registers[src] + '00000'
                    print (words, "BRANCH", size, ir)

                elif words[0] == 'in':
                    destination = words[1]
                    ir += "000" + self.registers[destination] + "00000"
                    print(words, "IN", size, ir)

                elif words[0] == 'out':
                    source = words[1]
                    ir += "000" + self.registers[source] + '00000'
                    print(words, "OUT", size, ir)

                elif len(self.instructions[words[0]]) == 13:  # CALL, PUSH or POP instructions.
                    register = words[1]
                    ir += "000" + self.registers[register]
                    print (words, "CALL PUSH POP OPERAND", size, ir)

                else:  # One operand ALU instructions
                    register = words[1]
                    print(words[0])
                    if words[0] == 'call':
                        ir += "000" + self.registers[register] + '00100'
                    else:    
                        ir += "000" + self.registers[register] + '00000'
                    # ir += "000" + self.registers[register]
                    print (words, "ONE ALU OPERAND", size, ir)

            else:  # Two operand instructions.
                category = Assembler.TWO_OPERAND_INST

                if words[0] == "ldm":  # LDM instruction.
                    size = 2
                    destination, immediate_value = words[1].split(",")
                    immediate_value = self.hexToBinary(immediate_value)
                    ir += "000" + self.registers[destination] + "00100"
                    ir += "," + immediate_value 
                    print (words, "LDM TWO OPERAND", size, ir)

                elif words[0] == "ldd":
                    source, destination = words[1].split(",")
                    ir +=  self.registers[source] + self.registers[destination] + '00000'
                    print (words, "LDD TWO OPERAND", size, ir)

                elif words[0] == "std":
                    source, destination = words[1].split(",")
                    ir += self.registers[destination] + self.registers[source] + '00000'
                    print (words, "STD TWO OPERAND", size, ir)

                elif words[0] == "shl" or words[0] == 'shr':
                    size = 1
                    ir += '000'
                    source, immediate_value  = words[1].split(",")
                    immediate_value = self.hexToBinaryShift(immediate_value)
                    # Ignore instructions if the immediate shift value is zero
                    # if immediate_value <= 0000:
                    #     size = 0
                    
                    # Limit immediate value to max 16
                    # immediate_value = min(1110, immediate_value)
                    ir += self.registers[source] + immediate_value + '0'  
                    print (words, "SHL SHR THREE OPERAND", size, ir)
                    

                else:  # Two operand ALU instructions.
                    destination,source = words[1].split(",")
                    ir += self.registers[destination] + self.registers[source]
                    ir += '00001'
                    print (words, "ALU TWO / MOV OPERAND", size, ir)

        # else:  # Three operand instructions.
        #     category = Assembler.THREE_OPERAND_INST
        #     size = 1
        #     ir += '000'
        #     source, immediate_value, destination = words[1].split(",")
        #     immediate_value = int(immediate_value)
        #     # Ignore instructions if the immediate shift value is zero
        #     if immediate_value <= 0:
        #         size = 0

        #     # Limit immediate value to max 16
        #     immediate_value = min(15, immediate_value - 1)

        #     ir += self.registers[source] + ('0' * (4 - len(bin(immediate_value)[2:]))) + bin(immediate_value)[2:]       
        #     print (words, "SHL SHR THREE OPERAND", size, ir)
        return ir, category, size

    def __read_code_file(self):
        # Read the file info string
        with open(self.path) as fp:
            line = fp.readline()
            isr_address_line = True
            while line:
                if len(line.strip()) != 0 and line.strip()[0] != ";" and line.strip()[:2] != "//" and line.strip()[0] != "#":
                    line = line.strip().lower()
                    line = line.split(";", 1)[0]
                    line = line.split("#", 1)[0]
                    self.file_lines.append(line)
                line = fp.readline()

    # Get the data variables.
    def __parse_data_seg(self):
        current_line = -1
        data_seg = False

        for line in self.file_lines:
            current_line += 1
            line_words = line.split(" ", 1)

            if line_words[0] == ".data":
                data_seg = True
                if len(line_words) > 1:
                    if (len(line_words[1].replace(" ", "")) >= 1):
                        self.current_data_mem_location = max(int(line_words[1]), 0)
                continue
            elif line_words[0] == ".org" and line_words[1] == "0":
                self.code_seg_start_line = current_line
                data_seg = False
                break

            if not data_seg:
                continue

            value = line
            value = value.replace(" ", "")
            value = int(value)
            address = self.current_data_mem_location
            self.current_data_mem_location += 1
            self.variables[address] = ('0' * (NUMBER_OF_BITS - len(bin(value)[2:]))) + bin(value)[2:]

    # Scan the code to get instructions.
    def __scan_code(self):
        # Get the start address of the code in the memory. found in ".code X" line
        code_line_words = self.file_lines[self.code_seg_start_line].split(" ", 1)
        if len(code_line_words) > 1:
            if (len(code_line_words[1].replace(" ", "")) >= 1):
                self.current_code_mem_location = int(code_line_words[1])

        # Scan to get variables/labels
        for i in range(self.code_seg_start_line + 1, len(self.file_lines)):
            line = self.file_lines[i]
            line_words = line.split(" ", 1)

            if line_words[0] == '.data':
                break
            elif line_words[0][0] == ".":
                # A new sub routine, change the start address.
                # print(line_words[1])
                self.current_code_mem_location = int(line_words[1])
                continue

            ir, category, size = self.__get_instruction_info(line)

            if size > 0:
                self.binary_code[self.current_code_mem_location] = ir

            self.current_code_mem_location += size

    def __save_instructions(self):
        with open(self.code_output_path, "w") as f:
            f.write("// memory data file (do not edit the following line - required for mem load use)" + '\n')
            f.write("// instance=/processor/PROG_MEM/Mem" + '\n')
            f.write("// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1" + '\n')

            size = 0
            while size < pow(2,20):
                if size in self.binary_code.keys():
                    ir_code = self.binary_code[size]
                    if ir_code != '':
                        for code in ir_code.split(','):
                            f.write(" " * (4 - len(str(size))) + str(size) + ": " + str(code) + '\n')
                            for i in range(len(code), 16):
                                code += '0'
                            # f.write(" " * (4 - len(str(size))) + str(size) + ": " + str(code) + '\n')
                            # f.write(str(code) + '\n')
                            size += 1
                else:
                    f.write(" " * (4 - len(str(size))) + str(size) + ": " + ('0' * NUMBER_OF_BITS) + '\n')
                    # f.write(('0' * NUMBER_OF_BITS) + '\n')
                    size += 1

    def __save_data(self):
        with open(self.data_output_path, "w") as f:
            f.write("// memory data file (do not edit the following line - required for mem load use)" + '\n')
            f.write("// instance=/processor/DATA_MEM/Mem" + '\n')
            f.write("// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1" + '\n')

            size = 0
            while size < pow(2,20):
                if size in self.variables.keys():
                    f.write(" " * (4 - len(str(size))) + str(size) + ": " + self.variables[size] + '\n')
                    # f.write(self.variables[size] + '\n')
                else:
                    f.write(" " * (4 - len(str(size))) + str(size) + ": " + ('0' * NUMBER_OF_BITS) + '\n')
                    # f.write(('0' * NUMBER_OF_BITS) + '\n')
                size += 1

    # Read instructions dictionary.
    @staticmethod
    def __read_dict(filename, sep):
        with open(filename, "r") as f:
            dict_ret = {}
            values = []
            for line in f:
                if len(line.strip()) != 0 and line.strip()[0] != "#" and line.strip()[:2] != "//":
                    line = line.rstrip()
                    line = line.lower()
                    values.append(line.split(sep))
            for value in values:
                dict_ret[value[0]] = value[1]
        return dict_ret


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', type=str, help='The assembly code input file.')
    args, unparsed = parser.parse_known_args()
    code_file_path = 'code.asm'
    code_ram_file_path = 'CODE_RAM.mem'
    data_ram_file_path = 'DATA_RAM.mem'
    if args.i is not None: code_file_path = args.i
    a = Assembler(code_file_path, code_ram_file_path, data_ram_file_path)
    a.parse()