unit Principal_Sextic;

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
function seno(xx, erro: string): string; overload;
var
  n: longword;
  termo: string;
begin
  n := 1;
  result := xx;
  repeat
    Result := FloatMultiplica(Result, xx);
    inc(n);
    application.processMessages;
  until (n = 12) or cancelar;
  result := FloatSoma(Result, '-2.0');
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
  x, erro, s, min, max: string;
begin
  btnPi.Enabled := false;
  cancelar := false;

  min := '1';
  max := '2';
  erro := '0.0000000000001';
  memo.text := x;

    repeat
      x := DivideDizima(FloatSoma(min, max), '2', 2 * length(erro));
      s := seno(x, erro);
      memo.lines.insert(0, s);
      if SNumCompare(s, '0') < 0 then
        min := x
      else // < 0 for sure
        max := x;

    memo.text := x;

    caption := inttostr(length(x) - 2);
    application.processMessages;
    erro[length(erro)] := '0';
    erro := erro + '1';

    until (SNumCompare(min, max) >= 0) or cancelar;

  Caption := 'Pi';
  btnPi.Enabled := true;
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
end;

end.
