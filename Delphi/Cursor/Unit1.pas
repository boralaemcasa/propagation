unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
     0: screen.cursor :=  crDefault;
     1: screen.cursor :=  crNone;
     2: screen.cursor :=  crArrow;
     3: screen.cursor :=  crCross;
     4: screen.cursor :=  crIBeam;
     5: screen.cursor :=  crSize;
     6: screen.cursor :=  crSizeNESW;
     7: screen.cursor :=  crSizeNS;
     8: screen.cursor :=  crSizeNWSE;
     9: screen.cursor :=  crSizeWE;
    10: screen.cursor :=  crUpArrow;
    11: screen.cursor :=  crHourGlass;
    12: screen.cursor :=  crDrag;
    13: screen.cursor :=  crNoDrop;
    14: screen.cursor :=  crHSplit;
    15: screen.cursor :=  crVSplit;
    16: screen.cursor :=  crMultiDrag;
    17: screen.cursor :=  crSQLWait;
    18: screen.cursor :=  crNo;
    19: screen.cursor :=  crAppStart;
    20: screen.cursor :=  crHelp;
    21: screen.cursor :=  crHandPoint;
    22: screen.cursor :=  crSizeAll;
  end;
end;

end.

