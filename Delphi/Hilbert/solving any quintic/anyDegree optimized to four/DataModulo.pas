unit DataModulo;

interface

uses
  SysUtils, Classes, DB, MemDS, DBAccess, PgAccess;

type
  Tdm = class(TDataModule)
    conn: TPgConnection;
    qryCoef: TPgQuery;
    qryByPower: TPgQuery;
    qryByI: TPgQuery;
    qryMinI: TPgQuery;
    qryDelAllMaster: TPgQuery;
    qryInsMaster: TPgQuery;
    qryDelMaster: TPgQuery;
    qryMult: TPgQuery;
    qryAdd: TPgQuery;
    qryMaxPower: TPgQuery;
    qrySumMaster: TPgQuery;
    qryUpdateCoef: TPgQuery;
    qryDerivMaster: TPgQuery;
    qryTTMaster: TPgQuery;
    qryResetMaster: TPgQuery;
    qry2: TPgQuery;
    qryExtractMaster: TPgQuery;
    qryCounter: TPgQuery;
    qrySimplifyD: TPgQuery;
    qryMaxI: TPgQuery;
    qryMinPower: TPgQuery;
    qryTimesMaster: TPgQuery;
    qryPowerUp: TPgQuery;
    qryMultC: TPgQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

end.
