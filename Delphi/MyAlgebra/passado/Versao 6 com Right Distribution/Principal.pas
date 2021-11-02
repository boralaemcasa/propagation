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

function Distribution(x,y: string): string;
function ExistVariable(s: string): boolean;
function NoParenthesisProcess(entry: string; jump: boolean): string;
function WithParenthesisProcess(entry: string): string;

implementation

{$R *.dfm}

uses SNum;

procedure TFormPrincipal.BtnEvalClick(Sender: TObject);
begin
  memoOut.text := WithParenthesisProcess(MemoIn.text);
end;

function NoParenthesisProcess(entry: string; jump: boolean): string;
var i, j: integer;
    memo: TStringList;
    s: string;
begin
  s := entry;
  memo := TStringList.Create;

  while (length(s) > 0) and not (s[1] in ['0'..'9', '-', 'a'..'z']) do
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
        if s[i] in ['+', '-', '*', '/', '^','='] then
        begin
          insert(#1, s, i+1);
          insert(#1, s, i);
          inc(i);
        end;
        inc(i);
      end;
      repeat
        i := pos('gcd', s);
        if i = 0 then
          break;
        delete(s, i, 3);
      until false;
      repeat
        i := pos('abs', s);
        if i = 0 then
          break;
        delete(s, i, 3);
      until false;
      Memo[j] := s;
      dec(j);
    end;

    s := StringReplace(memo.text, #1, #13#10, [rfReplaceAll]);

    i := 1;
    while i <= length(s) do
      if s[i] in ['0'..'9', #13, #10, 'a'..'z'] then
        inc(i)
      else if (s[i] in ['+', '-', '*', '/', '^', '=']) and (i < length(s)) then
        inc(i)
      else delete(s, i, 1);

    memo.Text := s;

    i := 0;
    repeat
      if i = memo.count then
        break;    
      if memo[i] = '' then
        memo.Delete(i)
      else inc(i);
    until false;
  end
  else
    begin
      i := 1;
      while i <= length(s) do
        if s[i] in ['0'..'9', '=', 'a'..'z'] then
          inc(i)
        else if (s[i] in ['+', '-', '*', '/', '^']) and (i < length(s)) then
          if (s[i+1] < '0') or (s[i+1] > '9') then
            delete(s, i+1, 1)
          else inc(i)
        else delete(s, i, 1);

      i := 1;
      if copy(s, 1, 1) = '-' then
        inc(i);
      while i <= length(s) do
        if s[i] in ['+', '-', '*', '/', '^', '='] then
        begin
          memo.Add(copy(s, 1, i-1));
          memo.Add(s[i]);
          delete(s, 1, i);
          i := 1;
        end
        else inc(i);

    memo.add(s);
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

function WithParenthesisProcess(entry: string): string;
var
  s, t, target: string;
  i, j, max: integer;
  maxfound, jump: boolean;
  memo, comma, frac: TStringList;
begin
  max := 0;
  s := entry;
  //s := StringReplace(s, '[', '(', [rfReplaceAll]);
  //s := StringReplace(s, ']', ')', [rfReplaceAll]);
  
//trim alphabet
  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', '+', '-', '*', '/', '^', '(', ')', ',', '=', 'a'..'z'] then
      inc(i)
    else delete(s, i, 1);

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

      if (i >= 2) and (s[i - 1] in ['0'..'9', 'a'..'z']) and (s[i] = '(') then
        if (memo[memo.Count - 1] <> 'gcd') and (memo[memo.Count - 1] <> 'abs') then
          if frac[frac.Count - 1] <> inttostr(j+1) then
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
        Memo[i+1] := WithParenthesisProcess(s);
        jump := true;
        while Memo[i + 2] <> ')' + inttostr(max) do
          Memo.Delete(i + 2);
        showmessage(memo.text);
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
          memo[i] := Distribution(memo[i], '/' + s);
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

  if jump then
    memo.text := NoParenthesisProcess(memo.Text, true)
  else
    memo.text := NoParenthesisProcess(entry, false);
  
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
var i: integer;
    slash: boolean;
begin
  slash := false;
  Result := copy(x, 1, 1);
  //if s[1] in ['+', '*', '/', '^','='] then
  //  insert(y, s, 2);
  i := 2;
  while i <= length(x) do
  begin
    if x[i] in ['+', '-', '*', '/', '='] then
      if slash then
        slash := false
      else
        result := result + y;

    result := result + x[i];
    if x[i] = '/' then
      slash := true;
    inc(i);
  end;

  result := result + y;
  showmessage(x + ' TIMES ' + y + ' EQUALS ' + result);
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

end.
