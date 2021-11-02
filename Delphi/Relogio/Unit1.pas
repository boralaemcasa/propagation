unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mmSystem, ExtCtrls, StdCtrls;

  {Dont forget about putting mmSystem in
   the uses when you make your own prog}

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    procedure salvar;
    procedure finalizarGravacao;
    procedure iniciarGravacao;
  public
    contador: integer;
    handle: THandle;
    arquivo: string;
  end;

var
  Form1: TForm1;

implementation

uses DateUtils, ShellApi;

{$R *.dfm}

procedure Tform1.iniciarGravacao;
var dia, mes, ano, hora, minuto: string;
begin
  ano := inttostr(YearOf(now));
  mes := inttostr(MonthOf(now));
  dia := inttostr(DayOf(now));
  hora := inttostr(HourOf(now));
  minuto := inttostr(MinuteOf(now));
  if length(mes) < 2 then
    mes := '0' + mes;
  if length(dia) < 2 then
    dia := '0' + dia;
  if length(hora) < 2 then
    hora := '0' + hora;
  if length(minuto) < 2 then
    minuto := '0' + minuto;

  arquivo := 'e:\in\' + ano + mes + dia + ' ' + hora + minuto + '.wav';
  application.title := hora + ':' + minuto;
  caption := application.title;

  contador := 0;


  Timer1.Enabled := true; //Turns timer1 on so you know
                                             //how long you'v been recording



  mciSendString('OPEN NEW TYPE WAVEAUDIO ALIAS MicSound', nil, 0, Handle);

    // MicSound is what the WaveAudio is asigned to.
    // It is used in all the mciSendString so if you
    // rename it to a diffrent name then you need to
    // make sure you change it on all of them.
    // If you dont know what I just said..
    // hell I dont think I know what i just said
    // then leave it the way it is, it will work ether way.

    // The Following is pritty much self explanatory but I put
    // the Notes out for those who dont follow.

  mciSendString('SET MicSound TIME FORMAT MS ' + // set the time format

    'BITSPERSAMPLE 8 ' + // 8 Bit
    'CHANNELS 1 ' + // MONO
    'SAMPLESPERSEC 8000 ' + // 8 KHz
    'BYTESPERSEC 8000', // 8000 Bytes/s
    nil, 0, Handle);

  mciSendString('RECORD MicSound', nil, 0, Handle);
end;

procedure tform1.finalizarGravacao;
begin
  Timer1.Enabled := false; //Stops the timer

  mciSendString('STOP MicSound', nil, 0, Handle);
end;

procedure tform1.salvar;
begin
  mciSendString(PChar('SAVE MicSound "' + arquivo + '"'), nil, 0, Handle);

  mciSendString('CLOSE MicSound', nil, 0, Handle);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  iniciarGravacao;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  inc(contador);
  if contador >= 361 then
  begin
    finalizarGravacao;
    salvar;
    iniciarGravacao;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  HMainIcon: HICON;
  tnid: TNotifyIconData;
const 
  WM_NOTIFYICON  = WM_USER+333;   
begin
  HMainIcon := LoadIcon(MainInstance, 'MAINICON');

  Shell_NotifyIcon(NIM_DELETE, @tnid);

  tnid.cbSize := sizeof(TNotifyIconData);
  tnid.Wnd := handle;
  tnid.uID := 123;
  tnid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  tnid.uCallbackMessage := WM_NOTIFYICON;
  tnid.hIcon := HMainIcon;
  tnid.szTip := 'POP3 Server';

  Shell_NotifyIcon(NIM_ADD, @tnid);
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin
  hide;
end;

end.

