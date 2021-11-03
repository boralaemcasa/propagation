unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TFormPrincipal = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    PopupMenu1: TPopupMenu;
    Abrir1: TMenuItem;
    ConverterparaTXT1: TMenuItem;
    Converterpara2531: TMenuItem;
    Salvarcomo1: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure ConverterparaTXT1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Converterpara2531Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Salvarcomo1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    s1, s2: string;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum253, SNum;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  memo1.Width := clientWidth div 2;
  memo2.Width := memo1.Width;
  OpenDialog.InitialDir := ExtractFilePath(application.ExeName);
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SaveDialog.Filter := OpenDialog.Filter;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  memo1.Width := clientWidth div 2;
  memo2.Width := memo1.Width;
end;

procedure TFormPrincipal.Abrir1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ReadLine253(OpenDialog.FileName, s1);
    Memo1.text := s1;
  end;
end;

procedure TFormPrincipal.MenuItem1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ReadLine253(OpenDialog.FileName, s2);
    Memo2.text := s2;
  end;
end;

procedure TFormPrincipal.ConverterparaTXT1Click(Sender: TObject);
begin
  Validar253(s1);
  memo1.text := s1;
  s2 := s1;
  From253to10(s2);
  memo2.Text := s2;
  Caption := '253 to TXT';
  Application.Title := 'From 253 to TXT';
  memo1.Tag := 10;
end;

procedure TFormPrincipal.MenuItem2Click(Sender: TObject);
begin
  Validar253(s2);
  memo2.text := s2;
  s1 := s2;
  From253to10(s1);
  memo1.Text := s1;
  Caption := '253 to TXT';
  Application.Title := 'From 253 to TXT';
  memo2.Tag := 10;
end;

procedure TFormPrincipal.Converterpara2531Click(Sender: TObject);
begin
  Validar10(s1);
  memo1.text := s1;
  s2 := s1;
  From10to253(s2);
  memo2.Text := s2;
  Caption := '253 to TXT';
  Application.Title := 'From 253 to TXT';
  memo1.Tag := 253;
end;

procedure TFormPrincipal.MenuItem3Click(Sender: TObject);
begin
  Validar10(s2);
  memo2.text := s2;
  s1 := s2;
  From10to253(s1);
  memo1.Text := s1;
  Caption := '253 to TXT';
  Application.Title := 'From 253 to TXT';
  memo2.Tag := 253;
end;

procedure TFormPrincipal.Salvarcomo1Click(Sender: TObject);
begin
  if SaveDialog.Execute then
    writeLine(SaveDialog.FileName, s1);
end;

procedure TFormPrincipal.MenuItem4Click(Sender: TObject);
begin
  if SaveDialog.Execute then
    writeLine(SaveDialog.FileName, s2);
end;

procedure TFormPrincipal.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  s1 := memo1.Text;
  if memo1.Tag = 10 then
    ConverterparaTXT1Click(sender)
  else if memo1.Tag = 253 then
    Converterpara2531Click(sender);
end;

procedure TFormPrincipal.Memo2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  s2 := memo2.Text;
  if memo2.Tag = 10 then
    MenuItem2Click(sender)
  else if memo2.Tag = 253 then
    MenuItem3Click(sender);
end;

end.
