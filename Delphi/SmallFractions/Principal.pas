unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Memo: TMemo;
    Panel1: TPanel;
    btnEnumerar: TButton;
    cbCoprime: TCheckBox;
    cbHalf: TComboBox;
    procedure btnEnumerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  halfYPositive = 0;
  halfYNegative = 1;
  halfXPositive = 2;
  halfXNegative = 3;
  halfAll = 4;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

// Retorna o maximo divisor comum entre a e b.
function gcd(a, b: integer): integer;
var r: integer;
begin
  if a = 0 then
  begin
    result := b;
    exit;
  end;

  if b = 0 then
  begin
    result := a;
    exit;
  end;

  if a < 0 then
    a := -a;

  if b < 0 then
    b := -b;

  if a < b then
  begin
    result := gcd(b, a);
    exit;
  end;

  r := a mod b;

  if r = 0 then
  begin
    result := b;
    exit;
  end;

  result := gcd(b, r);
end;

function coprime(x, y: double): boolean;
begin
  result := (
    gcd(round(x), round(y)) = 1
  );
end;

function bloqueio(x, y: double; co_prime: boolean; halfMode: byte): boolean;
begin
  if x <> round(x) then
    Result := true
  else if y <> round(y) then
    Result := true
  else if co_prime and (not coprime(x, y)) then
    Result := true
  else if (halfMode = halfYPositive) and (y <= 0) then
    Result := true
  else if (halfMode = halfXPositive) and (x <= 0) then
    Result := true
  else if (halfMode = halfYNegative) and (y >= 0) then
    Result := true
  else if (halfMode = halfXNegative) and (x >= 0) then
    Result := true
  else
    Result := false;
end;

procedure Incrementar(var p, q: integer; co_prime: boolean; halfMode: byte); overload;
var m, rr: integer;
    x, y: double;
begin
  if co_prime then
  begin
    m := gcd(p, q);
    x := p div m;
    y := q div m;
  end
  else
  begin
    x := p;
    y := q;
  end;

  rr := round(sqr(x) + sqr(y));

  repeat
    if (y > 0) or (y = 0) and (x > 0) then
    begin
      while x - 1 > - sqrt(rr) do
      begin
        x := x - 1;
        y := sqrt(rr - x * x);
        if not bloqueio(x, y, co_prime, halfMode) then
        begin
          p := round(x);
          q := round(y);
          exit;
        end;
      end;

      if co_prime then
      begin
        x := -sqrt(rr - 1);
        y := -1;
      end
      else
      begin
        x := -sqrt(rr);
        y := 0;
      end;

      if not bloqueio(x, y, co_prime, halfMode) then
      begin
        p := round(x);
        q := round(y);
        exit;
      end;
      x := trunc(x);
      if not co_prime then
        x := x - 1; // y = 0 is welcome. x := x - 1 + 1
    end;

    while x + 1 < sqrt(rr) do
    begin
      x := x + 1;
      y := -sqrt(rr - x * x);
      if not bloqueio(x, y, co_prime, halfMode) then
      begin
        p := round(x);
        q := round(y);
        exit;
      end;
    end;

    inc(rr);
    if co_prime then
    begin
      x := sqrt(rr - 1);
      y := 1;
    end
    else
    begin
      x := sqrt(rr);
      y := 0;
    end;

    if not bloqueio(x, y, co_prime, halfMode) then
    begin
      p := round(x);
      q := round(y);
      exit;
    end;
    x := trunc(x);
    if not co_prime then
      x := x + 1; // y = 0 is welcome. x := x + 1 - 1
  until false;
end;

procedure Incrementar(var p, q: integer; co_prime: boolean; halfMode: byte; n: integer); overload;
begin
  while n > 0 do
  begin
    Incrementar(p, q, co_prime, halfMode);
    dec(n);
  end;
end;

procedure TFormPrincipal.btnEnumerarClick(Sender: TObject);
var p, q, i, n: integer;
begin
  p := StrToInt(Memo.Lines[0]);
  q := StrToInt(Memo.Lines[1]);
  n := StrToInt(Memo.Lines[2]);
  Memo.Lines.Clear;
  memo.lines.add(cbHalf.Text);

  if cbCoprime.Checked then
    memo.Lines.Add('Only CoPrime')
  else
    memo.lines.add('Includes not CoPrime');

  i := 0;
  repeat
    Memo.Lines.Add(IntToStr(p) + '/' + IntToStr(q) + ' ; r² = ' + IntToStr(sqr(p) + sqr(q)));
    Incrementar(p, q, cbCoprime.Checked, cbHalf.ItemIndex, n);
    inc(i);
  until i = 1000;
end;

end.
