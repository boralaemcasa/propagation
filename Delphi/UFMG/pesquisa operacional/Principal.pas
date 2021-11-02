unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Menus, ComCtrls;

type
  TPivot = record
    li, col: integer;
  end;
  TStringPivot = record
    li, col: string;
  end;

  TFormPrincipal = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnInit: TButton;
    w0: TLabeledEdit;
    Label6: TLabel;
    b: TStringGrid;
    OpenDialog: TOpenDialog;
    PopupMenu1: TPopupMenu;
    FPI: TMenuItem;
    Descerdireto: TMenuItem;
    btnFind: TButton;
    Memo: TMemo;
    Criarvariveisauxiliares: TMenuItem;
    FPIVariveisAuxiliares: TMenuItem;
    cbSalvar: TCheckBox;
    lblSalvar: TLabel;
    Panel1: TPanel;
    lblNegativos: TLabel;
    Label10: TLabel;
    x: TStringGrid;
    Label17: TLabel;
    PanelCalcular: TPanel;
    Label7: TLabel;
    lblNovaA: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    novaCT: TStringGrid;
    novow0: TLabeledEdit;
    novaA: TStringGrid;
    novoB: TStringGrid;
    opNovaCT: TStringGrid;
    opNovaA: TStringGrid;
    PopupMenu2: TPopupMenu;
    PivoterColLi: TMenuItem;
    rocarosinaldalinha: TMenuItem;
    Calcularx: TMenuItem;
    PrimalNegativosUmMovimento: TMenuItem;
    Dualummovimento: TMenuItem;
    PrimalZeroUmmovimento: TMenuItem;
    PrimalNegativosPlay: TMenuItem;
    DualPlay: TMenuItem;
    PrimalZeroPlay: TMenuItem;
    btnCancelar: TButton;
    cTmenosyTA: TStringGrid;
    Label4: TLabel;
    lblA: TLabel;
    cT: TStringGrid;
    A: TStringGrid;
    MemoTemp: TMemo;
    procedure btnInitClick(Sender: TObject);
    procedure FPIClick(Sender: TObject);
    procedure PivoterColLiClick(Sender: TObject);
    procedure CalcularxClick(Sender: TObject);
    procedure DescerdiretoClick(Sender: TObject);
    procedure rocarosinaldalinhaClick(Sender: TObject);
    procedure CriarvariveisauxiliaresClick(Sender: TObject);
    procedure PrimalNegativosUmMovimentoClick(Sender: TObject);
    procedure PrimalNegativosPlayClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FPIVariveisAuxiliaresClick(Sender: TObject);
    procedure DualummovimentoClick(Sender: TObject);
    procedure DualPlayClick(Sender: TObject);
    procedure lblSalvarClick(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
    procedure PrimalZeroUmmovimentoClick(Sender: TObject);
    procedure PrimalZeroPlayClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    query: TStringPivot;
    flagSaida: boolean;
    fimDoJogo, nomeArq, msgFPI: string;
    procedure Pivotear(msg: string; pivot: TPivot);
    procedure OpostoLinha(linha: integer);
    function  Pivot(coluna: integer): string;
    procedure Salvar(msg: string);
    function  Canonica(coluna: integer; considerarC: boolean): integer;
    function EscolherColuna(var coluna, linha: integer): boolean;
    function EscolherLinha(var coluna, linha: integer; primalZero: boolean): boolean;
    function TudoZeroB: boolean;
    function TudoZeroCT: boolean;
    procedure Init;
    function IsOTIMA: boolean;
    function IsINVIAVEL: boolean;
    function IsILIMITADA: boolean;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum, ShellAPI;

function FracbMenosAx(b, a, x: string): string;
begin
  if FracCompare(x, '0') = 0 then
    Result := b
  else if FracCompare(a, '0') = 0 then
    Result := b
  else
    Result := FracSub(b, FracMul(a, x));
end;

function FracbMaisAx(b, a, x: string): string;
begin
  if FracCompare(x, '0') = 0 then
    Result := b
  else if FracCompare(a, '0') = 0 then
    Result := b
  else
    Result := FracAdd(b, FracMul(a, x));
end;

function ConstruirPivot(col, li: integer): TPivot;
begin
  result.col := col;
  result.li := li;
end;

procedure TFormPrincipal.Pivotear(msg: string; pivot: TPivot);
var li, col, contaNegativosC, contaNegativosB: integer;
    temp: string;
begin
  if canonica(pivot.col, true) = pivot.li then
    exit;

  contaNegativosC := 0;
  contaNegativosB := 0;

  temp := novaA.Cells[pivot.col, pivot.li]; //7
  if FracCompare(temp, '0') = 0 then
    exit;

//  if FracCompare(temp, '0') < 0 then
//    showmessage('o pivô (' + inttostr(pivot.col) + ',' + inttostr(pivot.li) + ') é negativo');

  for col := 0 to opnovaa.ColCount - 1 do
    opnovaa.cells[col, pivot.li] := FracDiv(opnovaa.cells[col, pivot.li], temp);

  for col := 0 to novaa.ColCount - 1 do
    novaa.Cells[col, pivot.li] := FracDiv(novaa.Cells[col, pivot.li], temp);

  novoB.Cells[0, pivot.li] := FracDiv(novob.Cells[0, pivot.li], temp);
  if FracCompare(novoB.Cells[0, pivot.li], '0') < 0 then
     inc(contaNegativosB);

  //showmessage('cT := cT - [-300] L4');

  temp := novaCT.cells[pivot.col, 0]; //-300

  for col := 0 to novaCT.ColCount - 1 do
  begin
    novaCT.Cells[col, 0] := FracbMenosAx(novaCT.Cells[col, 0], temp, novaa.cells[col, pivot.li]);
    if FracCompare(novaCT.Cells[col,0], '0') < 0 then
      inc(contaNegativosC);
  end;

  novow0.text := FracbMenosAx(novow0.text, temp, novob.cells[0, pivot.li]);

  for col := 0 to opnovact.ColCount - 1 do
    opNovaCT.Cells[col,0] := FracbMenosAx(opNovaCT.Cells[col,0], temp, opnovaa.Cells[col, pivot.li]);

  FOR LI := 0 TO NOVAA.RowCount - 1 DO
    IF LI <> pivot.li THEN
    BEGIN
      //showmessage('L1 := L1 - 11 L4');

      temp := novaa.cells[pivot.col, LI]; //11
      IF FracCompare(temp, '0') <> 0 then
      begin
        for col := 0 to novaa.colcount - 1 do
          novaA.Cells[col, LI] := FracbMenosAx(novaA.Cells[col, LI], temp, novaA.cells[col, pivot.li]);

        novob.cells[0, LI] := FracbMenosAx(novob.cells[0, LI], temp, novoB.cells[0, pivot.li]);

        for col := 0 to opnovaA.ColCount - 1 do
          opNovaA.Cells[col,LI] := FracbMenosAx(opNovaA.Cells[col,LI], temp, opnovaa.Cells[col, pivot.li]);
      end;
      if FracCompare(novoB.Cells[0, LI], '0') < 0 then
        inc(contaNegativosB);
    END;

  if not cbSalvar.Checked then
    Salvar(msg + ', Pivoteamento: coluna = ' + inttostr(pivot.col) + ', linha = ' + inttostr(pivot.li));
  memo.Lines.Add(inttostr(memo.lines.count + 1) + 'º (' + inttostr(pivot.col) + ', ' + inttostr(pivot.li) + ')');
  lblNegativos.Caption := inttostr(contanegativosC) + ' negativos em nova c'#13#10 + inttostr(contanegativosB) + ' negativos em novo b';
  Application.ProcessMessages;
end;

procedure TFormPrincipal.OpostoLinha(linha: integer);
var col: integer;
begin
  for col := 0 to novaa.ColCount - 1 do
    novaa.Cells[col, linha] := FracOposto(novaa.Cells[col, linha]);

  novob.Cells[0, linha] := FracOposto(novob.Cells[0, linha]);

  for col := 0 to opnovaa.ColCount - 1 do
    opNovaa.Cells[col, linha] := FracOposto(opNovaa.Cells[col, linha]);

  if not cbsalvar.Checked then
    Salvar('Oposto da linha ' + inttostr(linha));
end;

procedure TFormPrincipal.btnInitClick(Sender: TObject);
begin
  Criarvariveisauxiliares.Checked := false;
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName)  + '\testes';
  OpenDialog.FileName := '*.txt';
  if OpenDialog.Execute then
  begin
    nomeArq := OpenDialog.FileName;
    Init;
  end;
end;

procedure TFormPrincipal.init;
var col, li, cols_entrada, rows_entrada: integer;
    f: TextFile;
    xx: double;
begin
  caption := 'Simplex ' + ExtractFileName(nomeArq);
  application.Title := 'Simplex ' + ExtractFileName(nomearq);

  if uppercase(extractfileext(nomeArq)) = '.INI' then
  begin
    memo.Lines.LoadFromFile(nomeArq);
    memo.text := stringReplace(memo.text, '[', ' ', [rfReplaceAll]);
    memo.text := stringReplace(memo.text, ']', #13#10, [rfReplaceAll]);
    memo.text := stringReplace(memo.text, ',', ' ', [rfReplaceAll]);
    nomeArq := copy(nomeArq, 1, length(nomeArq) - 4) + '.txt';
    memo.Lines.SaveToFile(nomeArq);
  end;

  if uppercase(extractfileext(nomeArq)) = '.TXT' then
  begin
    AssignFile(f, nomeArq);
    reset(f);
    readln(f, rows_entrada);
    readln(f, cols_entrada);
    cT.colCount := cols_entrada;
    cT.rowCount := 1;
    for col := 0 to cols_entrada - 1 do
    begin
      read(f, xx);
      cT.Cells[col, 0] := fracValida(floattostr(xx * 10) + '/10');
    end;
    readln(f, xx);
    w0.text := fracValida(floattostr(xx * 10) + '/10');

    a.ColCount := cols_entrada;
    a.RowCount := rows_entrada;
    lblA.caption := 'A tem ' + inttostr(a.colCount) + ' colunas e ' + inttostr(a.rowCount) + ' linhas';

    b.colCount := 1;
    b.rowCount := rows_entrada;

    for li := 0 to rows_entrada - 1 do
    begin
      for col := 0 to cols_entrada - 1 do
      begin
        read(f, xx);
        a.Cells[col, li] := fracValida(floattostr(xx * 10) + '/10');
      end;
      readln(f, xx);
      b.Cells[0, li] := fracValida(floattostr(xx * 10) + '/10');
    end;

    closefile(f);
  end;

  memo.clear;
end;

function TFormPrincipal.Pivot(coluna: integer): string;
var li, contador, pivo: integer;
begin
  if FracCompare(novaCT.Cells[coluna, 0], '0') <> 0 then
  begin
    result := '0';
    exit;
  end;

  contador := 0;
  pivo := 0;

  for li := 0 to novaa.RowCount - 1 do
    if FracCompare(novaa.Cells[coluna, li], '0') <> 0 then
    begin
      inc(contador);
      pivo := li;
    end;

  if contador <> 1 then
    result := '0'
  else if FracCompare(novaa.Cells[coluna, pivo], '1') <> 0 then
    result := '0'
  else
  begin
    for li := 0 to coluna - 1 do
      if Canonica(li, true) = pivo then
      begin
        result := '0';
        exit;
      end;

    result := novob.Cells[0, pivo];
  end;
end;

function TFormPrincipal.Canonica(coluna: integer; considerarC: boolean): integer;
var li, contador, pivo: integer;
begin
  if considerarC then
    if FracCompare(novaCT.Cells[coluna, 0], '0') <> 0 then
    begin
      result := -1;
      exit;
    end;

  contador := 0;
  pivo := 0;

  for li := 0 to novaa.RowCount - 1 do
    if FracCompare(novaa.Cells[coluna, li], '0') <> 0 then
    begin
      inc(contador);
      pivo := li;
    end;

  if contador <> 1 then
    result := -1
  else if FracCompare(novaa.Cells[coluna, pivo], '1') <> 0 then
    result := -1
  else
    result := pivo;
end;

function TFormPrincipal.TudoZeroB: boolean;
var li: integer;
begin
  for li := 0 to novaa.RowCount - 1 do
    if FracCompare(novoB.Cells[0, li], '0') <> 0 then
    begin
      result := false;
      exit;
    end;

  result := true;
end;

function TFormPrincipal.TudoZeroCT: boolean;
var col: integer;
begin
  for col := 0 to novact.RowCount - 1 do
    if FracCompare(novact.Cells[col, 0], '0') <> 0 then
    begin
      result := false;
      exit;
    end;

  result := true;
end;

procedure TFormPrincipal.FPIClick(Sender: TObject);
var col, li, cols_entrada, rows_entrada: integer;
begin
  Memo.clear;
  query.col := '0';
  query.li := '0';

  cols_entrada := a.colcount;
  rows_entrada := a.rowcount;

  novaA.ColCount := cols_entrada + rows_entrada;
  novaA.RowCount := rows_entrada;
  x.ColCount := 1;
  x.RowCount := novaa.ColCount;
  cTmenosyTA.ColCount := 1;
  cTmenosyTA.RowCount := novaa.ColCount;
  lblnovaA.caption := 'nova A tem ' + inttostr(novaa.colCount) + ' colunas e ' + inttostr(novaa.rowCount) + ' linhas';

  for col := 0 to cols_entrada - 1 do
    for li := 0 to novaa.RowCount - 1 do
      novaA.Cells[col,li] := a.cells[col, li];

  for col := cols_entrada to novaa.ColCount - 1 do
    for li := 0 to novaa.RowCount - 1 do
      if li = col - cols_entrada then
        novaA.Cells[col, li] := '1'
      else
        novaA.Cells[col, li] := '0';

  novoB.colCount := 1;
  novoB.rowCount := rows_entrada;

  for li := 0 to novob.RowCount - 1 do
    novoB.cells[0,li] := b.cells[0,li];

  novow0.text := w0.Text;

  novaCT.colCount := cols_entrada + rows_entrada;
  novaCT.rowCount := 1;

  for col := 0 to cols_entrada - 1 do
    novaCT.cells[col,0] := FracOposto(ct.Cells[col, 0]);
  for col := cols_entrada to novaCT.ColCount - 1 do
    novaCT.cells[col,0] := '0';

  opnovact.ColCount := rows_entrada;
  opnovact.RowCount := 1;
  for col := 0 to opnovact.ColCount - 1 do
    opNovaCT.Cells[col, 0] := '0';

  opNovaA.ColCount := rows_entrada;
  opnovaa.rowcount := rows_entrada;

  for col := 0 to opnovaa.ColCount - 1 do
    for li := 0 to opnovaa.RowCount - 1 do
      if li = col then
        opnovaA.Cells[col, li] := '1'
      else
        opnovaA.Cells[col, li] := '0';

//---

  A.ColCount := cols_entrada + rows_entrada;
  A.RowCount := rows_entrada;
  lblA.caption := 'A tem ' + inttostr(a.colCount) + ' colunas e ' + inttostr(a.rowCount) + ' linhas';

  for col := cols_entrada to a.ColCount - 1 do
    for li := 0 to a.RowCount - 1 do
      if li = col - cols_entrada then
        A.Cells[col, li] := '1'
      else
        A.Cells[col, li] := '0';

  CT.colCount := cols_entrada + rows_entrada;
  CT.rowCount := 1;

  for col := cols_entrada to CT.ColCount - 1 do
    CT.cells[col,0] := '0';

  Salvar(msgFPI);
end;

procedure TFormPrincipal.Salvar(msg: string);
var f: TextFile;
    col, li: integer;
begin
  assignfile(f, OpenDialog.InitialDir + '\' + copy(ExtractFileName(OpenDialog.FileName), 1, length(ExtractFileName(OpenDialog.FileName)) - 4) + '.html');
  if msg = 'Começo' then
  begin
    rewrite(f);
    writeln(f, '<html>');
    writeln(f, '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>');
    writeln(f, '<title>Simplex ' + OpenDialog.fileName + '</title>');
    writeln(f, '<style type="text/css">');
    writeln(f, '#customers');
    writeln(f, '{');
    writeln(f, 'font-family:Arial;');
    writeln(f, 'border-collapse:collapse;');
    writeln(f, '}');
    writeln(f, '#customers td');
    writeln(f, '{');
    writeln(f, 'font-size:1em;');
    writeln(f, 'border:1px solid green;');
    writeln(f, 'padding:3px 7px 2px 7px;');
    writeln(f, 'height:10px;');
    writeln(f, '}');
    writeln(f, '#customers tr.alt td');
    writeln(f, '{');
    writeln(f, 'color:#000000;');
    writeln(f, 'background-color:#EAF2D3;');
    writeln(f, '}');
    writeln(f, '</style>');
    writeln(f, '</head>');
    writeln(f, '<body bgcolor="gainsboro">');
  end
  else
    append(f);

  if not cbSalvar.Checked then
  begin
    write(f, msg);
    writeln(f, '<br/><br/>');
    writeln(f, '<table id="customers" class="fix">');
    writeln(f, '<tr>');

    for col := 0 to opNovaCT.ColCount - 1 do
    begin
      write(f, '<td>');
      write(f, opnovact.cells[col, 0]);
      writeln(f, '</td>');
    end;

    for col := 0 to novaCT.ColCount - 1 do
    begin
      write(f, '<td>');
      write(f, novact.cells[col, 0]);
      writeln(f, '</td>');
    end;

    write(f, '<td>');
    write(f, novow0.text);
    writeln(f, '</td>');
    writeln(f, '</tr>');

    for li := 0 to novaa.RowCount - 1 do
    begin
      if not odd(li) then
        writeln(f, '<tr class="alt">')
      else
        writeln(f, '<tr>');

      for col := 0 to opNovaA.ColCount - 1 do
      begin
        write(f, '<td>');
        write(f, opnovaA.cells[col, li]);
        writeln(f, '</td>');
      end;

      for col := 0 to novaA.ColCount - 1 do
      begin
        write(f, '<td><b>');
        write(f, novaA.cells[col, li]);
        writeln(f, '</b></td>');
      end;

      write(f, '<td>');
      write(f, novob.cells[0, li]);
      writeln(f, '</td>');
      writeln(f, '</tr>');
    end;

    writeln(f, '</table>');
    writeln(f);
    writeln(f, '<br/><hr/><br/>');
    writeln(f);
  end;
  closefile(f);
end;

procedure TFormPrincipal.PivoterColLiClick(Sender: TObject);
begin
  inputQuery('Coluna', 'Escolha de 0 a ' + inttostr(novaa.ColCount - 1), query.col);
  inputQuery('Linha', 'Escolha de 0 a ' + inttostr(novaa.RowCount - 1), query.li);
  if application.MessageBox(PChar('Pivotear col = ' + query.col + ', li = ' + query.li + ' ?'), 'Confirmação', MB_ICONEXCLAMATION + mb_yesno) = mryes then
    Pivotear('Manualmente ', ConstruirPivot(strtoint(query.col), strtoint(query.li)));
end;

procedure TFormPrincipal.CalcularxClick(Sender: TObject);
var col, li, n, cols_entrada: integer;
    s, texto: string;
    f: textFile;
    tudoMenorIgualZero, AxMenorQueB, AxMaiorQueB,
    temNegativo, temPositivo, tudoZero, flagInterromper: boolean;
    piv: TPivot;
begin
  flagInterromper := false;
  x.ColCount := 1;
  x.RowCount := novaa.ColCount;
  cTmenosyTA.ColCount := 1;
  cTmenosyTA.RowCount := novaa.ColCount;

  for col := 0 to novaa.ColCount - 1 do
    x.cells[0, col] := Pivot(col);

  s := '0';
  for col := 0 to ct.colcount - 1 do
    s := FracbMaisAx(s, ct.cells[col, 0], x.cells[0, col]);

  texto := 'c<sup>T</sup> x = ' + s + '<br/>';

  AxMenorQueB := false;
  AxMaiorQueB := false;
  for li := 0 to a.RowCount - 1 do
  begin
    s := '0';
    for col := 0 to a.colcount - 1 do
      s := FracbMaisAx(s, a.cells[col, li], x.cells[0, col]);

    if FracCompare(s, b.Cells[0, li]) < 0 then
    begin
      texto := texto + '<br/>A<sub>' + inttostr(li + 1) + '</sub> x = ' + s;
      texto := texto + ' < ';
      AxMenorQueB := true;
      texto := texto + 'b<sub>' + inttostr(li + 1) + '</sub>';
    end
    else if FracCompare(s, b.Cells[0, li]) > 0 then
	  begin
      texto := texto + '<br/>A<sub>' + inttostr(li + 1) + '</sub> x = ' + s;
      texto := texto + ' > ';
      AxMaiorQueB := true;
      texto := texto + 'b<sub>' + inttostr(li + 1) + '</sub>';
    end;
  end;

  assignfile(f, OpenDialog.InitialDir + '\' + copy(ExtractFileName(OpenDialog.FileName), 1, length(ExtractFileName(OpenDialog.FileName)) - 4) + '.html');
  append(f);
  write(f, '<b>', fimDoJogo, '</b><br/><br/>Multiplicando a matriz inicial por x<sup>T</sup> = (');

  for col := 0 to novaa.ColCount - 2 do
    write(f, x.cells[0, col], ' ; ');

  writeln(f, x.cells[0, novaa.colcount - 1], ')<br/><br/>');

  writeln(f, texto);

  if AxMaiorQueB then
    writeln(f, '<br/>Ax MAIOR QUE b? Solução inválida.');

  if AxMenorQueB then
    writeln(f, '<br/>Ax &#x2260; b. <b>Solução inválida.</b>');

  texto := '';
  for col := 0 to novaa.ColCount - 1 do
    if FracCompare(x.Cells[0, col], '0') < 0 then
      texto := texto + 'x<sub>' + inttostr(col + 1) + '</sub> < 0; ';

  if texto <> '' then
    writeln(f, '<br/><b>Solução inválida.</b> ', texto);

  temNegativo := false;
  temPositivo := false;

  texto := '(';
  for li := 0 to novaa.colcount - 1 do
  begin
    s := '0';
    for col := 0 to opnovact.colcount - 1 do
      s := FracbMaisAx(s, opNovaCT.cells[col, 0], a.cells[li, col]);

    if FracCompare(s, '0') < 0 then
      temNegativo := true
    else if FracCompare(s, '0') > 0 then
      temPositivo := true;

    cTMenosyTa.cells[0, li] := FracSub(ct.Cells[li, 0], s);

    texto := texto + s + ' ; ';
  end;
  delete(texto, length(texto) - 2, 3);

  s := '0';
  for col := 0 to opnovact.colcount - 1 do
    s := FracbMaisAx(s, b.cells[0, col], opNovaCT.cells[col, 0]);

  writeln(f);

  write(f, '<br/><br/>y<sup>T</sup> = (');
  for col := 0 to opNovaCT.ColCount - 2 do
    write(f, opnovaCT.cells[col, 0], ' ; ');

  writeln(f, opnovaCT.cells[opnovaCT.colcount - 1, 0], ')<br/>');

  write(f, 'y<sup>T</sup> b = ', s, ' ; y<sup>T</sup> A = ', texto, ')');
  if ((FracCompare(s, '0') < 0) and (not temNegativo)) or
     ((FracCompare(s, '0') > 0) and (not temPositivo)) then
    writeln(f, '<br/><b>Certificado de Inviabilidade</b>');

  temNegativo := false;
  temPositivo := false;

  write(f, '<br/><br/>c<sup>T</sup> - y<sup>T</sup>A = (');
  texto := '';
  for li := 0 to novact.colcount - 1 do
  begin
    texto := texto + ctmenosyta.cells[0, li] + ' ; ';

    if FracCompare(ctmenosyta.cells[0, li], '0') < 0 then
      temNegativo := true
    else if FracCompare(ctmenosyta.cells[0, li], '0') > 0 then
      temPositivo := true;
  end;

  delete(texto, length(texto) - 2, 3);
  write(f, texto, ')');

  if temNegativo and (not temPositivo) then
    writeln(f, ' < 0<br/>')
  else if (not temNegativo) and temPositivo then
    writeln(f, ' > 0<br/>')
  else if (not temNegativo) and (not temPositivo) then
    writeln(f, ' = 0<br/>')
  else
    writeln(f, '<br/>');

  s := '0';
  texto := '';
  for col := 0 to novact.ColCount - 1 do
  begin
    texto := texto + novaCT.cells[col, 0] + ' ; ';
    s := FracbMaisAx(s, ct.Cells[col, 0], x.cells[0, col]);
  end;
  delete(texto, length(texto) - 2, 2);

  if FracCompare(s, novow0.text) = 0 then
  begin
    writeln(f, 'y<sup>T</sup> b = c<sup>T</sup> x = ', s, '<br/>');
    if not temPositivo then
	  begin
      writeln(f, '<b>Certificado de solução ótima</b> = x.<br/>');

      if Criarvariveisauxiliares.checked then
      begin
        if FracCompare(s, '0') = 0 then
        begin
          writeln(f, '<br/>Este é o simplex auxiliar. O sistema original é solúvel. Trate de achar ótima/ilimitada!<br/>');
          flagInterromper := true;
        end
        else if FracCompare(s, '0') < 0 then
          writeln(f, '<br/>Este é o simplex auxiliar. O sistema original é inviável. Compare y<sup>T</sup> b com as ' + inttostr(a.colcount - a.rowCount) + ' primeiras colunas de y<sup>T</sup> A.<br/>');
      end;
    end;
  end
  else
    writeln(f, 'y<sup>T</sup> b &#x2260; c<sup>T</sup> x = ', s, '<br/>');

  if IsOTIMA and flagInterromper then
  begin
    writeln(f, '<br/><br/><hr/><br/>');
    closefile(f);
    Init; // mesmo nomeArq
    application.ProcessMessages;
    sleep(100);

    memotemp.Clear;
    for col := 0 to A.ColCount - 1 do
    begin
      li := Canonica(col, true);
      if li >= 0 then
        memoTemp.Lines.Add(inttostr(col) + ',' + inttostr(li));
    end;

    Criarvariveisauxiliares.Checked := false;
    msgFPI := 'Continuamos com FPI sem auxiliares';

    cols_entrada := a.colcount;

    novaA.ColCount := cols_entrada;
    x.ColCount := 1;
    x.RowCount := novaa.ColCount;
    cTmenosyTA.ColCount := 1;
    cTmenosyTA.RowCount := novaa.ColCount;
    lblnovaA.caption := 'nova A tem ' + inttostr(novaa.colCount) + ' colunas e ' + inttostr(novaa.rowCount) + ' linhas';

    novaCT.colCount := cols_entrada;
    novaCT.rowCount := 1;

    for col := 0 to cols_entrada - 1 do
      novaCT.cells[col,0] := FracOposto(ct.Cells[col, 0]);

    for col := 0 to opnovact.ColCount - 1 do
      opNovaCT.Cells[col, 0] := '0';

    novow0.text := w0.Text;

    Salvar(msgFPI);

    msgFPI := 'Começo';
    sleep(100);

    li := 0;
    memoTemp.show;
    flagsaida := false;
    while (MemoTemp.Lines.Count > 0) and (not flagSaida) do
    begin
      s := memoTemp.Lines[li];
      col := pos(',', s);
      piv.col := strToInt(copy(s, 1, col - 1));
      delete(s, 1, col);
      piv.li := strToInt(s);

      if IsILIMITADA or IsINVIAVEL or IsOTIMA then
        break;

      //break;
      Pivotear('Pela continuação do auxiliar', piv);
      if Canonica(piv.col, true) = piv.li then
        MemoTemp.Lines.Delete(li)
      else if pos('(' + inttostr(piv.col) + ', ' + inttostr(piv.li) + ')', memo.Text) = 0 then
        inc(li)
      else
        MemoTemp.Lines.Delete(li);
      if li = MemoTemp.Lines.Count then
        li := 0;
      application.processMessages;
    end;
    //memoTemp.hide;

    //PrimalNegativosPlayClick(Sender);
    sleep(100);

    //CalcularxClick(sender); // recursividade
    exit;
  end;

//quais colunas são < 0 ?
  for col := 0 to novact.colcount - 1 do
  begin
    if FracCompare(novact.cells[col, 0], '0') < 0 then
    begin
      tudoMenorIgualZero := true;
      for li := 0 to novaa.rowcount - 1 do
        if FracCompare(novaa.cells[col, li], '0') > 0 then
        begin
          tudoMenorIgualZero := false;
          break;
        end;

      if not tudoMenorIgualZero then
        break;

      for li := 0 to novact.colcount - 1 do
      begin
        n := canonica(li, false);
        if n >= 0 then
          cTMenosyTa.cells[0, li] := FracOposto(novaa.cells[col, n])
        else if li = col then
          cTMenosyTa.cells[0, li] := '1'
        else
          ctmenosyta.cells[0, li] := '0';
      end;

      writeln(f, '<br/><br/>');
      write(f, 'd = (');
      for li := 0 to novact.colcount - 2 do
        write(f, ctmenosyta.cells[0, li], ' ; ');
      writeln(f, ctmenosyta.cells[0, novact.colcount - 1], ') > 0<br/>');

      tudoZero := true;
      for li := 0 to novaa.rowCount - 1 do
      begin
        s := '0';
        for n := 0 to novaa.colcount - 1 do
          s := FracbMaisAx(s, ctmenosyta.cells[0, n], novaa.cells[n, li]);

        writeln(f, 'A<sub>', li + 1, '</sub> d = ', s, '<br/>');
        if FracCompare(s, '0') <> 0 then
          tudoZero := false;
      end;

      if not tudoZero then
        writeln(f, 'Veja que o certificado de ilimitada é capenga.<br/>');

      s := '0';
      for li := 0 to novact.colcount - 1 do
        s := FracbMenosAx(s, ctmenosyta.cells[0, li], novaCT.cells[li, 0]);

      if FracCompare(s, '0') > 0 then
        writeln(f, 'c^T d = ', s, ' > 0<br/><b>Certificado de ilimitada.</b><br/>')
      else
        writeln(f, 'c^T d = ', s, '<br/>');
      break;
    end;
  end;

  for col := 0 to novaCT.colCount - 1 do
    if novaCT.cells[col, 0] = '0' then
	  if canonica(col, true) = -1 then
	    for li := 0 to novaa.rowcount - 1 do
		  if FracCompare(novaa.cells[col, li], '0') > 0 then
		    writeln(f, 'Primal de zero: ', col, ', ', li, '<br/>');
  
  writeln(f);
  writeln(f, '<br/><br/><hr/><br/>');
  writeln(f);
  closefile(f);
  ShellExecute(handle, 'open',
    PChar(OpenDialog.InitialDir + '\' + copy(ExtractFileName(OpenDialog.FileName), 1, length(ExtractFileName(OpenDialog.FileName)) - 4) + '.html'),
    '',
    PChar(OpenDialog.InitialDir),
    SW_MAXIMIZE);
end;

procedure TFormPrincipal.DescerdiretoClick(Sender: TObject);
var col, li, cols_entrada, rows_entrada: integer;
begin
  Memo.Clear;
  query.col := '0';
  query.li := '0';

  cols_entrada := a.colcount;
  rows_entrada := a.rowcount;

  novaA.ColCount := cols_entrada;
  novaA.RowCount := rows_entrada;
  x.ColCount := 1;
  x.RowCount := novaa.ColCount;
  cTmenosyTA.ColCount := 1;
  cTmenosyTA.RowCount := novaa.ColCount;
  lblnovaA.caption := 'nova A tem ' + inttostr(novaa.colCount) + ' colunas e ' + inttostr(novaa.rowCount) + ' linhas';

  for col := 0 to cols_entrada - 1 do
    for li := 0 to novaa.RowCount - 1 do
      novaA.Cells[col,li] := a.cells[col, li];

  novoB.colCount := 1;
  novoB.rowCount := rows_entrada;

  for li := 0 to novob.RowCount - 1 do
    novoB.cells[0,li] := b.cells[0,li];

  novow0.text := w0.text;

  novaCT.colCount := cols_entrada;
  novaCT.rowCount := 1;

  for col := 0 to cols_entrada - 1 do
    novaCT.cells[col,0] := FracOposto(ct.Cells[col, 0]);

  opnovact.ColCount := rows_entrada;
  opnovact.RowCount := 1;
  for col := 0 to opnovact.ColCount - 1 do
    opNovaCT.Cells[col, 0] := '0';

  opNovaA.ColCount := rows_entrada;
  opnovaa.rowcount := rows_entrada;

  for col := 0 to opnovaa.ColCount - 1 do
    for li := 0 to opnovaa.RowCount - 1 do
      if li = col then
        opnovaA.Cells[col, li] := '1'
      else
        opnovaA.Cells[col, li] := '0';

  Salvar(msgFPI);
end;

procedure TFormPrincipal.rocarosinaldalinhaClick(Sender: TObject);
begin
  inputQuery('Linha', 'Escolha de 0 a ' + inttostr(novaa.RowCount - 1), query.li);
  if application.MessageBox(PChar('Trocar sinal li = ' + query.li + ' ?'), 'Confirmação', MB_ICONEXCLAMATION + mb_yesno) = mryes then
    OpostoLinha(strtoint(query.li));
end;

procedure TFormPrincipal.CriarvariveisauxiliaresClick(Sender: TObject);
var li, col: integer;
begin
  Criarvariveisauxiliares.Checked := not Criarvariveisauxiliares.Checked;

  if Criarvariveisauxiliares.Checked then
  begin
    for li := 0 to b.RowCount - 1 do
      if FracCompare(b.Cells[0, li], '0') < 0 then
      begin
        for col := 0 to novaa.ColCount - 1 do
          a.Cells[col, li] := FracOposto(a.Cells[col, li]);

        b.Cells[0, li] := FracOposto(b.Cells[0, li]);
      end;

    for li := 0 to ct.ColCount - 1 do
      ct.cells[li, 0] := '0';
    ct.ColCount := ct.ColCount + a.rowcount;
    a.colcount := a.ColCount + a.RowCount;
    lblA.caption := 'A tem ' + inttostr(a.colCount) + ' colunas e ' + inttostr(a.rowCount) + ' linhas';
    for li := 1 to a.rowcount do
    begin
      for col := 1 to a.rowcount do
        if li = col then
          a.Cells[a.colcount - li, a.rowcount - li] := '1'
        else
          a.Cells[a.colcount - li, a.rowcount - col] := '0';
        ct.Cells[a.colcount - li, 0] := '-1';
    end;

    DescerdiretoClick(Sender);

    //Salvar('Criamos variáveis auxiliares');

    for li := 1 to novaa.RowCount do
      Pivotear('Pelo Simplex Auxiliar', construirPivot(novaa.colcount - li, novaa.rowcount - li));
  end
  else
  begin
    cT.ColCount := 0;
    ct.cells[0,0] := '';
    w0.Clear;
    a.ColCount := 0;
    a.RowCount := 0;
    lblA.caption := 'A';
    a.Cells[0,0] := '';
    b.RowCount := 0;
    b.Cells[0,0] := '';
    memo.clear;
    opNovaCT.ColCount := 0;
    opNovaCT.Cells[0,0] := '';
    novaCT.ColCount := 0;
    novaCT.Cells[0,0] := '';
    novow0.Clear;
    opNovaA.ColCount := 0;
    opNovaA.RowCount := 0;
    lblnovaA.caption := 'nova A';
    opNovaA.Cells[0,0] := '';
    novaA.ColCount := 0;
    novaA.RowCount := 0;
    novaA.Cells[0,0] := '';
    novoB.RowCount := 0;
    novoB.Cells[0,0] := '';
    x.ColCount := 0;
    x.RowCount := 0;
    x.Cells[0,0] := '';
  end;
end;

function TFormPrincipal.EscolherColuna(var coluna, linha: integer): boolean;
var mincoluna: integer;
begin
  while TudoZeroB and (linha <= novob.RowCount - 1) do
    inc(linha);

  if linha = novoB.rowCount then
  begin
    result := false;
    exit;
  end;

  coluna := 0;
  while FracCompare(novaa.cells[coluna, linha], '0') >= 0 do // negativo com negativo. vamos rodar opostocoluna abaixo
  begin
    inc(coluna);
    if coluna = novaa.colcount then
    begin
      result := false;
      exit;
    end;
  end;
  mincoluna := coluna;

  repeat
    inc(coluna);
    if coluna >= novaa.colcount then
      break;
    if FracCompare(novaa.Cells[coluna, linha], '0') >= 0 then // negativo com negativo. vamos rodar opostocoluna abaixo
      continue;
    if canonica(coluna, true) >= 0 then
      continue;

    if FracCompare(FracAbs(FracDiv(novact.cells[coluna, 0], novaa.cells[coluna, linha]))
         ,
         FracAbs(FracDiv(novact.cells[coluna, 0], novaa.cells[mincoluna, linha]))) > 0 then

      if pos('(' + inttostr(mincoluna) + ', ' + inttostr(linha) + ')', memo.Text) = 0 then

        mincoluna := coluna;

  until false;

  coluna := mincoluna;
  result := (coluna < novaa.colcount) and (FracCompare(novaa.Cells[coluna, linha], '0') < 0) and (pos('(' + inttostr(mincoluna) + ', ' + inttostr(linha) + ')', memo.Text) = 0);
end;

procedure TFormPrincipal.PrimalNegativosUmMovimentoClick(Sender: TObject);
var li, col: integer;
    continuar: boolean;
begin
  continuar := true;
  col := 0;
  if not IsILIMITADA then
    if not IsINVIAVEL then
      if not IsOTIMA then
        while col <= novaCT.colCount - 1 do
        begin
          if FracCompare(novact.Cells[col, 0], '0') < 0 then
          begin
            if EscolherLinha(col, li, false) then
            begin
            Pivotear('Pelo Primal de Negativos', ConstruirPivot(col, li));
            continuar := false;
            break;
            end;
          end;
          inc(col);
        end;

  if not continuar then
    exit;

  fimDoJogo := 'Fim do Primal de Negativos';
  CalcularxClick(Sender);
  flagSaida := true;
end;

function TFormPrincipal.EscolherLinha(var coluna, linha: integer; primalZero: boolean): boolean;
var minlinha, col: integer;
begin
  while TudoZeroCT and (coluna <= novact.colCount - 1) and (canonica(coluna, true) >= 0) do
    inc(coluna);

  if coluna = novact.colCount then
  begin
    result := false;
    exit;
  end;

  linha := 0;
  while FracCompare(novaa.cells[coluna, linha], '0') <= 0 do
  begin
    inc(linha);
    if linha = novaa.rowcount then
    begin
      result := false;
      exit;
    end;
  end;
  minlinha := linha;

  repeat
    inc(linha);
    if linha >= novaa.rowcount then
      break;
    if FracCompare(novaa.Cells[coluna, linha], '0') <= 0 then
      continue;

  //verificar se ExisteCanonica(linha)
    if primalZero then
    begin
      col := 0;
      while col <= novaa.ColCount - 1 do
      begin
        if canonica(col, true) = linha then
          break;
        inc(col);
      end;
    end;

    if primalZero then
      if (col < novaa.colcount) and (canonica(col, true) = linha) then
        continue;

    if (FracCompare(FracAbs(FracDiv(novoB.cells[0, linha], novaa.cells[coluna, linha]))
                     ,
                    FracAbs(FracDiv(novoB.cells[0, minlinha], novaa.cells[coluna, minlinha]))) < 0) then
      if pos('(' + inttostr(coluna) + ', ' + inttostr(minlinha) + ')', memo.Text) = 0 then
        minlinha := linha;
  until false;

  if primalZero then
    if linha >= novaa.rowcount then
    begin
      result := false;
      exit;
    end;

  linha := minlinha;
  result := (linha < novaa.rowcount) and (FracCompare(novaa.Cells[coluna, linha], '0') > 0) and (pos('(' + inttostr(coluna) + ', ' + inttostr(minlinha) + ')', memo.Text) = 0);
end;

procedure TFormPrincipal.PrimalNegativosPlayClick(Sender: TObject);
var i: integer;
begin
  PanelCalcular.Hide;
  i := 0;
  flagSaida := false;
  repeat
    PrimalNegativosUmMovimentoClick(Sender);
    inc(i);
  until flagSaida or (i >= 100000);
  PanelCalcular.Show;
end;

procedure TFormPrincipal.btnFindClick(Sender: TObject);
var SearchRec: TSearchRec;
begin
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName) + '\testes';
  OpenDialog.FileName := '*.txt';

  if FindFirst(OpenDialog.InitialDir + '\' + OpenDialog.FileName, faArchive, searchrec) = 0 then
    repeat
      OpenDialog.FileName := searchRec.Name;
      nomeArq := OpenDialog.InitialDir + '\' + searchrec.Name;
      Init;
      application.ProcessMessages;
      sleep(100);

      FPIVariveisAuxiliaresClick(Sender);
      sleep(100);

      PrimalNegativosPlayClick(Sender);
    until FindNext(searchrec) <> 0;
end;

procedure TFormPrincipal.FPIVariveisAuxiliaresClick(Sender: TObject);
var cols_entrada, rows_entrada, col, li: integer;
begin
  if Criarvariveisauxiliares.Checked then
  begin
    CriarvariveisauxiliaresClick(Sender);
    exit;
  end;

  cols_entrada := a.colcount;
  rows_entrada := a.rowcount;

  A.ColCount := cols_entrada + rows_entrada;
  A.RowCount := rows_entrada;
  lblA.caption := 'A tem ' + inttostr(a.colCount) + ' colunas e ' + inttostr(a.rowCount) + ' linhas';

  for col := cols_entrada to a.ColCount - 1 do
    for li := 0 to a.RowCount - 1 do
      if li = col - cols_entrada then
        A.Cells[col, li] := '1'
      else
        A.Cells[col, li] := '0';

  CT.colCount := cols_entrada + rows_entrada;
  CT.rowCount := 1;

  for col := cols_entrada to CT.ColCount - 1 do
    CT.cells[col,0] := '0';

  CriarvariveisauxiliaresClick(Sender);
end;

procedure TFormPrincipal.DualummovimentoClick(Sender: TObject);
var col, li: integer;
    continuar: boolean;
begin
  continuar := true;
  li := 0;
  if not IsILIMITADA then
    if not IsINVIAVEL then
      if not IsOTIMA then
        while li <= novob.RowCount - 1 do
        begin
          if FracCompare(novob.Cells[0, li], '0') < 0 then
          begin
            if EscolherColuna(col, li) then
            begin
              OpostoLinha(li);
              Pivotear('Pelo Dual de Negativos', ConstruirPivot(col, li));
              continuar := false;
              break;
            end;
          end;
          inc(li);
        end;

  if not continuar then
    exit;

  fimDoJogo := 'Fim do Dual de Negativos';
  CalcularxClick(Sender);
  flagSaida := true;
end;

function TFormPrincipal.IsILIMITADA: boolean;
var
  col, li: integer;
  tudoMenorIgualZero: boolean;
begin
  Result := true;
//quais colunas são < 0 ?
  for col := 0 to novact.colcount - 1 do
    if FracCompare(novact.cells[col, 0], '0') < 0 then
    begin
      tudoMenorIgualZero := true;
      for li := 0 to novaa.rowcount - 1 do
        if FracCompare(novaa.cells[col, li], '0') > 0 then
        begin
          tudoMenorIgualZero := false;
          break;
        end;

      if tudoMenorIgualZero then
        for li := 0 TO novoB.RowCount - 1 do
          if FracCompare(novoB.Cells[0, li], '0') < 0 then      // b negativo
            if FracCompare(novaA.Cells[col, li], '0') = 0 then  // A zero => coordenada negativa limitada
            begin
              tudoMenorIgualZero := false;
              break;
            end;

      if tudoMenorIgualZero then
        exit; // return true
    end;

  Result := false;
end;

function TFormPrincipal.IsINVIAVEL: boolean;
var
  li, col: integer;
  tudoMenorIgualZero, tudoMaiorIgualZero: boolean;
begin
  Result := true;

  for li := 0 to novob.RowCount - 1 do
    if FracCompare(novob.Cells[0, li], '0') > 0 then
    begin
      tudoMenorIgualZero := true;
      for col := 0 to novaA.ColCount - 1 do
        if FracCompare(novaA.Cells[col, li], '0') > 0 then
        begin
          tudoMenorIgualZero := false;
          break;
        end;
      if tudoMenorIgualZero then
        exit; // return true
    end
    else if FracCompare(novob.Cells[0, li], '0') < 0 then
    begin
      tudoMaiorIgualZero := true;
      for col := 0 to novaA.ColCount - 1 do
        if FracCompare(novaA.Cells[col, li], '0') < 0 then
        begin
          tudoMaiorIgualZero := false;
          break;
        end;
      if tudoMaiorIgualZero then
        exit; // return true
    end;

  Result := false;
end;

function TFormPrincipal.IsOTIMA: boolean;
var
  col, li: integer;
  s, yTb: string;
  //tudoZero: boolean;
begin
  Result := false;
{
  if Criarvariveisauxiliares1.Checked then
    if FracCompare(novow0.Text, '0') > 0 then
      exit;
}
  for li := 0 to novaa.colcount - 1 do
  begin
    s := '0';
    for col := 0 to opnovact.colcount - 1 do
      s := FracbMaisAx(s, opNovaCT.cells[col, 0], a.cells[li, col]);

    cTMenosyTa.cells[0, li] := FracSub(ct.Cells[li, 0], s);
    if FracCompare(ctmenosyta.cells[0, li], '0') > 0 then
      exit;  // return false;
  end;
{
  //tudo Zero no manual é ótima, mas está agarrando o dual
  tudoZero := true;
  for li := 0 to novaa.colcount - 1 do
    if FracCompare(ctmenosyta.cells[0, li], '0') <> 0 then
    begin
      tudoZero := false;
      break;
    end;
  if tudoZero then
    exit;
}
  for col := 0 to novaa.ColCount - 1 do
  begin
    x.cells[0, col] := Pivot(col);
    if FracCompare(x.Cells[0, col], '0') < 0 then
      exit;
  end;

  s := '0';
  for col := 0 to novact.ColCount - 1 do
    s := FracbMaisAx(s, ct.Cells[col, 0], x.cells[0, col]);

  yTb := '0';
  for col := 0 to opnovact.colcount - 1 do
    yTb := FracbMaisAx(yTb, b.cells[0, col], opNovaCT.cells[col, 0]);

  if FracCompare(s, yTb) <> 0 then
    exit;

  for li := 0 to a.RowCount - 1 do
  begin
    s := '0';
    for col := 0 to a.colcount - 1 do
      s := FracbMaisAx(s, a.cells[col, li], x.cells[0, col]);

    if FracCompare(s, b.Cells[0, li]) <> 0 then
      exit;
  end;

  Result := true;
end;

procedure TFormPrincipal.DualPlayClick(Sender: TObject);
var i: integer;
begin
  PanelCalcular.Hide;
  i := 0;
  flagSaida := false;
  repeat
    DualummovimentoClick(Sender);
    inc(i);
  until flagSaida or (i >= 100000);
  PanelCalcular.Show;
end;

procedure TFormPrincipal.lblSalvarClick(Sender: TObject);
begin
  cbSalvar.Checked := not cbSalvar.Checked;
end;

procedure TFormPrincipal.MemoDblClick(Sender: TObject);
begin
  if flagSaida then
    memo.Clear;
end;

procedure TFormPrincipal.PrimalZeroUmmovimentoClick(
  Sender: TObject);
var li, col: integer;
    continuar: boolean;
    //oldcaption: string;
begin
  continuar := true;
  //oldcaption := caption;
  col := 0;
  if not IsILIMITADA then
    if not IsINVIAVEL then
      if not IsOTIMA then
        while col <= novaCT.colCount - 1 do
        begin
          //caption := oldCaption + ' coluna ' + inttostr(col);
          //application.Title := oldCaption + ' coluna ' + inttostr(col);

          if FracCompare(novact.Cells[col, 0], '0') = 0 then
          begin
            if EscolherLinha(col, li, true) then
            begin
              Pivotear('Pelo Primal de Zero', ConstruirPivot(col, li));
              continuar := false;
              break;
            end;
          end;
          inc(col);
        end;

  if not continuar then
    exit;

  //caption := oldCaption;
  //application.Title := oldCaption;
  fimDoJogo := 'Fim do Primal de Zero';
  CalcularxClick(Sender);
  flagSaida := true;
end;

procedure TFormPrincipal.PrimalZeroPlayClick(Sender: TObject);
var i: integer;
begin
  PanelCalcular.Hide;
  i := 0;
  flagSaida := false;
  repeat
    PrimalZeroUmmovimentoClick(Sender);
    inc(i);
  until flagSaida or (i >= 100000);
  PanelCalcular.Show;
end;

procedure TFormPrincipal.btnCancelarClick(Sender: TObject);
begin
  flagSaida := true;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  msgFPI := 'Começo';
end;

end.
