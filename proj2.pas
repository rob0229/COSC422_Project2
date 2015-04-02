program project2;
uses crt;

type
variable_info = record
    var_name: string;
    var_type: string;
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

end;

begin
    writeln('hi');
end.
