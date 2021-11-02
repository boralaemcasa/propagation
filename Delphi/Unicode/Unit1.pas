unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntFileCtrl, TntStdCtrls;

type
  TForm1 = class(TForm)
    memo: TTntMemo;
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

procedure TForm1.Button1Click(Sender: TObject);
var
  fs, fs2: TFileStream;
  w: Word;
  ws: widestring;
  S, s2: string;
  i, x, contador, mega: Integer;
begin
{open file}
  fs := TFileStream.Create('V:\java\novo servidor\heroku_backup.sql', fmOpenRead);
  fs2 := TFileStream.Create('V:\java\novo servidor\editado\heroku_out.tmp', fmOpenWrite or fmCreate);

{stream can contain unicode characters - we must check before parse}
  fs.Read(w, SizeOf(w));
  case w of
    $FEFF, $FFFE:
begin
  if (fs.Size > fs.Position) then
  begin
    i := fs.Size - fs.Position;
    SetLength(ws, i div 2);
    fs.Read(ws[1], i);
    if (w = $FFFE) then
    begin
      for i := 1 to Length(ws) do
        ws[i] := WideChar(Swap(Word(ws[i])));
    end;
  end;
end;
else
{restore position}
  fs.Seek(-SizeOf(w), soFromCurrent);

  contador := 0;
  mega := 0;
  repeat
    ws := '';
    SetString(S2, nil, 2);
    repeat
      x := fs.Read(Pointer(S2)^, 2);
      if x <= 0 then break;
      ws := ws + s2;
      inc(contador);
      if contador mod 524288 = 0 then
      begin
        contador := 0;
        inc(mega);
        caption := inttostr(mega);
      end;
    until pos(#$0d#$0a#$0d#$0a, ws) > 0;

    application.processmessages;
    s := StringReplace(ws, #$0d#$0a#$0d#$0a, #$0d#$0a, [rfreplaceall]);
    fs2.Write(Pointer(S)^, length(s));
  until x <= 0;
end;

{close file}
fs.Free;
fs2.Free;
end;

end.

