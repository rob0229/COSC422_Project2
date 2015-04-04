program project2;
uses crt, types, menu, functions;

var choice: integer;
var stack: array of activation_record;
var func_array: array of function_info;
var num_functions: integer;
var stack_size: integer;
var num_global_vars: integer;
var i: integer;
var name: string;
var dataType: string;
var value: string;

{* Main program execution*}
begin
	{* initial stack array *}
	stack_size := 1;
    num_functions := 0;
	setlength(stack, stack_size);
    setlength(func_array, num_functions);
	writeln('Enter the number of global variables');
	readln(num_global_vars);
	stack[0].num_locals := num_global_vars;
	setlength(stack[0].locals, stack[0].num_locals);

    stack[0].name := 'Global Variables';
    stack[0].control_link := nil;
    stack[0].access_link := nil;

	for i := 0 to (num_global_vars - 1) do 
		begin
			writeln('Enter the variable name for global var ', i+1);
			readln(name);
			writeln('Enter the data type of ', name);
			readln(dataType);
			writeln('Enter a value for ', name);
			readln(value);
			stack[0].locals[i].var_name := name;
			stack[0].locals[i].var_type := dataType;
			stack[0].locals[i].var_value := value;
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
                        setlength(func_array, num_functions);
                        func_array[num_functions - 1] := createFunction();
                        writeln('returned from createFunction');   
    				end;
                {*Simulate a function call*}
    			2 : 
    				begin
    					writeln('You chose to call a function: ');
                        stack_size := stack_size + 1;
                        {* add the activation record for called function to the stack *}
                        stack := callFunction(func_array, stack, num_functions, stack_size);
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
