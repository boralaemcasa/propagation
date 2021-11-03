unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MPlayer, ComCtrls;

type
  TFormPrincipal = class(TForm)
    btnDefault: TButton;
    btnCancelar: TButton;
    lbl: TLabel;
    lblHora: TLabel;
    Timer: TTimer;
    mp: TMediaPlayer;
    lblAcumulado: TLabel;
    cbDesligar: TCheckBox;
    procedure btnDefaultClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbDesligarClick(Sender: TObject);
  private
    { Private declarations }
  public
    flagContinuar: boolean;
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
    s253, sp, sn, spMuitos: string;
    n, L1, L2, size: integer;
    hora: TDateTime;
    w, min, sec, msec: word;
    c1, c2, tempoAcumulado: double;
begin // paramcount = 0
  //exit;
  btnDefault.Enabled := false;
  btndefault.Width := 1;
  btndefault.Height := 1;
  flagContinuar := true;
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

  c1 := 1/ln(10);
  c2 := ln(253) * c1;

  tempoAcumulado := 0;
  while (not eof(f)) and (flagContinuar or (tempoAcumulado <> 0)) do
  begin
    spMuitos := #1;
    repeat
      read(f, p);
      sp := IntToStr(p);
      multiplica253(spMuitos, sp);
      inc(n);
      sn := intToStr(n);
    until length(spMuitos) > 759;

    hora := Now;
    size := length(s253);
    L1 := trunc((size - 1) * c2) + 1;
    //L2 := trunc(ln(pow(253,size) - 1) * c1) + 1;
    L2 := trunc(size * c2) + 1;
    lbl.Caption := inteiroToStr(n) + ' ; p = ' + inteiroToStr(p) + ' ; len entre ' + inteiroToStr(L1) + ' e ' + inteiroToStr(L2);
    //lbl.Caption := 'Vou multiplicar';
    //application.processMessages;
    multiplica253(s253, spMuitos);
    //lbl.Caption := 'Vou salvar';
    //application.processMessages;  

    hora := Now - hora;
    decodeTime(hora, w, min, sec, msec);
    lblHora.Caption := 'time = ' + {IntToStr(min) + ' min ' +} IntToStr(sec) + ',' + IntToStr(msec) + ' s';

    tempoAcumulado := tempoAcumulado + hora;
    decodeTime(tempoAcumulado, w, min, sec, msec);
    application.Title := IntToStr(min) + ' min ' + IntToStr(sec) + ',' + IntToStr(msec) + ' s';
    lblAcumulado.Caption := 'acúmulo = ' + application.title;
    application.ProcessMessages;

    if tempoAcumulado >= 14.5 {dia} / 24.0 / 60.0 then
    begin
      inc(s253[1]); // nao tem como terminar em 252. incrementa, vira primo
      SNum.WriteLine('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\n' + sn + 'p' + sp + '.253', s253);
      dec(s253[1]); // decrementa, vira um múltiplo de 10
      //application.processMessages;
      SNum.WriteLine('produtorio253A.ini', sn);
      //application.processMessages;
      tempoAcumulado := 0;
    end;

{
	if n mod 16 = 0 then
    begin
      caption := sn + ' ; p = ' + sp + ' ; len = ' + inttostr(length(s));
      application.Title := caption;
    end;
}
  end;
  closefile(f);
  btnDefault.Enabled := true;
  caption := 'exit;';
  application.Title := caption;
  mp.Play;
  if cbDesligar.Checked and (not flagContinuar) then
    WinExec('cmd /k shutdown -t 0 -s', sw_minimize);

  sleep(1000);
  close;
  //***btnDividir.Click;
end;

procedure TFormPrincipal.btnCancelarClick(Sender: TObject);
begin
  flagContinuar := false;
  btnCancelar.enabled := false;
  btncancelar.width := 1;
  btncancelar.Height := 1;
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
  if Key = vk_f10 then
    btnCancelarClick(Sender);
end;

procedure TFormPrincipal.cbDesligarClick(Sender: TObject);
begin
  if cbDesligar.checked then
    cbDesligar.Color := clRed
  else
    cbDesligar.Color := screen.ActiveForm.Color;
end;

end.


