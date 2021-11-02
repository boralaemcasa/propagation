

program test1;


{$APPTYPE CONSOLE}

    uses
{$IFDEF FPC}
       Windows,CPM,sysutils;
{$ELSE}
      winapi.Windows,CPM,system.sysutils; 
{$ENDIF}

var arr2:TCPMInfo;
   i:integer;
   finishTime:double;
begin

solveCPM('jobsPC.txt',arr2,finishTime);

writeln;
writeln('The system solved by CPM: ');
writeln;

for i:=0 to length(arr2)-1
do
 begin
writeln('job: ',arr2[i].job,'  start: ',format('%g', [arr2[i].start]),'  finish: ',format('%g', [arr2[i].finish])); 
end;

writeln;
writeln('Finish time is: ',format('%g', [finishTime] ));

setlength(arr2,0);

end.

