unit functions;
interface
uses types;

var i, num_params, num_locals, choice: integer;
var new_record : activation_record;
var new_stack, return_stack: array of activation_record;

procedure printStack(stack: activation_record_array; var size: integer);
procedure createFunction(func: ^function_info);
function callFunction(func_array: function_info_array; stack: activation_record_array; var num_functions: integer; var stack_size: integer ): activation_record_array;
function functionReturn(func_array: function_info_array; stack: activation_record_array; var num_functions: integer; var stack_size: integer): activation_record_array;

function calculateActivationRecordSize(rec: activation_record): integer;

implementation

{* haven't even looked at this function yet -kevin *}
procedure printStack(stack: activation_record_array; var size: integer);
    begin
        writeln('---------------------------------------------------');
        writeln('|     ',' Function  Name ':20, ' | ', stack[size-1].name:20, ' |');
        writeln('---------------------------------------------------');

        {* Only displays this information for stack items that are not Global variables, (not stack[0])*}
        if stack[size-1].control_link <> -1 then
            begin
                writeln('|     ', 'control_link name':20, ' | ', stack[stack[size-1].control_link].name:20, ' |');
                writeln('---------------------------------------------------');
            end;
        if stack[size-1].access_link <> -1 then
            begin
                writeln('|     ', 'access_link name':20, ' | ', stack[stack[size-1].access_link].name:20, ' |');
                writeln('---------------------------------------------------');
            end;
        {* Displays all the variables within the function *}
        for i := 0 to (stack[size-1].num_locals-1) do
            begin
            
                writeln('|     ', stack[size-1].locals[i].var_name:20, ' | ', stack[size-1].locals[i].var_value:20, ' |');
                writeln('---------------------------------------------------');
            end;
{*
        writeln('| Return Address':20, ' | ', stack[size-1].access_link^.name:20,' |');
        writeln('---------------------------------------------------');
*}
            
        end;

function createFunction() : function_info;
    var
        i: integer;
        func: function_info;
    
    begin
        writeln('Enter the function name:');
        readln(func.func_name);

        {* get names/types of parameters *}
        writeln('Enter the number of parameters:');
        readln(func.num_params);        
        setlength(func.params, func.num_params);
        for i := 0 to (func.num_params - 1) do 
        begin
            writeln('Enter the variable name for parameter ', i+1);
            readln(func.params[i].var_name);
            writeln('Enter the data type of ', func.params[i].var_name);
            readln(func.params[i].var_type);
        end;

        {* get names/types of local variables *}
        writeln('Enter the number of local variables: ');
        readln(func.num_locals);
        setlength(func.locals, func.num_locals);
        for i := 0 to (func.num_locals - 1) do 
        begin
            writeln('Enter the variable name for local var', i+1);
            readln(func.params[i].var_name);
            writeln('Enter the data type of ', func.params[i].var_name);
            readln(func.params[i].var_type);
        end;

        {* get the function return type/value *}
        writeln('Enter the return type of the function');
        readln(func.ret.var_type);
        writeln('Enter the return value of the function');
        readln(func.ret.var_value);
        
        createFunction := func;
    end;

{* haven't even looked at this function yet -kevin *}
function callFunction(func_array: function_info_array; stack: activation_record_array; var num_functions: integer; var stack_size: integer ): activation_record_array;
    var
        i, choice: integer;
        param_value: string;
        
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

        {*set control_link, access_link, and return pointers*}
        if (stack_size > 2) then
            begin
                new_stack[stack_size - 1].control_link^ := new_stack[stack_size - 2];
            end
        else
            begin

                writeln('here 3: ', new_stack[stack_size - 1].name);
                writeln(new_stack[0].name);

                new_stack[stack_size - 1].control_link^ := new_stack[0];
            end;
        new_stack[stack_size - 1].access_link^ := new_stack[0];
        new_stack[stack_size - 1].return_address := stack_size - 1;

        {* Set the temp values *}
        new_stack[stack_size - 2].ret.var_name := new_stack[stack_size - 1].ret.var_name;
        new_stack[stack_size - 2].ret.var_type := new_stack[stack_size - 1].ret.var_type;


        {* Return the new stack *}
        callFunction := new_stack;

    end;

{* haven't even looked at this function yet -kevin *}
function functionReturn( func_array: function_info_array; stack: activation_record_array; var num_functions: integer; var stack_size: integer): activation_record_array;
    var
        return_val: string;
        
    begin 
        return_stack := stack;
        {* This is the simulated function return*}
        {* get the simulated return value of the function call *}
        writeln('Enter a value for the function to return');
        readln(return_val);
        return_stack[stack_size - 2].ret.var_value := return_stack[stack_size - 1].ret.var_value;
        functionReturn := return_stack;
    end;
    


{* calculate size based on type: int = 4, char = 1, everything else = 0 *}
function calculateTypeSize(var_type: string): integer;
    begin
        calculateTypeSize := 0
    
        if var_type == "int" or var_type == "integer" then
            calculateTypeSize := 4
        else if var_type == "char" then
            calculateTypeSize := 1;
    end;

{* figure out the size of an activation record *}
function calculateActivationRecordSize(rec: ^activation_record): integer;
    var
        i, size: integer;
    
    {*    name: string;
    control_link: integer;
    access_link: integer;
    return_address: integer;
    ret: variable_info;
    num_locals: integer;
    locals: array of variable_info;
    temporary: variable_info;  *}
    begin
        size := 4 + 4 + 4; {* control_link + access_link + return_address *}
        size := size + calculateTypeSize(ret^.var_type);
        for i := 0 to rec^.num_locals - 1 do
            begin
                size := size + calculateTypeSize(ret^.locals[i].var_type);
            end;
        size := size + calculateTypeSize(ret^.temporary.var_type);
        
        calculateActivationRecordSize := size;
    end;
end.