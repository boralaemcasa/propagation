program Derivator;

uses
  Forms,
  Principal in 'Principal.pas' {frm_principal},
  Derivar in 'Derivar.pas',
  Distribuir in 'Distribuir.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_principal, frm_principal);
  Application.Run;
end.
