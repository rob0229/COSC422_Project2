{*
Name: functions.pas
Programmers: Kevin Masterson (k.m.masterson@gmail.com), Rob Close (rob0229@gmail.com)
*}

unit functions;
interface
uses sysutils, types;

procedure printStack(numprint: integer);
function createFunction(): function_info ;
procedure callFunction();
procedure functionReturn();

function calculateActivationRecordSize(var rec: activation_record): integer;

implementation

procedure printActivationRecord(var rec: activation_record);
    var
        i: integer;
    begin
        writeln('   ','Function name:':20, ' ', rec.name);
        writeln('   ','Stack address:':20, ' ', (stack_base + rec.offset));
        writeln('   ','Record size:':20, ' ', rec.size);
        writeln('---------------------------------------------------');

        {* Only displays this information for stack items that are not Global variables, (not stack[0])*}
        if rec.control_link <> -1 then
            begin
                writeln('   ', 'control_link:':20, ' ', (stack_base + stack[rec.control_link].offset), ' (', stack[rec.control_link].name, ')');
                writeln('   ', 'access_link:':20, ' ', (stack_base + stack[rec.access_link].offset), ' (', stack[rec.access_link].name, ')');
                if rec.return_address = -1 then
                    begin
                        writeln('   ', 'return_address:':20, ' 0 (no previous function to return to)');
                        writeln('   ', 'return_value_addr:':20, ' 0 (no previous function to return to)');
                    end
                else
                    begin
                        writeln('   ', 'return_address:':20, ' ', func_array[rec.return_address].code_address, ' (', func_array[rec.return_address].func_name, ')');
                        writeln('   ', 'return_value_addr:':20, ' ', (stack_base + stack[rec.control_link].offset + 12), ' (', stack[rec.control_link].name, ')');
                    end;
                    
                    
                writeln('---------------------------------------------------');
            end;
            
        {* don't display temporary if globals *}
        if rec.control_link <> -1 then
            begin
                writeln('   ','temporary:':20, ' ', rec.temporary.var_type, ' ', rec.temporary.var_name, ' = ', rec.temporary.var_value);
            end;
            
        {* Displays all the variables within the function *}
        writeln('   ', '# of locals/args:':20, ' ', rec.num_locals);
        for i := 0 to (rec.num_locals-1) do
            begin
                writeln('   ', ('local ' + IntToStr(i+1) + ':'):20, ' ', rec.locals[i].var_type, ' ', rec.locals[i].var_name, ' = ', rec.locals[i].var_value);
            end;

        writeln('===================================================');
        writeln('***************************************************');
        writeln('===================================================');
    end;

{* print up to 'numprint' activation records *}
procedure printStack(numprint: integer);
    var
        i: integer;
    begin
        writeln('Registers:');
        writeln('Environment pointer:':25, ' ', (stack_base + stack[stack_pointer].offset), ' (', stack[stack_pointer].name, ')');
        if instruction_pointer = -1 then
            begin
                writeln('Program counter:':25, ' 0 (no function running)');
            end
        else
            begin
                writeln('Program counter:':25, ' ', func_array[instruction_pointer].code_address, ' (', func_array[instruction_pointer].func_name, ')');
            end;
            
        writeln('===================================================');
        writeln(' Top of stack:');
        writeln('===================================================');
        
        {* start looping backwards through stack *}
        for i := (stack_size - 1) downto 0 do
            begin
                {* stop when we've printed enough *}
                if numprint = 0 then exit;
                
                printActivationRecord(stack[i]);
                numprint := numprint - 1;                
            end
    end;

function createFunction() : function_info;
    var
        i: integer;
        func: function_info;
        input: string;
    
    begin
        writeln('Enter the function name: ');
        readln(func.func_name);

        {* get names/types of parameters *}
        func.num_params := -1;
        while func.num_params = -1 do
            begin
                writeln('Enter the number of parameters: ');
                readln(input);
                func.num_params := StrToIntDef(input, -1);
            end;
        setlength(func.params, func.num_params);
        for i := 0 to (func.num_params - 1) do 
        begin
            writeln('Enter the variable name for parameter ', i+1, ': ');
            readln(func.params[i].var_name);
            func.params[i].var_type := '';
            while (func.params[i].var_type <> 'int') and (func.params[i].var_type <> 'char') do
                begin
                    writeln('Enter the data type of ', func.params[i].var_name, ': ');
                    readln(func.params[i].var_type);
                    func.params[i].var_type := LowerCase(func.params[i].var_type);
                end;
        end;

        {* get names/types of local variables *}
        func.num_locals := -1;
        while func.num_locals = -1 do
            begin
                writeln('Enter the number of local variables: ');
                readln(input);
                func.num_locals := StrToIntDef(input, -1);
            end;
        setlength(func.locals, func.num_locals);
        for i := 0 to (func.num_locals - 1) do 
        begin
            writeln('Enter the variable name for local var', i+1);
            readln(func.locals[i].var_name);
            func.locals[i].var_type := '';
            while (func.locals[i].var_type <> 'int') and (func.locals[i].var_type <> 'char') do
                begin
                    writeln('Enter the data type of ', func.locals[i].var_name, ': ');
                    readln(func.locals[i].var_type);
                    func.locals[i].var_type := LowerCase(func.locals[i].var_type);
                end;
            writeln('Enter the value of ', func.locals[i].var_name);
            readln(func.locals[i].var_value);
        end;

        {* get the function return type/value *}
        func.return_type := '';
        while (func.return_type <> 'void') and (func.return_type <> 'int') and (func.return_type <> 'char') do
            begin
                writeln('Enter the return type of the function: ');
                readln(func.return_type);
                func.return_type := LowerCase(func.return_type);
            end;
        
        
        {* get code address *}
        func.code_address := 0;
        while func.code_address = 0 do
            begin
                writeln('Enter the code address for the function: ');
                readln(input);
                func.code_address := StrToIntDef(input, 0);
            end;
        
        createFunction := func;
    end;

procedure callFunction();
    var
        i, localsi, choice: integer;
        param_value: string;
        new_record: activation_record;
        input: string;
        
    begin

        if num_functions = 0 then 
            begin
                writeln();
                writeln('ERROR ****** No functions exist to call!!! ******');
                writeln();
                exit;
            end;

        {*Display all the functions and ask the user to choose one*}
        for i := 0 to (num_functions - 1) do
            begin
                writeln(i:5, ' ', func_array[i].func_name);
            end;
            
        choice := -1;
        while (choice < 0) or (choice >= num_functions) do
            begin
                writeln('Enter the number for the function you want to call');
                readln(input);
                choice := StrToIntDef(input, -1);
            end;

        {* Update the new activation_record information from the users choice*}
        new_record.name := func_array[choice].func_name; 
        new_record.return_type := func_array[choice].return_type;
        
        {* store this function's name and return type in the calling function's temporary variable *}
        stack[stack_size - 1].temporary.var_name := new_record.name + '()';
        if new_record.return_type <> 'void' then
            stack[stack_size - 1].temporary.var_type := new_record.return_type
        else
            stack[stack_size - 1].temporary.var_type := 'int (ignored)';
        
        {* set control_link, access_link, and return pointers *}
        new_record.control_link := stack_size - 1;
        new_record.access_link := 0;
        new_record.return_address := instruction_pointer;
        
        {* change instruction pointer *}
        instruction_pointer := choice;
        
        {* get the function call argument values and assign to the local variables of the new activation_record *}
        new_record.num_locals := func_array[choice].num_params + func_array[choice].num_locals;
        setlength(new_record.locals, new_record.num_locals);
        localsi := 0;
        for i := 0 to (func_array[choice].num_params - 1) do 
            begin
                writeln('Enter the value for parameter name ', func_array[choice].params[i].var_name, ' of data type ', func_array[choice].params[i].var_type);
                readln(param_value);
                new_record.locals[localsi].var_name := func_array[choice].params[i].var_name; 
                new_record.locals[localsi].var_type := func_array[choice].params[i].var_type;  
                new_record.locals[localsi].var_value := param_value;    
                localsi := localsi + 1;
            end;
        {* add locals to activation_record *}
        for i := 0 to (func_array[choice].num_locals - 1) do
            begin
                new_record.locals[localsi] := func_array[choice].locals[i]; 
                localsi := localsi + 1;
            end;
            
        {* set temporary *}
        new_record.temporary.var_name := '?';
        new_record.temporary.var_type := '?';
        new_record.temporary.var_value := '?';

        {* set offset and size *}
        new_record.offset := stack[stack_size - 1].offset + stack[stack_size - 1].size;
        new_record.size := calculateActivationRecordSize(new_record);

        {* Add the new activation record to the stack *}
        stack_size := stack_size + 1;
        setlength(stack, stack_size);
        stack[stack_size - 1] := new_record;
        
        {* update stack pointer *}
        stack_pointer := stack_size - 1;
    end;

procedure functionReturn();
    var
        return_val: string;
        
    begin
        {* skip if no functions *}
        if stack_size <= 1 then
            begin
                writeln();
                writeln('ERROR ****** No functions on stack!!! ******');
                writeln();
                exit;
            end;
    
        {* get the simulated return value of the function call if it isn't void *}
        if stack[stack_size - 1].return_type <> 'void' then
            begin
                writeln('Enter a ', stack[stack_size - 1].return_type, ' value for the function to return: ');
                readln(return_val);
                stack[stack_size - 2].temporary.var_value := return_val;
            end;
            
        {* jump to old instruction pointer *}
        instruction_pointer := stack[stack_size - 1].return_address;
        
        {* move stack pointer back *}
        stack_pointer := stack[stack_size - 1].control_link;
        
        {* remove top activation record *}
        stack_size := stack_size - 1;
        setlength(stack, stack_size);
    end;
    
{* figure out the size of an activation record *}
function calculateActivationRecordSize(var rec: activation_record): integer;
    begin
        calculateActivationRecordSize := rec.num_locals * 4 + 4 + 4 + 4 + 4 + 4; {* control_link + access_link + return_address + temporary + return result address*}
    end;
end.