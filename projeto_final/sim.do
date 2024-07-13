quit -sim
vlog *.sv
vsim -displaymsgmode both work.testbench

add wave sim:/testbench/*

run 0.14ns