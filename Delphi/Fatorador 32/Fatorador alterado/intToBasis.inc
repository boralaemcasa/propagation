function IntToBasis(p, b: int64): string;
function caracter(x: word): string;
begin
   if x < 10 then
      Result := char(x + 48)
   else if x < 10 + 26 then
      Result := char(x + 55)
   else
      Result := '[' + IntToStr(x) + ']';
end;

var s: string;
begin
  s := '';
  while p >= b do
  begin
    s := caracter(p mod b) + s;
    p := p div b;
  end;
  if p > 0 then
    s := caracter(p) + s;
  result := s;
end;