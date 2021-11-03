unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    Memo: TMemo;
    procedure MemoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.MemoDblClick(Sender: TObject);
var f: file of longword;
    p1, p2, max: longword;
begin
  fileMode := 0;
  assignfile(f, '..\Produtorio\primos novos.dat');
  reset(f);
  p1 := 2;
  max := 0;
  while not eof(f) do
  begin
    read(f, p2);
    if p2 - p1 > max then
    begin
      max := p2 - p1;
      memo.lines.add(inttostr(p2) + ' - ' + inttostr(p1) + ' = ' + inttostr(max));
      application.processmessages;
    end;
    p1 := p2;
  end;
  closefile(f);
  memo.lines.Add('EOF');
  memo.Lines.SaveToFile('output.txt');
  close;
end;

end.
