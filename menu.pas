unit menu;
interface
procedure displayMenu();

implementation 
procedure displayMenu();
	begin
		writeln('Choose an option');
		writeln('1- Create a function');
		writeln('2- Call Function');
		writeln('3- Simulate Function Return');
		writeln('4- Print Current Stack');
		writeln('5- Reset Simulation');
		writeln('6- Exit');
	end;
end.
