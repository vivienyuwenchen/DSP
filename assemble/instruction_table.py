#############################
#    SZ, TZ, ZM             #
#    10/3/2013              #
#    instruction_table.py   #
#############################

# Create the Symbol Table as a dictionary. This table stores ROM addresses of each reserved register in our MIPS
# Assembler


# nstruction format length
# 6 : R
# 4 : I
# 2 : J

# All values in HEX
instruction_table = {
#Accumulator Instruction
	'AB'	: ['0111111110001000'],
	'ADD'	: ['0000', 's', '0', 'd'],
	'ADDH'  : ['01100000','0','d'],
	'ADDS'	: ['01100001', '0','d'],
	'AND'	: ['01100001', '0','d'],
	'LAC'	: ['0010','s','0', 'd' ],
	'LACK'	: ['01111110','k'],
	'OR'	: ['01111010','0', 'd'],
	'SUB'	: ['0001', 's', '0','d'],
	'ZA'	: ['0111111110001001'],
#Aux Register, Data Page pointer instructions
	'LDP'	: ['01101111','0', 'd'],
#T Register, P Register, and multiply instructions
	'LT'	: ['01101010','0','d'],
	'LTA'	: ['01101100', '0', 'd'],
	'APA'	: ['0111111110001111'],
	'PA'	: ['0111111110001110'],
	'SPA'	: ['0111111110010000'],
	'MPY'	: ['01101101', '0', 'd']
	}
