unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    cancelar: boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  cancelar := true;
end;

function formatar(s: string): string;
begin
  result := s[2] + LowerCase(copy(s, 3, length(s)));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\tenho em pen drive\processa biba 2\novo2.txt');
  for i := 0 to memo.lines.count - 1 do
  begin
    s := memo.lines[i];
    if s[1] in ['0'..'9'] then
      memo.Lines[i] := 'novoVersiculo(' + copy(s, 1, pos(' ', s)) + ', "' + copy(s, pos(' ', s) + 1, length(s)) + '");';
  end;
end;

end.

