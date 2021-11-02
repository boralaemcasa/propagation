unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    MemoOut: TMemo;
    MemoIn: TMemo;
    BtnEval: TButton;
    procedure BtnEvalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum;

procedure TFormPrincipal.BtnEvalClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := memoIn.text;
  while (length(s) > 0) and ((s[1] < '0') or (s[1] > '9')) and (s[1] <> '-') do
    delete(s, 1, 1);

  i := 1;
  while i <= length(s) do
    if (s[i] >= '0') and (s[i] <= '9') then
      inc(i)
    else if (s[i] in ['+', '-', '*', '/', '^', '#']) and (i < length(s)) then
      if (s[i+1] < '0') or (s[i+1] > '9') then
        delete(s, i+1, 1)
      else inc(i)
    else delete(s, i, 1);

  memoOut.Clear;
  i := 1;
  if s[1] = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] in ['+', '-', '*', '/', '^', '#'] then
    begin
      memoOut.Lines.Add(copy(s, 1, i-1));
      memoOut.lines.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memoOut.lines.add(s);

  i := 1; //if priority = 2 then
  while i < memoOut.Lines.Count do
  begin
    if memoOut.Lines[i] = '^' then
    begin
      MemoOut.Lines[i - 1] := FracPower(MemoOut.Lines[i - 1], MemoOut.Lines[i + 1]);
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    if memoOut.Lines[i] = '#' then
    begin
      MemoOut.Lines[i - 1] := FracPower(MemoOut.Lines[i - 1], FracOposto(MemoOut.Lines[i + 1]));
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    inc(i);
  end;

  i := 1; //if priority = 1 then
  while i < memoOut.Lines.Count do
  begin
    if memoOut.Lines[i] = '*' then
    begin
      MemoOut.Lines[i - 1] := FracMul(MemoOut.Lines[i - 1], MemoOut.Lines[i + 1]);
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    if memoOut.Lines[i] = '/' then
    begin
      MemoOut.Lines[i - 1] := FracDiv(MemoOut.Lines[i - 1], MemoOut.Lines[i + 1]);
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    inc(i);
  end;

  i := 1; // priority = 0
  while i < memoOut.Lines.Count do
  begin
    if memoOut.Lines[i] = '+' then
    begin
      MemoOut.Lines[i - 1] := FracAdd(MemoOut.Lines[i - 1], MemoOut.Lines[i + 1]);
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    if memoOut.Lines[i] = '-' then
    begin
      MemoOut.Lines[i - 1] := FracSub(MemoOut.Lines[i - 1], MemoOut.Lines[i + 1]);
      memoOut.Lines.Delete(i);
      memoOut.Lines.Delete(i);
      i := 0;
    end;

    inc(i);
  end;
end;

end.
