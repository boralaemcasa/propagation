unit Poly;

interface

uses Classes, Dialogs, StdCtrls;

type
  TMonomial = record
    coef, powers: string;
  end;

  TLinha = array of string;
  PLinha = record
    case byte of
      0: (p: ^TLinha);
      1: (i: integer);
  end;

  TPoly = class
  public
    dim: word;
    mywho: string;
    max: integer;
    list: TStringList;
    constructor Create(dimension: word);
    destructor free(freeMem: boolean = true);

    function Sum(p: TPoly): TPoly;
    function Multiply(p: TPoly; memo: TMemo): TPoly;
    function TimesConstant(k: string): TPoly;
    function Derivative: TPoly;
    function coefx(n: string): string;
    function isZero(RAM: boolean): boolean;

    function SumToDisk(who: string; p: TPoly): TPoly;
    function MultiplyToDisk(who: string; p: TPoly; memo: TMemo): TPoly;
    function TimesConstantToDisk(who: string; k: string): TPoly;
    function DerivateToDisk(who: string): TPoly;
    procedure DiskReduce(who, n: string; p: TPoly; memo: TMemo);
    procedure AddToDisk(who, s: string);
    procedure DiskSimplify(memo: TMemo);
    function coefxInDisk(n: string; algebra: boolean): string;

    procedure Add(s: string; ordenar: boolean = true; posicao: integer = -1);
    procedure Simplify;
    procedure Reduce(n: string; p: TPoly; memo: TMemo);
    function GetMax: integer;
    function Monomial(n: string): TMonomial;
    function Text: string;
  end;

function nTimesStr(n, s: string): string;
function SplitPowers(s: string): TStringList;

implementation

uses SNum, SysUtils, Forms, DB, DataModulo;

constructor TPoly.Create(dimension: word);
begin
  dim := dimension;
  max := -1;
  list := TStringList.Create;
end;

destructor TPoly.free(freeMem: boolean = true);
var
  i: integer;
  p: PLinha;
begin
  if freeMem then
    for i := 0 to list.Count - 1 do
    begin
      p.i := strtoint(list[i]);
      Dispose(p.p);
    end;

  list.free;
end;

function TPoly.Multiply(p: TPoly; memo: TMemo): TPoly;
var
  maxdim: word;
  i, j, k: integer;
  a, b: PLinha;
  s: string;
begin
  if dim > p.dim then
    maxdim := dim
  else
    maxdim := p.dim;

  result := TPoly.Create(maxdim);
  for i := 0 to list.Count - 1 do
  begin
    if fileExists('cancelar.txt') then
    begin
      application.Terminate;
      exit;
    end;
    for j := 0 to p.list.Count - 1 do
    begin
      a.i := strtoint(list[i]);
      b.i := strtoint(p.list[j]);

      s := FracMul(a.p^[0], b.p^[0]);
      for k := 1 to maxdim do
        if k < dim + 1 then
          if k < p.dim + 1 then
            s := s + '.' + Soma(a.p^[k], b.p^[k])
          else
            s := s + '.' + Soma(a.p^[k], '0')
        else if k < p.dim + 1 then
          s := s + '.' + Soma('0', b.p^[k])
        else
          s := s + '.0';

      result.Add(s, i > 0); // if i = 0 then nao ordenar
    end;
    if (i > p.dim - 3) and (i < list.count - 1) then
    begin
      if memo.Lines.Count >= 10240 then
        memo.clear;
      memo.lines.add('mult (I) ' + inttostr(i + 1) + '/' + inttostr(list.count) + ' = ' +
        inttostr((i + 1) * 100 div list.Count) + ' %');
      application.processMessages;
    end;
  end;
end;

function TPoly.MultiplyToDisk(who: string; p: TPoly; memo: TMemo): TPoly;
var
  i, c1, c2: integer;
begin
  result := TPoly.Create(dim);
  result.mywho := who;
  if p.isZero(false) or isZero(false) then
  begin
    result.list.Text := '0';
    exit;
  end;

  dm.qryMaxI.ParamByName('w').AsString := mywho;
  dm.qryMaxI.Open;
  c1 := dm.qryMaxI.fieldByName('m').AsInteger;
  dm.qryMaxI.Close;

  dm.qryMaxI.ParamByName('w').AsString := p.mywho;
  dm.qryMaxI.Open;
  c2 := dm.qryMaxI.fieldByName('m').AsInteger;
  dm.qryMaxI.Close;

  i := c1 * c2;
  memo.Lines.Add('mult insert master ' + IntToStr(i));
  application.ProcessMessages;
  if i < 30000000 then
  begin
    dm.qryMult.ParamByName('newwho').AsString := who;
    dm.qryMult.ParamByName('who1').AsString := mywho;
    dm.qryMult.ParamByName('who2').AsString := p.mywho;
    dm.qryMult.ExecSQL;
  end
  else
  begin // (A + B)(C + D)
    i := (c1 div 2 + 1) * (c2 div 2 + 1);
    dm.qryMultC.ParamByName('newwho').AsString := who;
    dm.qryMultC.ParamByName('who1').AsString := mywho;
    dm.qryMultC.ParamByName('who2').AsString := p.mywho;
  //AC
    dm.qryMultC.ParamByName('offset').AsInteger := 0;
    dm.qryMultC.ParamByName('a1').AsInteger := 0;
    dm.qryMultC.ParamByName('b1').AsInteger := c1 div 2;
    dm.qryMultC.ParamByName('a2').AsInteger := 0;
    dm.qryMultC.ParamByName('b2').AsInteger := c2 div 2;
    memo.Lines.Add('mult AC');
    application.ProcessMessages;
    dm.qryMultC.ExecSQL;
  //AD
    dm.qryMultC.ParamByName('offset').AsInteger := i;
    dm.qryMultC.ParamByName('a1').AsInteger := 0;
    dm.qryMultC.ParamByName('b1').AsInteger := c1 div 2;
    dm.qryMultC.ParamByName('a2').AsInteger := c2 div 2;
    dm.qryMultC.ParamByName('b2').AsInteger := c2 + 1;
    memo.Lines.Add('mult AD');
    application.ProcessMessages;
    dm.qryMultC.ExecSQL;
  //BC
    dm.qryMultC.ParamByName('offset').AsInteger := 2 * i;
    dm.qryMultC.ParamByName('a1').AsInteger := c1 div 2;
    dm.qryMultC.ParamByName('b1').AsInteger := c1 + 1;
    dm.qryMultC.ParamByName('a2').AsInteger := 0;
    dm.qryMultC.ParamByName('b2').AsInteger := c2 div 2;
    memo.Lines.Add('mult BC');
    application.ProcessMessages;
    dm.qryMultC.ExecSQL;
  //BD
    dm.qryMultC.ParamByName('offset').AsInteger := 3 * i;
    dm.qryMultC.ParamByName('a1').AsInteger := c1 div 2;
    dm.qryMultC.ParamByName('b1').AsInteger := c1 + 1;
    dm.qryMultC.ParamByName('a2').AsInteger := c2 div 2;
    dm.qryMultC.ParamByName('b2').AsInteger := c2 + 1;
    memo.Lines.Add('mult BD');
    application.ProcessMessages;
    dm.qryMultC.ExecSQL;

    result.DiskSimplify(memo);
  end;

  dm.qryMaxI.paramByName('w').asString := who;
  dm.qryMaxI.Open;
  result.list.text := dm.qryMaxI.fieldByName('m').AsString;
  dm.qryMaxI.Close;

  dm.qryMaxPower.paramByName('w').asString := who;
  dm.qryMaxPower.Open;
  result.max := dm.qryMaxPower.fieldByName('m').AsInteger;
  dm.qryMaxPower.Close;
end;

function TPoly.Sum(p: TPoly): TPoly;
var
  maxdim: word;
  i, j: integer;
  L: PLinha;
  s: string;
begin
  if dim > p.dim then
    maxdim := dim
  else
    maxdim := p.dim;

  result := TPoly.Create(maxdim);
  for i := 0 to list.Count - 1 do
  begin
    L.i := strtoint(list[i]);
    s := L.p^[0];
    for j := 1 to dim do
      s := s + '.' + L.p^[j];
    result.Add(s, false);
  end;
  for i := 0 to p.list.Count - 1 do
  begin
    L.i := strtoint(p.list[i]);
    s := L.p^[0];
    for j := 1 to p.dim do
      s := s + '.' + L.p^[j];
    result.Add(s);
  end;
end;

function TPoly.SumToDisk(who: string; p: TPoly): TPoly;
var
  maxdim: word;
begin
  if dim > p.dim then
    maxdim := dim
  else
    maxdim := p.dim;

  result := TPoly.Create(maxdim);
  result.list.Text := Soma(list[0], p.list[0]);
  result.max := max;

  dm.qrySumMaster.paramByName('who').asString := who;
  dm.qrySumMaster.paramByName('L').asString := list[0];
  dm.qrySumMaster.paramByName('mywho').asString := p.mywho;
  dm.qrySumMaster.ExecSQL;

  result.mywho := who;
end;

function TPoly.TimesConstant(k: string): TPoly;
var
  i: integer;
  m: TMonomial;
begin
  Result := TPoly.Create(dim);

  for i := 0 to list.Count - 1 do
  begin
    m := monomial(inttostr(i));
    Result.Add(FracMul(m.coef, k) + '.' + m.powers, false);
  end;
end;

function TPoly.TimesConstantToDisk(who, k: string): TPoly;
begin
  Result := TPoly.Create(dim);
  result.list.text := list.text;
  result.max := max;
  if k = '0' then
    exit;

  dm.qryTimesMaster.ParamByName('who').AsString := who;
  dm.qryTimesMaster.ParamByName('mywho').AsString := mywho;
  dm.qryTimesMaster.ParamByName('k').AsString := k;
  dm.qryTimesMaster.ExecSQL;

  result.mywho := who;
end;

function trocar(s, t: string): boolean;
var
  ps, pt: PLinha;
  i: integer;
begin
  ps.i := strtoint(s);
  pt.i := strtoint(t);

  i := length(ps.p^) - 1;
  s := ps.p^[i];
  t := pt.p^[i];
  for i := i - 1 downto 1 do
  begin
    s := s + '.' + ps.p^[i];
    t := t + '.' + pt.p^[i];
  end;
  result := (s > t);
end;

procedure TPoly.Add(s: string; ordenar: boolean = true; posicao: integer = -1);
var
  i: integer;
  p: PLinha;
  a: TStringList;
begin
  if posicao = -1 then
    posicao := list.Count;

  new(p.p);
  SetLength(p.p^, dim + 1);

  a := SplitPowers(s);
  for i := 0 to a.Count - 1 do
    p.p^[i] := a[i];
  for i := a.count to dim do
    p.p^[i] := '0';
  list.Insert(posicao, inttostr(p.i));
  a.Free;

  i := strtoint(p.p^[1]);
  if i > max then
    max := i;

  i := list.count - 2;
  if ordenar then
    while (i >= 0) and trocar(list[i], list[i + 1]) do
    begin
      s := list[i];
      list[i] := list[i + 1];
      list[i + 1] := s;
      dec(i);
    end;
end;

procedure TPoly.AddToDisk(who, s: string);
var
  i: integer;
  p: PLinha;
  a: TStringList;
  coef: string;
begin
  if list.text = '' then
    list.Text := '1'
  else
    list.Text := Soma(list[0], '1');

  new(p.p);
  SetLength(p.p^, dim + 1);

  a := SplitPowers(s);
  for i := 0 to a.Count - 1 do
    p.p^[i] := a[i];
  for i := a.count to dim do
    p.p^[i] := '0';
  a.free;

  if dm.qryAdd.Tag <> dim then
  begin
    dm.qryAdd.SQL.Clear;
    dm.qryAdd.SQL.add('select i, coef::text coef');
    dm.qryAdd.SQL.add('from poly m');
    dm.qryAdd.SQL.add('where who = :w');
    for i := 1 to dim do
    begin
      dm.qryAdd.SQL.add('  and m.p' + inttostr(i) + ' = :p' + inttostr(i));
    end;
    dm.qryAdd.Tag := dim;
  end;

  dm.qryAdd.ParamByName('w').AsString := mywho;
  for i := 1 to dim do
    dm.qryAdd.ParamByName('p' + inttostr(i)).AsString := p.p^[i];
  dm.qryAdd.Open;
  dm.qryAdd.First;
  if not dm.qryAdd.IsEmpty then
    while not dm.qryAdd.eof do
    begin
      coef := dm.qryAdd.fieldByName('coef').asstring;
      p.p^[0] := FracAdd(p.p^[0], coef);

      dm.qryDelMaster.ParamByName('p1').AsString := who;
      dm.qryDelMaster.ParamByName('p3').AsString := dm.qryAdd.fieldbyName('i').asString;
      dm.qryDelMaster.ExecSQL;

      dm.qryAdd.Next;
    end;
  dm.qryAdd.Close;

  if p.p^[0] <> '0' then
  begin
    dm.qryInsMaster.ParamByName('p1').asString := who;
    dm.qryInsMaster.ParamByName('p2').asInteger := strToInt(list[0]);
    dm.qryInsMaster.ParamByName('p3').asString := p.p^[0];

    for i := 1 to dim do
      dm.qryInsMaster.ParamByName('PP' + inttostr(i)).AsSmallInt := StrToInt(p.p^[i]);
    dm.qryInsMaster.ExecSql;
  end;

  i := strtoint(p.p^[1]);
  if i > max then
    max := i;
  dispose(p.p);
  //mywho := who;
end;

function TPoly.Monomial(n: string): TMonomial;
var
  i: integer;
  p: PLinha;
begin
  p.i := strtoint(list[strtoint(n)]);
  result.coef := p.p^[0];
  result.powers := p.p^[1];
  for i := 2 to dim do
    result.powers := result.powers + '.' + p.p^[i];
end;

function TPoly.Derivative: TPoly; // em relaçao a x_1
var
  i, j: integer;
  a: PLinha;
  s: string;
begin
  Result := TPoly.Create(dim);

  for i := 0 to list.Count - 1 do
  begin
    a.i := strToInt(list[i]);
    if a.p^[1] <> '0' then
    begin
      s := FracMul(a.p^[0], a.p^[1]) + '.' + Subtrai(a.p^[1], '1');
      for j := 2 to dim do
        s := s + '.' + a.p^[j];
      Result.Add(s, false);
    end;
  end;
end;

function TPoly.DerivateToDisk(who: string): TPoly; // em relaçao a x_1
begin
  Result := TPoly.Create(dim);
  result.list.text := list.text;
  result.mywho := who;
  if max = 0 then
    result.max := 0
  else
    result.max := max - 1;

  dm.qryDerivMaster.ParamByName('who').AsString := who;
  dm.qryDerivMaster.ParamByName('mywho').AsString := mywho;
  dm.qryDerivMaster.ExecSQL;

  result.mywho := who;
end;

function nTimesStr(n, s: string): string;
var i: integer;
begin
  result := '';
  for i := 1 to strtoint(n) do
    result := result + s;
end;

function SplitPowers(s: string): TStringList;
var i: integer;
begin
  result := TStringList.Create;
  repeat
    i := pos('.', s);
    if i = 0 then
      break;
    result.Add(copy(s, 1, i - 1));
    delete(s, 1, i);
  until false;
  result.Add(s);
end;

procedure TPoly.Simplify; // cancel(i, i + 1)
var
  i, k: integer;
  a, b: PLinha;
  flag: boolean;
  s: string;
begin
  i := 0;
  while i < list.count - 1 do
  begin
    a.i := strtoInt(list[i]);
    b.i := strtoint(list[i + 1]);
    flag := true;
    for k := 1 to dim do
      if a.p^[k] <> b.p^[k] then
      begin
        flag := false;
        break;
      end;

    if flag then
    begin
      s := FracAdd(a.p^[0], b.p^[0]);
      if s = '0' then
      begin
        FreeMem(b.p);
        FreeMem(a.p);
        list.Delete(i + 1);
        list.Delete(i);
        max := GetMax;
      end
      else
      begin
        for k := 1 to dim do
          s := s + '.' + a.p^[k];

        FreeMem(b.p);
        FreeMem(a.p);
        list.Delete(i + 1);
        list.Delete(i);
        Add(s, false, i);
      end;
      dec(i);
    end;

    inc(i);
  end;
end;

function TPoly.GetMax: integer;
var
  a: PLinha;
  i, j: integer;
begin
  result := -1;
  for i := 0 to list.count - 1 do
  begin
    a.i := strToInt(list[i]);
    try
      j := strtoint(a.p^[1]);
    except
      result := 0;
      exit;
    end;
    if j > result then
      result := j;
  end;
end;

procedure TPoly.Reduce(n: string; p: TPoly; memo: TMemo);
var
  a: PLinha;
  i, j: integer;
  temp: array[1..4] of TPoly;
  m: TMonomial;
  s: string;
begin
  if fileExists('cancelar.txt') then
  begin
    application.terminate;
    exit;
  end;

  simplify;
  if max < strtoint(n) then
    exit;

  i := -1;
  repeat
    repeat
      inc(i);
      if i >= list.count then
        break;

      a.i := strToInt(list[i]);
      if strtoint(a.p^[1]) = max then
        break;
    until false;

    m.coef := a.p^[0];
    s := Subtrai(a.p^[strtoint(n) + 2], '1');

    m.powers := intToStr(max - strtoint(n));
    for j := 2 to strtoint(n) + 1 do
      m.powers := m.powers + '.' + a.p^[j];
    m.powers := m.powers + '.' + s;

    repeat
      list.Delete(i);

      temp[1] := TPoly.Create(strtoint(n) + 2);
      temp[1].Add('1.' + m.powers); // x^{max - n} a_n
      memo.Lines.Add(m.powers + ' (' + inttostr(i) + '/' + inttostr(list.count) + ')');
      application.processMessages;

      temp[2] := p.Multiply(temp[1], memo);
      temp[1].free;
      temp[3] := temp[2].TimesConstant(m.coef);
      temp[2].free;
      temp[4] := self.Sum(temp[3]);
      temp[3].free;
      temp[4].Simplify;

      list.text := temp[4].list.text;
      max := temp[4].max;
      temp[4].free(false);
      if max < strtoint(n) then
        break;
      i := 0;

      repeat
        inc(i);
        if i >= list.count then
          break;

        a.i := strToInt(list[i]);
        if strtoint(a.p^[1]) = max then
        begin
          m.coef := a.p^[0];
          s := Subtrai(a.p^[strtoint(n) + 2], '1');
          m.powers := intToStr(max - strtoint(n));
          for j := 2 to strtoint(n) + 1 do
            m.powers := m.powers + '.' + a.p^[j];
          m.powers := m.powers + '.' + s;

          break;
        end;
      until false;

    until i >= list.count;

  until max < strtoint(n);
end;

procedure TPoly.DiskReduce(who, n: string; p: TPoly; memo: TMemo);
var
  i, j: integer;
  temp: array[1..3] of TPoly;
  s, coef: string;
  L: TStringList;
begin
  if fileExists('cancelar.txt') then
  begin
    application.terminate;
    exit;
  end;

  DiskSimplify(memo);
  if max < strtoint(n) then
    exit;

  repeat
    dm.qryByPower.paramByName('w').asString := who;
    dm.qryByPower.paramByName('p').asInteger := max;
    dm.qryByPower.Open;
    dm.qryByPower.First;

    dm.qryTTMaster.ExecSQL;

    temp[1] := TPoly.Create(strtoint(n) + 2);
    temp[1].mywho := 'TTX';
    while not dm.qryByPower.Eof do
    begin
      i := dm.qryByPower.FieldByName('i').AsInteger;

      dm.qryByI.paramByName('w').asString := who;
      dm.qryByI.ParamByName('p3').AsInteger := i;
      dm.qryByI.Open;
      dm.qryByI.First;

      L := TStringList.Create;
      L.add('0');
      for j := 1 to strtoint(n) + 2 do
        L.Add(dm.qryByI.FieldByName('p' + inttostr(j)).AsString);

      coef := dm.qryByI.FieldByName('coef').AsString;

      dm.qryByI.Close;

      dm.qryDelMaster.ParamByName('p1').AsString := who;
      dm.qryDelMaster.ParamByName('p3').AsInteger := i;
      dm.qryDelMaster.ExecSQL;

      L[1] := IntToStr(max - strtoint(n));
      L[strtoint(n) + 2] := Subtrai(L[strtoint(n) + 2], '1');

      s := coef;
      for j := 1 to strtoint(n) + 2 do
        s := s + '.' + L[j];
      L.Free;

      temp[1].AddToDisk('TTX', s); // x^{max - n} a_n
      if dm.qryByPower.RecNo mod 500 = 0 then
        if dm.qryByPower.RecNo < dm.qryByPower.RecordCount then
        begin
          memo.lines.add('reduce ' + s + ' (I) ' + inttostr(dm.qryByPower.RecNo) + '/' + inttostr(dm.qryByPower.RecordCount) + ' = ' +
            inttostr((dm.qryByPower.RecNo) * 100 div dm.qryByPower.RecordCount) + ' %');
          application.processMessages;
        end;
      dm.qryByPower.Next;
    end;

    dm.qryByPower.Close;

    temp[2] := p.MultiplyToDisk('TTY', temp[1], memo);
    temp[2].mywho := 'TTY';
    temp[1].free(false);
    temp[3] := self.SumToDisk(who, temp[2]);
    temp[2].free(false);

    list.Text := temp[3].list.text;
    DiskSimplify(memo);

    dm.qryMaxPower.ParamByName('w').AsString := who;
    dm.qryMaxPower.Open;
    max := dm.qryMaxPower.fieldByName('m').AsInteger;
    dm.qryMaxPower.Close;

    temp[3].free(false);

  until max < strtoint(n);
end;

function TPoly.coefx(n: string): string;
var
  i, j: integer;
  a: PLinha;
  flag: boolean;
begin
  result := '';
  for i := 0 to list.count - 1 do
  begin
    a.i := strToInt(list[i]);
    try
      flag := (a.p^[1] = n);
    except
      flag := (n = '0');
    end;

    if flag then
    begin
      result := result + a.p^[0];
      for j := 1 to dim do
        result := result + '.' + a.p^[j];
      result := result + #13#10;
    end;
  end;
  if result = '' then
    result := '0';
end;

function TPoly.coefxInDisk(n: string; algebra: boolean): string;
var
  j: integer;
begin
  result := '';

  dm.qryByPower.paramByName('w').asString := mywho;
  dm.qryByPower.paramByName('p').asString := n;
  dm.qryByPower.Open;
  dm.qryByPower.First;
  while not dm.qryByPower.Eof do
  begin
    if not algebra then
      result := result + dm.qryByPower.fieldByName('coef').AsString
    else if dm.qryByPower.fieldByName('coef').AsString = '1' then
      result := result + '+'
    else if dm.qryByPower.fieldByName('coef').AsString = '-1' then
      result := result + '-'
    else if copy(dm.qryByPower.fieldByName('coef').AsString, 1, 1) = '-' then
      result := result + dm.qryByPower.fieldByName('coef').AsString
    else
      result := result + '+' + dm.qryByPower.fieldByName('coef').AsString;

    for j := 1 to dim do
    begin
      if not algebra then
        result := result + '.' + dm.qryByPower.fieldByName('p' + inttostr(j)).AsString
      else if dm.qryByPower.fieldByName('p' + inttostr(j)).AsInteger <> 0 then
      begin
        if j = 2 then
        begin
          if dm.qryByPower.fieldByName('p' + inttostr(j)).AsInteger = 1 then
            result := result + ' x'
          else
            result := result + ' x^' + dm.qryByPower.fieldByName('p' + inttostr(j)).AsString;
        end
        else if j > 2 then
        begin
          if dm.qryByPower.fieldByName('p' + inttostr(j)).AsInteger = 1 then
            result := result + ' a_' + inttostr(j - 2)
          else
            result := result + ' a_' + inttostr(j - 2) + '^' + dm.qryByPower.fieldByName('p' + inttostr(j)).AsString;
        end;
      end;
    end;

    if result[length(result)] in ['+', '-'] then
      result := result + '1';

    result := result + #13#10;

    if algebra then
      application.mainform.caption := 'Y ' + mywho + ' ' + n + ' (I) ' + inttostr(dm.qryByPower.RecNo) + '/' + inttostr(dm.qryByPower.RecordCount) + ' = ' +
        inttostr((dm.qryByPower.RecNo) * 100 div dm.qryByPower.RecordCount) + ' %'
    else
      application.mainform.caption := 'X ' + mywho + ' ' + n + ' (I) ' + inttostr(dm.qryByPower.RecNo) + '/' + inttostr(dm.qryByPower.RecordCount) + ' = ' +
        inttostr((dm.qryByPower.RecNo) * 100 div dm.qryByPower.RecordCount) + ' %';
    application.processMessages;
    dm.qryByPower.Next;
  end;

  dm.qryByPower.Close;
  if result = '' then
    result := '0';
end;

function TPoly.Text: string;
var
  i, j: integer;
  p: PLinha;
begin
  result := '';
  for i := 0 to list.Count - 1 do
  begin
    p.i := strtoint(list[i]);
    result := result + p.p^[0];
    for j := 1 to dim + 1 do
      result := result + '.' + p.p^[j];
    result := result + #13#10;
  end;
end;

procedure TPoly.DiskSimplify(memo: TMemo);
var
  i: integer;
begin
  if dm.qryMinI.Tag <> dim then
  begin
    dm.qryMinI.SQL.Clear;
    dm.qryMinI.SQL.Add('select sum(coef)::text as coef,');
    dm.qryMinI.SQL.Add('  min(i) as m');
    for i := 1 to dim do
      dm.qryMinI.SQL.Add(', p' + inttostr(i));
    dm.qryMinI.SQL.Add('from poly m');
    dm.qryMinI.SQL.Add('where m.who = :w');
    dm.qryMinI.SQL.Add('group by');
    dm.qryMinI.SQL.Add('  p1');
    for i := 2 to dim do
      dm.qryMinI.SQL.Add(', p' + inttostr(i));
    dm.qryMinI.SQL.Add('having count(*) > 1');
    dm.qryMinI.Tag := dim;
  end;

  if dm.qrySimplifyD.Tag <> dim then
  begin
    dm.qrySimplifyD.SQL.Clear;
    dm.qrySimplifyD.SQL.Add('delete from poly where who = :w and i not in (');
    dm.qrySimplifyD.SQL.Add('select');
    dm.qrySimplifyD.SQL.Add('  min(i) as m');
    dm.qrySimplifyD.SQL.Add('from poly m');
    dm.qrySimplifyD.SQL.Add('where m.who = :w');
    dm.qrySimplifyD.SQL.Add('group by');
    dm.qrySimplifyD.SQL.Add('  p1');
    for i := 2 to dim do
      dm.qrySimplifyD.SQL.Add(', p' + inttostr(i));
    dm.qrySimplifyD.SQL.add(')');
    dm.qrySimplifyD.Tag := dim;
  end;

  dm.qryMinI.ParamByName('w').AsString := mywho;
  dm.qryMinI.Open;
  dm.qryMinI.First;

//del <> min
  dm.qrySimplifyD.ParamByName('w').AsString := mywho;
  dm.qrySimplifyD.ExecSQL;

  while not dm.qryMinI.Eof do
  begin
    if dm.qryMinI.FieldByName('coef').AsString = '0' then
    begin
      dm.qryDelMaster.ParamByName('p1').AsString := mywho;
      dm.qryDelMaster.ParamByName('p3').AsString := dm.qryMinI.fieldbyName('m').asString;
      dm.qryDelMaster.ExecSQL;
    end
    else
    begin
      dm.qryUpdateCoef.ParamByName('pc').asstring := dm.qryMinI.fieldbyName('coef').asString;
      dm.qryUpdateCoef.ParamByName('pnew').AsString := mywho;
      dm.qryUpdateCoef.ParamByName('pi').AsInteger := dm.qryMinI.fieldbyName('m').AsInteger;
      dm.qryUpdateCoef.ExecSQL;
    end;

    if dm.qryMinI.RecNo mod 1000 = 0 then
      if dm.qryMinI.RecNo < dm.qryMinI.RecordCount then
      begin
        memo.lines.add('simplify (I) ' + inttostr(dm.qryMinI.RecNo) + '/' + inttostr(dm.qryMinI.RecordCount) + ' = ' +
          inttostr((dm.qryMinI.RecNo) * 100 div dm.qryMinI.RecordCount) + ' %');
        application.processMessages;
      end;
    dm.qryMinI.Next;
  end;
  dm.qryMinI.Close;
end;

function TPoly.isZero(RAM: boolean): boolean;
var
  s: string;
  i: integer;
begin
  if RAM then
  begin
    if list.Count > 1 then
    begin
      result := false;
      exit;
    end;

    s := list[0];
    i := pos('.', s);
    if i > 0 then
      s := copy(s, 1, i - 1);

    result := (s = '') or (s = '0');
  end
  else
    result := (list.Text = '') or (list[0] = '0');
end;

end.

