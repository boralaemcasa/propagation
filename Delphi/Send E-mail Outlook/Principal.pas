unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses MAPI;

function SendMail(Parametros: array of Variant): Integer;
var
  Index: Integer;
  Flags: Cardinal;
  MAPIModule: HModule;
  MAPIMessage: TMapiMessage;
  lpSender: TMapiRecipDesc;
  lpRecepient: TMapiRecipDesc;
  MAPISendMail: TFNMapiSendMail;
  FileAttach: array[0..10] of TMapiFileDesc;
begin

{Parametros[0] = E-mail de Origem
Parametros[1] = E-mail de Destino
Parametros[2] = Assunto
Parametros[3] = Texto do E-mail
Parametros[4] = Confirma Envio direto (True/False)
Parametros[5] = Quantidade de Anexos
Parametros[6..n] = Anexos}

  FillChar(MAPIMessage, SizeOf(MAPIMessage), 0);

  with MAPIMessage do
  begin
    if Parametros[0] <> '\' then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      lpSender.lpszName := PChar(string(Parametros[0]));
      lpSender.lpszAddress := PChar(string(Parametros[0]));
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    lpRecips := nil;

    if Parametros[1] <> '\' then
    begin
      lpRecepient.ulRecipClass := MAPI_TO;
      lpRecepient.lpszName := PChar(string(Parametros[1]));
      lpRecepient.lpszAddress := PChar(string(Parametros[1]));
      lpRecepient.ulReserved := 0;
      lpRecepient.ulEIDSize := 0;
      lpRecepient.lpEntryID := nil;
      nRecipCount := 1;
      lpRecips := @lpRecepient;
    end;

    if Parametros[2] <> '\' then
      lpszSubject := PChar(string(Parametros[2]));

    if Parametros[3] <> '\' then
      lpszNoteText := PChar(string(Parametros[3]));

    nFileCount := 0;
    lpFiles := nil;

    if Parametros[5] > 0 then
    begin
      FillChar(FileAttach, SizeOf(FileAttach), 0);

      for Index := 0 to (Parametros[5] - 1) do
      begin
        FileAttach[Index].nPosition := Cardinal($FFFFFFFF);
        FileAttach[Index].lpszPathName := PChar(string(Parametros[Index + 6]));
      end;

      nFileCount := Parametros[5];
      lpFiles := @FileAttach;
    end;
  end;

  MAPIModule := LoadLibrary(PChar(MAPIDLL));

  if MAPIModule = 0 then
    Result := -1
  else
  begin
    try
      Flags := 0;

      if Parametros[4] then
        Flags := MAPI_DIALOG or MAPI_LOGON_UI;

      @MAPISendMail := GetProcAddress(MAPIModule, 'MAPISendMail');

      if @MAPISendMail <> nil then
        Result := MAPISendMail(0, Application.Handle, MAPIMessage, Flags, 0)
      else
        Result := 1;
    finally
      FreeLibrary(MAPIModule);
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var parametros: array[0..6] of variant;
begin
  parametros[0] := 'teste@tjmg.jus.br';
  parametros[1] := 'vinicius.ferraz@tjmg.jus.br';
  parametros[2] := 'subject';
  parametros[3] := 'body';
  parametros[4] := true;
  parametros[5] := 1;
  parametros[6] := 'C:\sis\su\Orçamentos Gerados\Pedido 000095_2012_9002033 (Lote 0).xls';
  SendMail(parametros)
end;

end.

