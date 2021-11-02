unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLstPrimos = file of Longword;
            // max int64 = 2^63 - 1 = 9223372036854775807
            // max longword =                  4294967295

  TForm1 = class(TForm)
    Edit: TEdit;
    Memo: TMemo;
    BtnCancel: TButton;
    BtnFatorar: TButton;
    BtnPausar: TButton;
    Lb: TLabel;
    BtnSaltar: TButton;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFatorarClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BtnPausarClick(Sender: TObject);
    procedure BtnSaltarClick(Sender: TObject);
  private
    { Private declarations }
  public
     cancel, pause: boolean;
     f: TLstPrimos;
  end;

var
  Form1: TForm1;

implementation

uses SNum;

const LstPrimos = 'primos novos.dat';

{$R *.DFM}

procedure LE(var f: TLstPrimos; var v: int64);
var p: longword;
begin
   read(f, p);
   v := p;
end;

procedure GRAVA(var f: TLstPrimos; var v: int64);
var p: longword;
begin
{   if v > 160000000 then
      begin
         CloseFile(f);
         Application.Terminate;
         exit;
      end;}
   p := v;
   write(f, p);
end;

procedure TForm1.BtnCancelClick(Sender: TObject);
begin
   pause := false;
   BtnPausar.Caption := 'Pausar';
   cancel := true; // muda flag para BtnFatorar
end;

procedure TForm1.BtnFatorarClick(Sender: TObject);
var x, ps, q, r, fatorado: string;
    p, p2: int64;
    n, counter, expo: integer;

// 23518382285074831439027407995760949

function espacos(s: string): string;
begin
   while Length(s) < n do
      s := ' ' + s;
   result := s;
end;

LABEL INICIO;
begin
//   memo.Clear;
INICIO:
   BtnFatorar.Enabled := false;
   counter := 0;

   x := Valida(Edit.text);
   Edit.text := x;
   if SNumCompare(x, '2') < 0 then x := '0';//exit;
   n := Length(Edit.Text);
   fatorado := x + ' = ';

   AssignFile(f, LstPrimos);
   if FileExists(LstPrimos)
      then reset(f)
      else rewrite(f);

{{{{{{{ manutençao
   p := 2;
   repeat
      LE(f, p2);
      if p2 < p then break;
      p := p2;
   until eof(f);

   if not eof(f) then
      begin
         seek(f, filepos(f) - 1);
         Truncate(f);
      end;
   CloseFile(f);
   exit;
}

   cancel := false;
   p := 2;
   if x = '0' then
      begin
         seek(f, FileSize(f) - 1);
         LE(f, p);
      end;
   ps := IntToStr(p);
   expo := 1;

   repeat
      if pause then
         begin
            Application.ProcessMessages;
            continue;
         end;

      Divide(x, ps, q, r);
      if (r = '0') and (x <> '0') then
         begin
            if pos(ps + ' * ', fatorado) > 0 then
               begin
                  inc(expo);
                  if q = '1' then
                     begin
                        fatorado := copy(fatorado, 1, length(fatorado) - 3);
                        fatorado := fatorado + ' ^ ' + IntToStr(expo) + ' * ';
                     end
               end
            else if expo = 1 then
               fatorado := fatorado + ps + ' * '
            else
               begin
                  fatorado := copy(fatorado, 1, length(fatorado) - 3);
                  fatorado := fatorado + ' ^ ' + IntToStr(expo) + ' * ' + ps + ' * ';
                  expo := 1;
               end;

            Memo.Lines.Add(espacos(inttostr(Memo.Lines.Count)) + ': ' + espacos(x) + #32#247#32 + espacos(ps) + ' = ' + espacos(q));
            Application.ProcessMessages;
            x := q;
         end
      else
         begin
//            Memo.Lines.Add(espacos(Memo.Lines.Count) + ': ' + espacos(x) + ' / ' + espacos(p) + ' = ' + espacos(x div p) + ',...');
            inc(counter);

         // próximo primo
            if eof(f) or (x = '0') then
               begin
                  inc(p);          // 2 => 3
                  if p mod 2 = 0
                     then inc(p);  // pular os pares
                  seek(f, 0);
                  while not eof(f) do
                     begin
                        LE(f, p2);
                        if p < p2 * p2 then break;

                        if p mod p2 = 0 then
                           begin
//                              Memo.Lines.Add(espacos(Memo.Lines.Count) + ': ' + espacos(p) + #32#247#32 + espacos(p2) + ' = ' + espacos(p div p2));
                              inc(p, 2);
                              seek(f, 0);
                           end
//                        else Memo.Lines.Add(espacos(Memo.Lines.Count) + ': ' + espacos(p) + ' > sqr(' + espacos(p2) + ')');
                     end;

                  Seek(f, FileSize(f));
                  GRAVA(f, p);
                  ps := IntToStr(p);
                  if counter mod 200 = 0 then
                     begin
                        Lb.Caption := ps;
                        Application.ProcessMessages;
                     end;
               end
            else
               begin
                  LE(f, p);
                  ps := inttostr(p);
                  if counter mod 1000 = 0 then
                     begin
                        Lb.Caption := '> ' + ps;
                        Application.ProcessMessages;
                     end;
               end;
         end;

      if (SNumCompare(x, ps) > 0) and (SNumCompare(x, Multiplica(ps, ps)) < 0) then
         begin
            Memo.Lines.Add(espacos(inttostr(Memo.Lines.Count)) + ': ' + espacos(x) + ' < ' + espacos(ps) + '²');
            Application.ProcessMessages;
            ps := x;
         end;
   until (x = '1') or cancel;

   if x = '1' then
      Memo.Lines.Add(espacos(inttostr(Memo.Lines.Count)) + ': FIM. ' + copy(fatorado, 1, length(fatorado) - 3))
   else if cancel then
      Memo.Lines.Add(espacos(inttostr(Memo.Lines.Count)) + ': FIM. ' + x + ' > ' + ps + '² = ' + Multiplica(ps, ps));

   seek(f, filesize(f) - 1);
   if not eof(f) then
      begin
         LE(f, p);
         lb.Caption := inttostr(p);
      end;

   BtnFatorar.Enabled := true;
   CloseFile(f);

   MEMO.LINES.ADD('');
   EXIT;
   IF NOT CANCEL THEN
      BEGIN
         x := Valida(Edit.text);
         EDIT.Text := Subtrai(X, '1');
         MEMO.LINES.ADD('');
         GOTO INICIO;
      END;
end;

procedure TForm1.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = vk_pause then
      BtnPausarClick(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
var f: TLstPrimos;
    p: int64;
begin
   pause := false;
   if not FileExists(LstPrimos) then exit;

   AssignFile(f, LstPrimos);
   reset(f);
   seek(f, filesize(f) - 1);
   if not eof(f) then
      begin
         LE(f, p);
         lb.Caption := inttostr(p);
      end;
end;

procedure TForm1.BtnPausarClick(Sender: TObject);
begin
   pause := not pause;

   if pause then
      BtnPausar.Caption := 'Continuar'
   else
      begin
         BtnPausar.Caption := 'Pausar';
         Memo.Clear;
      end;
end;

procedure TForm1.BtnSaltarClick(Sender: TObject);
var p: int64;
    dest: longword;
    i, lim1, lim2: integer; // pesq binária
begin
   val(Edit.text, dest, i);
   Edit.text := IntToStr(dest);
   Memo.Lines.Add('// Procurando ' + Edit.Text);

   lim1 := 0;
   lim2 := fileSize(f) - 1;
   repeat
      i := (lim1 + lim2) div 2;
      seek(f, i);
      Le(f, p);
      if p = dest then
         begin
            lim1 := i;
            break;
         end
      else if p > dest then
         lim2 := i
      else lim1 := i;
   until lim1 = lim2 - 1;

   seek(f, lim1);
   Le(f, p);

   Memo.Lines.Add('// Salto para ' + IntToStr(p));
   if Eof(f) then
      seek(f, FileSize(f) - 1);
end;

end.

