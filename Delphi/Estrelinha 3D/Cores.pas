(************************************
		Cubo - seleçao de cores
		www.freewebs.com/claudino
		vinicius_alvorecer@yahoo.com.br
 ************************************)
unit Cores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormCores = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Button1: TButton;
    Button2: TButton;
    ColorDialog: TColorDialog;
    btnPadroes: TButton;
    procedure Panel1Click(Sender: TObject);
    procedure btnPadroesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCores: TFormCores;

implementation

{$R *.dfm}

procedure TFormCores.Panel1Click(Sender: TObject);
begin
  ColorDialog.Color := TPanel(sender).Color;
  if ColorDialog.Execute then
    TPanel(sender).Color := ColorDialog.Color;
end;

procedure TFormCores.btnPadroesClick(Sender: TObject);
begin
  Panel1.Color := clWhite;  //ABCD
  Panel2.Color := clYellow; //EFGH

  Panel3.Color := clGreen;  //ABFE
  Panel4.Color := clBlue;   //BCGF

  Panel5.Color := clPurple; //CDHG
  Panel6.Color := clRed;    //ADHE
end;

end.
