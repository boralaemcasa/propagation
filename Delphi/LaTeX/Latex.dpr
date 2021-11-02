program Latex;
uses classes, dialogs, sysutils;
var list: TStringList;
    s: string;
begin
  if paramcount <> 1 then
  begin
    showmessage('Lat�x [fil�.tex]');
    exit;
  end;
  list := TStringList.Create;
  list.LoadFromFile(paramstr(1));
  s := stringReplace(list.text, '�', '\''a', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''e', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''i', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''o', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''u', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''A', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''E', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''I', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''O', [rfReplaceAll]);
  s := stringReplace(s, '�', '\''U', [rfReplaceAll]);
  s := stringReplace(s, '�', '\c{c}', [rfReplaceAll]);
  s := stringReplace(s, '�', '\c{C}', [rfReplaceAll]);
  s := stringReplace(s, '�', '\~a', [rfReplaceAll]);
  s := stringReplace(s, '�', '\~o', [rfReplaceAll]);
  s := stringReplace(s, '�', '\~A', [rfReplaceAll]);
  s := stringReplace(s, '�', '\~O', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^a', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^e', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^o', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^A', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^E', [rfReplaceAll]);
  s := stringReplace(s, '�', '\^O', [rfReplaceAll]);
  s := stringReplace(s, '�', '\`a', [rfReplaceAll]);
  s := stringReplace(s, '�', '\`A', [rfReplaceAll]);
  list.Text := s;
  list.SaveToFile(paramstr(1));
  list.free;
end.
