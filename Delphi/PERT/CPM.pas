// This library that uses JNI Wrapper 
// was written by Amine Moulay Ramdane.


unit CPM;

interface

// and this is also an example that shows how to call 
// static methods using the JNIWrapper unit.

{$APPTYPE CONSOLE}

    uses
{$IFDEF FPC}
       Windows, 
        SysUtils,
        Classes,
        JNIWrapper,
        JNI,Javaruntime;
{$ELSE}
        system.SysUtils,
        system.Classes,
        JNIWrapper,
       JNI,Javaruntime,
        winapi.Windows; 
{$ENDIF}

{$IFDEF FPC}
  type char = system.char;
{$ELSE}
 type char = system.char;
{$ENDIF}

   Tinfo = record
      job: integer;
    start: system.double;
    finish: system.double;
     end;

TCPMInfo = array of Tinfo;

 

procedure solveCPM(filename:string;var info:TCPMInfo;var finishTime:system.double);

IMPLEMENTATION 

var Runtime : TJavaRuntime;

function Split(Str: string ; Delimiter:char;var ListOfStrings: TStringList):boolean ;

var a:char;

begin
 a:=delimiter;
   ListOfStrings:=TStringList.create;
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := char(a);
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;
    
   
procedure solveCPM(filename:string;var info:TCPMInfo;var finishTime:system.double);


var
        JNITest : TJavaClass;
        Params1,Params2 ,Params: TJavaParams;
        JMethod1,Jmethod2 : TJavaMethod;
        i:integer;   
        ret1,ret2:jvalue;     
        tstr1,tstr2:TStrings;
        TestObject : TJavaObject;
        arr2:TCPMInfo;
        Name:string;
       StrList1,StrList2:TStringList;
       dist:Extended;


begin

//Runtime := TJavaRuntime.Create(SunJava2); 

       try
        arr2:=info;
 
Name:=filename;
   if FileExists(Name)
   then
    begin
             Params1 := TJavaParams.Create;
             Params1.addString(Name);
             
    end   
 else 
   begin
   writeln('The file '+Name+' doesn''t exist !');
   halt
  end;     
           Params2 := TJavaParams.Create;
            



            JNITest := TJavaClass.Create('CPM');

      
tstr1:=TStringlist.create;
tstr2:=TStringlist.create;

JMethod2 := TJavaMethod.Create(JNITest, 'SP1', static, AStringArray, params1, Nil);

ret2:=JMethod2.Call(Params1, nil);
tstr2:=JstringArrayToDTStrings(ret2.l);


Split(tstr2[0],'_', StrList1);

setlength(info,strlist1.count-1);

dist:=0.0;
for i:=0 to StrList1.count-2
do
 begin
  Split(StrList1[i],'-', StrList2);
  
info[i].job:=i;
info[i].start:=strtofloat(strlist2[0]);
info[i].finish:=strtofloat(strlist2[1]);


 // writeln('job: ',i,'  start: ',strlist2[0],'  finish: ',strlist2[1]); 
  StrList2.free; 
end;

finishTime:=strtofloat(StrList1[StrList1.count-1]);
//writeln('Finish time is: ', StrList1[StrList1.count-1]);

StrList1.free;

            Params2.Free;

            JMethod2.Free;

            JNITest.Free;
            tstr1.free;
            tstr2.free;
          
        except
         on EJvmException do 
             ShowException(ExceptObject, ExceptAddr);
        end;

end;

initialization
 Runtime := TJavaRuntime.GetDefault;  

finalization
 runtime.callexit(0);
runtime.free;

end.
