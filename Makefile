toplevel: toplevel.t.v
	iverilog -o toplevel.o toplevel.t.v
	./toplevel.o

tests: basicbuildingblocks.t.v
	iverilog -o basicbuildingblocks.o basicbuildingblocks.t.v
	./basicbuildingblocks.o

clean:
	rm *.o
	rm *.vcd

run:
	make toplevel
	make tests
	make clean
