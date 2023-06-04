program Ideographs;
uses sysutils;
var
  f: textFile;
  i, j, k, n, c: integer;
  s: string;
begin
  n := $3400; c := 4;
  assignfile(f, 'C:\temptemp\unicode\saida.htm');
  rewrite(f);
  writeln(f, '<html>');
  writeln(f, '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>');
  writeln(f, '<title>Ideographs</title>');
  writeln(f, '<style type="text/css">');
  writeln(f, '#customers');
  writeln(f, '{');
  writeln(f, 'font-size:1.5em;');
  writeln(f, 'border-collapse:collapse;');
  writeln(f, '}');
  writeln(f, '</style>');
  writeln(f, '<body>');
  writeln(f, '<a href="https://en.wikipedia.org/wiki/CJK_Unified_Ideographs_Extension_D">CJK Ideographs</a><br/>');
  writeln(f, '<br/>');
  writeln(f, '<table id="customers">');
  i := -1;
  while true do
  begin
    inc(i); k := 40 * i;
    if odd(i) then
      s := '<tr><td><font face="courier new" style="background-color: #A7C942;" color="white">'
    else
      s := '<tr><td><font face="courier new" style="background-color: blue;" color="white">';
    if k < 10 then
      s := s + '&nbsp;&nbsp;&nbsp;&nbsp;'
    else if k < 100 then
      s := s + '&nbsp;&nbsp;&nbsp;'
    else if k < 1000 then
      s := s + '&nbsp;&nbsp;'
    else if k < 10000 then
      s := s + '&nbsp;';
    writeln(f, s  + inttostr(k) + '&nbsp;</font></td>');
    for j := 1 to 40 do
    begin
      if n = $4DBF + 1 then
        n := $4E00
      else if n = $9FFF + 1 then
        n := $F900
      else if n = $FAFF + 1 then
      begin
        n := $20000; inc(c);
      end
      else if n = $2EBEF + 1 then
        n := $2F800
      else if n = $2FA1F + 1 then
        n := $30000
      else if n = $323AF + 1 then
        break;
      write(f, '<td title="x' + inttohex(n, c) + '">&#x' + inttohex(n, c) + ';</td>');
      n := n + 1;
    end;
    writeln(f, '</tr>');
    if n > $323AF then
      break;
  end;
  writeln(f, '</table>');
  writeln(f, '<br/>');
  writeln(f, 'Versão de 04/junho/2023');
  closefile(f);
end.
