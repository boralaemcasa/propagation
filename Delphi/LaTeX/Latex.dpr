program Latex;
uses classes, dialogs, sysutils;
var list: TStringList;
    s: string;
begin
  if paramcount <> 1 then
  begin
    showmessage('Latéx [filé.tex]');
    exit;
  end;
  list := TStringList.Create;
  list.LoadFromFile(paramstr(1));
  s := stringReplace(list.text, 'á', '\''a', [rfReplaceAll]);
  s := stringReplace(s, 'é', '\''e', [rfReplaceAll]);
  s := stringReplace(s, 'í', '\''i', [rfReplaceAll]);
  s := stringReplace(s, 'ó', '\''o', [rfReplaceAll]);
  s := stringReplace(s, 'ú', '\''u', [rfReplaceAll]);
  s := stringReplace(s, 'Á', '\''A', [rfReplaceAll]);
  s := stringReplace(s, 'É', '\''E', [rfReplaceAll]);
  s := stringReplace(s, 'Í', '\''I', [rfReplaceAll]);
  s := stringReplace(s, 'Ó', '\''O', [rfReplaceAll]);
  s := stringReplace(s, 'Ú', '\''U', [rfReplaceAll]);
  s := stringReplace(s, 'ç', '\c{c}', [rfReplaceAll]);
  s := stringReplace(s, 'Ç', '\c{C}', [rfReplaceAll]);
  s := stringReplace(s, 'ã', '\~a', [rfReplaceAll]);
  s := stringReplace(s, 'õ', '\~o', [rfReplaceAll]);
  s := stringReplace(s, 'Ã', '\~A', [rfReplaceAll]);
  s := stringReplace(s, 'Õ', '\~O', [rfReplaceAll]);
  s := stringReplace(s, 'â', '\^a', [rfReplaceAll]);
  s := stringReplace(s, 'ê', '\^e', [rfReplaceAll]);
  s := stringReplace(s, 'ô', '\^o', [rfReplaceAll]);
  s := stringReplace(s, 'Â', '\^A', [rfReplaceAll]);
  s := stringReplace(s, 'Ê', '\^E', [rfReplaceAll]);
  s := stringReplace(s, 'Ô', '\^O', [rfReplaceAll]);
  s := stringReplace(s, 'à', '\`a', [rfReplaceAll]);
  s := stringReplace(s, 'À', '\`A', [rfReplaceAll]);
  list.Text := s;
  list.SaveToFile(paramstr(1));
  list.free;
end.
