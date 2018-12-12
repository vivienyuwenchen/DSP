##############################
#    SZ, TZ, ZM              #
#    10/3/2013               #
#      assembly_parser.py    #
##############################

import re

class command(object):
    def __init__(self, cmd_string):
        return


class assembly_parser(object):

    # Word size
    word_size = 4

    # Default memory location
    default_mem_loc  = 0

    # List of labels and their respective locations
    symbol_table = {}

    # Current location in memory
    current_location = 0

    # dictionary of memory locations w/ their values
    system_memory = {}

    # current instruction table
    instruction_table = {}

    # current symbol table
    register_table = {}

    # current pseudoinstruction table
    pseudinstr_table = {}

    # Output for zengxu's wishes
    output_array = []

    def __init__(self, default_memory_location, instruction_table, register_table, pseudoinstruction_table, word_size):
        ''' Initialize tables and memory
        '''
        self.default_mem_loc    = default_memory_location
        self.instruction_table  = instruction_table
        self.register_table     = register_table
        self.pseudinstr_table   = pseudoinstruction_table
        self.word_size          = word_size

    def first_pass(self, lines):
        ''' For first pass, calculate size in mem of each instruction for calculating addressing
        '''
        self.current_location = self.default_mem_loc
        for line in lines:

            # Sanitize string (comments, whitespace, etc.)
            if '#' in line:
                line = line[0:line.find('#')]
            line = line.strip()
            if not len(line):
                continue

            # Make sure memory locations line up before allocating memory for bytes
            self.fix_current_location()

            # Label recognition
            if ':' in line:
                label = line[0:line.find(':')]
                self.symbol_table[label] = str(self.current_location)
                line = line[line.find(':') + 1:].strip()

            # Go to proper address, increment for all stored memory
            if '.' in line:
                if '.org' in line:
                    self.current_location = int(line[line.find('.org') + len('.org'):])
                    continue
                if '.byte' in line:
                    bytes = line[line.find('.byte') + len('.byte'):].split(',')
                    for byte in bytes:
                        self.current_location += 1
                    continue
                if '.end' in line: #now we support magical directives that appear later in the project
                    continue #now we support magical directives that appear later in the project

            # Make sure memory location lines up with divisions of 4
            self.fix_current_location()

            # Parse instructions to establish mem size
            instruction = line[0:line.find(' ')]
            args        = line[line.find(' ') + 1:].replace(' ', '').split(',')
            if not instruction:
                continue

            # Sanitize arguments so every numeric is decimal
            acount = 0
            for arg in args:
                if arg not in self.symbol_table.keys():
                    if arg[-1] == 'H':
                        args[acount] = str(int(arg[:-1], 16))
                    elif arg[-1] == 'B':
                        args[acount] = str(int(arg[:-1], 2))
                acount += 1

            self.current_location += self.calculate_instruction_size(instruction, args)

    def second_pass(self, lines):
        ''' For second pass, we convert assembly to machine code
        '''

        self.current_location = self.default_mem_loc
        for line in lines:

            # Sanitize string (comments, whitespace, etc.)
            if '#' in line:
                line = line[0:line.find('#')]
            line = line.strip()
            if not len(line):
                continue

            # Make sure memory location lines up with divisions of word_size before storing bytes
            self.fix_current_location()

            # Label ignorator
            if ':' in line:
                label = line[0:line.find(':')]
                line = line[line.find(':') + 1:].strip()
                self.output_array.append( '\n' + hex(int(self.symbol_table[label])) + ' <' + label + '>:' )

            # Assembler directives: .org, .byte, etc.
            if '.' in line:
                if '.org' in line:
                    self.current_location = int(line[line.find('.org') + len('.org'):])
                    continue
                if '.byte' in line:
                    bytes = line[line.find('.byte') + len('.byte'):].split(',')
                    for byte in bytes:
                        byte = byte.strip()
                        if 'H' in byte:
                            byte = hex(int(byte[0:-1], 16))
                        elif 'B' in byte:
                            byte = hex(int(byte[0:-1], 2))
                        else:
                            byte = hex(int(byte))
                        self.store_bit_string(self.hex2bin(byte.strip(), 8), 'BYTE', [])
                    continue
                if '.end' in line: #now we support magical directives that appear later in the project
                    continue #now we support magical directives that appear later in the project

            # Make sure memory locations line up after storing bytes
            self.fix_current_location()

            # Parse the line!
            instruction = line[0:line.find(' ')].strip()
            args        = line[line.find(' ') + 1:].replace(' ', '').split(',')

            if not instruction:
                continue

            # Sanitize arguments so every numeric is decimal
            acount      = 0
            for arg in args:
                if arg not in self.symbol_table.keys():
                    if arg[-1] == 'H':
                        args[acount] = str(int(arg[:-1], 16))
                    elif arg[-1] == 'B':
                        args[acount] = str(int(arg[:-1], 2))
                acount += 1

            # Create function code from instruction table
            if instruction in self.pseudinstr_table.keys():
                self.parse_pseudoinstruction(instruction, args)
            elif instruction in self.instruction_table.keys():
                self.parse_instruction(instruction, args)

            else:
                print( "INSTRUCTION: " + instruction + " IS INVALID! ABORT")
                exit()

        self.print_memory_map()


    def parse_instruction(self, instruction, raw_args):
        ''' Parses instruction, places proper hex into memory
            Different cases for R, I, J instructions
        '''

        machine_code = self.instruction_table[instruction]
        print(machine_code)
        # parse arguments
        arg_count = 0
        offset    = 'not_valid'
        args      = raw_args[:]
        for arg in args:
            if '(' in arg:

                # Parse offset from known syntax
                offset   = hex(int(arg[0:arg.find('(')]))
                register = re.search('\((.*)\)', arg)

                # Location in memory is offset from memory location
                location = self.register_table[register.group(1)]
                register = location

                # Finish processing args
                args[arg_count] = register

            elif arg in self.register_table.keys():

                # Replace symbol with value in table
                args[arg_count] = int(self.register_table[arg])

            elif arg in self.symbol_table:
                # Replace label with its value
                args[arg_count] = self.symbol_table[arg]
            elif 's' in arg:                    #added by sam
                args[arg_count] = '{:04b}'.format(arg)
                print(args[arg_count])
            elif 'd' in arg:                    #added by sam
                args[arg_count] ='{:07b}'.format(arg)
                print(args[arg_count])


            # Increment argument counter for modifying list
            arg_count += 1

        # Branch instructions are all relative to location
        if (instruction == 'beq' or instruction == 'bne'):
            args[2] = (int(args[2]) - self.current_location - 4)/4
        # Jump instructions are all absolute divisions of 4 of the location (word loc)
        if (instruction == 'j' or instruction == 'jal' or instruction == 'jr'):
            args[0] = str(int(args[0])/4)
        # Finally convert each value to hex
        #for i in range(0, len(args)):
        #    args[i] = str(hex(int(args[i])))


        # R instruction
        if len(machine_code) == 1:
            print(machine_code)
            self.store_bit_string(machine_code[0], instruction, raw_args)
            return

        if len(machine_code) == 2:

            print(machine_code)
            print(args)
            # Set rs, rt, imm in the machine_code
            k = int(args[0])
            print(k)
            machine_code[1] = k
            print(machine_code)

            # Get binary of machine code
            op_binary = (machine_code[0])
            print(op_binary)
            #opp_binary = '{:04b}'.format(machine_code[0])
            k_binary ='{:08b}'.format(machine_code[1])
            print(k_binary)

            # Create 32-bit string to divide up into bytes
            bit_string = op_binary + k_binary
            print(bit_string)
            self.store_bit_string(bit_string, instruction, raw_args)
            return
        if len(machine_code) == 3:
            print(machine_code)
            print(args)
            # Set rs, rt, imm in the machine_code
            dma = int(args[0])

            machine_code[2] = dma
            print(machine_code)

            # Get binary of machine code
            op_binary = machine_code[0]
            print("op: " +op_binary)
            arp_binary = '{:01b}'.format(int(machine_code[1]))
            print("arp: " +arp_binary)
            dma_binary = '{:07b}'.format(machine_code[2])
            print("dma: " +dma_binary)
            # Create 32-bit string to divide up into bytes
            bit_string = op_binary +  arp_binary + dma_binary
            print(bit_string)
            self.store_bit_string(bit_string, instruction, raw_args)
            return


        # I instruction
        if len(machine_code) == 4:
            print(machine_code)
            print(args)
            # Set rs, rt, imm in the machine_code
            dma = int(args[0])
            shift  = int(args[1])

            # # Is this one of the andi/addi no offset immediate syntaxes?
            # if len(args) == 3:
            #     imm = hex(int(args[2], 16))
            #
            # # Is this one of the lui/li type no offset, no rs syntaxes?
            # elif imm is 'not_valid':
            #     imm = args[1]
            #     rs = '0'

            machine_code[1] = shift
            machine_code[3] = dma
            print(machine_code)

            # Get binary of machine code
            op_binary = '{:04b}'.format(int(machine_code[0]))
            print(op_binary)
            #opp_binary = '{:04b}'.format(machine_code[0])
            shift_binary ='{:04b}'.format(machine_code[1])
            print(shift_binary)
            arp_binary = '{:01b}'.format(int(machine_code[2]))
            print(arp_binary)
            dma_binary = '{:07b}'.format(machine_code[3])
            print(dma_binary)
            # Create 32-bit string to divide up into bytes
            bit_string = op_binary + shift_binary + arp_binary + dma_binary
            print(bit_string)
            self.store_bit_string(bit_string, instruction, raw_args)
            return


    def parse_pseudoinstruction(self, instruction, args):
        ''' Parse pseudo instructions, replace with regular instructions
        '''

        instructions = []
        arguments    = []
        if instruction == 'beq':
            if not '$' in args[1]:
                if self.value_outside_range(int(args[1])):

                    # Calculate lower and upper 16 bits, put into register
                    immediate_lower_16 = int(args[1]) % pow(2, 16)
                    immediate_upper_16 = int(args[1]) / pow(2, 16)
                    instructions = ['lui', 'ori', 'beq']
                    arguments    = [['$at', str(immediate_upper_16)],
                                    ['$at', '$at', str(immediate_lower_16)],
                                    ['$at', args[0], args[2]]]

                else:
                    instructions = ['addi', 'beq']
                    arguments    = [[args[0], args[0], args[1]],
                                    [args[0], args[0], args[2]]]
            else:
                instructions.append(instruction)
                arguments.append(args)

        # li check for size of argument
        if instruction == 'li':
            if self.value_outside_range(int(args[1])):
                    immediate_lower_16 = int(args[1]) % pow(2, 16)
                    immediate_upper_16 = int(args[1]) / pow(2, 16)
                    instructions = ['lui', 'addi']
                    arguments    = [[args[0], str(immediate_upper_16)], [args[0], args[0], str(immediate_lower_16)]]
            else:
                    instructions = ['addi']
                    arguments    = [[args[0], '$zero', args[1]]]

        # addi check for size of argument
        if instruction == 'addi':
            if self.value_outside_range(int(args[2])):
                 immediate_lower_16 = int(args[2]) % pow(2, 16)
                 immediate_upper_16 = int(args[2]) / pow(2, 16)
                 instructions = ['lui', 'addi', 'add']
                 arguments    = [[args[0], str(immediate_upper_16)],
                                 [args[0], args[0], str(immediate_lower_16)],
                                 [args[0], args[0], args[1]]]
            else:
                instructions.append(instruction)
                arguments.append(args)

        # lw check for size of argument
        # is this correct?
        if instruction == 'lw':
            if '(' in args[1]:
                # Parse offset from known syntax
                offset = int(args[1][0:args[1].find('(')])
                register = re.search('\((.*)\)', args[1]).group(1)
                if self.value_outside_range(offset):
                    immediate_lower_16 = offset % pow(2, 16)
                    immediate_upper_16 = offset / pow(2, 16)
                    instructions = ['lui', 'addi', 'lw']
                    arguments    = [[args[0], str(immediate_upper_16)],
                                    [args[0], register, '$zero'],
                                    [args[0], str(immediate_lower_16)+"("+register+")"]]
                else:
                    instructions.append(instruction)
                    arguments.append(args)

        # Branch instructions will always be same amount of regular instructions
        if instruction == 'bge':
            instructions = ['slt', 'beq']
            arguments = [[args[0], args[0], args[1]], [args[0], '$zero', args[2]]]

        if instruction == 'bgt':
            instructions = ['slt', 'bne']
            arguments = [[args[0], args[0], args[1]], [args[0], '$zero', args[2]]]

        if instruction == 'ble':
            instructions = ['slt', 'bne']
            arguments = [[args[0], args[1], args[0]], [args[0], '$zero', args[2]]]

        if instruction == 'move':
            instructions = ['add']
            arguments = [[args[0], args[1], '$zero']]

        if instruction == 'clear':
            instructions = ['add']
            arguments = [[args[0], '$zero', '$zero']]

        count = 0

        for reg_instr in instructions:
            self.parse_instruction(reg_instr, arguments[count])
            count += 1

    def calculate_instruction_size(self, instruction, args):
            ''' Calculate instruction size for first pass in bytes
            '''

            if instruction in self.pseudinstr_table:

                # Check for overloaded instruction: beq
                if instruction == 'beq':
                    if not '$' in args[1]:
                        if self.value_outside_range(int(args[1])):
                            return 12
                        else:
                            return 8
                    else:
                        return 4

                # li check for size of argument
                if instruction == 'li':
                    if self.value_outside_range(int(args[1])):
                        return 8
                    else:
                        return 4

                # addi check for size of argument
                if instruction == 'addi':
                    if self.value_outside_range(int(args[2])):
                        return 12
                    else:
                        return 4

                # lw check for size of argument
                if instruction == 'lw':
                    if '(' in args[1]:
                        # Parse offset from known syntax
                        offset = int(args[1][0:args[1].find('(')])
                        if self.value_outside_range(offset):
                            return 12
                        else:
                            return 4

                # Branch instructions will always be same amount of regular instructions
                if instruction == 'bgt' or instruction == 'ble' or instruction == 'bge':
                    return 8

                # move and clear always are 4 bytes
                return 4

            if instruction in self.instruction_table:
                return 4
            else:
                print( "NOT VALID INSTRUCTION: " + instruction + "\n ABORTING...")
                exit()

    def hex2bin(self, hex_val, num_bits):
        ''' Returns binary string of num_bits length of hex value (pos or neg)
        '''

        # Adjust for negative by performing Two's Complement (tc)
        tc = False
        if '-' in hex_val:
            tc = True
            hex_val = hex_val.replace('-', '')

        bit_string = '0' * num_bits
        bin_val    = str(bin(int(hex_val, 16)))[2:]
        bit_string = bit_string[0: num_bits - len(bin_val)] + bin_val + bit_string[num_bits:]

        # Two's complement if negative hex value
        if tc:
            tsubstring = bit_string[0:bit_string.rfind('1')]
            rsubstring = bit_string[bit_string.rfind('1'):]
            tsubstring = tsubstring.replace('1', 'X')
            tsubstring = tsubstring.replace('0', '1')
            tsubstring = tsubstring.replace('X', '0')
            bit_string = tsubstring + rsubstring

        return bit_string

    def bin2hex(self, bit_string):
        bit_string = '0b'+bit_string
        hex_string = str(hex(int(bit_string, 2)))[2:]
        hex_string = hex_string.zfill(2)
        return hex_string

    def store_bit_string(self, bit_string, instruction, arguments):
        ''' Store bit string into current memory block, divided into bytes
        '''
        self.output_array.append(bit_string)
        # # new word!
        # if self.current_location % 2 == 0:
        #     # Format it nicely
        #     self.output_array.append((self.current_location))

        # for i in range(0, len(bit_string) - 1, 8):
        #     self.system_memory[self.current_location] = bit_string[i:i + 8]
        #
        #     self.output_array[-1] = self.output_array[-1] + (bit_string[i:i + 8])
        #
        #     self.current_location += 1
        #
        # if self.current_location %2 == 0:
        #     # Finish formatting nicely
        #     self.output_array[-1] += '    ' + instruction.ljust(5) + ', '.join(arguments)

    def print_memory_map(self):
        ''' Print memory map as it exists after allocation
        '''
       #  print( "The memory map is:\n")
       #  keylist = self.system_memory.keys()
       #  print(keylist)
       #  keylist.sort()
       #  for key in keylist:
       #      print( "%s: %s" % (key, self.system_memory[key]))
       #
       #  print( "\nThe label list is: " + str(self.symbol_table))
       # # print "\nThe current location is: " + str(self.current_location)
       #  print ('\n\n')
        f = open("machine_code.dat", "w")
        print ('The memory map in binary:')
        for output in self.output_array:
            print(output)
            f.write(output +"\n")


    def value_outside_range(self, value):
        ''' Check if value is greater than 16-bits
        '''
        if abs(value) > pow(2,32):
            print ("The value: " + str(value) + " is greater than 32-bits! ERROR")
            exit()

        return value > (pow(2, 15) - 1) or value < -(pow(2, 15))

    def fix_current_location(self):
        '''Make sure memory location lines up with divisions of word_size
        '''
        if self.current_location % self.word_size is not 0:
            self.current_location += self.word_size - self.current_location % self.word_size
