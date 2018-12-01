toplevel: toplevel.t.v
	iverilog -o toplevel.o toplevel.t.v
	./toplevel.o

tests: alu.t.v muxes.t.v
	iverilog -o alu.o alu.t.v
	iverilog -o muxes.o muxes.t.v
	iverilog -o shifters.o shifters.t.v
	./alu.o
	./muxes.o
	./shifters.o

clean:
	rm *.o
	rm *.vcd

run:
	make toplevel
	make tests
	make clean
