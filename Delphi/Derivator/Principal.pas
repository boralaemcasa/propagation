unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  Tfrm_principal = class(TForm)
    btnDerivate: TButton;
    Panel1: TPanel;
    MemoSource: TMemo;
    MemoDest: TMemo;
    btnTeste: TButton;
    OpenDialog: TOpenDialog;
    Panel2: TPanel;
    MemoConst: TMemo;
    Label3: TLabel;
    Label1: TLabel;
    edit: TEdit;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    Loadfromfile1: TMenuItem;
    PopupMenu2: TPopupMenu;
    CRLFbeforeand1: TMenuItem;
    Width2911: TMenuItem;
    N30lines1: TMenuItem;
    btnDistribuir: TButton;
    Deletemultline1: TMenuItem;
    Mandarparacima1: TMenuItem;
    LongoProcesso1: TMenuItem;
    procedure btnDerivateClick(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Loadfromfile1Click(Sender: TObject);
    procedure CRLFbeforeand1Click(Sender: TObject);
    procedure Width2911Click(Sender: TObject);
    procedure N30lines1Click(Sender: TObject);
    procedure btnDistribuirClick(Sender: TObject);
    procedure Deletemultline1Click(Sender: TObject);
    procedure Mandarparacima1Click(Sender: TObject);
    procedure LongoProcesso1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_principal: Tfrm_principal;

implementation

{$R *.dfm}

uses derivar, distribuir;

procedure Tfrm_principal.btnDerivateClick(Sender: TObject);
begin
  MemoDest.Text := Parcial(MemoSource.lines.text, edit.Text, memoConst.text);
end;

procedure Tfrm_principal.btnTesteClick(Sender: TObject);
begin
(*
  showmessage(Parcial('-2u - 3v - 4w', 'x'));
  showmessage(Parcial('-2u 3v - 4u 5w - 6v 7w', 'x'));
  showmessage(Parcial('-2u(3v - 4w) - 5vw', 'x'));
  showmessage(Parcial('-Ru - Rv - Rw', 'x', 'R'));
  MemoSource.Text := '\frac{A_{3y} - I_{3y}}{w_y} + w_{yy} \frac{I_3 - A_3}{w_y^2}';
  showmessage(Parcial(MemoSource.Text, 'x', 'A_3'));
  showmessage('Agora explicite I_2');
*)
  MemoSource.Text := '(a + b) 2 (c + d) 3 (e + f) \frac{u}{v}';
  MemoDest.Text := Distributiva(MemoSource.lines.text);
end;

procedure Tfrm_principal.FormShow(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure Tfrm_principal.Loadfromfile1Click(Sender: TObject);
begin
  OpenDialog.Execute;
  MemoSource.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure Tfrm_principal.CRLFbeforeand1Click(Sender: TObject);
var s: string;
    i,j,k: integer;
begin
  s := MemoDest.Text;
  s := StringReplace(s, '+', #13#10'+', [rfReplaceAll]);
  s := StringReplace(s, '-', #13#10'-', [rfReplaceAll]);
  MemoDest.text := s;

  memoDest.hide;
  j := 0; // conta '(' abertos
  for i := 0 to MemoDest.Lines.Count - 1 do
  begin
    s := MemoDest.Lines[i];
    for k := 1 to length(s) do
      case s[k] of
        '(': inc(j);
        ')': dec(j);
      end;

    MemoDest.Lines[i] := s + #9#9#9#9#9#9#9'%' + IntToStr(j);
  end;
  MemoDest.Show;
end;

procedure Tfrm_principal.Width2911Click(Sender: TObject);
var s: string;
    i, j: integer;
begin
  memoDest.Hide;
  s := MemoDest.Text;
  MemoDest.Clear;
  j := 0;
  while length(s) > 291 do
  begin
    i := 292;
    repeat
       dec(i);
    until (s[i] in ['+', '-']) and (s[i-1] <> '(');
    MemoDest.Lines.Add(copy(s, 1, i - 1) + '\\');
    inc(j);
    if j mod 10 = 0 then
    begin
      MemoDest.Lines.Add('\end{multline*}');
      MemoDest.Lines.Add('');
      MemoDest.Lines.Add('\begin{multline*}');
    end;
    delete(s, 1, i - 1);
  end;
  MemoDest.Lines.Add(s);
  MemoDest.Show;
end;

procedure Tfrm_principal.N30lines1Click(Sender: TObject);
var i: integer;
    s: string;
begin
  MemoDest.hide;
  i := 0;
  while i < MemoDest.Lines.Count do
    if pos('multline', MemoDest.Lines[i]) > 0 then
      MemoDest.Lines.Delete(i)
    else if trim(MemoDest.Lines[i]) = '' then
      MemoDest.Lines.Delete(i)
    else begin
      if pos('\\', MemoDest.Lines[i]) = 0 then
         MemoDest.Lines[i] := MemoDest.Lines[i] + '\\';
      inc(i);
    end;

  i := 30;
  while i < MemoDest.Lines.Count do
  begin
    MemoDest.Lines[i - 1] := copy(MemoDest.Lines[i - 1], 1, length(MemoDest.Lines[i - 1]) - 2);
    MemoDest.Lines.Insert(i, '\end{multline*}');
    MemoDest.Lines.Insert(i + 1, '');
    MemoDest.Lines.Insert(i + 2, '\begin{multline*}');
    i := i + 33;
  end;
  MemoDest.Show;
end;

procedure Tfrm_principal.btnDistribuirClick(Sender: TObject);
begin
  MemoDest.Text := Distributiva(MemoSource.lines.text);
  winexec('cmd /c echo '#7, SW_MINIMIZE);
end;

procedure Tfrm_principal.Deletemultline1Click(Sender: TObject);
var i: integer;
    s: string;
begin
  MemoDest.hide;
  i := 0;
  while i < MemoDest.Lines.Count do
    if pos('multline', MemoDest.Lines[i]) > 0 then
      MemoDest.Lines.Delete(i)
    else if trim(MemoDest.Lines[i]) = '' then
      MemoDest.Lines.Delete(i)
    else begin
      if pos('\\', MemoDest.Lines[i]) = 0 then
         MemoDest.Lines[i] := MemoDest.Lines[i] + '\\';
      inc(i);
    end;
  MemoDest.Show;
end;

procedure Tfrm_principal.Mandarparacima1Click(Sender: TObject);
begin
  MemoSource.Text := MemoDest.Text;
end;

procedure Tfrm_principal.LongoProcesso1Click(Sender: TObject);
var dir: string;
    i: integer;
begin
  dir := ExtractFilePath(Application.ExeName) + 'derivations\';
  i := 1;
  MemoSource.Lines.LoadFromFile(dir + 'tmp.tex');
  btnDistribuir.Click;
  MemoDest.Lines.SaveToFile(dir + 'auto_' + inttostr(i) + '.tex');
  repeat
    MemoSource.Text := MemoDest.Text;
    inc(i);
    btnDistribuir.Click;
    MemoDest.Lines.SaveToFile(dir + 'auto_' + inttostr(i) + '.tex');
  until MemoSource.Text = MemoDest.Text;
end;

end.

