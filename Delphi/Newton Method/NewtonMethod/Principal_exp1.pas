unit Principal_exp1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Memo: TMemo;
    Panel1: TPanel;
    btnPI: TButton;
    btnCancel: TButton;
    procedure btnPIClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;
  cancelar: boolean;

implementation

{$R *.dfm}

uses SNum;

function seno(x, erro: string): string; overload;
var
  n: longword;
  termo: string;
begin
  n := 0;
  termo := '1';
  Result := '1';
  repeat
    inc(n);
    termo := FloatMultiplica(termo, x);
    termo := DivideDizima(termo, inttostr(n), length(erro) - 2);
    Result := FloatSoma(Result, termo);
    application.processMessages;
  until (SNumCompare(termo, erro) < 0) or cancelar;
end;

function trunc(x: string): string;
var i: integer;
begin
  i := pos('.', x);
  if i > 0 then
    Result := copy(x, 1, i - 1)
  else
    Result := x;
end;

procedure TFormPrincipal.btnPIClick(Sender: TObject);
var
  erro, s: string;
  i: integer;
begin
  btnPi.Enabled := false;
  cancelar := false;

  erro := '0.';
  for i := 1 to 1500 do
    erro := erro + '0';

  erro := erro + '1';

  s := seno('1', erro);
  memo.text := s;

  Caption := 'Pi';
  btnPi.Enabled := true;
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
end;

end.
