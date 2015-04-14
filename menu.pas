{*
Name: menu.pas
Programmers: Kevin Masterson (k.m.masterson@gmail.com), Rob Close (rob0229@gmail.com)
*}

unit menu;
interface
procedure display_menu();

implementation 
procedure display_menu();
    begin
        writeln('Choose an option');
        writeln('1- Create a function');
        writeln('2- Call Function');
        writeln('3- Simulate Function Return');
        writeln('4- Print Stack');
        writeln('5- Exit');
    end;
end.