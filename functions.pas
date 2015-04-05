unit functions;
interface
uses types;
var i, num_params, num_locals, choice: integer;
var temp_func: function_info;
var func_name, param_name, param_dataType, local_name, local_dataType, param_value, return_type, return_val: string;
var new_record : activation_record;
var new_stack, return_stack: array of activation_record;

procedure printStack(stack: array of activation_record; var size: integer);
function createFunction(): function_info;
function callFunction(func_array: array of function_info; stack: activation_record_array; var num_functions: integer; var stack_size: integer ): activation_record_array;
function functionReturn( func_array: array of function_info; stack: activation_record_array; var num_functions: integer; var stack_size: integer): activation_record_array;

implementation

procedure printStack(stack: array of activation_record; var size: integer);
	begin
		writeln('----------------------------------------------------');
		writeln('|  Function  Name ':20, ' | ', stack[size-1].name:20, ' |');
		writeln('----------------------------------------------------');

		{* Only displays this information for stack items that are not Global variables, (not stack[0])*}
		if stack[size-1].control_link <> nil then
			begin
				writeln('| control_link name':20, ' | ', stack[size-1].control_link^.name:20, ' |');
				writeln('-----------------------------------------------------');
			end;
		if stack[size-1].access_link <> nil then
			begin
				writeln('| access_link name':20, ' | ', stack[size-1].access_link^.name:20, ' |');
				writeln('-----------------------------------------------------');
			end;
		{* Displays all the variables within the function *}
		for i := 0 to (stack[size-1].num_locals-1) do
			begin
			
				writeln('| Var ', stack[size-1].locals[i].var_name:20, ' | ', stack[size-1].locals[i].var_value:20, ' |');
				writeln('-----------------------------------------------------');
			end;
{*
		writeln('| Return Address':20, ' | ', stack[size-1].access_link^.name:20,' |');
		writeln('-----------------------------------------------------');
*}
			
		end;

 function createFunction(): function_info;
 	begin
 		writeln('Enter the function Name:');
 		readln(func_name);
 		temp_func.func_name := func_name;

 		writeln('Enter the number of parameters:');
 		readln(num_params);
 		temp_func.num_params := num_params;
 		setlength(temp_func.params, num_params);
 		for i := 0 to (num_params - 1) do 
		begin
			writeln('Enter the variable name for parameter ', i+1);
			readln(param_name);
			writeln('Enter the data type of ', param_name);
			readln(param_dataType);
			
			temp_func.params[i].var_name := param_name;
			temp_func.params[i].var_type := param_dataType;
		end;



 		writeln('Enter the number of local variables: ');
 		readln(num_locals);
 		setlength(temp_func.locals, num_locals);
 		temp_func.num_locals := num_locals;
 		for i := 0 to (num_locals - 1) do 
		begin
			writeln('Enter the variable name for local var', i+1);
			readln(local_name);
			writeln('Enter the data type of ', local_name);
			readln(local_dataType);
			
			temp_func.params[i].var_name := local_name;
			temp_func.params[i].var_type := local_dataType;
		end;

		{* Get the function return type *}
		writeln('Enter the return type of the function');
		readln(return_type);
		temp_func.ret.var_type := return_type;

 		createFunction := temp_func;
 	end;

function callFunction(func_array: array of function_info; stack: activation_record_array; var num_functions: integer; var stack_size: integer ): activation_record_array;
	begin
		new_stack := stack;

		{*Display all the functions and ask the user to choose one*}
		writeln('Enter the number for the function you want to call');
		for i := 0 to (num_functions - 1) do
			begin
				writeln(i:5, ' ', func_array[i].func_name );
			end;
		readln(choice);

		{* Update the new activation_record information from the users choice*}
		new_record.name := func_array[choice].func_name; 

		{* get the function call argument values and assign to the local variables of the new activation_record *}
		setlength(new_record.locals, func_array[choice].num_params);
		for i := 0 to (func_array[choice].num_params - 1) do 
            begin
                writeln('Enter the value for parameter name ', func_array[choice].params[i].var_name, ' of data type ', func_array[choice].params[i].var_type);
                readln(param_value);
                new_record.locals[i].var_name := func_array[choice].params[i].var_name; 
                new_record.locals[i].var_type := func_array[choice].params[i].var_type;  
                new_record.locals[i].var_value := param_value;    
            end;

      
		

		{* Add the new activation record to the stack *}
		setlength(new_stack, stack_size);
		 writeln('made it to here');
		new_stack[stack_size - 1] := new_record;
 writeln('here 1');

		{*set control_link, access_link, and return pointers*}
		if (stack_size > 2) then
			begin
		    	new_stack[stack_size - 1].control_link^ := new_stack[stack_size - 2];

writeln('here 2');

			end
		else
			begin

writeln('here 3: ', new_stack[stack_size - 1].name);

				 new_stack[stack_size - 1].control_link^ := new_stack[0];
			end;

writeln('here 4');

		new_stack[stack_size - 1].access_link^ := new_stack[0];
        new_stack[stack_size - 1].return_address := stack_size - 1;

 writeln('here 5');

        {* Set the temp values *}
        new_stack[stack_size - 2].ret.var_name := new_stack[stack_size - 1].ret.var_name;
        new_stack[stack_size - 2].ret.var_type := new_stack[stack_size - 1].ret.var_type;

 writeln('here 6');
       
        	{* Return the new stack *}
            callFunction := new_stack;

	end;

function functionReturn( func_array: array of function_info; stack: activation_record_array; var num_functions: integer; var stack_size: integer): activation_record_array;
	begin 
		return_stack := stack;
		{* This is the simulated function return*}
		{* get the simulated return value of the function call *}
        writeln('Enter a value for the function to return');
        readln(return_val);
        return_stack[stack_size - 2].ret.var_value := return_stack[stack_size - 1].ret.var_value;
        functionReturn := return_stack;
        	end;

end.