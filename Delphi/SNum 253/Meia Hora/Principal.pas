unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DateUtils;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  s1, s2: string;
  f: TextFile;
  i, y, mon, d, h, min: word;
  date1, date2: TDateTime;
begin
  fileMode := 0;
  assignfile(f, 'a.txt');
  reset(f);

  readln(f, s1);

  d := strtoint(copy(s1, 1, 2));
  mon := strtoint(copy(s1, 4, 2));
  y := strtoint(copy(s1, 7, 4));
  h := strtoint(copy(s1, 13, 2));
  min := strtoint(copy(s1, 16, 2));
  date1 := EncodeDateTime(y, mon, d, h, min, 0, 0);

  repeat
    readln(f, s2);
    d := strtoint(copy(s2, 1, 2));
    mon := strtoint(copy(s2, 4, 2));
    y := strtoint(copy(s2, 7, 4));
    h := strtoint(copy(s2, 13, 2));
    min := strtoint(copy(s2, 16, 2));
    date2 := EncodeDateTime(y, mon, d, h, min, 0, 0);

    decodedatetime(date2 - date1, y, mon, d, h, min, y, mon);
    min := round((date2 - date1) * 24 * 60);
    if min < 30 then
    begin
      memo.lines.add('move "' + copy(s2, 37, length(s2)) + '" deletar');
    end
    else
    begin
      s1 := s2;
      date1 := date2;
    end;
  until eof(f);

  closefile(f);
end;

end.
