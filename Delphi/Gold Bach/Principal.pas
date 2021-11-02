unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TGoldBach = record
    par, p1, p2: longword;
  end;
  TSeveralGoldBach = array[0..15] of TGoldBach;

  TFormPrincipal = class(TForm)
    btnArquivo: TButton;
    lblNext: TLabel;
    btnCancelar: TButton;
    Memo: TMemo;
    btnListar: TButton;
    btnUmNro: TButton;
    btnTeste: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnArquivoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnUmNroClick(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
  private
    function UltimoF: TGoldBach;
    procedure Gravar(gold: TGoldBach);
    function ProximoF: TGoldBach;
    procedure Zerar;
    { Private declarations }
  public
    f: file of TSeveralGoldBach;
    g: file of LongWord;
    v, vGrava: TSeveralGoldBach;
    posSeveral, posGrava: byte;
    cancelar: boolean;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

function TFormPrincipal.UltimoF: TGoldBach;
begin
  seek(f, filesize(f) - 1);
  read(f, v);
  posSeveral := 15;
  while v[posSeveral].par = 0 do
    dec(posSeveral);
  result := v[posSeveral];
  inc(posSeveral);
end;

function TFormPrincipal.ProximoF: TGoldBach;
begin
  if posSeveral = 16 then
  begin
    read(f, v);
    posSeveral := 0;
  end;

  result := v[posSeveral];
  inc(posSeveral);
end;

procedure TFormPrincipal.Zerar;
var i: byte;
begin
  for i := 0 to 15 do
  begin
    vGrava[i].par := 0;
    vGrava[i].p1 := 0;
    vGrava[i].p2 := 0;
  end;
  posGrava := 0;
end;

procedure TFormPrincipal.Gravar(gold: TGoldBach);
begin
  vGrava[posGrava] := gold;
  inc(posGrava);
  if posGrava = 16 then
  begin
    write(f, vGrava);
    Zerar;
    showmessage(inttostr(filesize(f)));
  end;
end;

function asString(gold: TGoldBach): string;
begin
  result := inttostr(gold.par) + ' = ' + inttostr(gold.p1) + ' + ' + inttostr(gold.p2);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var
  gold: TGoldBach;
  t: TextFile;
  s: string;
  i: longword;
begin
  Zerar;

  filemode := 2;
  assignFile(f, 'GoldBach.dat');
  reset(f);
  gold := UltimoF;
  lblNext.Caption := AsString(gold);

  assignFile(g, 'primos novos.dat');
  fileMode := 0;
  reset(g);
{
  if fileexists('list1.txt') then
  begin
    assignfile(t, 'list1.txt');
    reset(t);
    for i := 1 to 1000000 do
    begin
      readln(t, s);
      memo.lines.add(s);
    end;
  end;
}
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  closefile(f);
  closefile(g);
end;

procedure TFormPrincipal.btnArquivoClick(Sender: TObject);
var
  gold: TGoldBach;
  posicao, min, max, i, p: longWord;
begin
  cancelar := false;
  btnCancelar.Enabled := true;
  btnArquivo.Enabled := false;

  gold := UltimoF;

  repeat
    closefile(f);
    filemode := 2;
    reset(f);
    inc(gold.par, 2);
    posicao := 0;
    repeat
      seek(g, posicao);
      read(g, gold.p1);
      if gold.p1 > gold.par div 2 then
        break;

      gold.p2 := gold.par - gold.p1;
      min := posicao;
      max := filesize(g);
      while min <= max do
      begin
        i := (min + max) div 2;
        seek(g, i);
        read(g, p);
        if p = gold.p2 then
          break;

        if p < gold.p2 then
          min := i + 1
        else
          max := i - 1;
      end;

      if p = gold.p2 then
      begin
        //seek(f, filesize(f));
        Gravar(gold);
        //showmessage(inttostr(filesize(f)));
      end;

      inc(posicao);
    until false;

    Application.ProcessMessages;
  until cancelar;

  if posGrava > 0 then
    write(f, vGrava);

  showmessage(inttostr(filesize(f)));
  gold := UltimoF;
  lblNext.Caption := AsString(gold);
  btnArquivo.Enabled := true;
end;

procedure TFormPrincipal.btnCancelarClick(Sender: TObject);
begin
  cancelar := true;
  btnCancelar.Enabled := false;
end;

procedure TFormPrincipal.btnListarClick(Sender: TObject);
var gold: TGoldBach;
    anterior, contador: longword;
    t1, t2: TextFile;
begin
  if btnCancelar.Enabled then
    exit;

  if Application.MessageBox('Are you sure?', 'Confirm', mb_yesno) <> mrYes then
    exit;

  btnListar.Enabled := false;
  memo.clear;
  assignfile(t1, 'list1.txt');
  rewrite(t1);
  assignfile(t2, 'list2.txt');
  rewrite(t2);

  seek(f, 0);
  anterior := 0;
  contador := 1;

  while not eof(f) do
  begin
    gold := ProximoF;

    if gold.par = anterior then
      inc(contador)
    else
    begin
      writeln(t1, 'Counter = ' + inttostr(contador));
      writeln(t2, 'f(' + inttostr(anterior) + ') = ' + inttostr(contador));
      contador := 1;
    end;

    writeln(t1, asString(gold));
    anterior := gold.par;
  end;

  closefile(t1);
  closefile(t2);
  memo.lines.LoadFromFile('list1.txt');

  btnListar.Enabled := true;
end;

procedure TFormPrincipal.btnUmNroClick(Sender: TObject);
var
  gold: TGoldBach;
  posicao, min, max, i, counter, p: longword;
  s: string;
begin
  if memo.lines.count = 0 then
    exit;

  gold.par := strtoint64(memo.lines[0]);
  if odd(gold.par) then
  begin
    if Application.MessageBox('Are you sure?', 'Confirm', mb_yesno) <> mrYes then
      exit;

    btnCancelar.Enabled := true;
    btnUmNro.Enabled := false;

    p := gold.par;
    seek(f, 0);
    repeat
      gold := ProximoF;
      if (gold.p1 = p) or (gold.p2 = p) then
      begin
        memo.Lines.Add(asstring(gold));
        application.ProcessMessages;
      end
      else if pos(inttostr(gold.par), memo.Lines[memo.lines.Count - 1]) = 0 then
        memo.lines.add(inttostr(gold.par));
    until cancelar or eof(f);

    btnCancelar.Enabled := false;
    btnUmNro.Enabled := true;
    exit;
  end;

  s := '';
  posicao := 0;
  counter := 0;
  btnUmNro.Enabled := false;
  repeat
    seek(g, posicao);
    read(g, gold.p1);
    if gold.p1 > gold.par div 2 then
      break;

    gold.p2 := gold.par - gold.p1;
    min := posicao;
    max := filesize(g);
    while min <= max do
    begin
      i := (min + max) div 2;
      seek(g, i);
      read(g, p);
      if p = gold.p2 then
        break;

      if p < gold.p2 then
        min := i + 1
      else
        max := i - 1;
    end;

    if p = gold.p2 then
    begin
      s := s + asstring(gold) + #13#10;
      inc(counter);
      memo.lines.add(asString(gold));
      Application.ProcessMessages;
    end;

    inc(posicao);
  until false;

  memo.lines.text := inttostr(gold.par) + ' Counter = ' + inttostr(counter) + #13#10#13#10 + s;
  btnUmNro.Enabled := true;
end;

procedure TFormPrincipal.btnTesteClick(Sender: TObject);
var
  gold: TGoldBach;
  t: TextFile;
  ultimo: longword;
begin
  assignFile(t, 'test.txt');
  rewrite(t);

  seek(f, 0);
  ultimo := 4;
  repeat
    gold := UltimoF;
    if gold.par = ultimo then
      write(t, ',', gold.p1)
    else
    begin
      writeln(t);
      write(t, gold.par, ':', gold.p1);
      ultimo := gold.par;
    end;
  until gold.par = 1002;

  closefile(t);
end;

procedure TFormPrincipal.MemoDblClick(Sender: TObject);
//var x: file of integer;
//    i: integer;
begin
{
  closefile(f);
  filemode := 2;
  assignfile(x, 'GoldBach.dat');
  reset(x);
  seek(x, filesize(x));
  i := 0;
  write(x, i);
  closefile(x);
  close;
}

{
  repeat
    seek(f, filesize(f) - 1);
    truncate(f);
    showmessage(inttostr(filesize(f)));
    FormShow(sender);
  until lblNext.caption <> '294420 = 147209 + 147211';
}
{
  Zerar;
  vGrava[0].par := 294420;
  vGrava[0].p1 := 147029;
  vGrava[0].p2 := 147391;
  vGrava[1].par := 294420;
  vGrava[1].p1 := 147073;
  vGrava[1].p2 := 147347;
  vGrava[2].par := 294420;
  vGrava[2].p1 := 147089;
  vGrava[2].p2 := 147331;
  vGrava[3].par := 294420;
  vGrava[3].p1 := 147137;
  vGrava[3].p2 := 147283;
  vGrava[4].par := 294420;
  vGrava[4].p1 := 147209;
  vGrava[4].p2 := 147211;
  write(f, vGrava);
  close;
}
end;

end.
