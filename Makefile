toplevel: TopLevel.t.v
	iverilog -o toplevel.o TopLevel.t.v
	./toplevel.o

tests: accumulator.t.v alu.t.v datamemory.t.v decoder.t.v dff.t.v instructionmemory.t.v multiplier.t.v muxes.t.v shifters.t.v
	iverilog -o accumulator.o accumulator.t.v
	iverilog -o alu.o alu.t.v
	iverilog -o datamemory.o datamemory.t.v
	iverilog -o decoder.o decoder.t.v
	iverilog -o dff.o dff.t.v
	iverilog -o instructionmemory.o instructionmemory.t.v
	iverilog -o multiplier.o multiplier.t.v
	iverilog -o muxes.o muxes.t.v
	iverilog -o shifters.o shifters.t.v
	./accumulator.o
	./alu.o
	./datamemory.o
	./decoder.o
	./dff.o
	./instructionmemory.o
	./multiplier.o
	./muxes.o
	./shifters.o

clean:
	rm *.o
	rm *.out
	rm *.vcd

run:
	make toplevel
	make tests
	make clean
