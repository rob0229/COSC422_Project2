program project2;
uses crt, types, menu;

var
rec: activation_record;
var 
choice: integer;

begin
    rec.control_link := 123;
    writeln(rec.control_link);
    displayMenu();
    readln(choice);
    writeln('You chose: ', choice);
end.
