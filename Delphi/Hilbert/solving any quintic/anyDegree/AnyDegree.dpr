program AnyDegree;

uses
  SNum in 'SNum.pas',
  Poly in 'Poly.pas',
  Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Poly2D in 'Poly2D.pas',
  DataModulo in 'DataModulo.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.

