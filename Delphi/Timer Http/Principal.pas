unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    contador, aguardar: cardinal;
    forcar: boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses IdHTTP;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  HTTP: TIdHTTP;
  Buffer: String;
begin
  timer1.Enabled := false;
  label1.Caption := 'Executando';
  contador := 0;
  HTTP := TIdHTTP.Create(self);
  try
    Buffer := HTTP.Get('http://boralaemcasa.herokuapp.com/polyWait');
  except
    Buffer := '1';
  end;
  if forcar or ((buffer <> '1') and (buffer <> '-2')) then
  begin
    try
      Buffer := HTTP.Get('http://boralaemcasa.herokuapp.com/postagem/pesquisa?pescar=dcoh36e50bo1f6&booVerb=1&booPost=0&booCateg=0&booWiki=0&booLeftPercent=1&booRightPercent=1&lambda=1');
      sleep(1000);
      Buffer := HTTP.Get('http://boralaemcasa.herokuapp.com/postagem/pesquisa?pescar=bafomet+continue5&booVerb=1&booPost=0&booCateg=0&booWiki=0&booLeftPercent=1&booRightPercent=1&lambda=1');
      aguardar := 0;
    except
    end;
    try
      timer1.Interval := strtoint(edit1.text);
    except
      timer1.Interval := 600000;
      edit1.Text := '600000';
    end;
    timer1.Enabled := true;
    forcar := false;
  end
  else
  begin // esperar (-2), -1, 0, (1)
    timer1.Interval := 60000;
    timer1.Enabled := true;
    inc(aguardar);
    if aguardar >= 17 then
      forcar := true;
  end;
  HTTP.Free;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var x: cardinal;
begin
  inc(contador);
  x := timer1.Interval div 1000 - contador;
  label1.caption := inttostr(contador div 60) + ':' + inttostr(contador mod 60) + ' / '
    + inttostr(x div 60) + ':' + inttostr(x mod 60);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  contador := 0;
  aguardar := 0;
  forcar := false;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  forcar := true;
  Timer1Timer(sender);
end;

end.
