:: run Assembler
python -u "d:\CUFE24\3rd year\first term\Computer Architecture\Five-stages-Pipeline-Processor\asm.py"

:: Run Assembler
::main %1
::vsim -c
:: Run ModelSim Do File
vsim -do "source run3.do"

::Run Python script
::python Test.py %2

:: Draw Wave Form
::vsim -do "vsim -view vsim.wlf; add wave -r *"