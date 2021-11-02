unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Memo1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure processar(nomearq, extensao: string);
    procedure processar2(nomearq, extensao: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Memo1DblClick(Sender: TObject);
begin
  processar2('ocaminho', '.sql');
  close;
end;

procedure TForm1.processar(nomearq, extensao: string);
var
  i, comeco: integer;
  s, m: string;
  f, g: textFile;
begin
  assignfile(f, 'D:\tenho offline\Delphi\Engolir\' + nomearq + extensao);
  reset(f);
  assignfile(g, 'D:\tenho offline\Delphi\Engolir\' + nomearq + ' novo' + extensao);
  rewrite(g);
  i := 0;
  comeco := 0;
  while not eof(f) do
  begin
    inc(i);
    readln(f, s);

(*
    if copy(s, 1, 2) = 'p.' then
    begin
      m := s;
      comeco := 1;
    end
    else if comeco = 0 then
      writeln(g, s)
    else if copy(s, 1, 1) = '"' then
      writeln(g, 's = ' + s + ';')
    else if copy(s, 1, 1) = '+' then
      if copy(s, length(s) - 1, 2) = ');' then
      begin
        delete(s, length(s) - 1, 1);
        writeln(g, 's = s ' + s);
        writeln(g, m + ' s);');
      end
      else writeln(g, 's = s ' + s + ';')
    else
      writeln(g, s);
*)

    if s = '' then
    begin
    end
    else if s[length(s)] in ['''', ',', ';', '{', '}'] then
    begin
    end
    else s := s + '''';

    writeln(g, s);

    caption := inttostr(i);
    application.processmessages;
  end;
  closefile(f);
  closefile(g);
end;

procedure TForm1.processar2(nomearq, extensao: string);
var
  i, j: integer;
  s, m: string;
  f, g: textFile;
begin
  assignfile(f, 'D:\' + nomearq + extensao);
  reset(f);
  assignfile(g, 'D:\' + nomearq + ' novo' + extensao);
  rewrite(g);
  i := 0;
  while not eof(f) do
  begin
    inc(i);
    readln(f, s);

    if copy(s, 1, 4) = '|| ' + '''' then
      j := 5
    else j := 1;

    while j < length(s) do
    begin
      if copy(s, j, 4) = '|| ' + '''' then
        if copy(s, j, 5) <> '|| ' + '''' + '''' then
        begin
          insert('''', s, j + 4);
          inc(j, 4);
        end;
      inc(j);
    end;

    if copy(s, length(s) - 1, 2) = '''' + '''' then
      delete(s, length(s), 1);

    writeln(g, s);

    caption := inttostr(i);
    application.processmessages;
  end;
  closefile(f);
  closefile(g);
  DeleteFile('D:\' + nomearq + extensao);
  MoveFile(pchar('D:\' + nomearq + ' novo' + extensao), pchar('D:\' + nomearq + extensao));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, ultimo: integer;
  s, m: string;
  f, g: textFile;

  procedure processarum(n: integer);
  begin
    inc(i, 3);
    while i <= n - 1 do
    begin
      readln(f, s);
      writeln(g, s);
      inc(i);
    end;
    dec(i);

    readln(f, s);
    writeln(g, s + ';');
    readln(f, s);
    writeln(g, 's = s ' + s);
  end;

  procedure processarfaixa(p, q: integer);
  begin
    repeat
      processarum(p);
      p := p + 100;
    until p > q;
  end;

begin
  assignfile(f, 'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  reset(f);
  assignfile(g, 'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A novo.java');
  rewrite(g);
{
  for i := 0 to 39400 - 2 do
  begin
    readln(f, s);
    writeln(g, s);
  end;

  readln(f, s);
  writeln(g, s + ';');
  readln(f, s);
  writeln(g, 's = s ' + s);

  processarFaixa(39400, 39900);

  while not eof(f) do
  begin
    readln(f, s);
    writeln(g, s);
  end;

}
  i := 0;
  ultimo := 0;
  while not eof(f) do
  begin
    inc(i);
    readln(f, s);

    if (copy(s, 1, 3) = 'p.e') or (copy(s, 1, 3) = 's =') then
    begin
      if i - ultimo > 100 then
      begin
        memo1.lines.add(inttostr(i) + ' ; ' + inttostr(i - ultimo) + ' ; ' + inttostr(ultimo));
        memo1.lines.add(m);
        memo1.lines.add(s);
      end;
      ultimo := i;
      m := s;
    end;

    caption := inttostr(i);
    application.processmessages;
  end;

{
  for i := 0 to 6500 - 2 do
  begin
    readln(f, s);
    writeln(g, s);
  end;

  readln(f, s);
  writeln(g, s + ';');
  readln(f, s);
  writeln(g, 's = s ' + s);

  processarum(6500);
  processarum(6600);
  processarum(12600);
  processarum(12700);
  processarfaixa(12800, 13200);
  processarum(17900);
  processarum(18000);
  processarum(18100);
  processarum(18900);
  processarfaixa(19000, 19600);
  processarfaixa(19800, 20500);
  processarfaixa(23400, 23600);
  processarfaixa(25600, 28300);
  processarum(31000);
  processarum(31200);
  processarfaixa(32200, 33200);
  processarfaixa(34500, 34800);
  processarum(35900);
  processarfaixa(36700, 37600);
  processarum(37900);
  processarfaixa(38100, 38300);
  processarum(39300);
  processarum(40300);
  processarum(40400);
  processarum(42200);
  processarum(43900);
  processarum(44000);
  processarfaixa(44700, 45100);
  processarum(45600);
  processarum(45700);
  processarum(46100);
  processarfaixa(47100, 47300);
  processarum(47900);
  processarfaixa(48100, 48300);
  processarum(48500);
  processarum(48600);
  processarum(49000);
  processarum(49100);
  processarum(49300);
  processarum(49700);


  for i := 0 to 31300 - 2 do
  begin
    readln(f, s);
    writeln(g, s);
  end;

  readln(f, s);
  writeln(g, s + ';');
  readln(f, s);
  writeln(g, 's = s ' + s);

  processarfaixa(31300, 31700);

  while not eof(f) do
  begin
    readln(f, s);
    writeln(g, s);
  end;
}
  closefile(f);
  closefile(g);
  //DeleteFile('D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  //MoveFile('D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A novo.java',
  //  'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  //close;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i, ultimo: integer;
  s, m: string;
  f, g: textFile;

  procedure maisdeumengolir(param: string);
  begin
    if pos('p.engolirCaminho(', param) = 0 then
      exit;

    if pos('", s);', param) = 0 then
      exit;

    s := copy(param, 1, pos('", s);', param) + 6);
    write(g, s);
    delete(param, 1, length(s));
    maisdeumengolir(param);
    s := param;
  end;

  procedure processar3(p, q, r: integer);
  begin
    readln(f, s);
    while i < r - 2 do
    begin
      inc(i);
      writeln(g, s);
      readln(f, s);
    end;

    while (pos('p.engolirCaminho(', s) = 0) or (copy(s, length(s) - 1, 2) = ');') do
    begin
      inc(i);
      writeln(g, s);
      readln(f, s);
    end;

    maisdeumengolir(s);

    m := s + ' s); ';
    writeln(g, 's =');
    inc(i);

    while copy(s, length(s) - 1, 2) <> ');' do
    begin
      readln(f, s);
      if copy(s, length(s) - 1, 2) = ');'
        then writeln(g, copy(s, 1, length(s) - 2) + ';')
      else writeln(g, s);
      inc(i);
    end;

    write(g, m);
  end;


begin
  assignfile(f, 'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  reset(f);
  assignfile(g, 'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A novo.java');
  rewrite(g);

  for i := 0 to 260 - 2 do
  begin
    readln(f, s);
    writeln(g, s);
  end;

  processar3(1052, 792, 260);
  processar3(1738, 456, 1282);
  processar3(2398, 660, 1738);
  processar3(2933, 535, 2398);
  processar3(3631, 698, 2933);
  processar3(4142, 511, 3631);
  processar3(4335, 193, 4142);
  processar3(4706, 371, 4335);
  processar3(5913, 1207, 4706);
  processar3(6113, 101, 6012);
  processar3(6304, 158, 6146);
  processar3(6787, 483, 6304);
  processar3(7642, 120, 7522);
  processar3(8642, 102, 8540);
  processar3(8750, 108, 8642);
  processar3(9361, 111, 9250);
  processar3(9938, 229, 9709);
  processar3(11204, 133, 11071);
  processar3(12852, 158, 12694);
  processar3(13521, 196, 13325);
  processar3(13956, 113, 13843);
  processar3(14543, 587, 13956);
  processar3(15158, 348, 14810);
  processar3(15637, 327, 15310);
  processar3(19900, 146, 19754);
  processar3(20496, 239, 20257);
  processar3(20876, 324, 20552);
  processar3(21207, 331, 20876);
  processar3(21654, 447, 21207);
  processar3(22126, 472, 21654);
  processar3(22484, 358, 22126);
  processar3(22604, 103, 22501);
  processar3(23616, 133, 23483);
  processar3(24890, 239, 24651);
  processar3(25524, 110, 25414);
  processar3(25675, 151, 25524);
  processar3(26653, 115, 26538);
  processar3(28688, 166, 28522);
  processar3(29977, 180, 29797);
  processar3(30547, 213, 30334);
  processar3(30777, 230, 30547);
  processar3(31010, 233, 30777);
  processar3(31346, 103, 31243);
  processar3(31527, 135, 31392);
  processar3(31667, 140, 31527);
  processar3(31879, 128, 31751);
  processar3(31996, 117, 31879);
  processar3(34711, 129, 34582);
  processar3(34881, 100, 34781);
  processar3(35070, 101, 34969);
  processar3(35713, 132, 35581);
  processar3(36595, 106, 36489);
  processar3(36714, 119, 36595);
  processar3(36829, 115, 36714);
  processar3(37678, 303, 37375);
  processar3(37805, 127, 37678);
  processar3(37924, 119, 37805);
  processar3(38210, 147, 38063);
  processar3(38312, 102, 38210);
  processar3(38498, 186, 38312);
  processar3(38739, 112, 38627);
  processar3(38938, 199, 38739);
  processar3(39094, 156, 38938);
  processar3(39295, 110, 39185);
  processar3(39472, 177, 39295);
  processar3(39857, 170, 39687);
  processar3(40431, 120, 40311);
  processar3(41322, 349, 40973);
  processar3(42482, 242, 42240);
  processar3(42582, 100, 42482);
  processar3(42945, 278, 42667);
  processar3(43513, 479, 43034);
  processar3(43808, 295, 43513);
  processar3(44073, 265, 43808);
  processar3(44510, 437, 44073);
  processar3(44637, 127, 44510);
  processar3(44782, 145, 44637);
  processar3(45071, 289, 44782);
  processar3(45189, 118, 45071);
  processar3(45406, 104, 45302);
  processar3(45555, 149, 45406);
  processar3(45735, 137, 45598);
  processar3(45838, 103, 45735);
  processar3(46046, 208, 45838);
  processar3(46280, 136, 46144);
  processar3(46465, 185, 46280);
  processar3(46779, 314, 46465);
  processar3(47221, 133, 47088);
  processar3(47484, 158, 47326);
  processar3(47768, 284, 47484);
  processar3(47982, 214, 47768);
  processar3(48181, 104, 48077);
  processar3(48545, 126, 48419);
  processar3(48811, 226, 48585);
  processar3(48955, 144, 48811);
  processar3(49123, 129, 48994);
  processar3(49432, 152, 49280);
  processar3(49651, 219, 49432);
  processar3(49978, 327, 49651);
  processar3(50158, 180, 49978);
  processar3(50491, 145, 50346);
  processar3(50614, 123, 50491);
  processar3(50851, 237, 50614);
  processar3(51541, 193, 51348);
  processar3(51958, 204, 51754);
  processar3(53199, 179, 53020);
  processar3(53934, 166, 53768);
  processar3(54450, 105, 54345);
  processar3(54944, 307, 54637);
  processar3(55903, 159, 55744);
  processar3(57658, 113, 57545);
  processar3(57880, 139, 57741);
  processar3(60433, 109, 60324);
  processar3(61212, 207, 61005);
  processar3(61451, 108, 61343);
  processar3(61752, 162, 61590);
  processar3(62692, 302, 62390);
  processar3(62940, 133, 62807);
  processar3(63788, 106, 63682);
  processar3(64936, 275, 64661);
  processar3(65244, 189, 65055);
  processar3(65644, 112, 65532);
  processar3(65948, 121, 65827);
  processar3(66499, 127, 66372);
  processar3(66697, 160, 66537);
  processar3(67698, 104, 67594);
  processar3(67872, 140, 67732);
  processar3(68643, 107, 68536);
  processar3(69306, 104, 69202);
  processar3(70276, 112, 70164);
  processar3(72705, 113, 72592);
  processar3(73163, 134, 73029);
  processar3(75008, 213, 74795);
  processar3(76739, 125, 76614);
  processar3(77971, 108, 77863);
  processar3(80145, 103, 80042);
  processar3(80637, 152, 80485);
  processar3(82171, 145, 82026);
  processar3(82796, 108, 82688);
  processar3(84366, 184, 84182);
  processar3(84689, 184, 84505);
  processar3(86074, 103, 85971);
  processar3(86176, 102, 86074);
  processar3(86671, 134, 86537);
  processar3(87374, 104, 87270);
  processar3(88364, 151, 88213);
  processar3(89462, 143, 89319);
  processar3(90662, 233, 90429);
  processar3(91400, 118, 91282);
  processar3(94455, 813, 93642);
  processar3(95055, 126, 94929);
  processar3(95223, 168, 95055);
  processar3(95489, 227, 95262);
  processar3(98370, 210, 98160);
  processar3(99367, 130, 99237);

  while not eof(f) do
  begin
    readln(f, s);
    writeln(g, s);
  end;


  closefile(f);
  closefile(g);
  DeleteFile('D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  MoveFile('D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A novo.java',
    'D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  close;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  s: string;
  i, j, k, max: integer;
begin
  max := 0;
  memo1.lines.LoadFromFile('D:\tenho offline\Delphi\Java\wiki2\wiki\src\main\java\br\com\calcula\wiki\Processar3A.java');
  s := memo1.text;
  i := 1;
  while i + 8 < length(s) do
  begin
    if copy(s, i, 8) = 'Section1' then
    begin
      j := i + 8;
      while (copy(s, j, 3) <> '");') and (copy(s, j, 3) <> 's);') and (copy(s, j, 3) <> 's =') do
        inc(j);
      if j - i > 60000 then
      begin
        memo2.Lines.add(inttostr(j - i));
        k := i - 1;
        repeat
          dec(k);
        until copy(s, k, 5) = 'p.eng';

        memo2.lines.add(copy(s, k, 40));
      end;

      if j - i > max then
        max := j - i;
    end;
    inc(i);
  end;
  showmessage(inttostr(max));
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  f, g: textfile;
  s, t, dirs, dirt: string;
  i: integer;
  flag: boolean;
begin
  assignfile(f, 'd:\ocaminho\listagem.txt');
  reset(f);
  assignfile(g, 'd:\ocaminho2.sql');
  rewrite(g);
  t := '';
  dirt := '';
  i := 0;
  while not eof(f) do
  begin
    readln(f, s);
    dirs := ExtractFilePath(s);
    s := ExtractFileName(s);
    if (copy(extractfileext(s), 1, 4) = '.htm') and (dirs = dirt) then
    begin
      repeat
        dirt := stringreplace(dirt, 'D:\ocaminho\', 'http://ocaminho.com.br/', [rfreplaceall]);
        dirt := stringreplace(dirt, '\', '/', [rfreplaceall]);
        if copy(extractfileext(t), 1, 4) = '.htm' then
          writeln(g, 'select fn_importar_categ(' + quotedstr(dirt) + ', ' +
            quotedstr(dirt + t) + ');');
        inc(i);
        caption := inttostr(i);
        application.processmessages;
        t := s;
        dirt := dirs;
        readln(f, s);
        dirs := ExtractFilePath(s);
        s := ExtractFileName(s);
      until dirs <> dirt;
      dirt := stringreplace(dirt, 'D:\ocaminho\', 'http://ocaminho.com.br/', [rfreplaceall]);
      dirt := stringreplace(dirt, '\', '/', [rfreplaceall]);
      if copy(extractfileext(t), 1, 4) = '.htm' then
        writeln(g, 'select fn_importar_categ(' + quotedstr(dirt) + ', ' +
          quotedstr(dirt + t) + ');');
    end;

    t := s;
    dirt := dirs;
  end;
  dirt := stringreplace(dirt, 'D:\ocaminho\', 'http://ocaminho.com.br/', [rfreplaceall]);
  dirt := stringreplace(dirt, '\', '/', [rfreplaceall]);
  writeln(g, 'select fn_importar_categ(' + quotedstr(dirt) + ', ' +
    quotedstr(t) + ');');
  closefile(f);
  closefile(g);
end;

end.

