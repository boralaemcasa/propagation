unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    ed: TEdit;
    procedure edKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

function Resultado(list: TStringList): string;
const ErrorDivZero = 'Divisão por zero';
      ErrorLN = 'Logaritmo de não positivo';
var i, j: integer;
    sublist: TStringList;
    a, b: double;
begin
  sublist := TStringList.Create;

//pi
  i := 0;
  while i < list.Count do
  begin
    if uppercase(list[i]) = 'PI' then
      list[i] := FloatToStr(pi);

    inc(i);
  end;

  //Application.MessageBox(pchar(list.Text), 'Ini, após pi');

//o '(' mais interior, que abre o primeiro ')'
  repeat
    j := 0;
    while j < list.Count do
      if list[j] = ')' then
        break
      else inc(j);

    if j = list.Count then // nao achou
      break;

    i := j - 1;
    while list[i] <> '(' do
      dec(i);

    sublist.Clear;
    list.Delete(i);
    for j := i to j - 2 do
    begin
      sublist.Add(list[i]);
      list.Delete(i);
    end;

    list[i] := Resultado(sublist);
    if (list[i] = ErrorDivZero) or (list[i] = ErrorLN) then
    begin
      result := list[i];
      exit;
    end;

    //Application.MessageBox(pchar(list.text), 'Sem parêntese');
  until false;

//sin, cos, exp, ln
  repeat
    i := 0;
    while i < list.Count do
      if (uppercase(list[i]) = 'SIN')
           or (uppercase(list[i]) = 'COS')
           or (uppercase(list[i]) = 'EXP')
           or (uppercase(list[i]) = 'LN') then
        break
      else inc(i);

    if i = list.Count then // nao achou
      break;

    a := StrToFloat(list[i+1]);
    if uppercase(list[i]) = 'SIN' then
      a := sin(a)
    else if uppercase(list[i]) = 'COS' then
      a := cos(a)
    else if uppercase(list[i]) = 'EXP' then
      a := exp(a)
    else if a > 0 then
      a := ln(a)
    else begin
      result := ErrorLN;
      showmessage(ErrorLN);
      exit;
    end;

    if list[i][1] = '-' then
      a := -a;
    list.Delete(i);
    list[i] := FloatToStr(a);

    //Application.MessageBox(pchar(list.Text), 'Após sin(x) e outras funções');
  until false;

//'^'
  repeat
    i := 0;
    while i < list.Count do
      if list[i] = '^' then
        break
      else inc(i);

    if i = list.Count then // nao achou
      break;

    a := StrToFloat(list[i-1]);
    b := StrToFloat(list[i+1]);
    if a > 0 then
      a := exp(b * ln(a))
    else begin
      result := ErrorLN;
      showmessage(ErrorLN);
      exit;
    end;
    list.Delete(i - 1);
    list.Delete(i - 1);
    list[i - 1] := FloatToStr(a);

    //Application.MessageBox(pchar(list.Text), 'Após ^');
  until false;

//'*' e '/'
  repeat
    i := 0;
    while i < list.Count do
      if (list[i] = '*') or (list[i] = '/') then
        break
      else inc(i);

    if i = list.Count then // nao achou
      break;

    a := StrToFloat(list[i-1]);
    b := StrToFloat(list[i+1]);
    if list[i] = '*' then
      a := a * b
    else if b <> 0 then
      a := a / b
    else begin
      result := ErrorDivZero;
      showmessage(ErrorDivZero);
      exit;
    end;
    list.Delete(i - 1);
    list.Delete(i - 1);
    list[i - 1] := FloatToStr(a);

    //Application.MessageBox(pchar(list.Text), 'Após * e /');
  until false;

//só restam '+' e '-'
  if list[0] = '+' then // + sobrando
    list.delete(0)
  else if list[0] = '-' then // - de mudança de sinal
  begin
    if copy(list[1], 1, 1) = '-'
      then list[1] := copy(list[1], 2, length(list[1]) - 1)
      else list[1] := '-' + list[1];
    list.delete(0);
  end;

  while list.Count > 1 do
  begin
    a := StrToFloat(list[0]);
    b := StrToFloat(list[2]);
    if list[1] = '+'
      then a := a + b
      else a := a - b;
    list.Delete(0);
    list.Delete(0);
    list[0] := FloatToStr(a);

    //Application.MessageBox(pchar(list.Text), 'Após + e -');
  end;

  result := list[0];

  sublist.Destroy;
end;

procedure TFormPrincipal.edKeyPress(Sender: TObject; var Key: Char);
var list: TStringList;
    s: string;
    i: integer;
begin
  if key <> #13 then
    exit;
  key := #0;

  ed.SetFocus;
  ed.SelStart := 3;
  exit;

//retirar espaços
  s := ed.Text;
  repeat
    i := pos(' ', s);
    if i = 0 then // nao achou
      break;
    delete(s, i, 1);
  until false;

  list := TStringList.Create;

//inicializar list
  i := 1;
  while i < length(s) do
  begin
    if s[i] in ['+','-','*','/','^','(',')'] then
    begin
      if i > 1 then
        list.Add(copy(s, 1, i - 1));
      list.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);
  end;

  if s[i] = ')' then
  begin
    delete(s, i, 1);
    if s <> '' then
      list.Add(s);
    list.Add(')');
  end
  else list.Add(s);

  ed.Text := Resultado(list);

  list.Destroy;
  //close;
end;

end.
