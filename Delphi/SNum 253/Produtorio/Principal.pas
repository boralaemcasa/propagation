unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MPlayer, ComCtrls;

type
  TFormPrincipal = class(TForm)
    btnCancelar: TButton;
    btnHTML: TButton;
    mp: TMediaPlayer;
    btnDividir: TButton;
    Edit: TEdit;
    btnASCII: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHTMLClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDividirClick(Sender: TObject);
    procedure btnASCIIClick(Sender: TObject);
  private
    { Private declarations }
  public
    flagContinuar: boolean;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum, SNum253;

function ByteToHTML(a: byte): string;
begin
  if a = 92 then
  begin
    Result := '\\';
    exit;
  end;

  if a = 253 then
  begin
    Result := 'The digits after this indicator repeat successively and infinitely many times';
    exit;
  end;

  if a = 254 then
  begin
    Result := 'Floating point "." indicator';
    exit;
  end;

  if a = 255 then
  begin
    Result := 'Negative number "-" indicator';
    exit;
  end;

  if (a in [33..126, 128, 130..140, 142, 145..156,158,159,161..172,174..252]) then
  begin // infelizmente 253..255 cairiam aqui.
    Result := chr(a);
    exit;
  end;

  Result := chr(a mod 16);
  a := a div 16;

  if Result < #10 then
    Result := char(byte(Result[1]) + 48)
  else
    Result := char(byte(Result[1]) + 55);

  //if a > 0 then
    if a < 10 then
      Result := char(a + 48) + Result
    else
      Result := char(a + 55) + Result;

  Result := '\' + Result;
end;

procedure TFormPrincipal.btnCancelarClick(Sender: TObject);
begin
  flagContinuar := false;
  btnCancelar.enabled := false;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  mp.Open;
end;

procedure TFormPrincipal.btnHTMLClick(Sender: TObject);
var f: TextFile;
    i, size, j, thousands: integer;
    g: file of longint;
    h: file of char;
    p: longint;
    flagOdd: boolean;
    dir: string;
    sList: TStringList;
    y, c10: double;
    s: string;
begin
  //showmessage('alterar diretório nos fontes e limitar tamanho do html em 100 mega');

  flagContinuar := true;
  sList := TStringList.Create;

  btnHTML.Enabled := false;
  sList.LoadFromFile('cabecalho.htm');
  sList.SaveToFile('primos de Euclides.htm');
  assignFile(f, 'primos de Euclides.htm');
  append(f);
  assignfile(g, 'primos novos.dat');
  reset(g);
  p := 2;
  flagOdd := true;
  y := 0;
  c10 := 1/ln(10);
  thousands := 1000000;
  //seek(g, 20700 - 1);
  //read(g, p);
  for i := 0 to maxLongInt do
  begin
    if i <= MAXLONGINT then
      dir := 'J:\PRIMORIAIS1'
    else
      dir := 'H:\_não deletar\2016 08 24\Produtorio\bolao';

    caption := inttostr(i);
    application.Title := caption;
    application.ProcessMessages;

    y := y + ln(p) * c10;

    fileMode := 0;
    assignfile(h, dir + '\n' + caption + 'p' + inttostr(p) + '.253');
    try
      reset(h);
    except
      continue;
    end;
    size := filesize(h);
    closefile(h);

    if trunc(y) + 1 >= 2000000 then
      //if i mod 256 = 0 then
      begin
        //if odd(i) then
        if flagOdd then
          write(f, '<tr>')
        else
          write(f, '<tr class="alt">');
        flagOdd := not flagOdd;

        write(f, '<td>');
        write(f, i);
        write(f, '</td><td>');
        write(f, p);
        write(f, '</td><td>');
        write(f, size);
        write(f, '</td><td>');
        write(f, IntToStr(trunc(y) + 1));
        write(f, '</td><td>');

        write(f, '<a href="n' + caption + 'p' + inttostr(p) + '.253">file</a>');
        //ReadLine253(dir + '\n' + caption + 'p' + inttostr(p) + '.253', s);
        //for j := 1 to length(s) do
        //  write(f, ByteToHTML(byte(s[j])));

        //write(f, '</td><td>');
        //write(f, 'copy j:\primoriais1\n' + caption + 'p' + inttostr(p) + '.253');

        writeln(f, '</td></tr>');
      end;

    read(g, p);

    if not flagContinuar then
      break;
  end;
  writeln(f, '</table>');
  writeln(f, '<br/><br/>+55 19 999 17 36 50<br/>+55 31 985 267 474<a href="');
  closeFile(f);
  closeFile(g);
  mp.Play;
  sleep(1000);
  btnHTML.Enabled := true;

  sList.Free;
  close;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  mp.Close;
end;

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_f10 then
    btnCancelarClick(Sender);
end;

procedure TFormPrincipal.btnDividirClick(Sender: TObject);
var i: integer;
    g: file of longword;
    p: longword;
    dir, s: string;
    s2, q, r: string;
begin
  flagContinuar := true;
  btnDividir.Enabled := false;
  s := edit.text;
  assignfile(g, 'H:\_não deletar\2016 08 24\Produtorio\primos novos.dat');
  reset(g);
  i := StrToInt(s);
  seek(g, i - 1);
  read(g, p);

  caption := s;
  application.Title := s;
  application.ProcessMessages;

  if i <= MAXLONGINT then
    dir := 'J:\PRIMORIAIS1'
  else
    dir := 'H:\_não deletar\2016 08 24\Produtorio\bolao';

  ReadLine253(dir + '\n' + s + 'p' + inttostr(p) + '.253', s);
  dec(s[1]);
  read(g, p);
  ReadLine253(dir + '\n' + inttostr(i + 1) + 'p' + inttostr(p) + '.253', s2);
  dec(s2[1]);
  Divide253(s2, s, q, r);
  From253to10(q);
  From253to10(r);
  showmessage(q + #13#10 + r);

  closeFile(g);
  mp.Play;
  btnDividir.Enabled := true;
end;

procedure TFormPrincipal.btnASCIIClick(Sender: TObject);
var f: TextFile;
    b: byte;
begin
  assignfile(f, 'H:\_não deletar\2016 08 24\ascii.htm');
  rewrite(f);
  writeln(f, '<title>ASCII</title>');
  writeln(f, '<table border="1">');
  for b := 0 to 255 do
  begin
    write(f, '<tr><td>', inttostr(b), '</td><td>');
    write(f, byteToHTML(b));
    writeln(f, '</td></tr>');
  end;

  writeln(f, '</table>');
  closefile(f);
  close;
end;

end.
