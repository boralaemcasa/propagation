unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, IdTelnet, OleCtrls, SHDocVw, ExtCtrls;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo2: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    efetivo: integer;
    ultimo: string;
    fileDownload: TFileStream;
  public
    procedure processar(endereco: string);
    procedure processarOCaminho(endereco, nomearq: string);
    procedure teste(nome_arquivo, endereco_completo: string);
    procedure escrever(var f: textFile; s: string);
    procedure procedimentoPadrao(ch, chnovo: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.processar(endereco: string);
var
  lResponse: TStringStream;
  s, arquivo: string;
  f: textFile;
  i: integer;
begin
  delete(endereco, 1, 1); // espaço
  arquivo := copy(endereco, 1, pos('.p', endereco) + 1);
  delete(endereco, 1, pos('.p', endereco) + 2);
  lResponse := TStringStream.Create('');
  idHttp1.Get(endereco, lResponse);
  s := lresponse.DataString;
  delete(s, 1, pos('Refer', s));
  delete(s, 1, pos('Refer', s));
  delete(s, 1, pos('<div', s) + 23);
  s := copy(s, 1, pos('</div>', s) - 1);
  while pos(#9, s) > 0 do
    s := stringReplace(s, #9, '', [rfreplaceall]);
  s := stringreplace(s, '<span class="versiculos">', '[', [rfreplaceall]);
  s := stringreplace(s, '</span>', ']', [rfreplaceall]);
  s := stringreplace(s, '<li>', '', [rfreplaceall]);
  s := stringreplace(s, '</li>', #13#10, [rfreplaceall]);
  s := stringreplace(s, '<ul class="lista-obras">', #13#10, [rfreplaceall]);
  s := stringreplace(s, '<h4>', '', [rfreplaceall]);
  s := stringreplace(s, '</h4>', '', [rfreplaceall]);
  s := stringreplace(s, '</ul>', '', [rfreplaceall]);
  s := stringreplace(s, '<hr>', '', [rfreplaceall]);
  memo1.text := copy(s, 1, length(s) - 5);
  lResponse.Free;
  assignFile(f, 'D:\tenho offline\Delphi\Engolir\saida.txt');
  append(f);
  arquivo := stringreplace(arquivo, ' ', ', "', [rfreplaceall]);
  write(f, 'engolirNepe(' + arquivo + '", ');
  for i := 0 to memo1.lines.Count - 1 do
  begin
    if i <> 0 then
      write(f, '+ "\n" + ');
    write(f, '"' + stringreplace(stringreplace(memo1.lines[i], #13, '', [rfReplaceAll]), #10, '', [rfreplaceall]) + '"');
    if i <> memo1.lines.Count - 1 then
      writeln(f);
  end;
  writeln(f, ');');
  closefile(f);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  f: TextFile;
  s: string;
  contador: integer;
  conseguiu: boolean;
begin
{
  assignFile(f, 'D:\tenho offline\Delphi\Engolir\saida.txt');
  rewrite(f);
  closefile(f);
}
  contador := 0;
  efetivo := 0;

  AssignFile(f, 'd:\teste.txt');
  reset(f);
  repeat
    readln(f, s);
    inc(contador);
  until pos('213127', s) > 0;

  while not eof(f) do
  begin
    readln(f, s);
    repeat
      conseguiu := false;
      try
        processar(s);
        conseguiu := true;
      except
      end;
    until conseguiu;
    inc(contador);
    caption := inttostr(contador) + ' (' + inttostr(efetivo) + ')';
    application.processmessages;
  end;
  closefile(f);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  lResponse: TStringStream;
  s: string;
  f: textFile;
  i: integer;
begin
  lResponse := TStringStream.Create('');
  idHttp1.Get('http://ocaminho.com.br/', lResponse);
  s := lresponse.DataString;
  memo1.text := s;
  lResponse.Free;
  assignFile(f, 'D:\ocaminho\index.html');
  rewrite(f);
  for i := 0 to memo1.lines.Count - 1 do
    writeln(f, memo1.lines[i]);
  closefile(f);
  assignfile(f, 'd:\ocaminho\lista de arquivos do caminho.txt');
  rewrite(f);
  while pos('<a href', s) > 0 do
  begin
    delete(s, 1, pos('<a href', s) + 8);
    writeln(f, copy(s, 1, pos('"', s) - 1));
  end;
  closefile(f);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  f: TextFile;
  s: string;
  contador: integer;
  conseguiu: boolean;
begin
  assignfile(f, 'd:\ocaminho\lista de arquivos do caminho 2.txt');
  rewrite(f);
  closefile(f);

  contador := 0;
  AssignFile(f, 'd:\ocaminho\lista de arquivos do caminho.txt');
  reset(f);
  while not eof(f) do
  begin
    readln(f, s);
    repeat
      conseguiu := false;
      try
        processarOCaminho(s, '2');
        conseguiu := true;
      except
        FreeAndNil(fileDownload);
      end;
    until conseguiu;
    inc(contador);
    caption := inttostr(contador) + ' (' + inttostr(efetivo) + ')';
    application.processmessages;
  end;
  closefile(f);
end;

procedure TForm1.teste;
begin
  fileDownload := TFileStream.Create(nome_arquivo, fmCreate);
  IdHTTP1.Get(endereco_completo, fileDownload);
  FreeAndNil(fileDownload);
end;

procedure TForm1.escrever(var f: textFile; s: string);
var address, arquivo, original, endereco: string;
begin
  endereco := s;
  if trim(endereco) = '' then
    exit;
  if pos('\http', endereco) > 0 then
    exit;
  if pos('\mailto', endereco) > 0 then
    exit;
  if pos('\#', endereco) > 0 then
    exit;
  if pos('#', endereco) > 0 then
    endereco := copy(endereco, 1, pos('#', endereco) - 1);

  endereco := stringreplace(endereco, '\', '/', [rfreplaceall]);
  s := endereco;
  address := 'http://ocaminho.com.br/' + endereco;

  endereco := stringreplace(endereco, '/', '\', [rfreplaceall]);
  arquivo := ExtractFileName(endereco);
  endereco := ExtractFilePath(endereco);
  original := endereco;
  endereco := 'd:\ocaminho\' + endereco;
  forceDirectories(endereco);
  if not fileexists(endereco + arquivo) then
    if pos(s, memo2.text) = 0 then
    begin
      writeln(f, s);
      memo2.lines.add(s);
    end;
end;

procedure TForm1.processarOCaminho(endereco, nomearq: string);
var
  s, arquivo, original, address, ultimo: string;
  f: textFile;
begin
  if ultimo = endereco then
    exit;
  if trim(endereco) = '' then
    exit;
  if pos('\http', endereco) > 0 then
    exit;
  if pos('\mailto', endereco) > 0 then
    exit;
  if pos('\#', endereco) > 0 then
    exit;
  if pos('#', endereco) > 0 then
    endereco := copy(endereco, 1, pos('#', endereco) - 1);

  endereco := stringreplace(endereco, '\', '/', [rfreplaceall]);
  if endereco = 'index.html' then
    address := 'http://ocaminho.com.br/' 
  else
    address := 'http://ocaminho.com.br/' + endereco;

  endereco := stringreplace(endereco, '/', '\', [rfreplaceall]);
  arquivo := ExtractFileName(endereco);
  if trim(arquivo) = '' then
    exit;
  endereco := ExtractFilePath(endereco);
  original := endereco;
  endereco := 'd:\ocaminho\' + endereco;
  forceDirectories(endereco);
  if fileexists(endereco + arquivo) then
    DeleteFile(endereco + arquivo);

  //if not fileexists(endereco + arquivo) then
  begin
    teste(endereco + arquivo, address);

    if nomearq <> '' then
    begin
      memo1.Lines.LoadFromFile(endereco + arquivo);
      s := memo1.text;
      assignfile(f, 'd:\ocaminho\lista de arquivos do caminho ' + nomearq + '.txt');
      append(f);
      while pos('<a href', s) > 0 do
      begin
        delete(s, 1, pos('<a href', s) + 8);
        escrever(f, original + copy(s, 1, pos('"', s) - 1));
      end;
      closefile(f);
    end;

    inc(efetivo);
  end;
end;

procedure TForm1.procedimentoPadrao(ch, chnovo: string);
var
  f: TextFile;
  s: string;
  contador: integer;
  conseguiu: boolean;
begin
  assignfile(f, 'd:\ocaminho\lista de arquivos do caminho ' + chnovo + '.txt');
  rewrite(f);
  closefile(f);
  memo2.clear;
  ultimo := '';

  contador := 0;

  AssignFile(f, 'd:\ocaminho\lista de arquivos do caminho ' + ch + '.txt');
  reset(f);
  while not eof(f) do
  begin
    readln(f, s);
    repeat
      conseguiu := false;
      try
        processarOCaminho(s, chnovo);
        conseguiu := true;
      except
        FreeAndNil(fileDownload);
      end;
    until conseguiu;
    inc(contador);
    caption := inttostr(contador) + ' (' + inttostr(efetivo) + ')';
    application.processmessages;
  end;
  closefile(f);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  procedimentoPadrao(edit1.text, edit2.text);
end;

procedure TForm1.Button5Click(Sender: TObject);

  procedure conseguir(s: string);
  var conseguiu: boolean;
  begin
    repeat
      conseguiu := false;
      try
        processarOCaminho(s, '1');
        conseguiu := true;
      except
        FreeAndNil(fileDownload);
      end;
    until conseguiu;
  end;

begin
  //conseguir('ocaminho/TDivino/VT/VTL/Et/Et09.htm');
  //conseguir('ocaminho/TKardequiano/TKP/TKIndexLivros.htm');
  //conseguir('ocaminho/TXavieriano/Livros/Acl/Acl08.htm');
  //conseguir('ocaminho/TXavieriano/Livros/Pec/Pec45.htm');
  //conseguir('ocaminho/PaginaInicial.html');
  //conseguir('index.html');

  //conseguir('ocaminho\TDivino\VT\VTL\Is\Is48.htm');
  //conseguir('ocaminho\TKardequiano\TKF\Re69\Jan\Re69JanA04.htm');
  //conseguir('ocaminho\TXavieriano\Livros\Cvv\Cvv17.htm');
  //conseguir('ocaminho\TXavieriano\Livros\Cxe\Cxe06.htm');
  //conseguir('ocaminho\TXavieriano\TXIndexAutC2.htm');

  conseguir('ocaminho/TDivino/VT/VTL/Is/Is47.htm');
  conseguir('ocaminho/TDivino/VT/VTP/Ez/Ez23.htm');
  conseguir('ocaminho/TKardequiano/TKP/Re61/Set/Re61SetA01.htm');
  conseguir('ocaminho/TXavieriano/Livros/Ds/Ds23.htm');
  conseguir('ocaminho/TXavieriano/Livros/Lib/Lib18.htm');
  conseguir('ocaminho/TXavieriano/Livros/Lib/Lib12.htm');
  conseguir('ocaminho/TXavieriano/Livros/Pec/Pec42.htm');
  conseguir('ocaminho\TXavieriano\Livros\Acl\Acl09.htm');
  conseguir('ocaminho\TXavieriano\Livros\Ani\AniP3C03.htm');
end;

end.

