unit types;
interface

type
    variable_info = record
        var_name: string;
        var_type: string;
        var_value: string;
    end;

    function_info = record
        func_name: string;
        num_params: integer;
        params: array of variable_info;
        num_locals: integer;
        locals: array of variable_info;
        return_type: string;
    end;

    activation_record = record
        name: string;
        control_link: integer;
        access_link: integer;
        return_address: integer;
        return_type: string;
        num_locals: integer;
        locals: array of variable_info;
        temporary: variable_info;
        offset: integer;
    end;

    activation_record_array = array of activation_record;
    function_info_array = array of function_info;

implementation

end.
