unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBTables, Menus;

type
  TFormPrincipal = class(TForm)
    dsPessoas: TDataSource;
    grid: TDBGrid;
    qryPessoas: TQuery;
    UpdateSQL1: TUpdateSQL;
    qryPessoasNome: TStringField;
    qryPessoasDe_Onde: TStringField;
    qryPessoasCod_TipoCivil: TIntegerField;
    qryPessoasPendencia: TIntegerField;
    qryPessoasDDD: TStringField;
    qryPessoasFones: TStringField;
    qryPessoasEmail: TStringField;
    qryPessoasEndereco: TStringField;
    qryPessoasObservacao: TStringField;
    popTiposCivis: TPopupMenu;
    qryPessoasdescricao: TStringField;
    TipoCivilNull: TMenuItem;
    tbTiposCivis: TTable;
    tbTiposCivisCodigo: TAutoIncField;
    tbTiposCivisDescricao: TStringField;
    qryDeOnde: TQuery;
    qryDeOndede_onde: TStringField;
    popDeOnde: TPopupMenu;
    qryContador: TQuery;
    qryContadornro: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridTitleClick(Column: TColumn);
    procedure qryPessoasAfterPost(DataSet: TDataSet);
    procedure qryPessoasAfterInsert(DataSet: TDataSet);
    procedure qryPessoasBeforePost(DataSet: TDataSet);
    procedure itemTipoCivilClick(Sender: TObject);
    procedure gridColEnter(Sender: TObject);
    procedure qryPessoasAfterScroll(DataSet: TDataSet);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure itemDeondeClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.FormShow(Sender: TObject);
var i: byte;
    f: file of integer;
    x: integer;
    item: TMenuItem;
begin
  qryPessoas.DatabaseName := ExtractFilePath(Application.ExeName);
  tbTiposCivis.DatabaseName := qryPessoas.DatabaseName;
  qryDeOnde.DatabaseName := qryPessoas.DatabaseName;
  qryContador.DatabaseName := qryPessoas.DatabaseName;

  qryPessoas.Open;

  tbTiposCivis.Open;
  while not tbTiposCivis.Eof do
  begin
    item := TMenuItem.Create(popTiposCivis);
    item.Caption := tbTiposCivisDescricao.AsString;
    item.Hint := tbTiposCivisCodigo.AsString;
    item.OnClick := itemTipoCivilClick;
    popTiposCivis.Items.Add(item);
    tbTiposCivis.Next;
  end;

  qryDeOnde.Open;
  while not qryDeOnde.Eof do
  begin
    item := TMenuItem.Create(popDeOnde);
    item.Caption := qryDeOndede_onde.AsString;
    if item.Caption = '-' then
      item.Caption := '';
    item.Hint := qryDeOndede_onde.AsString;
    item.OnClick := itemDeondeClick;
    popDeOnde.Items.Add(item);
    qryDeOnde.Next;
  end;

//ler larguras
  AssignFile(f, ExtractFilePath(Application.ExeName) + 'Agenda.dat');
  try
    reset(f);
  except
    exit;
  end;
  for i := 0 to grid.Columns.Count - 1 do
  begin
    read(f, x);
    grid.Columns[i].width := x;
  end;
  CloseFile(f);
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var i: byte;
    f: file of integer;
    x: integer;
begin
//salvar larguras
  AssignFile(f, ExtractFilePath(Application.ExeName) + 'Agenda.dat');
  rewrite(f);
  for i := 0 to grid.Columns.Count - 1 do
  begin
    x := grid.Columns[i].width;
    write(f, x);
  end;
  CloseFile(f);
end;

procedure TFormPrincipal.gridTitleClick(Column: TColumn);
begin
  if qryPessoas.State in [dsEdit, dsInsert] then
    qryPessoas.Post;
  qryPessoas.SQL.Text := 'select p.*, t.descricao ' +
                         ' from pessoas p left join tipos_civis t' +
                         ' on p.cod_tipocivil = t.codigo' +
                         ' order by ' + Column.FieldName;
  qryPessoas.Open;
end;

procedure TFormPrincipal.qryPessoasAfterPost(DataSet: TDataSet);
begin
  qryPessoas.ApplyUpdates;
end;

procedure TFormPrincipal.qryPessoasAfterInsert(DataSet: TDataSet);
begin
  qryPessoasDe_Onde.AsString := '-';
  popTiposCivis.popup(Mouse.CursorPos.x - 10, mouse.cursorpos.y - 10);
end;

procedure TFormPrincipal.qryPessoasBeforePost(DataSet: TDataSet);
begin
  if qryPessoasNome.IsNull then
  begin
    Application.MessageBox('Digite um nome', 'Atenção', MB_ICONEXCLAMATION);
    abort;
  end;

  if qryPessoasDe_Onde.IsNull then
    qryPessoasDe_Onde.AsString := '-';

//cancelar inserçao do nada
  if (qryPessoas.State = dsInsert) and qryPessoasNome.IsNull and
      (qryPessoasDe_Onde.AsString = '-') then
  begin
    qryPessoas.Cancel;
    abort;
  end;
end;

//popup tipos civis
procedure TFormPrincipal.itemTipoCivilClick(Sender: TObject);
var s: string;
begin
  if not (qryPessoas.State in [dsEdit, dsInsert]) then
    qryPessoas.Edit;
  qryPessoasCod_TipoCivil.AsString := TMenuItem(sender).Hint;
  s := TMenuItem(sender).Caption;
  delete(s, pos('&', s), 1);
  qryPessoasDescricao.AsString := s;
end;

procedure TFormPrincipal.gridColEnter(Sender: TObject);
begin
  grid.Hint := grid.SelectedField.AsString;
end;

procedure TFormPrincipal.qryPessoasAfterScroll(DataSet: TDataSet);
begin
  grid.Hint := grid.SelectedField.AsString;
end;

procedure TFormPrincipal.gridKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #14 then //ctrl + N
  begin
    if qryPessoas.IsEmpty then exit;

    if grid.SelectedField.FieldName = 'Nome' then exit;

    if not (qryPessoas.State in [dsEdit, dsInsert]) then
      qryPessoas.Edit;

    if grid.SelectedField.FieldName = 'De_Onde' then
      qryPessoasDe_Onde.AsString := '-'
    else
      grid.SelectedField.Clear;
  end
  else if key = #4 then // ctrl + D
    popDeOnde.popup(Mouse.CursorPos.x - 10, mouse.cursorpos.y - 10);
end;

//popup de onde
procedure TFormPrincipal.itemDeondeClick(Sender: TObject);
begin
  if not (qryPessoas.State in [dsEdit, dsInsert]) then
    qryPessoas.Edit;
  qryPessoasDe_Onde.AsString := TMenuItem(sender).Hint;
end;

procedure TFormPrincipal.gridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_delete) and (ssShift in shift) then
  begin
    qryPessoas.Delete;
    qryPessoas.ApplyUpdates;
  end
  else if key = vk_f5 then
  begin
    qryContador.Open;
    Application.MessageBox(PChar('Existem ' + qryContadornro.AsString + ' registros.'),
      'Atenção', MB_ICONINFORMATION);
    qryContador.Close;
  end;
end;

end.
