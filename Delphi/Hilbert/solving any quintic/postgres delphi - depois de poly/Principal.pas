unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBAccess, PgAccess, MemDS, StdCtrls;

type
  TForm1 = class(TForm)
    PgConnection1: TPgConnection;
    qry: TPgQuery;
    PgDataSource1: TPgDataSource;
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    qryi: TPgQuery;
    PgDataSource2: TPgDataSource;
    PgDataSource3: TPgDataSource;
    PgQuery3: TPgQuery;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure qryAfterScroll(DataSet: TDataSet);
    procedure qryiAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  qry.Open;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PgConnection1.Disconnect;
end;

function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do
  begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;

function EnumProc(wnd: HWND; Lines: TStrings): BOOL; stdcall;
var
  buf, Caption: array[0..255] of char;
begin
  Result := True;
  GetClassName(wnd, buf, SizeOf(buf) - 1);
  SendMessage(wnd, WM_GETTEXT, 256, Integer(@Caption));
  Lines.Add(Format('ID: %d, ClassName: %s, Caption: %s',
           [GetDlgCtrlID(wnd), buf, Caption]));
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  h, hb: THandle;
  i: byte;
begin
  if key = vk_f5 then
  begin
    qry.Close;
    qry.Open;
  end
  else if key = vk_f9 then
  begin
    qry.First;
    while not qry.Eof do
    begin
      qryi.First;
      while not qryi.Eof do
      begin
        caption := inttostr(qryi.RecNo) + '/' + inttostr(qryi.RecordCount);
        application.ProcessMessages;
        qryi.Next;
      end;

      qry.Next;
    end;
  end
  else if key = vk_f1 then
  begin
    WinExec('c:\_vinicius\anydegree\anydegree.exe', sw_show);
    h := FindWindowByTitle('Devart PgDAC');
    if h <> 0 then
    begin
      hb := FindWindowEx(h, 0, 'Button', nil);
      PostMessage(hb, WM_KEYDOWN, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYUP, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYDOWN, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYUP, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);

      //Memo1.Clear;
      //EnumChildWindows(h, @EnumProc, Integer(memo1.Lines));
    end;
  end;
end;

procedure TForm1.qryAfterScroll(DataSet: TDataSet);
begin
  qryi.Close;
  qryi.parambyname('p').AsString := qry.fieldbyname('who').AsString;
  qryi.Open;
  DBGrid2.Height := DBGrid1.Height;
end;

procedure TForm1.qryiAfterScroll(DataSet: TDataSet);
begin
  PgQuery3.Close;
  PgQuery3.parambyname('w').AsString := qry.fieldbyname('who').AsString;
  PgQuery3.parambyname('i').AsString := qryi.fieldbyname('i').AsString;
  PgQuery3.Open;
  DBGrid2.Height := DBGrid1.Height;
end;

end.
