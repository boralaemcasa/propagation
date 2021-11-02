// This PERT library was written by Amine Moulay Ramdane.

unit PERT;

interface

{$APPTYPE CONSOLE}

    uses
{$IFDEF FPC}
       Windows, 
        SysUtils,
        Classes,
        CPM,
        math;
{$ELSE}
        system.SysUtils,
        system.Classes,
        winapi.Windows,
        CPM, 
        system.math; 
{$ENDIF}

type
   
 Tinfo1 = record
      job: integer;
     variance:system.double;    
 end;

TPERT1Info = array of Tinfo1;


procedure solvePERT(filename:string;var info:TCPMInfo;var  finishTime:system.double;var criticalPathStdDeviation:system.double);

function NormalDistA (const Mean, StdDev, AVal, BVal: Extended): Single;

function NormalDistP (const Mean, StdDev, AVal: Extended): Single;

function InvNormalDist (const Mean, StdDev, PVal: Extended; const Less: Boolean): Extended;

IMPLEMENTATION 

function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

function SameFloat (const X1, X2: Extended): Boolean;
begin
  Result := (abs (X1 - X2) = 0); 
end;

function FloatIsZero (const X: Extended): Boolean;
begin
  Result := (abs (X)=0) 
end;

function FloatIsPositive(const X: Extended): Boolean;
begin
  Result := (abs (X)>0) 
end;

function InvNormalQ (const P: Extended): Extended;
const
  C0: Extended = 2.515517;
  C1: Extended = 0.802853;
  C2: Extended = 0.010328;
  D1: Extended = 1.432788;
  D2: Extended = 0.189269;
  D3: Extended = 0.001308;
var
  T: Extended;
begin
  T := Sqrt (Ln (1.0 / Sqr (P)));
  Result := T - (C0 + C1 * T + C2 * Sqr (T)) /
    (1.0 + D1 * T + D2 * Sqr (T) + D3 * Sqr (T) * T);
end;

{ Returns the Original AVal for Pr (X < AVal) = PVal if Less is
    True, or Pr (X > AVal) = PVal if Less is False,
    for a Normal Distribution with given Mean and Standard Deviation.

    Standard Deviation must be > 0 or function will return an Exception.
    PVal (Probability) must be 0 < PVal < 1 or function will return an Exception.

    Approximation has an absolute error < 4.5 x 10^4
    Thus 3 figure accuracy.

} 
function InvNormalDist (const Mean, StdDev, PVal: Extended; const Less: Boolean): Extended;
var
  P: Extended;
  Lower: Boolean;
begin
  if not FloatIsPositive (StdDev) then
    raise EMathError.Create ('Standard Deviation must be Positive');

  if (PVal <= 0) or (PVal >= 1) then
    raise EMathError.Create ('Probability must be strictly between 0 and 1');

  if Less then
  begin
    P := 1 - PVal;
    Lower := P > 0.5;
    if Lower then
      P := PVal;
  end
  else
  begin
    P := PVal;
    Lower := P > 0.5;
    if Lower then
      P := 1 - PVal;
  end;
  Result := InvNormalQ (P);

  if Lower then
    Result := Mean - (Result * StdDev)
  else
    Result := Mean + (Result * StdDev);
end;

function NormalZ (const X: Extended): Extended;
{ Returns Z(X) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the function that defines the Standard
  Normal Distribution Curve.
  Full Accuracy of FPU }
begin
  Result := Exp (- Sqr (X) / 2.0)/Sqrt (2 * Pi);
end;

function NormalP (const A: Extended): Single;
{Returns P(A) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the Probability that a value is less
  than A, i.e. Area under the curve defined by NormalZ to the left
  of A.
  Only handles values A >= 0 otherwise exception raised.
  Accuracy: Absolute Error < 7.5e-8 }
const
  B1: Extended = 0.319381530;
  B2: Extended = -0.356563782;
  B3: Extended = 1.781477937;
  B4: Extended = -1.821255978;
  B5: Extended = 1.330274429;
var
  T: Extended;
  T2: Extended;
  T4: Extended;
begin
  if (A < 0) then
    raise EMathError.Create ('Value must be Non-Negative')
  else
  begin
    T := 1 / (1 + 0.2316419 * A);
    T2 := Sqr (T);
    T4 := Sqr (T2);
    Result := 1.0 - NormalZ (A) * (B1 * T + B2 * T2
      + B3 * T * T2 + B4 * T4 + B5 * T * T4);
  end;
end;

function NormalDistP (const Mean, StdDev, AVal: Extended): Single;
{Returns the Probability of (X < AVal) for a Normal Distribution
  with given Mean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
var
  Z: Extended;
  Lower: Boolean;
begin
  if FloatIsZero (StdDev) or (StdDev < 0) then
    raise EMathError.Create ('Standard Deviation must be positive')
  else
  begin
    Z := (AVal - Mean) / StdDev; // Convert to Standard (z) value
    Lower := Z < 0; // If Negative use Symmetry to calculate
    if Lower then
      Z := (Mean - AVal) / StdDev;
    Result := NormalP (Z); // Access function
    if Lower then // If Negative use Symmetry to calculate
      Result := 1.0 - Result;
  end;
end;

function NormalDistA (const Mean, StdDev, AVal, BVal: Extended): Single;
{ Returns the Probability of (AVal < X < BVal) for a Normal Distribution
  with given Mean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
begin
  if SameFloat (AVal, BVal) then
    Result := 0
  else
  begin
    Result := NormalDistP (Mean, StdDev, BVal) -
      NormalDistP (Mean, StdDev, AVal);
    if BVal < AVal then
      Result := -1 * Result;
  end;
end;
  
   
procedure solvePERT(filename:string;var info:TCPMInfo;var  finishTime:system.double;var CriticalPathStdDeviation:system.double);


var
        myFile1,myFile2 : TextFile;
        text1,text2,str  : string;
        ret:boolean;
        filename1:string; 
        i,j,k,l,m,n:integer;
        optimistic,most_likely,pessimistic:string;
        Te,variance:system.double;
        Pert1Info:TPERT1Info;
begin

setlength(Pert1Info,1000);

text1:='';
text2:='';
k:=0;
j:=0;
m:=0;
n:=1;

filename1:=filename+'.17423895678432945265423456787564';

repeat

ret:=not fileexists(GetTempDirectory+filename1);
if ret then break;

{$IFDEF FPC}
       deletefile(GetTempDirectory+filename1);
{$ELSE}
      deletefile(pwidechar(GetTempDirectory+filename1));
{$ENDIF}

//filename1:=filename1+'1';

until false;

AssignFile(myFile1, filename);
Reset(myFile1);
AssignFile(myFile2,GetTempDirectory+filename1);
ReWrite(myFile2);


while not Eof(myFile1) do
  begin

l:=0;
if k=0
then
 begin
    ReadLn(myFile1, text1);
    Writeln(myFile2, text1);
    ReadLn(myFile1, text1);
 end
else 
    ReadLn(myFile1, text1);


str:='';
for i:=1 to length(text1)
do
begin

if ((text1[i]<>' ') and (text1[i]<>#13)) 
then 
begin
if j=0 then 
begin
inc(j);
str:='';
end; 
str:=str+text1[i]
end
else 
begin

if j<>0 
then 
begin
j:=0;
inc(l);
if l=1 then optimistic:=str;
if l=2 then most_likely:=str;
if l=3 then pessimistic:=str;

if l=3
then 
begin
 
inc(m);
Te:=(strtofloat(optimistic)+(4*strtofloat(most_likely))+strtofloat(pessimistic))/6;

variance:=power(((strtofloat(pessimistic)-strtofloat(optimistic))/6),2);
Write(myFile2,format('%g', [Te])
 );

if m-1>length(Pert1Info)-1
   then setlength(Pert1Info,length(Pert1Info)+1000);

Pert1Info[m-1].job:=n-1;
Pert1Info[m-1].variance:=variance;

end;
if l>3 then Write(myFile2, ' '+str);

str:='';
end;


end;
end;
Writeln(myFile2, ' '+str);
inc(n)
;

if k=0 then inc(k);
l:=0;
end;
setlength(Pert1Info,m);


CloseFile(myFile1);
CloseFile(myFile2);

solveCPM(GetTempDirectory+filename1,info,finishTime);

criticalPathStdDeviation:=0;

for i:=0 to length(info)-1
do
 begin
criticalPathStdDeviation:=criticalPathStdDeviation+Pert1Info[info[i].job].variance;

end;

criticalPathStdDeviation:=sqrt(criticalPathStdDeviation);

//{$IFDEF FPC}
 //      deletefile(filename1);
//{$ELSE}
 //     deletefile(pwidechar(filename1));
//{$ENDIF}


setlength(Pert1Info,0);
end;
end.
