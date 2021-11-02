unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Buttons, Menus;

type
  TForm1 = class(TForm)
    ImageList: TImageList;
    TV: TTreeView;
    PopupMenu1: TPopupMenu;
    Renomear1: TMenuItem;
    Excluir1: TMenuItem;
    Inserir1: TMenuItem;
    NovaRaiz1: TMenuItem;
    procedure TVGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TVGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TVDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TVDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Renomear1Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure Inserir1Click(Sender: TObject);
    procedure NovaRaiz1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses funcoes, Types;

procedure TForm1.TVGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if Node.HasChildren then
    if Node.Expanded then
      Node.ImageIndex := 3
    else
      Node.ImageIndex := 0
  else
    Node.ImageIndex := 1;
end;

procedure TForm1.TVGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TForm1.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept := true;
end;

procedure TForm1.TVDragDrop(Sender, Source: TObject; X, Y: Integer);
var posicao: boolean;
begin
  posicao := tv.GetNodeAt(x, y).parent = tv.selected.parent;
  if posicao then
    case Application.MessageBox('Sim para alterar posição'#13#10'Não para criar subchave', 'Deseja alterar posição?', MB_ICONQUESTION + MB_YESNOCANCEL) of
      mrCancel: exit;
      mryes: posicao := true;
      mrno: posicao := false;
    end;

  if posicao
    then tv.Selected.MoveTo(tv.GetNodeAt(x, y), naInsert)
  else tv.Selected.MoveTo(tv.GetNodeAt(x, y), naAddChild);

  TVChange(sender, tv.selected);
end;

procedure TForm1.TVChange(Sender: TObject; Node: TTreeNode);
var s: string;
begin
  s := '';
  repeat
    s := lzero(inttostr(node.Index + 1), 3) + '.' + s;
    node := node.parent;
  until node = nil;

  delete(s, length(s), 1);
  caption := s;
end;

procedure TForm1.Renomear1Click(Sender: TObject);
var r: TRect;
  p: TPoint;
begin
  r := tv.Selected.DisplayRect(true);
  p.x := r.right + tv.left;
  p.y := r.Bottom + tv.top;
  p := ClientToScreen(p);
  mouse.CursorPos := p;
  mouse_event(MOUSEEVENTF_LEFTDOWN, p.x, p.y, 0, 0);
  mouse_event(MOUSEEVENTF_LEFTUP, p.x, p.y, 0, 0);
end;

procedure TForm1.Excluir1Click(Sender: TObject);
begin
  if tv.selected <> nil then
    tv.Items.Delete(tv.selected);
end;

procedure TForm1.Inserir1Click(Sender: TObject);
begin
  tv.Selected := tv.Items.AddChild(tv.Selected, 'Novo Item');
  Renomear1Click(sender);
end;

procedure TForm1.NovaRaiz1Click(Sender: TObject);
begin
  tv.Selected := tv.Items.AddChild(nil, 'Nova Raiz');
  Renomear1Click(sender);
end;

end.

