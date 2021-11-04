unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    procedure processar(nomearq: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.processar(nomearq: string);
var s, t, u: string;
    f: textFile;
    i: integer;
begin
  filemode:= 0;
  assignfile(f, 'V:\sem backup\Retrospectiva\delphi\' + nomearq);
  reset(f);
  while not eof(f) do
  begin
    readln(f, s);
    repeat
      i := pos('hqdefault', s);
      if i = 0 then
        break;
      u := copy(s, pos('channel/', s) + 7, 26);
      t := copy(s, i - 12, 11) + ' ' + u;
      t := copy(t, 1, pos('"', t) - 1);
      if pos(t, memo.Text) = 0 then
         memo.Lines.add('https://www.youtube.com/watch?v=' + t);
      delete(s, 1, i + 2);
    until false;
  end;
  closefile(f);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo.lines.clear;
  // eu salvei o html da playlist em um txt
  // daí tive que tirar os outros canais maniveladamente
  processar('reproduzir1.txt');
  processar('reproduzir2.txt');
  processar('reproduzir3.txt');
  showmessage(inttostr(memo.lines.count));
  close;
end;

end.
