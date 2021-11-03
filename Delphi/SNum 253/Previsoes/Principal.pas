unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    btnCalcular: TButton;
    Memo: TMemo;
    cbDividir: TCheckBox;
    cb1000: TCheckBox;
    cbMover: TCheckBox;
    procedure btnCalcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum, SNum253;

function TamanhoArq(s: string): integer;
var f: file of char;
begin
  if not fileExists(s) then
    result := 0
  else
  begin
    assignFile(f, s);
    reset(f);
    Result := fileSize(f);
    closeFile(f);
  end;
end;

procedure TFormPrincipal.btnCalcularClick(Sender: TObject);
var G: file of longword;
    p: longword;
    i, i_final, d253, d10, tamanho, acumulado, pasta: integer;
    x, y, c253, c10: double;
    nomeArq1, nomeArq, linha, s, s2, q, r: string;
    dateTime1, dateTime2: TDateTime;
    F: TEXTFILE;
    FLAGODD: BOOLEAN;
begin
  btnCalcular.enabled := false;

  assignfile(f, 'J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\primos de euclides.htm');
  append(f);
  flagodd := true;

  fileMode := 0;
  assignFile(g, 'J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\primos novos.dat');
  reset(g);
  //seek(f, 207408);
  //closefile(f);
  //button1.enabled := true;
  //exit;

  ReadLine('J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\produtorio253A.ini', s);
  i_final := StrToInt(s); // 22130

  memo.lines.add('n ; dígitos253 ; dígitos10 ; tamanho ; acumulado ; pasta');
  x := 0;
  y := 0;
  acumulado := 0;
  pasta := 1;
  p := 2;
  c253 := 1/ln(253);
  c10 := 1/ln(10);
  s2 := #2;
  DateTime1 := 0;
  nomeArq1 := '';
  for i := 0 to i_final do
  begin
    if i <= MAXLONGINT then
      nomeArq := 'J:\PRIMORIAIS1\n' + inttostr(i) + 'p' + inttostr(p) + '.253'
    else
      nomeArq := 'J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\bolao\n' + inttostr(i) + 'p' + inttostr(p) + '.253';

    x := x + ln(p) * c253;
    y := y + ln(p) * c10;
    d253 := trunc(x) + 1;
    d10 := trunc(y) + 1;
    tamanho := TamanhoArq(nomeArq);

    if fileExists(nomeArq) and (y >= 2000000) then
    BEGIN
      inc(acumulado, tamanho);

        if flagOdd then
          write(f, '<tr>')
        else
          write(f, '<tr class="alt">');
        flagOdd := not flagOdd;

        write(f, '<td>');
        write(f, i);
        write(f, '</td><td>');
        write(f, p);
        write(f, '</td><td>');
        write(f, d253);
        write(f, '</td><td>');
        write(f, d10);
        write(f, '</td><td>');

        write(f, '<a href="n' + INTTOSTR(i) + 'p' + inttostr(p) + '.253">file</a>');
        //ReadLine253(dir + '\n' + caption + 'p' + inttostr(p) + '.253', s);
        //for j := 1 to length(s) do
        //  write(f, ByteToHTML(byte(s[j])));

        //write(f, '</td><td>');
        //write(f, 'copy j:\primoriais1\n' + caption + 'p' + inttostr(p) + '.253');

        writeln(f, '</td></tr>');
    END;
    if acumulado > 50 * 1024 * 1024 then
    begin
      acumulado := tamanho;
      inc(pasta);
    end;

    linha := inttostr(i) + ' ; ' + inttostr(d253) + ' ; ' + inttostr(d10) + ' ; ' +
        inttostr(tamanho) + ' ; ' + floattostr(acumulado/(1024*1024)) + ' ; ' + inttostr(pasta);
    if (abs(d10 -  20000000) < 50) or
       (abs(d10 -  30000000) < 50) or
       (abs(d10 -  40000000) < 50) or
       (abs(d10 -  50000000) < 50) or
       (abs(d10 -  60000000) < 50) or
       (abs(d10 -  70000000) < 50) or
       (abs(d10 -  80000000) < 50) or
       (abs(d10 -  90000000) < 50) or
       (abs(d10 - 100000000) < 50) then
    begin
      memo.lines.add(linha);
      application.processmessages;
    end;
{
    if i >= 756622 then
    begin
      memo.lines.add(linha);
      application.processmessages;
    end;
}
    if cb1000.Checked then
      if d10 mod 1000 = 0 then
      begin
        memo.lines.add(linha);
        application.processMessages;
      end;

    if (tamanho <> d253) and (tamanho <> 0) then
    begin
      memo.lines.add(linha);
      application.processMessages;
      //break;
    end;

    if i mod 16 = 0 then
    begin
      caption := 'i = ' + inttostr(i);
      application.processMessages;
    end;

    if cbMover.checked and fileExists(nomeArq) then
    begin
      DateTime2 := FileDateToDateTime(FileAge(nomeArq));
      if DateTime2 - DateTime1 >= 4.0 {dia} / 24.0 / 60.0 then
      begin
        DateTime1 := DateTime2;
        nomeArq1 := nomeArq;
      end
      else
        moveFile(pchar(nomeArq), pchar('J:\PRIMORIAIS1\deletar\n' + inttostr(i) + 'p' + inttostr(p) + '.253'));
    end;

    s := s2;
    read(g, p);

    if cbDividir.checked then
    begin
      if i <= maxLongInt then
        nomeArq := 'J:\PRIMORIAIS1\n' + inttostr(i + 1) + 'p' + inttostr(p) + '.253'
      else if i <= 104000 then
        nomeArq := 'C:\PRIMORIAIS2\n' + inttostr(i + 1) + 'p' + inttostr(p) + '.253'
      else
        nomeArq := 'J:\_DESORDEM\Delphi\2016 08 24 C\Produtorio\bolao\n' + inttostr(i + 1) + 'p' + inttostr(p) + '.253';
      if not fileExists(nomeArq) then
        break;

      ReadLine253(nomeArq, s2);
      dec(s2[1]);
      Divide253(s2, s, q, r);
      From253to10(q);
      if (r <> #0) or (q <> inttostr(p)) then
      begin
        memo.lines.add(linha);
        memo.lines.add('q = ' + q + ' ; r <> 0');
        application.processMessages;
        break;
      end;
    end;

    if eof(g) or fileExists('cancelar.txt') then
      break;

    //if i mod 10 <> 0 then
    //  DeleteFile(nomeArq);
  end;
  closeFile(f);
  closeFile(g);
  btnCalcular.enabled := true;
  memo.lines.add(linha); // quero ver a última hehehe
end;

end.

