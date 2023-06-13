class BrainfuckInterpreter
    attr_accessor :program, :memory, :data_ptr, :prog_ptr

    COMMANDS = {
        '>' => :increment_data_ptr,
        '<' => :decrement_data_ptr,
        '+' => :increment_byte,
        '-' => :decrement_byte,
        '.' => :output_byte,
        ',' => :input_byte,
        '[' => :begin_loop,
        ']' => :end_loop
    }.freeze

    def initialize(program)
        @program = program
        @memory = Array.new(30_000, 0)
        @data_ptr = 0
        @prog_ptr = 0
    end

    def run
        while @prog_ptr < @program.length
            command = COMMANDS[@program[@prog_ptr]]
            send(command) if command
            @prog_ptr += 1
        end
    end

    private

    def increment_data_ptr
        @data_ptr += 1
    end

    def decrement_data_ptr
        @data_ptr -= 1
    end

    def increment_byte
        @memory[@data_ptr] += 1
    end

    def decrement_byte
        @memory[@data_ptr] -= 1
    end

    def output_byte
        print @memory[@data_ptr].chr
    end

    def input_byte
        @memory[@data_ptr] = gets.ord
    end

    def begin_loop
        return if @memory[@data_ptr] != 0

        loop = 1
        while loop > 0
            @prog_ptr += 1
            case @program[@prog_ptr]
                when '['
                    loop += 1
                when ']'
                    loop -= 1
            end
        end
    end

    def end_loop
        return if @memory[@data_ptr] == 0

        loop = 1
        while loop > 0
            @prog_ptr -= 1
            case @program[@prog_ptr]
                when '['
                    loop -= 1
                when ']'
                    loop += 1
            end
        end
        @prog_ptr -= 1
    end
end

# Run a Brainfuck program:
program = ">++++++++[<+++++++++>-]<.
>++++[<+++++++>-]<+.
+++++++..
+++.
>>++++++[<+++++++>-]<++.
------------.
>++++++[<+++++++++>-]<+.
<.
+++.
------.
--------.
>>>++++[<++++++++>-]<+."
interpreter = BrainfuckInterpreter.new(program)
interpreter.run # Outputs "Hello, World!"
