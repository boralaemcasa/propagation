unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i, j, counter: integer;
  s: string;
begin
  memo.Lines.loadfromfile('C:\_VINICIUS CLAUDINO FERRAZ\fonte viva\segue-me.txt');
  i := 0;
  counter := 0;
  while i < memo.lines.count do
  begin
    s := memo.lines[i];
    if (length(s) > 0) and (s[1] in ['1'..'9']) then
    begin
      if i > 0 then
      begin
        memo.Lines[i - 1] := stringReplace(memo.lines[i - 1], '<br>" +', '");', [rfReplaceAll]);
      end;
      inc(counter);
      memo.lines[i] := 'novoCapituloVerbo("Segue-me ' + inttostr(counter) + ' - ' + trim(memo.Lines[i+1]) + '");';
      memo.Lines.Delete(i + 1);
      j := i + 1;
      while pos('(', memo.lines[j]) = 0 do
        inc(j);
      s := trim(memo.lines[j]);
      delete(s, 1, pos('(', s));
      delete(s, length(s), 1);
      if s[length(s)] = '.' then
        delete(s, length(s), 1);
      s := stringReplace(s, 'ª Epístola a ', '_', [rfReplaceAll]);
      s := stringReplace(s, 'ª Epístola aos ', '_', [rfReplaceAll]);
      s := stringReplace(s, 'ª Epístola de ', '_', [rfReplaceAll]);
      s := stringReplace(s, ',', '', [rfReplaceAll]);
      s := stringReplace(s, ':', ', ', [rfReplaceAll]);
      s := stringReplace(s, ' ,', ',', [rfReplaceAll]);
      s := stringReplace(s, '  ', ' ', [rfReplaceAll]);
      memo.Lines.Insert(i+1, 'novoVersiculo("' + s + '");');
      s := 'processar("' + trim(memo.lines[i+2]) + '" +';
      if s[length(s) - 3] in ['.', '!', '?', ':', '"', '“', '”', ')'] then
        insert('<br>', s, length(s) - 2)
      else
        insert(' ', s, length(s) - 2);
      memo.lines[i+2] := s;
      inc(i,2);
    end
    else begin
      s := '"' + trim(memo.lines[i]) + '" +';
      if s[length(s) - 3] in ['.', '!', '?', ':', '"', '“', '”', ')'] then
        insert('<br>', s, length(s) - 2)
      else
        insert(' ', s, length(s) - 2);
      memo.lines[i] := s;
    end;

    inc(i);
    application.ProcessMessages;
  end;
  memo.Lines.SaveToFile('C:\_VINICIUS CLAUDINO FERRAZ\fonte viva\segueMe.java');
  close;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i: integer;
begin
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\fonte viva\chico total 3.txt');
  for i := 0 to memo.lines.count - 1 do
      memo.Lines[i] := 'processarLink(' + inttostr(i + 251) + ', "' + memo.Lines[i] + '");';
end;

end.
