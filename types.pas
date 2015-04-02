unit types;
interface

type
variable_info = record
    var_name: string;
    var_type: string;
    var_value: integer;
end;

function_info = record
    func_name: string;
    num_params: integer;
    params: array of variable_info;
    num_locals: integer;
    locals: array of variable_info;
    ret: variable_info;
end;

activation_record = record
    control_link: integer;
    access_link: integer;
    return_address: integer;
    ret: variable_info;
    num_locals: integer;
    locals: array of variable_info;
    temporary: variable_info;    
end;

implementation
end.