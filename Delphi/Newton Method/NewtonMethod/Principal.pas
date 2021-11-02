unit Principal;

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

// Sigma (-1)^n / (2n + 1)! * x^{2n + 1}
function sin(xx, erro: string): string; overload;
var
  n: longword;
  termo: string;
begin
  n := 0;
  termo := xx;
  xx := FloatMultiplica(xx, xx);
  Result := termo;
  repeat
    inc(n);
  //termo := - termo / (2n) / (2n + 1) * x * x;
    termo := oposto(termo);
    termo := FloatMultiplica(termo, xx);
    termo := copy(termo, 1, pos('.', termo) + length(erro) + 20);
    termo := DivideDizima(termo, IntToStr(2 * n * (2 * n + 1)), length(erro) - 2);
    Result := FloatSoma(Result, termo);
    application.processMessages;
  until (odd(n) and (SNumCompare(Oposto(termo), erro) < 0)) or cancelar;
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
  x, erro, s: string;
  min, max, middle: byte;
begin
  btnPi.Enabled := false;
  cancelar := false;

  x := '3.';
  erro := '0.001';
  memo.text := x;

  repeat
    x := x + '4';
    min := 0 + 48;
    max := 9 + 48;
    repeat
      middle := (min + max) div 2;
      x[length(x)] := char(middle);
      s := sin(x, erro);
      if SNumCompare(s, '0') > 0 then
        min := middle + 1
      else // < 0 for sure
        max := middle - 1
    until (min > max) or cancelar;

    if cancelar then
      break;

    x[length(x)] := char(max);
    memo.text := memo.text + char(max);
    caption := inttostr(length(x) - 2);
    application.processMessages;
    erro[length(erro)] := '0';
    erro := erro + '1';
  until cancelar or (length(x) >= 1002);
  Caption := 'Pi';
  btnPi.Enabled := true;
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
end;

end.
