

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

solvePERT('power_plant.txt',arr2,finishTime,criticalPathStdDeviation);

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


Value := NormalDistA(finishTime, criticalPathStdDeviation, low(int64),55);

writeln;
writeln('Probability between -Inf and 55 is: ', format('%f', [value]));  

value:=InvNormalDist(finishTime,criticalPathStdDeviation,0.84,true);

writeln;
writeln('The estimate of the critical path with 84 percent confidence is: ', format('%f', [value]));  


setlength(arr2,0);

end.

