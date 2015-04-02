program project2;
uses crt, types, menu;

var choice: integer;
var stack: array of activation_record;
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
	setlength(stack, stack_size);
	writeln('Enter the number of global variables');
	readln(num_global_vars);
	stack[0].num_locals := num_global_vars;
	setlength(stack[0].locals, stack[0].num_locals);

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
  
    writeln(' global is: ', stack[0].locals[0].var_name);
    display_menu();
    readln(choice);

    while choice <> 6 do
    	begin
    		case choice of 
    			1 : 
    				begin
    					writeln('You chose: ', choice);
    				end;
    			2 : 
    				begin
    					writeln('You chose: ', choice);
    				end;
    			3: 
    				begin
    					writeln('You chose: ', choice);
    				end;
    			4 : 
    				begin
    					writeln('You chose: ', choice);
    				end;
    			5 : 
    				begin
    					writeln('You chose: ', choice);
    				end;
    			else 
    				writeln('That is not a valid choice');
    		end;
    		display_menu();
    		readln(choice);
    	end;
end.
