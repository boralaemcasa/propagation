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
    BtnEval: TButton;
    PopupMenu1: TPopupMenu;
    Loadfromfile1: TMenuItem;
    OpenDialog: TOpenDialog;
    procedure BtnEvalClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Loadfromfile1Click(Sender: TObject);
  private
  public
  end;

var
  FormPrincipal: TFormPrincipal;

function BasisDifference(x, x3: string): string;
function CommandProcess(s: string): string;
function Denominator(s: string): string;
function Distribution(x,y: string): string;
function ExistVariable(s: string): boolean;
function IsVariable(s: string): char;
function NoParenthesisProcess(s: string; jump: boolean): string;
function SolveFor(variable, s: string): string;
function WithParenthesisMONOProcess(s: string): string;
function WithParenthesisProcess(s: string): string;

implementation

{$R *.dfm}

uses SNum;

procedure TFormPrincipal.BtnEvalClick(Sender: TObject);
begin
  memoOut.text := CommandProcess(MemoIn.text);
end;

function NoParenthesisProcess(s: string; jump: boolean): string;
var i, j: integer;
    memo: TStringList;
begin
  memo := TStringList.Create;

  while (length(s) > 0) and not (s[1] in ['0'..'9', '-', 'a'..'z', '(']) do
    delete(s, 1, 1);

  if jump then
  begin
    memo.text := s;
    j := Memo.Count - 1;
    while j >= 0 do
    begin
      s := Memo[j];
      if s[1] in ['+', '*', '/', '^','='] then
        insert(#1, s, 2);
      i := 2;
      while i <= length(s) do
      begin
        if (copy(s, i, 3) = 'gcd') or (copy(s, i, 3) <> 'abs') then
          inc(i, 2)
        else if copy(s, i, 4) = 'frac' then
          inc(i, 3)
        else if s[i] in ['+', '-', '*', '/', '^','=', 'a'..'z'] then
        begin
          insert(#1, s, i+1);
          insert(#1, s, i);
          inc(i);
        end;
        inc(i);
      end;
      Memo[j] := s;
      dec(j);
    end;

    s := StringReplace(memo.text, #1#1, #13#10, [rfReplaceAll]);
    s := StringReplace(s, #1, #13#10, [rfReplaceAll]);

    i := 1;
    while i <= length(s) do
      if s[i] in ['0'..'9', #13, #10, 'a'..'z', '(', ')'] then
        inc(i)
      else if (s[i] in ['+', '-', '*', '/', '^', '=']) and (i < length(s)) then
        inc(i)
      else delete(s, i, 1);

    memo.Text := s;
  end
  else
    begin
      i := 1;
      while i <= length(s) do
        if s[i] in ['0'..'9', '=', 'a'..'z', '(', ')'] then
          inc(i)
        else if (s[i] in ['+', '-', '*', '/', '^']) and (i < length(s)) then
          if s[i+1] in ['0'..'9', 'a'..'z', '('] then
            inc(i)
          else delete(s, i+1, 1)
        else delete(s, i, 1);

      i := 1;
      if copy(s, 1, 1) = '-' then
        inc(i);
      while i <= length(s) do
        if s[i] in ['+', '-', '*', '/', '^', '=', 'a'..'z'] then
        begin
          memo.Add(copy(s, 1, i-1));
          memo.Add(s[i]);
          delete(s, 1, i);
          i := 1;
        end
        else inc(i);

    memo.add(s);
  end;

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
    if (i + 3 < memo.Count) and (memo[i + 2] = '/') and (memo[i - 1] = memo[i + 3]) and ((i + 4 >= memo.count) or (memo[i + 4] <> '^')) then // x^3 / x
    begin
      s := Subtrai(Memo[i + 1], '1');
      if s = '1' then
      begin end
      else if s = '0' then
        memo[i - 1] := '1'
      else
        memo[i - 1] := memo[i - 1] + '^' + s;
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      i := 0;
    end
    else if (i >= 3) and (memo[i - 2] = '/') and (memo[i - 1] = memo[i - 3]) then // x / x^3
    begin
      Memo[i - 3] := '1';
      Memo[i + 1] := Subtrai(memo[i + 1], '1');
      i := 0;
    end
    else if (i >= 5) and (memo[i - 2] = '/') and (memo[i - 1] = memo[i - 5]) then // x^2 / x^3
    begin
      s := Subtrai(memo[i + 1], memo[i - 3]);
      if s = '1' then
        Memo[i - 1] := '1/' + memo[i - 5]
      else if s = '-1' then
        Memo[i - 1] := memo[i - 5]
      else if s = '0' then
        Memo[i - 1] := '1'
      else if SNumCompare(s, '1') > 0 then
        Memo[i - 1] := '1/' + memo[i - 5] + '^' + s
      else
        Memo[i - 1] := memo[i - 5] + '^' + SNumOposto(s);
      Memo.Delete(i);
      Memo.Delete(i);
      memo.delete(i - 5);
      memo.delete(i - 5);
      memo.delete(i - 5);
      memo.delete(i - 5);
      i := 0;
    end
    else if (i + 2 < memo.Count) and (memo[i - 1] = memo[i + 2]) and ((i + 3 >= memo.count) or (memo[i + 3] <> '^')) then // x^3 x
    begin
      s := Soma(Memo[i + 1], '1');
      if s <> '1' then
        memo[i - 1] := memo[i - 1] + '^' + s;
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      i := 0;
    end
    else if (i >= 2) and (memo[i - 1] = memo[i - 2]) then // x x^3
    begin
      s := Soma(Memo[i + 1], '1');
      if s <> '1' then
        memo[i - 2] := memo[i - 2] + '^' + s;
      Memo.delete(i-1);
      Memo.delete(i-1);
      Memo.delete(i-1);
      i := 0;
    end
    else if (i + 3 < memo.Count) and (memo[i - 1] = memo[i + 2]) and (memo[i + 3] = '^') then // x^3 x^2
    begin
      s := Soma(Memo[i + 1], Memo[i + 4]);
      if s <> '1' then
        memo[i - 1] := memo[i - 1] + '^' + s;
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      Memo.delete(i);
      i := 0;
    end;

    inc(i);
  end;

  i := 1; //if priority = 1 then
  while i < Memo.Count do
  begin
    if i + 1 < memo.count then
    if Memo[i] = '/' then
    if memo[i - 1] = memo[i + 1] then // x / x
    begin
      Memo[i - 1] := '1';
      Memo.Delete(i);
      Memo.Delete(i);
      i := 0;
    end;

    if (i >= 1) and (memo[i] = '1') then
      if memo[i - 1][1] in ['a'..'z'] then
      begin
        memo.Delete(i);
        i := 0;
      end;

    if (i >= 1) and (copy(memo[i], 1, 2) = '1/') then
      if memo[i - 1][1] in ['a'..'z'] then
      begin
        s := memo[i];
        delete(s, 1, 1);
        memo[i] := s;
        i := 0;
      end;
 
    if (i >= 1) and (memo[i][1] in ['a'..'z']) then  // x x 
      if memo[i - 1] = memo[i] then
      begin
        memo[i - 1] := memo[i - 1] + '^2';
        memo.Delete(i);
        i := 0;
      end;

    inc(i);
  end;

  if not ExistVariable(Memo.text) then
  begin
    i := 1; //if priority = 2 then
    while i < memo.Count do
    begin
      if i + 1 < memo.count then
      if memo[i] = '^' then
        if (memo[i - 1] = FracValida(memo[i- 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
        begin
          Memo[i - 1] := FracPower(Memo[i - 1], Memo[i + 1]);
          memo.Delete(i);
          memo.Delete(i);
          i := 0;
        end;

      inc(i);
    end;

    i := 1; //if priority = 1 then
    while i < Memo.Count do
    begin
      if i + 1 < memo.count then
      if Memo[i] = '*' then
      if (memo[i - 1] = FracValida(memo[i- 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
      begin
        Memo[i - 1] := FracMul(Memo[i - 1], Memo[i + 1]);
        Memo.Delete(i);
        Memo.Delete(i);
        i := 0;
      end;

      if (i >= 1) and (i + 1 < memo.count) then
      if Memo[i] = '/' then
      if (memo[i - 1] = FracValida(memo[i- 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
      begin
        Memo[i - 1] := FracDiv(Memo[i - 1], Memo[i + 1]);
        Memo.Delete(i);
        Memo.Delete(i);
        i := 0;
      end;

      inc(i);
    end;

    i := 1; // priority = 0
    while i < Memo.Count do
    begin
      if i + 1 < memo.count then
      if Memo[i] = '+' then
      if (memo[i - 1] = FracValida(memo[i- 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
      begin
        Memo[i - 1] := FracAdd(Memo[i - 1], Memo[i + 1]);
        Memo.Delete(i);
        Memo.Delete(i);
        i := 0;
      end;

      if (i >= 1) and (i + 1 < memo.count) then
      if Memo[i] = '-' then
      if (memo[i - 1] = FracValida(memo[i- 1])) and (memo[i + 1] = FracValida(memo[i + 1])) then
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
  //showmessage(entry + ' EQUALS ' + result);
end;

function WithParenthesisProcess(s: string): string;
begin
  repeat
    Result := WithParenthesisMONOProcess(s);
    if Result = s then
      break;
    s := Result;
  until false;
end;

function WithParenthesisMONOProcess(s: string): string;
var
  t, target: string;
  i, j, max: integer;
  maxfound, jump: boolean;
  memo, comma, frac: TStringList;
begin
  result := s;
  max := 0;
  //s := StringReplace(s, '[', '(', [rfReplaceAll]);
  //s := StringReplace(s, ']', ')', [rfReplaceAll]);

//trim alphabet
  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', '+', '-', '*', '/', '^', '(', ')', ',', '=', 'a'..'z'] then
      inc(i)
    else delete(s, i, 1);

  if s = '' then
  begin
    Application.MessageBox('Empty string', 'Syntax error', MB_ICONEXCLAMATION);
    exit;
  end;

  if not (s[1] in ['0'..'9', '(', '+', '-', 'a'..'z']) then
  begin
    Application.MessageBox('+, -, variable or digit or ( expected as first character', 'Syntax error', MB_ICONEXCLAMATION);
    exit;
  end;

  jump := false;
  j := 0;
  memo := TStringList.Create;
  comma := TStringList.Create;
  frac := TStringList.Create;
  i := 1;
  while i <= length(s) do
    if s[i] = #1 then
    begin
      Application.MessageBox('Reserved character', 'Syntax error', MB_ICONEXCLAMATION);
      memo.free;
      comma.free;
      frac.free;
      exit;
    end
    else if s[i] in ['+', '-', '*', '/'] then
    begin
      if not (s[i + 1] in ['0'..'9', '(', 'a'..'z']) then
      begin
        Application.MessageBox(PChar('variable or digit or ( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;

      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
      memo.Add(s[i]);
      delete(s, 1, i);
      i := 1;
    end
    else if s[i] in ['(', ',','='] then
    begin
      if s[i] = '=' then
        if not (s[i + 1] in ['0'..'9', '(', 'a'..'z']) then
        begin
          Application.MessageBox(PChar('variable or digit or ( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
          memo.free;
          comma.free;
          frac.free;
          exit;
        end;

      if s[i + 1] in [',', ')', '*', '/', '^'] then
      begin
        Application.MessageBox(PChar('+, - or digit or variable expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;
      if (s[i] = ',') and (comma.count = 0) then
      begin
        Application.MessageBox('comma outside gcd', 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;

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
            comma.Add(inttostr(j));
      end;
      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
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
        begin
          frac.Delete(frac.Count - 1);
          insert('/', s, i+1);
        end;
      if s[i + 1] in ['(', '0'..'9', 'a'..'z'] then
        insert('*', s, i+1);
      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
      memo.Add(s[i] + inttostr(j));
      if comma.count > 0 then
        if comma[comma.count - 1] = inttostr(j) then
          comma.Delete(comma.Count - 1);
      dec(j);
      if j < 0 then
      begin
        Application.MessageBox('Excess of )', 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;
      delete(s, 1, i);
      i := 1;
    end
    else if (copy(s, i, 3) = 'gcd') or (copy(s, i, 3) = 'abs') then
    begin
      if s[i + 3] <> '(' then
      begin
        Application.MessageBox(PChar('( expected after ' + copy(s, i, 3)), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;
      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
      memo.Add(copy(s, i, 3));
      delete(s, 1, i + 2);
      i := 1;
    end
    else if copy(s, i, 4) = 'frac' then
    begin
      if s[i + 4] <> '(' then
      begin
        Application.MessageBox(PChar('( expected after ' + copy(s, i, 4)), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        frac.free;
        exit;
      end;
      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
      frac.Add(inttostr(j+1));
      delete(s, 1, i + 3);
      i := 1;
    end
    else inc(i);

  if j > 0 then
  begin
    Application.MessageBox('Excess of (', 'Syntax error', MB_ICONEXCLAMATION);
    memo.free;
    comma.free;
    frac.free;
    exit;
  end;

  if s <> '' then
    memo.Add(s);

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
          s := WithParenthesisProcess(s);
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
            s := mdc(s, WithParenthesisProcess(t));
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
          Memo[i + 1] := FracAbs(WithParenthesisProcess(s));
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
        s := WithParenthesisProcess(s);
        if i >= 1 then
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
              else
                s := '(' + s + ')';
            end;
        memo[i + 1] := s;
        jump := true;
        while Memo[i + 2] <> ')' + inttostr(max) do
          Memo.Delete(i + 2);
        //showmessage(memo.text);
        Memo.Delete(i+2);
        Memo.Delete(i);
        if (i + 1 < memo.count) and (memo[i + 1] = '*') then
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
          memo[i] := Distribution(memo[i], s);
          for j := 1 to j - i do
            memo.delete(i + 1);
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
          begin
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
            else memo[i] := '1';  
          end
          else memo[i] := Distribution(memo[i], '/' + s);
          for j := 1 to j - i do
            memo.delete(i + 1);
        end
        else if (i >= 1) and (copy(Memo[i - 1],1,1) = '(') then
        begin
          if (copy(Memo[i + 1],1,1) <> ')') and (copy(Memo[i + 1],1,1) <> ',') then
          begin
            s := Memo[i] + Memo[i + 1];
            s := StringReplace(s, '--', '+', [rfReplaceAll]);
            s := StringReplace(s, '++', '+', [rfReplaceAll]);
            s := StringReplace(s, '+-', '-', [rfReplaceAll]);
            s := StringReplace(s, '-+', '-', [rfReplaceAll]);
            Memo[i] := s;
            Memo.Delete(i+1);
          end
        end
        else if (Memo.Count > i + 1) and (copy(Memo[i + 1],1,1) = ')') then
          if (copy(Memo[i - 1],1,1) <> '(') and (copy(Memo[i - 1],1,1) <> ',') then
          begin
            s := Memo[i-1] + Memo[i];
            s := StringReplace(s, '--', '+', [rfReplaceAll]);
            s := StringReplace(s, '++', '+', [rfReplaceAll]);
            s := StringReplace(s, '+-', '-', [rfReplaceAll]);
            s := StringReplace(s, '-+', '-', [rfReplaceAll]);
            Memo[i-1] := s;
            Memo.Delete(i);
          end;
        i := 0;
      end;

      inc(i);
    end;
    if not maxfound then
      dec(max);
  until max <= 0;

  repeat
    s := NoParenthesisProcess(memo.text, jump);
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
  comma.free;
  frac.free;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  BtnEval.Left := (panelEval.width - btnEval.Width) div 2;
end;

procedure TFormPrincipal.Loadfromfile1Click(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
  if OpenDialog.Execute then
    MemoIn.Lines.LoadFromFile(OpenDialog.FileName);
end;

function Distribution(x,y: string): string;
var i, j: integer;
    flag: boolean;
begin
  if (copy(y, 1, 1) = '(') and (copy(y, length(y), 1) = ')') then
  begin
    result := copy(y, 2, length(y) - 2);
    if result = FracValida(result) then
      y := result;
  end;

  if (x = FracValida(x)) and (y = FracValida(y)) then
  begin
    result := FracMul(x, y);
    exit;
  end;

  if copy(y,1,1) = '/' then
    j := 2
  else
    j := 1;

  if copy(y,j,1) = '(' then
  begin
    flag := true;
    i := j + 1;
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
      delete(y, j, 1);
      delete(y, length(y), 1);
    end;
  end;

  flag := false;
  Result := copy(x, 1, 1);
  //if s[1] in ['+', '*', '/', '^','='] then
  //  insert(y, s, 2);
  i := 2;
  while i <= length(x) do
  begin
    if (x[i] = '(') and flag then
      inc(j)
    else if (x[i] = ')') and flag then
      dec(j)
    else if x[i] in ['+', '-', '*', '/', '='] then
      if not flag then
        result := result + y
      else if j = 0 then
        flag := false;

    result := result + x[i];
    if x[i] = '/' then
    begin
      flag := true;
      j := 0;
    end;
    inc(i);
  end;

  result := result + y;
  //showmessage(x + ' TIMES ' + y + ' EQUALS ' + result);
end;

function ExistVariable(s: string): boolean;
var i: integer;
begin
  for i := 1 to length(s) do
    if (s[i] >= 'a') and (s[i] < 'z') then
    begin
      Result := true;
      exit;
    end;
  Result := false;
end;

function CommandProcess(s: string): string;
var d, variable: string;
    i: integer;
    ch: char;
begin
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
      Application.MessageBox(PChar('solve for [variable]: expected. encountered: ' + ch), 'Syntax error', MB_ICONEXCLAMATION);
      exit;
    end;
  end;
  Result := WithParenthesisProcess(s);

  repeat
    s := denominator(Result);
    if s = '' then
      break;
    Result := Distribution(Result, s);
    Result := WithParenthesisProcess(Result);
    //showmessage(Result);
  until false;

  if ch = 'x' then
    result := SolveFor(variable, Result);
end;

function IsVariable(s: string): char;
var i: integer;
begin
  i := 2;
  if s = '' then
    Result := ' '
  else if s[1] in ['a'..'z'] then
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

function SolveFor(variable, s: string): string;
begin
  result := s;
  if pos(variable, s) = 0 then
  begin
    result := result + #13#10'Variable ' + variable + ' does not occur in entry.';
    exit;
  end;
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
  else if s[1] in ['0'..'9', 'a'..'z'] then
  while i <= length(s) do
    if s[i] in ['0'..'9','^'] then
      inc(i)
    else break;

  result := copy(s, 1, i - 1);
end;

function BasisDifference(x, x3: string): string;
var i, i3: integer;
    p, p3: string;
begin
  i3 := pos('^', x3);
  if i3 = 0 then
    p3 := '1'
  else
    p3 := copy(x3, i3+1, length(x3));

  i := pos('^', x);
  if i = 0 then
    p := '1'
  else
    p := copy(x, i+1, length(x));

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

end.
