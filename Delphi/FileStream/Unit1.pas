unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ReadLine( var Stream: TFileStream; var Line: string): boolean;
var
  RawLine: UTF8String;
  ch: AnsiChar;
begin
result := False;
ch := #0;
while (Stream.Read( ch, 1) = 1) and (ch <> #10) do
  begin
  result := True;
  RawLine := RawLine + ch
  end;
Line := RawLine + ch;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fsa, fsb, fsc: TFileStream;
  s: string;
begin
  fsa := TFileStream.Create('v:\java\196n5 parte a.txt', fmOpenRead);
  fsb := TFileStream.Create('v:\java\196n5.txt', fmOpenRead);
  fsc := TFileStream.Create('v:\java\196n5 saida.txt', fmCreate or fmOpenWrite);
  readline(fsa, s);
  fsc.write(s[1], length(s));
  readline(fsb, s);
  fsc.write(s[1], length(s));
  fsa.Free;
  fsb.free;
  fsc.free;
end;

end.
