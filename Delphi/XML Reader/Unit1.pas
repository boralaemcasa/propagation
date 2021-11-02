unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient, StdCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    q: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    FileListBox1: TFileListBox;
    procedure FileListBox1Change(Sender: TObject);
    procedure FileListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FileListBox1Change(Sender: TObject);
var i: integer;
begin
  if FileListBox1.ItemIndex = -1 then
    exit;
  q.FileName := FileListBox1.Items[FileListBox1.ItemIndex];
  q.LoadFromFile;
  for i := 0 to q.fields.count - 1 do
    if q.fields[i] is TDateTimeField then
      (q.fields[i] as TDateTimeField).DisplayFormat := 'yyyy/mm/dd'
    else if q.fields[i] is TBCDField then
      (q.fields[i] as TBCDField).Currency := true
    else if q.fields[i] is TFloatField then
      (q.fields[i] as TFloatField).Currency := true;
end;

procedure TForm1.FileListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_delete then
    FileListBox1.DeleteSelected;
end;

end.
