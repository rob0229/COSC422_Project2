{*
Name: proj2.pas
Programmers: Kevin Masterson (k.m.masterson@gmail.com), Rob Close (rob0229@gmail.com)
*}

program project2;
uses crt, sysutils, strutils, types, menu, functions;

procedure initProgram();
    var
        i: integer;
        input: string;
    begin
        {* initial empty function array *}
        num_functions := 0;
        setlength(func_array, num_functions);

        {* beginning of stack *}
        stack_base := 1000000;    
        {* no code yet! *}
        instruction_pointer := -1;
        {* stack pointer starts off at first record *}
        stack_pointer := 0;

        {* initial stack array *}
        stack_size := 1;
        setlength(stack, stack_size);
        stack[0].name := 'Global Variables';
        stack[0].control_link := -1;
        stack[0].access_link := -1;
        stack[0].offset := 0;
        stack[0].return_address := -1;

        stack[0].num_locals := -1;
        while stack[0].num_locals = -1 do
            begin
                writeln('Enter the number of global variables');    
                readln(input);
                stack[0].num_locals := StrToIntDef(input, -1);
            end;

        setlength(stack[0].locals, stack[0].num_locals);
        for i := 0 to (stack[0].num_locals - 1) do 
            begin
                writeln('Enter the variable name for global var ', i+1, ': ');
                readln(stack[0].locals[i].var_name);
                writeln('Enter the data type of ', stack[0].locals[i].var_name, ': ');
                readln(stack[0].locals[i].var_type);
                writeln('Enter a value for ', stack[0].locals[i].var_name, ': ');
                readln(stack[0].locals[i].var_value);
            end;

        stack[0].size := stack[0].num_locals * 4;
    end;

procedure runLoop();
    var
        choice, numprint: integer;
        input: string;
        
    begin
        display_menu();
        readln(input);

        choice := StrToIntDef(input, -1);

        while choice <> 6 do
            begin
                case choice of 
                    {* Create a function *}
                    1 : 
                        begin
                            writeln('You chose to create a function: ');
                            num_functions := num_functions + 1;
                            setlength(func_array, num_functions);
                            func_array[num_functions - 1] := createFunction();
                            writeln('returned from createFunction');   
                        end;
                    {*Simulate a function call*}
                    2 : 
                        begin
                            writeln('You chose to call a function: ');
                            {* add the activation record for called function to the stack *}
                            callFunction();
                            writeln('returned from callFunction');
                        end;
                    {* return function *}
                    3: 
                        begin
                            writeln('You chose to simulate the return of a function: ');
                            functionReturn();
                            writeln('returned from functionReturn');
                        end;
                    {* Print the stack *}    
                    4 : 
                        begin
                            writeln('You chose to print the stack: ');
                            numprint := -1;
                            while numprint = -1 do
                                begin
                                    writeln('Enter number of activation records to print: ');
                                    readln(input);
                                    numprint := StrToIntDef(input, -1);
                                end;
                            printStack(numprint);
                            writeln('returned from printStack');
                        end;
                    {* Reset the Simulation *}
                    5 : 
                        begin
                            writeln('You chose to reset the simulation: ');
                            exit; {* exit function, main loop restarts it *}
                        end;
                    else 
                        writeln('That is not a valid choice');
                end;
                display_menu();
                readln(choice);
            end;
         halt; {* exit program entirely if choice was 6 *}
    end;
    
{* Main program execution*}
begin
    while 1=1 do
        begin
            initProgram();
            runLoop();
        end;
end.
