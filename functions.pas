unit functions;
interface
uses types;
var i: integer;
var temp_func: function_info;
var func_name: string;

procedure printStack(stack: array of activation_record; var size: integer);
function createFunction(): function_info;

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

		writeln('| Return Address':20, ' | ', stack[size-1].access_link^.name:20,' |');
		writeln('-------------------------------------------');
			
		end;

 function createFunction(): function_info;
 	begin
 		writeln('Enter the function Name:');
 		readln(func_name);
 		temp_func.func_name := func_name;
 		createFunction := temp_func;
 	end;

end.







{*
control_link: ^activation_record;
    access_link: ^activation_record;
    return_address: integer;
    ret: variable_info;
    num_locals: integer;
    locals: array of variable_info;
    temporary: variable_info;    

 *}