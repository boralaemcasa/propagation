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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

function NoParenthesisProcess(s: string; jump: boolean): string;
function WithParenthesisProcess(entry: string): string;

implementation

{$R *.dfm}

uses SNum;

procedure TFormPrincipal.BtnEvalClick(Sender: TObject);
begin
  memoOut.text := WithParenthesisProcess(MemoIn.text);
end;

function NoParenthesisProcess(s: string; jump: boolean): string;
var i, j: integer;
    memo: TStringList;
begin
  memo := TStringList.Create;

  while (length(s) > 0) and ((s[1] < '0') or (s[1] > '9')) and (s[1] <> '-') do
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
      if s[i] in ['0'..'9', #13, #10] then
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
        if (s[i] >= '0') and (s[i] <= '9') or (s[i] = '=') then
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

  i := 1; //if priority = 2 then
  while i < memo.Count do
  begin
    if memo[i] = '^' then
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
    if Memo[i] = '*' then
    begin
      Memo[i - 1] := FracMul(Memo[i - 1], Memo[i + 1]);
      Memo.Delete(i);
      Memo.Delete(i);
      i := 0;
    end;

    if Memo[i] = '/' then
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
    if Memo[i] = '+' then
    begin
      Memo[i - 1] := FracAdd(Memo[i - 1], Memo[i + 1]);
      Memo.Delete(i);
      Memo.Delete(i);
      i := 0;
    end;

    if Memo[i] = '-' then
    begin
      Memo[i - 1] := FracSub(Memo[i - 1], Memo[i + 1]);
      Memo.Delete(i);
      Memo.Delete(i);
      i := 0;
    end;

    inc(i);
  end;

  while Memo[0] = '-' do
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
end;

function WithParenthesisProcess(entry: string): string;
var
  s, t: string;
  i, j, max: integer;
  maxfound, jump: boolean;
  memo, comma: TStringList;
begin
//trim alphabet
  s := entry;
  i := 1;
  while i <= length(s) do
    if s[i] in ['0'..'9', '+', '-', '*', '/', '^', 'g', 'c', 'd', '(', ')', ',', 'a', 'b', 's', '='] then
      inc(i)
    else delete(s, i, 1);

  if not (s[1] in ['0'..'9', '(', '+', '-']) then
    if (copy(s, 1, 3) <> 'gcd') and (copy(s, 1, 3) <> 'abs') then
    begin
      Application.MessageBox('+, -, abs or gcd or digit or ( expected as first character', 'Syntax error', MB_ICONEXCLAMATION);
      exit;
    end;

  jump := false;
  j := 0;
  memo := TStringList.Create;
  comma := TStringList.Create;
  i := 1;
  while i <= length(s) do
    if s[i] = #1 then
    begin
      Application.MessageBox('Reserved character', 'Syntax error', MB_ICONEXCLAMATION);
      memo.free;
      comma.free;
      exit;
    end
    else if s[i] in ['+', '-', '*', '/'] then
    begin
      if not (s[i + 1] in ['0'..'9', '(']) then
        if (copy(s, i + 1, 3) <> 'gcd') and (copy(s, i + 1, 3) <> 'abs') then
        begin
          Application.MessageBox(PChar('abs or gcd or digit or ( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
          memo.free;
          comma.free;
          exit;
        end;

      inc(i);
    end
    else if s[i] in ['(', ',','='] then
    begin
      if s[i] = '=' then
        if not (s[i + 1] in ['0'..'9', '(']) then
          if (copy(s, i + 1, 3) <> 'gcd') and (copy(s, i + 1, 3) <> 'abs') then
          begin
            Application.MessageBox(PChar('abs or gcd or digit or ( expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
            memo.free;
            comma.free;
            exit;
          end;

      if s[i + 1] in [',', ')', '*', '/', '^'] then
      begin
        Application.MessageBox(PChar('+, - or digit expected after ' + s[i]), 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
        exit;
      end;
      if (s[i] = ',') and (comma.count = 0) then
      begin
        Application.MessageBox('comma outside gcd', 'Syntax error', MB_ICONEXCLAMATION);
        memo.free;
        comma.free;
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
      if s[i + 1] in ['(', '0'..'9'] then
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
        exit;
      end;
      t := copy(s, 1, i-1);
      if t <> '' then
        memo.Add(t);
      memo.Add(copy(s, i, 3));
      delete(s, 1, i + 2);
      i := 1;
    end
    else inc(i);

  if j > 0 then
  begin
    Application.MessageBox('Excess of (', 'Syntax error', MB_ICONEXCLAMATION);
    memo.free;
    comma.free;
    exit;
  end;

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
        Memo.Delete(i+2);
        Memo[i+1] := NoParenthesisProcess(Memo[i + 1], true);
        jump := true;
        Memo.Delete(i);
        if (i >= 1) and (copy(Memo[i - 1],1,1) = '(') then
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

end.
