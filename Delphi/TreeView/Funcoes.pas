unit Funcoes;

interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, Grids, DBGrids, ExtCtrls, DBCtrls, StdCtrls,
  Buttons, Mask;
type
  TSetChar = set of Char;
function lzero(variavel: string; tamanho: integer): string;
function Branco(variavel: string; tamanho: integer): string;
function brancof(variavel: string; tamanho: integer): string;
function Extenso(Valor: Extended): string;
function primeironome(nome: string): string;
function DriveOk(Drive: Char): boolean;
function VerifyCPF(s: string): Boolean;
function VerifyCgc(cCgc: string): Boolean;
function TodosIguais(s: string): Boolean;
function FilterNumber(cValor: string): string;
function Replicate(Caractere: char; nCaracteres: integer): string;
function ChecaEstado(Dado: string): boolean;
procedure FechaTabelas;
function ProximoDiaUtil(dData: TDateTime): TDateTime;
function GetFieldType(fld: TField): string;
function PasswordInputBox(const ACaption, APrompt: string): string;
function RemoveAcentos(Str: string): string;
function GetBuildInfo: string;
function BeginOfMonth(Dt: TDateTime): TDateTime;
function MyFloatToStr(S: Double): string;

function Arredondar(Valor: Double; Dec: Integer): Double;
function Empty(inString: string): Boolean;
function AddLog(texto, Path: string): Boolean;

function GeraSqlInsert(Value: array of string): string;
var
  b_AbreNovo: Boolean = FALSE;
  vHoras: ttime;
  b_PontoOk, b_Cnpj, b_VerRegistro: boolean;
  StrCodigo, strCnpj: string;
  strUsuario, strCodUsuario: string;
  strFornecedor: string;
  iTodos: boolean = true;
  b_ALTERAR, b_EXCLUIR, b_ATENDER, b_QTDE, b_AGLUTINAR: Boolean;
  StrLanca: boolean;
  tmpCodigo, tmpcnpj: string;
  sUsuario: string;

implementation

uses ZDataSet;

function GeraSqlInsert(Value: array of string): string;
var i: Integer;
const
  f: string = '","';
begin
  Result := '"';
  for i := 0 to length(Value) - 1 do
    Result := Result + Value[i] + f;
  Result := Copy(Result, 1, Length(Result) - 2) + ');';
end;

function MyFloatToStr(S: Double): string;
var
  SaveDecSep: Char;
begin
  SaveDecSep := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := FloatToStr(S);
  finally
    DecimalSeparator := SaveDecSep
  end;
end;

function Arredondar(Valor: Double; Dec: Integer): Double;
var
  Valor1,
    Numero1,
    Numero2,
    Numero3: Double;
begin
  Valor1 := Exp(Ln(10) * (Dec + 1));
  Numero1 := Int(Valor * Valor1);
  Numero2 := (Numero1 / 10);
  Numero3 := Round(Numero2);
  Result := (Numero3 / (Exp(Ln(10) * Dec)));
end;

function BeginOfMonth(Dt: TDateTime): TDateTime;
var
  Y, M, D: Word;
begin
  DecodeDate(Dt, Y, M, D);
  Result := EncodeDate(Y, M, 1);
end;

function PasswordInputBox(const ACaption, APrompt: string): string;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  Value: string;
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  Result := '';
  Form := TForm.Create(Application);
  with Form do
  try
    Canvas.Font := Font;
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(DialogUnits));
    DialogUnits.X := DialogUnits.X div 52;
    BorderStyle := bsDialog;
    Caption := ACaption;
    ClientWidth := MulDiv(180, DialogUnits.X, 4);
    ClientHeight := MulDiv(63, DialogUnits.Y, 8);
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      AutoSize := True;
      Left := MulDiv(8, DialogUnits.X, 4);
      Top := MulDiv(8, DialogUnits.Y, 8);
      Caption := APrompt;
    end;
    Edit := TEdit.Create(Form);
    with Edit do
    begin
      Parent := Form;
      Left := Prompt.Left;
      Top := MulDiv(19, DialogUnits.Y, 8);
      Width := MulDiv(164, DialogUnits.X, 4);
      MaxLength := 255;
      PasswordChar := '*';
      SelectAll;
    end;
    ButtonTop := MulDiv(41, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(50, DialogUnits.X, 4);
    ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'OK';
      ModalResult := mrOk;
      Default := True;
      SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
    end;
    with TButton.Create(Form) do
    begin
      Parent := Form;
      Caption := 'Cancel';
      ModalResult := mrCancel;
      Cancel := True;
      SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
    end;
    if ShowModal = mrOk then
    begin
      Value := Edit.Text;
      Result := Value;
    end;
  finally
    Form.Free;
   // Form := nil;
  end;
end;

function AddLog(texto, Path: string): Boolean;
var
  log: textfile;
begin
  try
    AssignFile(log, Path);
    if not FileExists(Path) then Rewrite(log, Path);
    Append(log);
    WriteLn(log, Texto);
  finally
    CloseFile(log);
  end;
end;

function GetBuildInfo: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
  Prog: string;
begin
  Prog := Application.Exename;
  VerInfoSize := GetFileVersionInfoSize(PChar(prog), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
  result := Copy(IntToStr(100 + v1), 3, 2) +
    Copy(IntToStr(100 + v2), 3, 2) +
    Copy(IntToStr(100 + v3), 3, 2) +
    Copy(IntToStr(100 + v4), 3, 2);
end;

function Empty(inString: string): Boolean;
{Testa se a variavel est· vazia ou n„o}
var
  index: Byte;
begin
  index := 1;
  Empty := True;
  while (index <= Length(inString)) and (index <> 0) do
  begin
    if inString[index] = ' ' then
    begin
      inc(index)
    end
    else
    begin
      Empty := False;
      index := 0
    end;
  end;
end;

function ProximoDiaUtil(dData: TDateTime): TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData + 2
  else
    if DayOfWeek(dData) = 1 then
      dData := dData + 1;
  ProximoDiaUtil := dData;
end;

function ChecaEstado(Dado: string): boolean;
const
  Estados = 'SPMGRJRSSCPRESDFMTMSGOTOBASEALPBPEMARNCEPIPAAMAPFNACRRRO';
var
  Posicao: integer;
begin
  Result := true;
  //if Dado <> '' then
  //  begin
  Posicao := Pos(UpperCase(Dado), Estados);
  if (Posicao = 0) or ((Posicao mod 2) = 0) then
  begin
    Result := false;
  end;
  //end;
end;

function GetFieldType(fld: TField): string;
begin
  case fld.DataType of
    //ftUnkown: Result := 'Unknown';
    ftString: Result := 'String';
    ftSmallint: Result := '16-bit integer';
    ftInteger: Result := '32-bit integer';
    ftWord: Result := '16-bit unsigned integer';
    ftBoolean: Result := 'Boolean';
    ftFloat: Result := 'Float';
    ftCurrency: Result := 'Money';
    ftBCD: Result := 'BCD';
    ftDate: Result := 'Date';
    ftTime: Result := 'Time';
    ftDateTime: Result := 'DateTime';
    ftBytes: Result := 'Fixed bytes (binary)';
    ftVarBytes: Result := 'Variable bytes (binary)';
    ftAutoInc: Result := 'Auto-inc 32-bit integer';
    ftBlob: Result := 'BLOB';
    ftMemo: Result := 'Text memo';
    ftGraphic: Result := 'Bitmap';
    ftFmtMemo: Result := 'Formatted text memo';
    ftParadoxOle: Result := 'Paradox OLE';
    ftDBaseOle: Result := 'dBASE OLE';
    ftTypedBinary: Result := 'Typed binary';
  else
    Result := 'Unknown';
  end;
end;

function Replicate(Caractere: char; nCaracteres: integer): string;
var
  n: integer;
  CadeiaCar: string;
begin
  CadeiaCar := '';
  for n := 1 to nCaracteres do CadeiaCar := CadeiaCar + Caractere;
  Result := CadeiaCar;
end;

function RemoveAcentos(Str: string): string;
{Remove caracteres acentuados de uma string}
const ComAcento = 'ÁËÏÚ˘Ó‰ÎÔˆ‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹«»Ã“ŸŒƒÀœ÷';
  SemAcento = 'ceiouiaeioaaeouaoaeioucuAAEOUAOAEIOUCUCEIOUIAEIO';
var
  x: Integer;
begin
  for x := 1 to Length(Str) do
  begin
    if Pos(Str[x], ComAcento) <> 0 then
    begin
      Str[x] := SemAcento[Pos(Str[x], ComAcento)];
    end;
  end;
  Result := Str;
end;

function FilterNumber(cValor: string): string;
const
  SC_NUM: TSetChar = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var
  i: byte;
  cNew: string;
begin
  cNew := '';
  for i := 1 to length(cValor) do
    if cValor[i] in SC_NUM then
      cNew := cNew + cValor[i];
  FilterNumber := cNew;
end;

function TodosIguais(s: string): Boolean;
var
  i: Byte;
  igual: Boolean;
begin
  igual := True;
  i := 2;
  while igual and (i <= length(s)) do begin
    igual := (s[i] = s[1]);
    i := i + 1;
  end;
  TodosIguais := igual;
end;

function VerifyCgc(cCgc: string): Boolean;
var
  lCgc: Boolean;
  i, j, Soma, Digito: Integer;
  Cgc1, Cgc2, Mult, Controle: string;
begin
  Digito := 0;
  cCgc := FilterNumber(cCgc);
  if length(cCgc) = 14 then begin
    Cgc1 := Copy(cCgc, 1, 12);
    Cgc2 := Copy(cCgc, 13, 2);
    Mult := '543298765432';
    Controle := '';
    for j := 1 to 2 do
    begin
      Soma := 0;
      for i := 1 to 12 do
      begin
        Soma := Soma + StrToInt(Cgc1[i]) * StrToInt(Mult[i]);
      end;
      if j = 2 then
        Soma := Soma + (2 * Digito);

      Digito := (Soma * 10) mod 11;

      if Digito = 10 then
        Digito := 0;
      Controle := Controle + IntToStr(Digito);
      Mult := '654329876543';
    end;
    if (cCgc <> '') and (Controle <> Cgc2) then
      lCgc := False
    else
      lCgc := True;
  end else
    lCGC := False;
  Result := lCgc and (not TodosIguais(cCGC));
end;

function VerifyCPF(s: string): Boolean;
var
  resto: byte;
  soma: Integer;
  i, dv: Byte;
  f: Byte;
  ok: Boolean;
begin
  s := FilterNumber(s);
  ok := (Length(s) = 11) and not TodosIguais(s);
  if ok then begin
    f := 2;
    soma := 0;
    for i := 9 downto 1 do begin
      soma := soma + StrToInt(s[i]) * f;
      f := f + 1;
    end;
    resto := soma mod 11;
    if resto < 2 then
      dv := 0
    else
      dv := 11 - resto;
    ok := (dv = StrToInt(s[10]));
    if ok then begin
      f := 2;
      soma := 0;
      for i := 10 downto 1 do begin
        soma := soma + StrToInt(s[i]) * f;
        f := f + 1;
      end;
      resto := soma mod 11;
      if resto < 2 then
        dv := 0
      else
        dv := 11 - resto;
      ok := (dv = StrToInt(s[11]));
    end;
  end;
  VerifyCPF := ok;
end;

function DriveOk(Drive: Char): boolean;
var
  I: byte;
begin
  Drive := UpCase(Drive);
  if not (Drive in ['A'..'Z']) then
    raise Exception.Create('Unidade incorreta');
  I := Ord(Drive) - 64;
  Result := DiskSize(I) >= 0;
end;

function primeironome(nome: string): string;
var
  Pnome: string;
begin
  pNome := '';
  if pos(' ', Nome) <> 0 then
  begin
    PNome := copy(Nome, 1, pos(' ', Nome) - 1);
  end;
  result := Pnome;
end;

function brancof(variavel: string; tamanho: integer): string;
{ Formata campos com zeros a esquerda }
var
  i: integer;
begin
  tamanho := tamanho - length(variavel);
  for i := 1 to tamanho do variavel := ' ' + variavel;
  result := variavel;
end;

function SubStr(inString: string; numChars, strSize: Byte): string;
begin
  result := Copy(inString, numChars, StrSize);
end;

function lzero(variavel: string; tamanho: integer): string;
{ Formata campos com zeros a esquerda }
var
  i: integer;
begin
  tamanho := tamanho - length(variavel);
  for i := 1 to tamanho do variavel := '0' + variavel;
  result := variavel;
end;

function Branco(variavel: string; tamanho: integer): string;
{ Formata campos com zeros a esquerda }
var
  i: integer;
begin
  tamanho := tamanho - length(variavel);
  for i := 1 to tamanho do variavel := variavel + ' ';
  result := variavel;
end;

procedure ChecaPost(E: EDatabaseError; var Action: TDataAction; Mensagem: pchar);
begin
end;
{ Valor por extenso de moedas
************************************************************************}

function Extenso(Valor: Extended): string;
var
  Centavos, Centena, Milhar, Milhao, Bilhao, Texto: string;
const
  Unidades: array[1..9] of string = ('um', 'dois', 'trÍs', 'quatro',
    'cinco',
    'seis', 'sete', 'oito',
    'nove');
  Dez: array[1..9] of string = ('onze', 'doze', 'treze',
    'quatorze', 'quinze',
    'dezesseis', 'dezessete',
    'dezoito', 'dezenove');
  Dezenas: array[1..9] of string = ('dez', 'vinte', 'trinta',
    'quarenta', 'cinquenta',
    'sessenta', 'setenta',
    'oitenta', 'noventa');
  Centenas: array[1..9] of string = ('cento', 'duzentos',
    'trezentos', 'quatrocentos',
    'quinhentos', 'seiscentos',
    'setecentos',
    'oitocentos', 'novecentos');

  function ifs(Expressao: Boolean; CasoVerdadeiro, CasoFalso: string): string;
  begin
    if Expressao then Result := CasoVerdadeiro else Result := CasoFalso;
  end;

  function MiniExtenso(Valor: string): string;
  var
    Unidade, Dezena, Centena: string;
  begin

    Unidade := '';
    Dezena := '';
    Centena := '';

    if (Valor[2] = '1') and (Valor[3] <> '0') then begin
      Unidade := Dez[StrToInt(Valor[3])];
      Dezena := '';
    end else begin
      if Valor[2] <> '0' then
        Dezena := Dezenas[StrToInt(Valor[2])];
      if Valor[3] <> '0' then
        Unidade := Unidades[StrToInt(Valor[3])];
    end;

    if (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
      Centena := 'cem'
    else
      if Valor[1] <> '0' then Centena :=
        Centenas[StrToInt(Valor[1])]
      else Centena := '';

    Result := Centena +
      ifs((Centena <> '') and ((Dezena <> '') or (Unidade <> '')), ' e ', '') + Dezena +
      ifs((Dezena <> '') and (Unidade <> ''), ' e ', '') + Unidade;
  end;

begin

  if Valor = 0 then begin
    Result := '';
    Exit;
  end;

  Texto := FormatFloat('000000000000.00', Valor);
  Centavos := MiniExtenso('0' + Copy(Texto, 14, 2));
  Centena := MiniExtenso(Copy(Texto, 10, 3));
  Milhar := MiniExtenso(Copy(Texto, 7, 3));

  if Milhar <> '' then
    Milhar := Milhar + ' mil';
  Milhao := MiniExtenso(Copy(Texto, 4, 3));

  if Milhao <> '' then
    Milhao := Milhao + ifs(Copy(Texto, 4, 3) = '001', ' milh„o',
      ' milhıes');
  Bilhao := MiniExtenso(Copy(Texto, 1, 3));

  if Bilhao <> '' then
    Bilhao := Bilhao + ifs(Copy(Texto, 1, 3) = '001', ' bilh„o',
      ' bilhıes');

  if (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
    Result := Bilhao + ' de reais'
  else if (Milhao <> '') and (Milhar + Centena = '') then
    Result := Milhao + ' de reais'
  else
    Result := Bilhao +
      ifs((Bilhao <> '') and (Milhao + Milhar + Centena <> ''),
      ifs((Pos(' e ', Bilhao) > 0) or (Pos(' e ', Milhao + Milhar + Centena) > 0), ', ', ' e '), '') + Milhao +
      ifs((Milhao <> '') and (Milhar + Centena <> ''),
      ifs((Pos(' e ', Milhao) > 0) or (Pos(' e ', Milhar + Centena) > 0), ', ', ' e '), '') + Milhar +
      ifs((Milhar <> '') and (Centena <> ''),
      ifs(Pos(' e ', Centena) > 0, ', ', ' e '), '') + Centena + ifs(Int(Valor) = 1, ' real',
      ifs(Int(Valor) > 1, ' reais', ''));
  if Centavos <> '' then
    Result := Result + ifs(Centena <> '', ' e ', '') + Centavos +
      ifs(Copy(Texto, 14, 2) = '01', ' centavo', ' centavos');
end;

procedure FechaTabelas;
var i: integer;
begin
  with Session do
    for i := 0 to DatabaseCount - 1 do
      Databases[I].Close;
end;
end.
