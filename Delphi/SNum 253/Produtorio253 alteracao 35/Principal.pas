unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MPlayer, ComCtrls;

type
  TFormPrincipal = class(TForm)
    btnDefault: TButton;
    Timer: TTimer;
    mp: TMediaPlayer;
    procedure btnDefaultClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum253, SNum;

function pow(a, b: double): double;
begin
  Result := exp(b * ln(a));
end;

procedure TFormPrincipal.btnDefaultClick(Sender: TObject);
var f: file of longword;
    p: longword;
    s253, sp, spMuitos, sn: string;
    n: integer;
    tempoAcumulado: double;
begin
  btnDefault.Width := 1;
  btnDefault.Height := 1;

  btnDefault.Enabled := false;
  fileMode := 0;
  assignfile(f, 'J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\primos novos.dat');
  reset(f);
  //lbl.Caption := 'LoadFromFile';
  //application.ProcessMessages;
  SNum.ReadLine('produtorio253A.ini', sn);
  n := StrToInt(sn);
  Seek(f, n - 1);
  read(f, p);
  sp := IntToStr(p);
  ReadLine253('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\n' + sn + 'p' + sp + '.253', s253);
  //lbl.Caption := 'Vou subtrair 1';
  //application.ProcessMessages;
  dec(s253[1]); // decrementa, vira um múltiplo de 10

  tempoAcumulado := 0;
  while (not eof(f)) and ((not fileexists('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\nao_continuar.txt')) or (tempoAcumulado <> 0)) and fileExists('produtorio253A.ini') do
  begin
    spMuitos := #1;
    while length(spMuitos) < 672 do
    begin
      read(f, p);
      sp := IntToStr(p);
      multiplica253(spMuitos, sp);
      inc(n);
      sn := intToStr(n);
      caption := inttostr(length(spMuitos));
      application.processmessages;
    end;
    multiplica253(s253, spMuitos, false);

    application.ProcessMessages;

      inc(s253[1]); // nao tem como terminar em 252. incrementa, vira primo
      SNum.WriteLine('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\n' + sn + 'p' + sp + '.253', s253);
      dec(s253[1]); // decrementa, vira um múltiplo de 10
      //application.processMessages;
      SNum.WriteLine('produtorio253A.ini', sn);
      //application.processMessages;
      mp.Play;
  //end;
  closefile(f);
  btnDefault.Enabled := true;
  caption := 'exit;';
  application.Title := caption;
  mp.Play;
  if fileexists('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\desligar.txt') and fileexists('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\nao_continuar.txt') then
    WinExec('cmd /k shutdown -t 0 -s', sw_minimize)
  else
    WinExec('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\Produtorio253.exe', sw_show);

  sleep(1000);
  close;
  exit;
end;
  //***btnDividir.Click;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
//var s: string;
begin
{
  s := '10203040506070809';
  multiplica(s,'103056',lbl);
  showmessage(s);
}
  mp.Open;
  timer.Enabled := true;
end;

procedure TFormPrincipal.TimerTimer(Sender: TObject);
begin
  timer.Enabled := false;
  if paramcount = 0 then
    btnDefault.Click
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  mp.Close;
end;

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
end;
{
procedure TFormPrincipal.TimerDisplayTimer(Sender: TObject);
begin
  inc(segundos);
  if segundos < 60 then
    lblHora.Caption := inttostr(segundos)
  else
    lblHora.Caption := inttostr(segundos div 60) + ':' + inttostr(segundos mod 60);
  application.processmessages;
end;
}
procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  Application.ProcessMessages;
end;

end.

