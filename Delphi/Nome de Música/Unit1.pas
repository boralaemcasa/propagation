unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var search: TSearchRec;
    path, s: string;
    i: integer;
CONST DIR = 'C:\Músicas\vi 2 ri - nao tem em cd';
      BUSCA = 'NA BADALA';
begin
  if FindFirst(DIR + '\*.mp3', faanyfile, search) = 0 then
  repeat
    path := DIR + '\';
    s := search.name;

    while (s <> '') and (s[1] in ['0'..'9', '_', '.', ' ', '-']) do
      delete(s, 1, 1);

    while (s <> '') and (s[length(s)] = '_') do
      delete(s, length(s), 1);

    for i := 1 to length(s) do
      if s[i] = '_' then
        s[i] := ' ';

        {
    repeat
    i := pos(BUSCA, uppercase(s));
    if i = 0 then break;
      delete(s, i, LENGTH(BUSCA));
    until false;
    }

    repeat
    i := pos(' .MP3', uppercase(s));
    if i = 0 then break;
      delete(s, i, 1);
    until false;

     while (search.name <> s) and
      fileexists(path + s) and
      fileexists(path + search.name) do
        insert('_', s, pos('.MP3', UPPERCASE(s)));

    try
      RenameFile(path + search.Name, path + s);
    except
    end;
  until FindNext(search) <> 0;

  Application.Terminate;
end;

end.
