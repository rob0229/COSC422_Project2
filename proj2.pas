program project2;
uses crt, types, menu, functions;

var
    i, choice: integer;
    
    stack: array of activation_record;
    stack_size: integer;
    
    functions: array of function_info;
    num_functions: integer;

{* Main program execution*}
begin
    {* initial empty function array *}
    num_functions := 0;
    setlength(func_array, num_functions);
    
    {* initial stack array *}
    stack_size := 1;
    setlength(stack, stack_size);
    stack[0].name := 'Global Variables';
    stack[0].control_link := -1;
    stack[0].access_link := -1;
    
    writeln('Enter the number of global variables');    
    readln(stack[0].num_locals);
    
    setlength(stack[0].locals, stack[0].num_locals);
    for i := 0 to (stack[0].num_locals - 1) do 
        begin
            writeln('Enter the variable name for global var ', i+1);
            readln(stack[0].locals[i].var_name);
            writeln('Enter the data type of ', name);
            readln(stack[0].locals[i].var_type);
            writeln('Enter a value for ', name);
            readln(stack[0].locals[i].var_value);
        end;

    display_menu();
    readln(choice);

    while choice <> 6 do
        begin
            case choice of 
                {* Create a function *}
                1 : 
                    begin
                        writeln('You chose to create a function: ');
                        num_functions := num_functions + 1;
                        setlength(functions, num_functions);
                        functions[num_functions - 1] := createFunction();
                        writeln('returned from createFunction');   
                    end;
                {*Simulate a function call*}
                2 : 
                    begin
                        writeln('You chose to call a function: ');
                        stack_size := stack_size + 1;
                        {* add the activation record for called function to the stack *}
                        stack := callFunction(functions, stack, num_functions, stack_size);
                    end;
                {* return function *}
                3: 
                    begin
                        writeln('You chose to simulate the return of a function: ');
                    end;
                {* Print the top of the stack *}    
                4 : 
                    begin
                        writeln('You chose to print the top of the stack: ');
                        printStack(stack, stack_size);
                        writeln('line 74 ');
                    end;
                {* Reset the Simulation *}
                5 : 
                    begin
                        writeln('You chose to reset the simulation: ');
                    end;
                else 
                    writeln('That is not a valid choice');
            end;
            display_menu();
            readln(choice);
        end;
end.
