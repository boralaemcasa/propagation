unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TFormPrincipal = class(TForm)
    PanelIn: TPanel;
    PanelEval: TPanel;
    MemoOut: TMemo;
    MemoIn: TMemo;
    PopupMenu1: TPopupMenu;
    Loadfromfile1: TMenuItem;
    OpenDialog: TOpenDialog;
    Showlog1: TMenuItem;
    N1: TMenuItem;
    AbsoluteValue1: TMenuItem;
    GreatestCommonDivisor1: TMenuItem;
    Fraction1: TMenuItem;
    Solveforx1: TMenuItem;
    NewtonBinomial1: TMenuItem;
    Evaluate1: TMenuItem;
    Clear1: TMenuItem;
    IncreaseSize1: TMenuItem;
    DecreaseSize1: TMenuItem;
    PanelButtons: TPanel;
    BtnEval: TButton;
    BtnCancel: TButton;
    Logarithm1: TMenuItem;
    Floor1: TMenuItem;
    procedure BtnEvalClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Loadfromfile1Click(Sender: TObject);
    procedure Showlog1Click(Sender: TObject);
    procedure AbsoluteValue1Click(Sender: TObject);
    procedure GreatestCommonDivisor1Click(Sender: TObject);
    procedure Fraction1Click(Sender: TObject);
    procedure Solveforx1Click(Sender: TObject);
    procedure NewtonBinomial1Click(Sender: TObject);
    procedure Evaluate1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure IncreaseSize1Click(Sender: TObject);
    procedure DecreaseSize1Click(Sender: TObject);
    procedure Logarithm1Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure Floor1Click(Sender: TObject);
  private
  public
    cancelar: boolean;
  end;

var
  FormPrincipal: TFormPrincipal;

function AbsolutePosition(variable, s: string): integer;
function AlgebricalOpposite(s: string): string;
function AppendLeftV(x, y: string): string;
function BasisDifference(x, x3: string): string;
function CommandProcess(s: string; LOGFILE: string; var cancelar: boolean): string;
function Denominator(s: string): string;
function Distribution(x, y: string; LOGFILE: string): string;
function ExistVariable(s: string): boolean;
function IsVariable(s: string): char;
procedure logToFile(s: string; LOGFILE: string);
function NoParenthesisProcess(s: string; LOGFILE: string): string;
function OppositeSign(s: string): char;
function SolveFor(variable, s: string; LOGFILE: string): string;
function WithParenthesisMONOProcess(redirect: boolean; s: string; LOGFILE: string; var cancelar: boolean): string;
function WithParenthesisProcess(redirect: boolean; s: string; LOGFILE: string; var cancelar: boolean): string;

implementation

{$R *.dfm}

uses SNum;

const
  LOG_FILE = 'Algebra.logToFile';
  ENABLEPOWER = false; // showmessage whenever '^'

procedure TFormPrincipal.BtnEvalClick(Sender: TObject);
var hora: TDateTime;
begin
  hora := now;
  memoOut.text := CommandProcess(MemoIn.text, ExtractFilePath(Application.ExeName) + LOG_FILE, cancelar);
  hora := now - hora;
  caption := inttostr(round(hora * 24 * 60 * 60)) + ' segundos';
end;

function NoParenthesisProcess(s: string; LOGFILE: string): string;
var
  i, j: integer;
  memo: TStringList;
begin
  s := StringReplace(s, #13#10, '', [rfReplaceAll]);
  if s = FracValida(s) then
  begin
    Result := s;
    exit;
  end;

  logToFile('no parenthesis process entry: ' + s, LOGFILE);
  memo := TStringList.Create;
  while (length(s) > 0) and not (s[1] in ['0'..'9', '-', 'a'..'z', 'V', '(']) do
    delete(s, 1, 1);

  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', 'a'..'z', 'V', '(', ')'] then
      inc(i)
    else if (s[i] in ['+', '-', '*', '/', '^']) and (i < length(s)) then
      if s[i + 1] in ['0'..'9', 'a'..'z', 'V', '('] then
        inc(i)
      else delete(s, i + 1, 1)
    else delete(s, i, 1);

  i := 1;
  if copy(s, 1, 1) = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] = 'V' then
    begin
      memo.Add(copy(s, 1, i - 1));
      delete(s, 1, i - 1);
      i := 2;
      while s[i] in ['0'..'9', 'a'..'z'] do
        inc(i);
    end
    else if s[i] in ['+', '-', '*', '/', '^', 'a'..'z'] then
    begin
      memo.Add(copy(s, 1, i - 1));
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memo.add(s);

  i := 0;
  repeat
    if i = memo.count then
      break;
    if memo[i] = '' then
      memo.Delete(i)
    else inc(i);
  until false;

  i := 1; //if priority = 2 then
  while i < memo.Count do
  begin
    if i + 1 < memo.count then
      if memo[i] = '^' then
        if (memo[i - 1] = FracValida(memo[i - 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracPower(Memo[i - 1], Memo[i + 1]);
          memo.Delete(i);
          memo.Delete(i);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
        end;

    inc(i);
  end;

  s := StringReplace(memo.text, #13#10, '', [rfReplaceAll]);
  memo.clear;
  i := 1;
  if copy(s, 1, 1) = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] = 'V' then
    begin
      memo.Add(copy(s, 1, i - 1));
      delete(s, 1, i - 1);
      i := 2;
      while s[i] in ['0'..'9', 'a'..'z'] do
        inc(i);
    end
    else if s[i] in ['+', '-', '*', '/', 'a'..'z'] then
    begin
      memo.Add(copy(s, 1, i - 1));
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memo.add(s);

  i := 0;
  repeat
    if i = memo.count then
      break;
    if memo[i] = '' then
      memo.Delete(i)
    else inc(i);
  until false;

  i := 1; //if priority = 1 then
  while i < Memo.Count do
  begin
    if i + 1 < memo.count then
      if Memo[i] = '*' then
        if memo[i + 1] <> FracValida(memo[i + 1]) then
          if memo[i - 1] <> FracValida(memo[i - 1]) then
          begin
            Memo.Delete(i);
            i := 0;
            repeat
              inc(i);
              if (i >= 1) and (i < memo.Count) and (memo[i - 1][1] = 'V') then // V7 x = x V7
                if memo[i][1] in ['a'..'z'] then
                begin
                  if (i >= 2) and (memo[i - 2] = '/') then
                  begin
                    s := memo[i];
                    memo.Delete(i);
                    memo.Insert(i - 2, s);
                    dec(i);
                  end
                  else
                  begin
                    s := memo[i];
                    memo[i] := memo[i - 1];
                    memo[i - 1] := s;
                  end;
                  i := 0;
                  //showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
                end;
            until i >= memo.Count;
            i := 0;
          end
          else
          begin
            Memo[i - 1] := Memo[i - 1] + Memo[i + 1];
            Memo.Delete(i);
            Memo.Delete(i);
            i := 0;
          end
        else if memo[i - 1] <> FracValida(memo[i - 1]) then
        begin
          if (i >= 2) and (memo[i - 2] = FracValida(memo[i - 2])) then
          begin
            memo[i - 2] := FracMul(memo[i - 2], memo[i + 1]);
            Memo.Delete(i);
            Memo.Delete(i);
            i := 0;
          end
          else
          begin
            Memo[i - 1] := Memo[i + 1] + Memo[i - 1];
            Memo.Delete(i);
            Memo.Delete(i);
            i := 0;
          end;
        end
        else
        begin
          Memo[i - 1] := FracMul(Memo[i - 1], Memo[i + 1]);
          Memo.Delete(i);
          Memo.Delete(i);
          i := 0;
        end;

    inc(i);
  end;

  s := StringReplace(memo.text, #13#10, '', [rfReplaceAll]);
  memo.clear;
  i := 1;
  if copy(s, 1, 1) = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] = 'V' then
    begin
      memo.Add(copy(s, 1, i - 1));
      delete(s, 1, i - 1);
      i := 2;
      while s[i] in ['0'..'9', 'a'..'z'] do
        inc(i);
    end
    else if s[i] in ['+', '-', '*', '/', '^', 'a'..'z'] then
    begin
      memo.Add(copy(s, 1, i - 1));
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memo.add(s);

  i := 0;
  repeat
    if i = memo.count then
      break;
    if memo[i] = '' then
      memo.Delete(i)
    else inc(i);
  until false;

  i := 1; //if priority = 2 then
  while i < Memo.Count do
  begin
    if Memo[i] = '^' then
    begin
      j := i + 3;
      repeat
        if (j < memo.Count) and (memo[j - 1] = '/') and (memo[i - 1] = memo[j]) and ((j + 1 >= memo.count) or (memo[j + 1] <> '^'))
          and (memo[i + 2] <> '+') and (memo[i + 2] <> '-') then // x^3 / x
        begin
          s := Subtrai(Memo[i + 1], '1');
          if s = '1' then
          begin end
          else if s = '0' then
            memo[i - 1] := '1'
          else
            memo[i - 1] := memo[i - 1] + '^' + s;
          Memo.delete(j - 1);
          Memo.delete(j - 1);
          Memo.delete(i);
          Memo.delete(i);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        inc(j);
        if j > memo.count - 1 then
          break;
      until (memo[j] = '+') or (memo[j] = '-');

      j := i - 3;
      repeat
        if (j >= 0) and (memo[i - 2] = '/') and (memo[i - 1] = memo[j]) and (memo[j + 1] <> '^') then // x / x^3
        begin
          Memo[j] := '1';
          if memo[i + 1] = '2' then
          begin
            memo.delete(i);
            memo.delete(i);
          end
          else
            Memo[i + 1] := Subtrai(memo[i + 1], '1');

          if j >= 1 then
            if memo[i - 1][1] in ['a'..'z', 'V'] then
              memo.Delete(j);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        dec(j);
        if j < 0 then
          break;
      until (memo[j] = '+') or (memo[j] = '-');

      j := i - 5;
      while (j >= 0) and (memo[j] <> '+') and (memo[j] <> '-')
        and (memo[i - 4] <> '+') and (memo[i - 4] <> '-') and (memo[i - 3] <> '+') and (memo[i - 3] <> '-') do
      begin
        if (j >= 0) and (memo[i - 2] = '/') and (memo[i - 1] = memo[j]) and (memo[j + 1] = '^') then // x^2 / x^3
        begin
          s := Subtrai(memo[i + 1], memo[j + 2]);
          if s = '1' then
            Memo[i - 1] := '1/' + memo[j]
          else if s = '-1' then
            Memo[i - 1] := memo[j]
          else if s = '0' then
            Memo[i - 1] := '1'
          else if SNumCompare(s, '1') > 0 then
            Memo[i - 1] := '1/' + memo[j] + '^' + s
          else
            Memo[i - 1] := memo[j] + '^' + SNumOposto(s);
          Memo.Delete(i);
          Memo.Delete(i);
          memo.delete(i - 2);
          memo.delete(j);
          memo.delete(j);
          memo.delete(j);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        dec(j);
      end;
    end;
    inc(i);
  end;

  i := 1; // after '/'
  while i < Memo.Count do
  begin
    if Memo[i] = '/' then
      if i + 1 < memo.count then
      begin
        j := i - 1;
        repeat
          if memo[j] = memo[i + 1] then // x / x
          begin
            Memo[j] := '1';
            Memo.Delete(i);
            Memo.Delete(i);
            if (j >= 1) and (memo[j - 1] = FracValida(memo[j - 1])) then
              Memo.Delete(j)
            else if (j + 1 < memo.count) and ((memo[j + 1] <> '+') and (memo[j + 1] <> '-') and (memo[j + 1] <> '^') and (memo[j + 1] <> '*') and (memo[j + 1] <> '/')) then
              Memo.Delete(j)
            else if (j = 1) and (memo[0] = '-') then
            begin
              memo.Delete(1);
              if (memo[0] = '-') or (memo.count > 1) and ((memo[1] = '+') or (memo[1] = '-') or (memo[1] = '^') or (memo[1] = '*')) then
                memo[0] := '-1';
            end;

            i := 0;
            //showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
            break;
          end;

          dec(j);
          if j < 0 then
            break;
        until (memo[j] = '+') or (memo[j] = '-') or (memo[j] = '*');
      end;
    inc(i);
  end;

  i := 1; // after '/'
  while i < Memo.Count do
  begin
    if Memo[i] = '^' then
    begin
      j := i + 2;
      while (j < memo.count) and (memo[j] <> '+') and (memo[j] <> '-') and (memo[j] <> '/') do
      begin
        if (i >= 1) and (j < memo.Count) and (memo[i - 1] = memo[j]) and ((j + 1 >= memo.count) or (memo[j + 1] <> '^')) then // x^3 x
        begin
          s := Soma(Memo[i + 1], '1');
          if s <> '1' then
            memo[i - 1] := memo[i - 1] + '^' + s;
          Memo.delete(j);
          Memo.delete(i);
          Memo.delete(i);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        inc(j);
        if j > memo.count - 1 then
          break;
      end;

      j := i - 2;
      while (j >= 0) and (memo[j] <> '+') and (memo[j] <> '-') and (memo[j] <> '(') do
      begin
        if (i >= 1) and (j >= 0) and (memo[i - 1] = memo[j]) and (memo[j + 1] <> '^') then // x x^3
        begin
          s := Soma(Memo[i + 1], '1');
          if s <> '1' then
            memo[j] := memo[j] + '^' + s;
          Memo.delete(i - 1);
          Memo.delete(i - 1);
          Memo.delete(i - 1);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        dec(j);
      end;

      j := i + 2;
      while (j < memo.count) and (memo[j] <> '+') and (memo[j] <> '-') and (memo[j] <> '/') do
      begin
        if (i >= 1) and (j + 1 < memo.Count) and (memo[i - 1] = memo[j]) and (memo[j + 1] = '^') then // x^3 x^2
        begin
          s := Soma(Memo[i + 1], Memo[j + 2]);
          if s <> '1' then
            memo[i - 1] := memo[i - 1] + '^' + s;
          Memo.delete(j);
          Memo.delete(j);
          Memo.delete(j);
          Memo.delete(i);
          Memo.delete(i);
          i := 0;
          if EnablePower then
            showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
          break;
        end;
        inc(j);
        if j > memo.count - 1 then
          break;
      end;
    end;

    inc(i);
  end;

  i := 1; //if priority = 1 then
  while i < Memo.Count do
  begin
    if (i >= 1) and (memo[i] = '1') then
      if memo[i - 1][1] in ['a'..'z', 'V'] then
      begin
        memo.Delete(i);
        i := 0;
      end;

    if (i >= 1) and (memo[i] = FracValida(memo[i])) then // x7 = 7x
      if memo[i - 1][1] in ['a'..'z', 'V'] then
      begin
        if (i >= 2) and (memo[i - 2] = '/') then
        begin
          s := memo[i];
          memo.Delete(i);
          memo.Insert(i - 2, s);
          dec(i);
        end
        else
        begin
          s := memo[i];
          memo[i] := memo[i - 1];
          memo[i - 1] := s;
        end;
        if (i >= 2) and (memo[i - 2] = fracValida(memo[i - 2])) then
        begin
          memo[i - 2] := fracmul(memo[i - 2], s);
          memo.Delete(i - 1);
        end;
        i := 0;
        //showmessage(StringReplace(memo.text, #13#10, '', [rfReplaceAll]));
      end;

    if (i >= 1) and (copy(memo[i], 1, 2) = '1/') then
      if memo[i - 1][1] in ['a'..'z', 'V'] then
      begin
        s := memo[i];
        delete(s, 1, 1);
        memo[i] := s;
        i := 0;
      end;

    j := i;
    if (i >= 1) and (memo[i - 1][1] in ['a'..'z', 'V']) then
      while (memo[j] <> '+') and (memo[j] <> '-') and (memo[j] <> '(') do
      begin
        if (j < memo.count) and (memo[j][1] in ['a'..'z', 'V']) then // x x
          if memo[i - 1] = memo[j] then
          begin
            memo[i - 1] := memo[i - 1] + '^2';
            memo.Delete(j);
            i := 0;
            break
          end;
        inc(j);
        if j > memo.count - 1 then
          break;
      end;

    inc(i);
  end;

  if (memo[0] = '1') and (memo.count > 1) and (memo[1][1] in ['a'..'z', 'V']) then
    memo.Delete(0);

  i := 1; //if priority = 1 then
  while i < Memo.Count do
  begin
    if i + 1 < memo.count then
      if Memo[i] = '*' then
        if (memo[i - 1] = FracValida(memo[i - 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracMul(Memo[i - 1], Memo[i + 1]);
          Memo.Delete(i);
          Memo.Delete(i);
          i := 0;
        end;

    if (i >= 1) and (i + 1 < memo.count) then
      if Memo[i] = '/' then
        if (memo[i - 1] = FracValida(memo[i - 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracDiv(Memo[i - 1], Memo[i + 1]);
          Memo.Delete(i);
          Memo.Delete(i);
          i := 0;
        end;

    inc(i);
  end;

  s := StringReplace(memo.text, #13#10, '', [rfReplaceAll]);
  memo.clear;
  i := 1;
  if copy(s, 1, 1) = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] in ['+', '-'] then
    begin
      memo.Add(copy(s, 1, i - 1));
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memo.add(s);

  i := 0;
  repeat
    if i = memo.count then
      break;
    if memo[i] = '' then
      memo.Delete(i)
    else inc(i);
  until false;

  i := 1; // priority = 0
  while i < Memo.Count do
  begin
    if i + 1 < memo.count then
      if Memo[i] = '+' then
        if (memo[i - 1] = FracValida(memo[i - 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracAdd(Memo[i - 1], Memo[i + 1]);
          Memo.Delete(i);
          Memo.Delete(i);
          i := 0;
        end;

    if (i >= 1) and (i + 1 < memo.count) then
      if Memo[i] = '-' then
        if (memo[i - 1] = FracValida(memo[i - 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracSub(Memo[i - 1], Memo[i + 1]);
          Memo.Delete(i);
          Memo.Delete(i);
          i := 0;
        end;

    inc(i);
  end;

  if memo.count > 1 then
    while (Memo[0] = '-') and (memo[1] = FracValida(memo[1])) do
    begin
      Memo[0] := FracOposto(Memo[1]);
      Memo.Delete(1);
    end;

  if memo.Count = 0 then
    result := '0'
  else
  begin
    result := '';
    for i := 0 to memo.Count - 1 do
      result := result + memo[i];
  end;
  memo.Free;
  Result := StringReplace(result, '+-', '-', [rfReplaceAll]);
  logToFile('no parenthesis process result: ' + Result, LOGFILE);
end;

function WithParenthesisProcess(redirect: boolean; s: string; LOGFILE: string; var cancelar: boolean): string;
begin
  repeat
    Result := WithParenthesisMONOProcess(redirect, s, LOGFILE, cancelar);
    if Result = s then
      break;
    s := Result;
  until false;
end;

function WithParenthesisMONOProcess(redirect: boolean; s: string; LOGFILE: string; var cancelar: boolean): string;
var
  t, target: string;
  i, j, max: integer;
  maxfound: boolean;
  memo, gcd, newton, frac: TStringList;
begin
  if redirect and (pos('(', s) = 0) then
  begin
    result := NoParenthesisProcess(s, LOGFILE);
    exit;
  end;

  logToFile('with parenthesis mono process entry: ' + s, LOGFILE);
  result := s;
  max := 0;

//trim alphabet
  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', '+', '-', '*', '/', '^', '(', ')', ',', 'a'..'z', 'V'] then
      inc(i)
    else delete(s, i, 1);

  if s = '' then
  begin
    result := '';
    //Application.MessageBox('Empty string', 'Syntax error', MB_ICONEXCLAMATION);
    exit;
  end;

  if not (s[1] in ['0'..'9', '(', '+', '-', 'a'..'z', 'V']) then
  begin
    result := '';
    Application.MessageBox('+, -, variable or digit or ( expected as first character', 'Syntax error', MB_ICONEXCLAMATION);
    exit;
  end;

  j := 0;
  memo := TStringList.Create;
  gcd := TStringList.Create;
  newton := TStringList.Create;
  frac := TStringList.Create;
  i := 1;
  while i <= length(s) do
    if s[i] in ['+', '-', '*', '/'] then
    begin
      if not (s[i + 1] in ['0'..'9', '(', 'a'..'z', 'V']) then
      begin
        result := '';
        Application.MessageBox(PChar('Variable or digit or ( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;

      t := copy(s, 1, i - 1);
      if t <> '' then
        memo.Add(t);
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else if s[i] in ['(', ','] then
    begin
      if not (s[i + 1] in ['+', '-', '0'..'9', '(', 'a'..'z', 'V']) then
      begin
        result := '';
        Application.MessageBox(PChar('+, - or ( or digit or  variable expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;
      if s[i] = ',' then
        if (gcd.count = 0) and (newton.count = 0) then
        begin
          result := '';
          Application.MessageBox('Comma outside gcd or binom', 'Syntax error', MB_ICONEXCLAMATION);
          memo.free;
          gcd.free;
          newton.free;
          frac.free;
          exit;
        end
        else if newton.Count > 0 then
          if (newton[newton.Count - 1] = ',') and (newton[newton.count - 2] = inttostr(j)) then
          begin
            result := '';
            Application.MessageBox('Invalid third parameter for binom', 'Syntax error', MB_ICONEXCLAMATION);
            memo.free;
            gcd.free;
            newton.free;
            frac.free;
            exit;
          end
          else if newton[newton.count - 1] = inttostr(j) then
            newton.Add(',');

      if (i >= 2) and (s[i - 1] in ['0'..'9']) and (s[i] = '(') then
      begin
        insert('*', s, i);
        inc(i);
      end;
      if s[i] = '(' then
      begin
        inc(j);
        if max < j then
          max := j;
        if memo.count >= 1 then
          if memo[memo.Count - 1] = 'gcd' then
            gcd.Add(inttostr(j))
          else if memo[memo.Count - 1] = 'binom' then
            newton.Add(inttostr(j));
      end;
      t := copy(s, 1, i - 1);
      if t <> '' then
        if t[length(t)] = '*' then
        begin
          memo.add(copy(t, 1, length(t) - 1));
          memo.add('*');
        end
        else memo.Add(t);
      if s[i] = '(' then
        memo.Add(s[i] + inttostr(j))
      else
        memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else if s[i] = ')' then
    begin
      if frac.count > 0 then
        if frac[frac.count - 1] = inttostr(j) then
          if s[i + 1] = '(' then
          begin
            frac.Delete(frac.Count - 1);
            insert('/', s, i + 1);
          end
          else
          begin
            result := '';
            Application.MessageBox(PChar('( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
            memo.free;
            gcd.free;
            newton.free;
            frac.free;
            exit;
          end;
      if s[i + 1] in ['(', '0'..'9', 'a'..'z', 'V'] then
        insert('*', s, i + 1);
      t := copy(s, 1, i - 1);
      if t <> '' then
        memo.Add(t);
      memo.Add(s[i] + inttostr(j));
      if gcd.count > 0 then
        if gcd[gcd.count - 1] = inttostr(j) then
          gcd.Delete(gcd.Count - 1);
      if newton.count > 0 then
        if (newton[newton.count - 1] = ',') and (newton[newton.count - 2] = inttostr(j)) then
        begin
          newton.Delete(newton.Count - 1);
          newton.Delete(newton.Count - 1);
        end
        else if newton[newton.count - 1] = inttostr(j) then
        begin
          result := '';
          Application.MessageBox('Missing second parameter for binom', 'Syntax error', MB_ICONEXCLAMATION);
          memo.free;
          gcd.free;
          newton.free;
          frac.free;
          exit;
        end;

      dec(j);
      if j < 0 then
      begin
        result := '';
        Application.MessageBox('Excess of )', 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;
      delete(s, 1, i);
      i := 1;
    end
    else if (copy(s, i, 3) = 'gcd') or (copy(s, i, 3) = 'abs') or (copy(s, i, 3) = 'log') then
    begin
      if s[i + 3] <> '(' then
      begin
        result := '';
        Application.MessageBox(PChar('( expected after ' + copy(s, i, 3)), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;
      t := copy(s, 1, i - 1);
      if t <> '' then
        memo.Add(t);
      memo.Add(copy(s, i, 3));
      delete(s, 1, i + 2);
      i := 1;
    end
    else if (copy(s, i, 5) = 'binom') or (copy(s, i, 5) = 'floor') then
    begin
      if s[i + 5] <> '(' then
      begin
        result := '';
        Application.MessageBox(PChar('( expected after ' + copy(s, i, 5)), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;
      t := copy(s, 1, i - 1);
      if t <> '' then
        memo.Add(t);
      memo.Add(copy(s, i, 5));
      delete(s, 1, i + 4);
      i := 1;
    end
    else if copy(s, i, 4) = 'frac' then
    begin
      if s[i + 4] <> '(' then
      begin
        result := '';
        Application.MessageBox(PChar('( expected after ' + copy(s, i, 4)), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        gcd.free;
        newton.free;
        frac.free;
        exit;
      end;
      t := copy(s, 1, i - 1);
      if t <> '' then
        memo.Add(t);
      frac.Add(inttostr(j + 1));
      delete(s, 1, i + 3);
      i := 1;
    end
    else inc(i);

  if j > 0 then
  begin
    result := '';
    Application.MessageBox('Excess of (', 'Syntax error', MB_ICONEXCLAMATION);
    memo.free;
    gcd.free;
    newton.free;
    frac.free;
    exit;
  end;

  if s <> '' then
    memo.Add(s);

  if max > 0 then
    repeat
      maxfound := false;
      i := 0;
      while i < Memo.Count do
      begin
        if Memo[i] = '(' + inttostr(max) then
        begin
          if (i >= 1) and (Memo[i - 1] = 'gcd') then
          begin
            j := i + 1;
            s := '';
            while (Memo[j] <> ',') and (Memo[j] <> ')' + inttostr(max)) do
            begin
              s := s + Memo[j];
              inc(j);
            end;
            s := WithParenthesisProcess(true, s, LOGFILE, cancelar);
            if pos('/', s) > 0 then // only integers allowed to gcd
              s := '1';

            while Memo[j] = ',' do
            begin
              inc(j);
              t := '';
              while (Memo[j] <> ',') and (Memo[j] <> ')' + inttostr(max)) do
              begin
                t := t + Memo[j];
                inc(j);
              end;
              t := WithParenthesisProcess(true, t, LOGFILE, cancelar);
              if pos('/', t) > 0 then // only integers allowed to gcd
                t := '1';
              s := mdc(s, t);
            end;

            Memo[i + 1] := s;
            while Memo[i + 2] <> ')' + inttostr(max) do
              Memo.Delete(i + 2);

            Memo.Delete(i - 1);
            dec(i);
          end
          else if (i >= 1) and (Memo[i - 1] = 'binom') then
          begin
            j := i + 1;
            s := '';
            while (Memo[j] <> ',') and (Memo[j] <> ')' + inttostr(max)) do
            begin
              s := s + Memo[j];
              inc(j);
            end;
            s := WithParenthesisProcess(true, s, LOGFILE, cancelar);

            if Memo[j] = ',' then
            begin
              inc(j);
              t := '';
              while (Memo[j] <> ',') and (Memo[j] <> ')' + inttostr(max)) do
              begin
                t := t + Memo[j];
                inc(j);
              end;
              s := binom(s, WithParenthesisProcess(true, t, LOGFILE, cancelar));
            end;

            Memo[i + 1] := s;
            while Memo[i + 2] <> ')' + inttostr(max) do
              Memo.Delete(i + 2);

            Memo.Delete(i - 1);
            dec(i);
          end
          else if (i >= 1) and (Memo[i - 1] = 'abs') then
          begin
            j := i + 1;
            s := '';
            while Memo[j] <> ')' + inttostr(max) do
            begin
              s := s + Memo[j];
              inc(j);
            end;
            Memo[i + 1] := FracAbs(WithParenthesisProcess(true, s, LOGFILE, cancelar));
            while Memo[i + 2] <> ')' + inttostr(max) do
              Memo.Delete(i + 2);

            Memo.Delete(i - 1);
            dec(i);
          end
          else if (i >= 1) and (Memo[i - 1] = 'log') then
          begin
            j := i + 1;
            s := '';
            while Memo[j] <> ')' + inttostr(max) do
            begin
              s := s + Memo[j];
              inc(j);
            end;
            Memo[i + 1] := FracLog('e', '1/100', WithParenthesisProcess(true, s, LOGFILE, CANCELAR), cancelar);
            while Memo[i + 2] <> ')' + inttostr(max) do
              Memo.Delete(i + 2);

            Memo.Delete(i - 1);
            dec(i);
          end
          else if (i >= 1) and (Memo[i - 1] = 'floor') then
          begin
            j := i + 1;
            s := '';
            while Memo[j] <> ')' + inttostr(max) do
            begin
              s := s + Memo[j];
              inc(j);
            end;
            Memo[i + 1] := FracFloor(WithParenthesisProcess(true, s, LOGFILE, CANCELAR));
            while Memo[i + 2] <> ')' + inttostr(max) do
              Memo.Delete(i + 2);

            Memo.Delete(i - 1);
            dec(i);
          end;
          maxfound := true;
          j := i + 1;
          s := '';
          while Memo[j] <> ')' + inttostr(max) do
          begin
            s := s + Memo[j];
            inc(j);
          end;
          s := WithParenthesisProcess(true, s, LOGFILE, cancelar);
          if (s = FracValida(s)) and (i >= 1) and (copy(memo[i - 1], length(memo[i - 1]), 1) = '^') then
          begin
            t := memo[i - 1];
            if t = '^' then
            begin
              t := memo[i - 2];
              if t = fracvalida(t) then
              begin
                s := fracpower(t, s);
                memo.Delete(i - 2);
                memo.Delete(i - 2);
                dec(i, 2);
              end;
            end
            else
            begin
              delete(t, length(t), 1);
              if t = fracvalida(t) then
              begin
                s := fracpower(t, s);
                memo.Delete(i - 1);
                dec(i);
              end;
            end;
          end
          else if i >= 1 then
            if memo[i - 1] = '/' then
              if memo[i - 2] = s then // x / (x)
              begin
                s := '1';
                memo.delete(i - 2);
                memo.delete(i - 2);
                dec(i, 2);
              end
              else
              begin
                t := BasisDifference(memo[i - 2], s); // x / x^3
                if t <> '' then
                begin
                  s := t;
                  memo.delete(i - 2);
                  memo.delete(i - 2);
                  dec(i, 2);
                end
                else if s <> fracValida(s) then
                begin
                  s := '(' + s + ')';
                  s := Distribution(memo[i - 2], '/' + s, LOGFILE);
                  memo.delete(i - 2);
                  memo.delete(i - 2);
                  dec(i, 2);
                end;
              end
            else if memo[i - 1][1] in ['a'..'z', 'V'] then
            begin
              if (i >= 2) and (memo[i - 2] = '-') then
              begin
                s := Distribution('-' + memo[i - 1], '(' + s + ')', LOGFILE);
                memo.Delete(i - 2);
                dec(i);
              end
              else
                s := Distribution(memo[i - 1], '(' + s + ')', LOGFILE);

              dec(i);
            end;

          memo[i + 1] := s;
          while Memo[i + 2] <> ')' + inttostr(max) do
            Memo.Delete(i + 2);
        //showmessage(memo.text);
          Memo.Delete(i + 2);
          Memo.Delete(i);
          if (i >= 1) and (memo[i - 1] = '-') then
          begin
            memo[i] := AlgebricalOpposite(memo[i]);
            memo.delete(i - 1);
          end
          else if (i + 1 < memo.count) and (memo[i + 1] = '*') then
          begin
            j := i + 2;
            s := Memo[j];
            if s[1] = '(' then
            begin
              target := s;
              target[1] := ')';
              s := '(';
              repeat
                inc(j);
                s := s + Memo[j];
              until memo[j] = target;
              delete(s, length(s) - length(target) + 2, length(target));
            end;
            memo[i] := Distribution(memo[i], s, LOGFILE);
            for j := 1 to j - i do
              memo.delete(i + 1);
          end
          else if (i >= 1) and (memo[i - 1] = '*') then
          begin
            if (i >= 3) and (memo[i - 3] = '-') then
            begin
              memo[i - 3] := Distribution('-' + memo[i - 2], s, LOGFILE);
              memo.Delete(i - 2);
              memo.Delete(i - 2);
              memo.delete(i - 2);
            end
            else
            begin
              memo[i - 2] := Distribution(memo[i - 2], s, LOGFILE);
              memo.Delete(i - 1);
              memo.Delete(i - 1);
            end;
          end
          else if (i + 1 < memo.count) and (memo[i + 1] = '/') then
          begin
            j := i + 2;
            s := Memo[j];
            if s[1] = '(' then
            begin
              target := s;
              target[1] := ')';
              s := '(';
              repeat
                inc(j);
                s := s + Memo[j];
              until memo[j] = target;
              delete(s, length(s) - length(target) + 2, length(target));
            end;
            if (memo[i] = s) or ('(' + memo[i] + ')' = s) then // x / (x)
              if i >= 1 then
              begin
                s := memo[i - 1];
                if s[length(s)] = '*' then
                begin
                  delete(s, length(s), 1);
                  memo[i - 1] := s;
                end;
                memo.Delete(i);
                dec(i);
                dec(j);
              end
              else memo[i] := Distribution(memo[i], '/' + s, LOGFILE)
            else memo[i] := Distribution(memo[i], '/' + s, LOGFILE);

            for j := 1 to j - i do
              memo.delete(i + 1);
          end
          else if (i >= 1) and (copy(Memo[i - 1], 1, 1) = '(') then
          begin
            if (copy(Memo[i + 1], 1, 1) <> ')') and (copy(Memo[i + 1], 1, 1) <> ',') then
            begin
              s := Memo[i] + Memo[i + 1];
              s := StringReplace(s, '--', '+', [rfReplaceAll]);
              s := StringReplace(s, '++', '+', [rfReplaceAll]);
              s := StringReplace(s, '+-', '-', [rfReplaceAll]);
              s := StringReplace(s, '-+', '-', [rfReplaceAll]);
              Memo[i] := s;
              Memo.Delete(i + 1);
            end
          end
          else if (Memo.Count > i + 1) and (copy(Memo[i + 1], 1, 1) = ')') then
            if (copy(Memo[i - 1], 1, 1) <> '(') and (copy(Memo[i - 1], 1, 1) <> ',') then
            begin
              s := Memo[i - 1] + Memo[i];
              s := StringReplace(s, '--', '+', [rfReplaceAll]);
              s := StringReplace(s, '++', '+', [rfReplaceAll]);
              s := StringReplace(s, '+-', '-', [rfReplaceAll]);
              s := StringReplace(s, '-+', '-', [rfReplaceAll]);
              Memo[i - 1] := s;
              Memo.Delete(i);
            end;
          i := 0;
        end;

        inc(i);
      end;
      if not maxfound then
        dec(max);
    until max <= 0;

  memo.text := StringReplace(memo.text, #13#10, '', [rfReplaceAll]);
  repeat
    s := NoParenthesisProcess(memo.text, LOGFILE);
    if (s = memo.text) or (s + #13#10 = memo.text) then
      break;
    memo.text := s;
  until false;

  if memo.Count = 0 then
    result := '0'
  else
  begin
    result := '';
    for i := 0 to memo.Count - 1 do
      result := result + memo[i];
  end;
  memo.Free;
  gcd.free;
  newton.free;
  frac.free;
  logToFile('with parenthesis mono process result: ' + result, LOGFILE);
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  PanelButtons.Left := (panelEval.width - PanelButtons.Width) div 2;
  MemoIn.Text := StringReplace(memoIn.Text, #13#10, '', [rfReplaceAll]);
  MemoOut.Text := StringReplace(memoOut.Text, #13#10, '', [rfReplaceAll]);
end;

procedure TFormPrincipal.Loadfromfile1Click(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
  if OpenDialog.Execute then
    MemoIn.Lines.LoadFromFile(OpenDialog.FileName);
end;

function Distribution(x, y: string; LOGFILE: string): string;
var
  i, j: integer;
  flag: boolean;
begin
  logToFile('distribution entries x: ' + x + ' ; y: ' + y, LOGFILE);
  if (copy(y, 1, 2) = '/(') and (copy(y, length(y), 1) = ')') then
  begin
    result := copy(y, 3, length(y) - 3);
    if result = FracValida(result) then
      y := FracDiv('1', result);
  end
  else if copy(y, 1, 1) = '/' then
  begin
    result := copy(y, 2, length(y) - 1);
    if result = FracValida(result) then
      y := FracDiv('1', result);
  end
  else if (copy(y, 1, 1) = '(') and (copy(y, length(y), 1) = ')') then
    y := copy(y, 2, length(y) - 2);

  if y = '0' then
  begin
    result := '0';
    exit;
  end;

  if (x = FracValida(x)) and (y = FracValida(y)) then
  begin
    result := FracMul(x, y);
    exit;
  end;

  if copy(y, 1, 1) = '-' then
  begin
    x := AlgebricalOpposite(x);
    delete(y, 1, 1);
  end;

  if copy(y, 1, 2) = '1/' then
    delete(y, 1, 1);

  if copy(y, 1, 1) = '/' then
    if copy(y, 2, 1) = '(' then
    begin
      flag := true;
      i := 3;
      while i <= length(y) do
      begin
        if y[i] in ['+', '-', '*', '/', '='] then
        begin
          flag := false;
          break;
        end;
        inc(i);
      end;

      if flag then
      begin
        delete(y, 2, 1);
        delete(y, length(y), 1);
        i := 3;
        if y[2] = 'V' then
        begin
          while (i <= length(y)) and (y[i] <> 'V') do
            inc(i);
          if y[i] = 'V' then
          begin
            insert('/', y, i);
            inc(i);
          end;
        end
        else
          while i <= length(y) do
          begin
            if y[i] in ['a'..'z'] then
            begin
              insert('/', y, i);
              inc(i);
            end;
            inc(i);
          end;
      end;
    end;

  if (copy(y, 1, 1) = '/') or (pos('+', y) = 0) and (pos('-', y) = 0) then
  begin
    flag := false;
    Result := copy(x, 1, 1);
    i := 2;
    j := 0;
    while i <= length(x) do
    begin
      if (x[i] = '(') and flag then
        inc(j)
      else if (x[i] = ')') and flag then
        dec(j)
      else if x[i] in ['+', '-', '='] then
        if not flag then
          result := AppendLeftV(result, y)
        else if j = 0 then
          flag := false;

      if x[i] = '/' then
      begin
        result := AppendLeftV(result, y);
        flag := true;
        j := 0;
      end;
      result := result + x[i];
      inc(i);
    end;
    if not flag then
      result := AppendLeftV(result, y);
  end
  else
  begin
    result := '';
    i := 1;
    while i <= length(y) do
    begin
      if y[i] in ['+', '-'] then
      begin
        result := result + distribution(x, copy(y, 1, i - 1), LOGFILE) + y[i];
        delete(y, 1, i);
        i := 0;
      end;
      inc(i);
    end;
    result := result + distribution(x, y, LOGFILE);
    result := stringReplace(result, '--', '+', [rfReplaceAll]);
  end;

  logToFile('distribution result: ' + result, LOGFILE);
end;

function ExistVariable(s: string): boolean;
var i: integer;
begin
  for i := 1 to length(s) do
    if (s[i] >= 'a') and (s[i] < 'z') or (s[i] = 'V') then
    begin
      Result := true;
      exit;
    end;
  Result := false;
end;

function CommandProcess(s: string; LOGFILE: string; var cancelar: boolean): string;
var
  t, variable: string;
  i: integer;
  ch: char;
  f: TextFile;
begin
  cancelar := false;
  if LOGFILE <> '' then
  begin
    assignFile(f, LOGFILE);
    rewrite(f);
    closeFile(f);
  end;

  i := 1;
  while i <= length(s) do
  begin
    if s[i] = '_' then
    begin
      delete(s, i, 1);
      insert('V', s, i - 1);
    end;
    inc(i);
  end;

  i := pos('=', s);
  if i > 0 then
  begin
    t := copy(s, i + 1, length(s));
    delete(s, i, length(s));
  end
  else t := '';

  ch := #1;
  variable := '';
  if copy(s, 1, 10) = 'solve for ' then
  begin
    delete(s, 1, 10);
    i := pos(':', s);
    if i > 0 then
    begin
      variable := copy(s, 1, i - 1);
      delete(s, 1, i);
    end;

    ch := IsVariable(variable);
    if ch <> 'x' then
    begin
      Application.MessageBox(PChar('solve for [variable]: expected. Encountered: ' + ch), 'Syntax error', MB_ICONEXCLAMATION);
      exit;
    end;

    if t = '' then
    begin
      Application.MessageBox('= symbol not found', 'Syntax error', MB_ICONEXCLAMATION);
      exit;
    end;
  end;
  s := StringReplace(s, #32, '', [rfReplaceAll]);
  Result := WithParenthesisProcess(false, s, LOGFILE, cancelar);
  if Result = '' then
    exit;
  if t <> '' then
  begin
    s := WithParenthesisProcess(false, t, LOGFILE, cancelar);
    if s = '' then
    begin
      result := '';
      exit;
    end;
    result := result + '=' + s;
  end;

  repeat
    s := denominator(Result);
    if s = '' then
      break;
    if s = fracValida(s) then
    begin
      s := Distribution(s + '*', Result, LOGFILE);
    end
    else s := Distribution(Result, s, LOGFILE);

    i := pos('=', s);
    if i > 0 then
    begin
      t := copy(s, i + 1, length(s));
      delete(s, i, length(s));
    end
    else t := '';

    Result := WithParenthesisProcess(true, s, LOGFILE, cancelar);
    if Result = '' then
      exit;
    if t <> '' then
    begin
      s := WithParenthesisProcess(true, t, LOGFILE, cancelar);
      if s = '' then
      begin
        result := '';
        exit;
      end;
      result := result + '=' + s;
    end;
  until false;

  if ch = 'x' then
  begin
    s := SolveFor(variable, Result, LOGFILE);
    if pos('ERROR: ', s) = 0 then
    begin
      i := pos('=', s);
      if i > 0 then
      begin
        t := copy(s, i + 1, length(s));
        delete(s, i, length(s));
      end
      else t := '';

      s := StringReplace(s, #32, '', [rfReplaceAll]);
      Result := WithParenthesisProcess(true, s, LOGFILE, cancelar);
      if Result = '' then
        exit;
      if t <> '' then
      begin
        s := WithParenthesisProcess(true, t, LOGFILE, cancelar);
        if s = '' then
        begin
          result := '';
          exit;
        end;
        result := result + '=' + s;
      end;
    end
    else result := s;
  end;

  if copy(result, 1, 1) = '+' then
    delete(result, 1, 1);
  result := StringReplace(result, '+', ' + ', [rfReplaceAll]);
  result := StringReplace(result, '-', ' - ', [rfReplaceAll]);
  result := StringReplace(result, '=', ' = ', [rfReplaceAll]);
  result := StringReplace(result, ' =  + ', ' = ', [rfReplaceAll]);
  result := StringReplace(result, '( -', '(-', [rfReplaceAll]);
  result := StringReplace(result, '( + ', '(', [rfReplaceAll]);
  result := trim(StringReplace(result, ' =  - ', ' = - ', [rfReplaceAll]));
end;

function IsVariable(s: string): char;
var i: integer;
begin
  i := 2;
  if s = '' then
    Result := ' '
  else if s[1] in ['a'..'z', 'V'] then
  begin
    while i <= length(s) do
      if s[i] in ['0'..'9', 'a'..'z'] then
        inc(i)
      else
      begin
        Result := s[i];
        exit;
      end;

    Result := 'x'; // good
  end
  else
    Result := s[1];
end;

function SolveFor(variable, s: string; LOGFILE: string): string;
var
  i, j, k: integer;
  memo: TStringList;
  equals: boolean;
  t: string;
begin
  j := 0;
  equals := false;
  result := s;
  if AbsolutePosition(variable, s) = 0 then
  begin
    result := result + #13#10#13#10'ERROR: Variable ' + variable + ' does not occur in entry.';
    exit;
  end;
  if pos(variable + '^', s) > 0 then
  begin
    result := result + #13#10#13#10'ERROR: Variable ' + variable + ' is not linear in entry.';
    exit;
  end;

  logToFile('solve for ' + variable + ' entry: ' + s, LOGFILE);
  memo := TStringList.Create;
  while (length(s) > 0) and not (s[1] in ['0'..'9', '-', 'a'..'z', 'V', '(']) do
    delete(s, 1, 1);

  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', '=', 'a'..'z', 'V', '(', ')'] then
      inc(i)
    else if (s[i] in ['+', '-', '*', '/', '^']) and (i < length(s)) then
      if s[i + 1] in ['0'..'9', 'a'..'z', 'V', '('] then
        inc(i)
      else delete(s, i + 1, 1)
    else delete(s, i, 1);

  i := 1;
  if copy(s, 1, 1) = '-' then
    inc(i);
  while i <= length(s) do
    if s[i] in ['+', '-', '='] then
    begin
      memo.Add(copy(s, 1, i - 1));
      t := memo[memo.count - 1];
      k := pos(variable, t);
      if (k > 0) and (variable[1] = 'V') then
      begin
        inc(k, length(variable));
        if (k <= length(t)) and (t[k] in ['0'..'9', 'a'..'z']) then
          k := 0;
      end;
      if k > 0 then
      begin
        if equals then
        begin
          memo.insert(j, OppositeSign(memo[memo.count - 2]) + memo[memo.count - 1]);
          memo.Delete(memo.Count - 1);
          if memo[memo.count - 1] <> '=' then
            memo.Delete(memo.Count - 1);
        end
        else if memo.Count > 1 then
        begin
          memo.insert(j, memo[memo.count - 2] + memo[memo.count - 1]);
          memo.Delete(memo.Count - 1);
          memo.Delete(memo.Count - 1);
        end;
        inc(j);
      end;

      memo.Add(s[i]);
      if s[i] = '=' then
        equals := true;
      delete(s, 1, i);
      i := 1;
    end
    else inc(i);

  memo.add(s);
  t := memo[memo.count - 1];
  k := pos(variable, t);
  if (k > 0) and (variable[1] = 'V') then
  begin
    inc(k, length(variable));
    if (k <= length(t)) and (t[k] in ['0'..'9', 'a'..'z']) then
      k := 0;
  end;
  if k > 0 then
  begin
    memo.insert(j, OppositeSign(memo[memo.count - 2]) + memo[memo.count - 1]);
    memo.Delete(memo.Count - 1);
    if memo[memo.count - 1] <> '=' then
      memo.Delete(memo.Count - 1);
  end;

  equals := false;
  i := 0;
  while i < memo.Count do
  begin
    if memo[i] = '=' then
      equals := true
    else if not equals and (memo[i] <> '+') and (memo[i] <> '-') then
    begin
      t := memo[i];
      k := pos(variable, t);
      if (k > 0) and (variable[1] = 'V') then
      begin
        inc(k, length(variable));
        if (k <= length(t)) and (t[k] in ['0'..'9', 'a'..'z']) then
          k := 0;
      end;
      if k = 0 then
      begin
        memo.Add(OppositeSign(memo[i - 1]) + memo[i]);
        memo.Delete(i);
        dec(i);
        if (memo[i] = '+') or (memo[i] = '-') then
        begin
          memo.delete(i);
          dec(i);
        end;
      end;
    end;

    inc(i);
  end;

  if memo[memo.Count - 1] = '' then
    memo.Delete(memo.Count - 1);

  s := '';
  repeat
    if memo[0] = '=' then
    begin
      memo[0] := variable + '=';
      if memo.Count = 1 then
        memo.Insert(1, '(0')
      else
        memo.Insert(1, '(');
      s := NoParenthesisProcess(Distribution(s, '/' + variable, LOGFILE), LOGFILE);
      //showmessage(s);
      if s = '-1' then
      begin
        memo[1] := '-' + memo[1];
        memo.Add(')')
      end
      else if s = '1' then
        memo.Add(')')
      else
        memo.Add(')/(' + s + ')');
      break;
    end
    else begin
      s := s + memo[0];
      memo.Delete(0);
    end;
  until false;

  result := StringReplace(memo.text, #13#10, '', [rfReplaceAll]);
  memo.free;
  logToFile('solve for ' + variable + ' result: ' + result, LOGFILE);
end;

function Denominator(s: string): string;
var i, j: integer;
begin
  i := pos('=', s);
  if i = 0 then
  begin
    result := '';
    exit;
  end;
  i := pos('/', s);
  if i = 0 then
  begin
    result := '';
    exit;
  end;
  delete(s, 1, i);
  i := 2;
  if s[1] = '(' then
  begin
    j := 1;
    while (i <= length(s)) and (j > 0) do
    begin
      if s[i] = '(' then
        inc(j)
      else if s[i] = ')' then
        dec(j);

      inc(i);
    end;
  end
  else if s[1] = 'V' then
    while i <= length(s) do
      if s[i] in ['0'..'9', '^', 'a'..'z'] then
        inc(i)
      else break
    else if s[1] in ['0'..'9', 'a'..'z'] then
      while i <= length(s) do
        if s[i] in ['0'..'9', '^'] then
          inc(i)
        else break;

  result := copy(s, 1, i - 1);
end;

function BasisDifference(x, x3: string): string;
var
  i, i3: integer;
  p, p3: string;
begin
  i3 := pos('^', x3);
  if i3 = 0 then
  begin
    p3 := '1';
    i3 := length(x3);
  end
  else
    p3 := copy(x3, i3 + 1, length(x3));

  i := pos('^', x);
  if i = 0 then
  begin
    p := '1';
    i := length(x);
  end
  else
    p := copy(x, i + 1, length(x));

  result := copy(x, 1, i - 1);
  if result = copy(x3, 1, i3 - 1) then
    if Subtrai(p3, p) = '1' then
      result := '1/' + result
    else if Subtrai(p3, p) = '-1' then
    begin end
    else if SNumCompare(p3, p) > 0 then
      result := '1/' + result + '^' + Subtrai(p3, p)
    else
      result := result + '^' + Subtrai(p, p3)
  else
    result := '';
end;

procedure logToFile(s: string; LOGFILE: string);
var f: TextFile;
begin
  //showmessage(s);
  if LOGFILE = '' then exit;
  assignFile(f, LOGFILE);
  append(f);
  writeln(f, StringReplace(s, #13#10, #32, [rfReplaceAll]));
  closeFile(f);
end;

procedure TFormPrincipal.Showlog1Click(Sender: TObject);
begin
  MemoIn.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + LOG_FILE);
end;

function OppositeSign(s: string): char;
begin
  if s = '-' then
    result := '+'
  else
    result := '-';
end;

procedure TFormPrincipal.AbsoluteValue1Click(Sender: TObject);
begin
  memoin.Text := 'abs(2 + 3 - 5 * 7 ^ 11)';
end;

procedure TFormPrincipal.GreatestCommonDivisor1Click(Sender: TObject);
begin
  memoin.text := 'gcd(20, 30, 50)';
end;

procedure TFormPrincipal.Fraction1Click(Sender: TObject);
begin
  memoin.text := 'frac(3 + 5)(7 + 11)';
end;

procedure TFormPrincipal.Solveforx1Click(Sender: TObject);
begin
  memoin.text := 'solve for x: ax + b = c';
end;

procedure TFormPrincipal.NewtonBinomial1Click(Sender: TObject);
begin
  MemoIn.Text := 'binom(60, 6)';
end;

procedure TFormPrincipal.Evaluate1Click(Sender: TObject);
begin
  BtnEval.Click;
end;

procedure TFormPrincipal.IncreaseSize1Click(Sender: TObject);
begin
  if MemoOut.Height > 50 then
    PanelIn.Height := PanelIn.Height + 10;
end;

procedure TFormPrincipal.DecreaseSize1Click(Sender: TObject);
begin
  if panelin.Height > 50 then
    PanelIn.Height := PanelIn.Height - 10;
end;

function AlgebricalOpposite(s: string): string;
var i, j: integer;
begin
  result := s;
  if s = '' then
    exit;

  if s[1] = '-' then
  begin
    delete(s, 1, 1);
    i := 1;
  end
  else
  begin
    s := '-' + s;
    i := 2;
  end;

  while i <= length(s) do
  begin
    if s[i] = '(' then
    begin
      j := 1;
      repeat
        inc(i);
        if s[i] = '(' then
          inc(j)
        else if s[i] = ')' then
          dec(j);
      until j = 0;
    end;

    if s[i] = '+' then
      s[i] := '-'
    else if s[i] = '-' then
      s[i] := '+';

    inc(i);
  end;
  result := s;
end;

function AbsolutePosition(variable, s: string): integer;
var i: integer;
begin
  if variable[1] = 'V' then
  begin
    result := pos(variable, s);
    exit;
  end;

  i := 1;
  while i <= length(s) do
  begin
    if s[i] = 'V' then
      while s[i + 1] in ['a'..'z', '0'..'9'] do
        inc(i)
    else if s[i] = variable then
    begin
      result := i;
      exit;
    end;

    inc(i);
  end;
  result := 0;
end;

function AppendLeftV(x, y: string): string;
var i: integer;
begin
  i := length(x) + 1;
  if y[1] <> '/' then
  begin
    dec(i);
    while i >= 1 do
    begin
      if x[i] in ['0'..'9', 'a'..'z', 'V'] then
        dec(i)
      else
        break;
    end;

    while (i <= length(x)) and (x[i] <> 'V') do
      inc(i);
  end;

  insert(y, x, i);
  result := x;
end;

procedure TFormPrincipal.Clear1Click(Sender: TObject);
begin
  if application.MessageBox('Clear all?', 'Confirmation', MB_ICONQUESTION + MB_YESNO) = mrYes then
  begin
    MemoIn.Clear;
    MemoOut.Clear;
    //cancelar := false;
    memoin.text := 'log(1024)/log(2)';
  end;
end;

procedure TFormPrincipal.Logarithm1Click(Sender: TObject);
begin
  memoin.text := 'log(11)';
end;

procedure TFormPrincipal.BtnCancelClick(Sender: TObject);
begin
  cancelar := true;
end;

procedure TFormPrincipal.Floor1Click(Sender: TObject);
begin
  memoin.text := 'floor(-4/3)';
end;

end.

