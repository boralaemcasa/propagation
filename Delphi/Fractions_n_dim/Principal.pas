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
    btnCancel: TButton;
    procedure btnEnumerarClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
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
  cancelar: boolean;

implementation

{$R *.dfm}

uses SNum;

function sqrt(x: string): string;
var
  min, max, rr: string;
  i: longint;
begin
  if x[1] = '-' then
  begin
    result := '0';
    exit;
  end;

  min := '';
  max := '';
  for i := 1 - (length(x) mod 2) to length(x) div 2 do
  begin
    max := max + '9';
    min := min + '0';
  end;
  min[1] := '1';

  repeat
    Divide(Soma(min, max), '2', Result, rr);
    rr := Multiplica(Result, Result);
    if rr = x then
      exit;
    if SNumCompare(rr, x) < 0 then
      min := Soma(Result, '1')
    else
      max := Subtrai(Result, '1');
    application.MainForm.Caption := inttostr(length(Subtrai(max, min)));
    application.processmessages;
  until SNumCompare(min, max) > 0;

  Result := max + '.1';
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

// Retorna o maximo divisor comum entre a e b.
function gcd(a, b: string): string;
var q, r: string;
begin
  if a = '0' then
  begin
    result := b;
    exit;
  end;

  if b = '0' then
  begin
    result := a;
    exit;
  end;

  if a[1] = '-' then
    delete(a, 1, 1);

  if b[1] = '-' then
    delete(b, 1, 1);

  if SNumCompare(a, b) < 0 then
  begin
    result := gcd(b, a);
    exit;
  end;

  Divide(a, b, q, r);

  if r = '0' then
  begin
    result := b;
    exit;
  end;

  result := gcd(b, r);
end;

function coprime(x, y: string): boolean;
begin
  result := (
    gcd(trunc(x), trunc(y)) = '1'
  );
end;

function bloqueio(x, y: string; co_prime: boolean; halfMode: byte; checkTwoHalves: boolean = true): boolean;
begin
  if (pos('.', x) > 0) and checkTwoHalves then
    Result := true
  else if (pos('.', y) > 0) and checkTwoHalves then
    Result := true
  else if co_prime and (not coprime(x, y)) and checkTwoHalves then
    Result := true
  else if (halfMode = halfYPositive) and (y[1] in ['0', '-']) then
    Result := true
  else if (halfMode = halfXPositive) and (x[1] in ['0', '-']) then
    Result := true
  else if (halfMode = halfYNegative) and (y[1] <> '-') then
    Result := true
  else if (halfMode = halfXNegative) and (x[1] <> '-') then
    Result := true
  else
    Result := false;
end;

// Basta checkar em [theta_0, theta_0 + pi/4]
function region(x, y: string): integer;
begin
  if (SNumCompare(y, '0') >= 0) and (SNumCompare(y, x) < 0) then
    Result := 1
  else if (SNumCompare(y, x) >= 0) and (SNumCompare(x, '0') > 0) then
    Result := 2
  else if (SNumCompare(x, '0') <= 0) and (SNumCompare(y, Oposto(x)) > 0) then
    Result := 3
  else if (SNumCompare(y, Oposto(x)) <= 0) and (SNumCompare(y, '0') > 0) then
    Result := 4
  else if (SNumCompare(y, '0') <= 0) and (SNumCompare(y, x) > 0) then
    Result := 5
  else if (SNumCompare(y, x) <= 0) and (SNumCompare(x, '0') < 0) then
    Result := 6
  else if (SNumCompare(x, '0') >= 0) and (SNumCompare(y, Oposto(x)) < 0) then
    Result := 7
  else
    Result := 8;
end;

procedure Incrementar(var p, q: string; co_prime: boolean; halfMode: byte); overload;
var m, rr, x, y: string;
    i, reg: shortint;
begin
  if co_prime then
  begin
    m := gcd(p, q);
    Divide(p, m, x, rr);
    Divide(q, m, y, rr);
  end
  else
  begin
    x := p;
    y := q;
  end;

  rr := Soma(Multiplica(x, x), Multiplica(y, y));
  if (halfMode = halfXnegative) and (SNumCompare(x, '0') > 0) then
  begin
    x := '0';
    y := sqrt(rr);
  end
  else if (halfMode = halfYnegative) and (SNumCompare(y, '0') > 0) then
  begin
    x := Oposto(sqrt(rr));
    y := '0';
  end
  else if (halfMode = halfXPositive) and (SNumCompare(x, '0') < 0) then
  begin
    x := '0';
    y := Oposto(sqrt(rr));
  end
  else if (halfMode = halfYPositive) and (SNumCompare(y, '0') < 0) then
  begin
    x := sqrt(rr);
    y := '0';
  end;

  reg := region(x, y);
  i := -2;

  repeat
    if (SNumCompare(y, '0') > 0) or (y = '0') and (SNumCompare(x, '0') > 0) then
    begin
      while SNumCompare(Subtrai(x, '1') , Oposto(sqrt(rr))) > 0 do
      begin
        if cancelar then break;
        x := Subtrai(x, '1');
        Application.MainForm.Caption := 'Is x = ' + x + ' a root for x² + y² = ' + rr + ' ?';
        application.processmessages;
        y := sqrt(Subtrai(rr, Multiplica(x, x)));

        if not bloqueio(x, y, co_prime, halfMode) then
        begin
          p := x;
          q := y;
          exit;
        end;

        if (region(x, y) <> reg) and not bloqueio(x, y, co_prime, halfMode, false) then
        begin
          inc(i);
          if i = 1 then
            break;
          reg := region(x, y);
        end;
      end;

      if i < 1 then
      BEGIN
        if co_prime then
        begin
          x := Oposto(sqrt(Subtrai(rr, '1')));
          y := '-1';
        end
        else
        begin
          x := Oposto(sqrt(rr));
          y := '0';
        end;

        if not bloqueio(x, y, co_prime, halfMode) then
        begin
          p := x;
          q := y;
          exit;
        end;
        x := trunc(x);
        if not co_prime then
          x := Subtrai(x, '1'); // y = 0 is welcome. x := x - 1 + 1
      END;
    end;

    if i < 1 then
      while SNumCompare(Soma(x, '1') , sqrt(rr)) < 0 do
      begin
        if cancelar then break;
        x := Soma(x, '1');
        Application.MainForm.Caption := 'Is x = ' + x + ' a root for x² + y² = ' + rr + ' ?';
        application.processmessages;
        y := Oposto(sqrt(Subtrai(rr , Multiplica(x , x))));
        if not bloqueio(x, y, co_prime, halfMode) then
        begin
          p := x;
          q := y;
          exit;
        end;

        if (region(x, y) <> reg) and not bloqueio(x, y, co_prime, halfMode, false) then
        begin
          inc(i);
          if i = 1 then
            break;
          reg := region(x, y);
        end;
      end;

    rr := Soma(rr, '1');
    if co_prime then
    begin
      x := sqrt(Subtrai(rr, '1'));
      y := '1';
    end
    else
    begin
      x := sqrt(rr);
      y := '0';
    end;

    if not bloqueio(x, y, co_prime, halfMode) then
    begin
      p := x;
      q := y;
      exit;
    end;

    reg := 1; // region(x, y);
    i := -2;

    x := trunc(x);
    if not co_prime then
      x := Soma(x, '1'); // y = 0 is welcome. x := x + 1 - 1
  until cancelar;
end;

procedure Incrementar(var p, q: string; co_prime: boolean; halfMode: byte; n: string); overload;
begin
  while SNumcompare(n, '0') > 0 do
  begin
    Incrementar(p, q, co_prime, halfMode);
    n := Subtrai(n, '1');
  end;
end;

procedure TFormPrincipal.btnEnumerarClick(Sender: TObject);
var
  p, q, n: string;
  i: integer;
begin
  p := '2';
  for i := 1 to 5000 do
    p := p + '00';
  memo.lines.text := sqrt(p);
  exit;


  btnEnumerar.Enabled := false;
  cancelar := false;
  p := Valida(Memo.Lines[0]);
  q := Valida(Memo.Lines[1]);
  n := Valida(Memo.Lines[2]);
  Memo.Lines.Clear;
  memo.lines.add(cbHalf.Text);

  if cbCoprime.Checked then
    memo.Lines.Add('Only CoPrime')
  else
    memo.lines.add('Includes not CoPrime');

  i := 0;
  repeat
    Memo.Lines.Add(p + '/' + q + ' ; r² = ' + Soma(Multiplica(p, p), Multiplica(q, q)));
    if i = 2 then
      break; // it's Break-Time!
    Incrementar(p, q, cbCoprime.Checked, cbHalf.ItemIndex, n);
    inc(i);
  until cancelar;
  Caption := 'Peano and UnLimited Fractions';
  btnEnumerar.Enabled := true;
  if cancelar then
    memo.lines.add('Operation cancelled by the user.');
end;

procedure TFormPrincipal.btnCancelClick(Sender: TObject);
begin
  cancelar := true;
end;

end.
