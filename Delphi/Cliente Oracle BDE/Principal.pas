unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Database: TDatabase;
    Panel1: TPanel;
    Memo: TMemo;
    Panel2: TPanel;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    Query: TQuery;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var f: textfile;
    i: integer;
    username, senha: string;
begin
  if key = vk_f8 then
  begin
    query.SQL.Assign(memo.Lines);
    query.execsql;
  end
  else if key = vk_f5 then
  begin
    dbgrid.DataSource := nil;

    if not database.connected then
    begin
      //database.params.Add('USERNAME=sessionoper');
      //database.Params.Add('PASSWORD=tjmg');
      database.Connected := true;
      InputQuery('username', 'username', username);
      InputQuery('senha', 'senha', senha);
      query.SQL.Clear;
      query.SQL.Text := 'select fn_cs_senha_aplicacao(''' + username + ''',''' +  senha + ''') senha from dual';
      query.Open;
      showmessage(query.Fields[0].AsString);
      database.Connected := false;
      //database.LoginPrompt := false;
      //database.params.clear;
      //database.params.Add('USERNAME=' + username);
      //database.Params.Add('PASSWORD=' + senha);
      Database.Connected := true;
    end;
    query.SQL.Assign(memo.Lines);
    query.open;
    dbgrid.DataSource := DataSource;
    if application.MessageBox('Deseja exportar para csv?', 'Confirmação', mb_iconquestion + mb_yesno) = mryes then
    begin
      assignfile(f, 'output.csv');
      rewrite(f);

      for i := 0 to query.fields.Count - 1 do
        if i < query.fields.Count - 1 then
          write(f, '"', dbgrid.columns[i].fieldname, '",')
        else
          writeln(f, '"', dbgrid.columns[i].fieldname, '"');

      query.First;
      while not query.eof do
      begin
        for i := 0 to query.fields.Count - 1 do
          if i < query.fields.Count - 1 then
            write(f, '"', query.fields[i].asString, '",')
          else
            writeln(f, '"', query.fields[i].asString, '"');

        query.next;
      end;
      closefile(f);
    end;
  end;
end;

end.
