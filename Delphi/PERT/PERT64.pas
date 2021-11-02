

program test1;


{$APPTYPE CONSOLE}

    uses
{$IFDEF FPC}
       Windows,PERT,CPM,sysutils;
{$ELSE}
      winapi.Windows,PERT,CPM,system.sysutils; 
{$ENDIF}

var arr2:TCPMInfo;
   i:integer;
   finishTime:double;
   criticalPathStdDeviation:double;
   value:single;

begin

if (fileexists(ParamStr(1)) and (ParamStr(1) <> ''))
then solvePERT(paramstr(1),arr2,finishTime,criticalPathStdDeviation)
else if (not fileexists(ParamStr(1)) and (ParamStr(1) <> ''))
then
begin
writeln;
writeln('File ',paramstr(1)+' doesn''t exist..');
exit;
end
else if (not fileexists(ParamStr(1)) and (ParamStr(1) = ''))
then
begin
writeln;
writeln('Please specify a file as the second argument of the command line..');
exit;
end;

writeln;
writeln('The system solved by PERT: ');
writeln;

writeln('The critical path is: ');
writeln;

for i:=0 to length(arr2)-1
do
 begin
writeln('job: ',arr2[i].job,'  start: ',format('%f', [arr2[i].start]),'  finish: ',format('%f', [arr2[i].finish])); 
end;

writeln;
writeln('Finish time is: ',format('%f', [finishTime] ));

writeln;
writeln('Critical path standard deviation is: ',format('%f', [criticalPathStdDeviation]));

setlength(arr2,0);

end.

