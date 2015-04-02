program project2;
uses crt, types;

var
rec: activation_record;

begin
    rec.control_link := 123;
    writeln(rec.control_link);
end.
