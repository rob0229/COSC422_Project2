unit functions;
interface
uses types;
var i, num_params, num_locals, choice: integer;
var temp_func: function_info;
var func_name, param_name, param_dataType, local_name, local_dataType: string;
var return_record : activation_record;

procedure printStack(stack: array of activation_record; var size: integer);
function createFunction(): function_info;
function callFunction(func_array: array of function_info; var num_functions: integer): activation_record;

implementation

procedure printStack(stack: array of activation_record; var size: integer);
	begin
		writeln('-------------------------------------------');
		writeln('|  Function  Name ':20, ' | ', stack[size-1].name:20, ' |');
		writeln('-------------------------------------------');

		{* Only displays this information for stack items that are not Global variables, (not stack[0])*}
		if stack[size-1].control_link <> nil then
			begin
				writeln('| control_link name':20, ' | ', stack[size-1].control_link^.name:20, ' |');
				writeln('-------------------------------------------');
			end;
		if stack[size-1].access_link <> nil then
			begin
				writeln('| access_link name':20, ' | ', stack[size-1].access_link^.name:20, ' |');
				writeln('-------------------------------------------');
			end;
		{* Displays all the variables within the function *}
		for i := 0 to (stack[size-1].num_locals-1) do
			begin
			
				writeln('| Var ', stack[size-1].locals[i].var_name:20, ' | ', stack[size-1].locals[i].var_value:20, ' |');
				writeln('-------------------------------------------');
			end;
{*
		writeln('| Return Address':20, ' | ', stack[size-1].access_link^.name:20,' |');
		writeln('-------------------------------------------');
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

 		createFunction := temp_func;
 	end;

function callFunction(func_array: array of function_info; var num_functions: integer ): activation_record;
	begin
		writeln('Enter the number for the function you want to call');
		for i := 0 to (num_functions - 1) do
			begin
				writeln(i:5, ' ', func_array[i].func_name );
			end;
		readln(choice);

		writeln('you chose ', choice);

		callFunction := return_record;
	end;



end.