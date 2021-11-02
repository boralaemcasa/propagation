unit DataModulo;

interface

uses
  SysUtils, Classes, DB, MemDS, DBAccess, PgAccess;

type
  Tdm = class(TDataModule)
    conn: TPgConnection;
    qryCoef: TPgQuery;
    qryOldPower: TPgQuery;
    qryByPower: TPgQuery;
    qryByI: TPgQuery;
    qryMinI: TPgQuery;
    qryMinPower: TPgQuery;
    qryDelAllDetail: TPgQuery;
    qryDelAllMaster: TPgQuery;
    qryInsDetail: TPgQuery;
    qryInsMaster: TPgQuery;
    qryDelMaster: TPgQuery;
    qryDelDetail: TPgQuery;
    qryMultM: TPgQuery;
    qryAdd: TPgQuery;
    qrySimplifyM: TPgQuery;
    qrySoma: TPgQuery;
    qryMaxPower: TPgQuery;
    qrySumMaster: TPgQuery;
    qrySumDetail: TPgQuery;
    qryTimesDetail: TPgQuery;
    qryTimesMaster: TPgQuery;
    qryUpdateCoef: TPgQuery;
    qryDerivMaster: TPgQuery;
    qryDerivDetail: TPgQuery;
    qryDerivPlus: TPgQuery;
    qryTTMaster: TPgQuery;
    qryTTDetail: TPgQuery;
    qryByJ: TPgQuery;
    qryPowerUp: TPgQuery;
    qryResetMaster: TPgQuery;
    qryResetDetail: TPgQuery;
    qry2: TPgQuery;
    qryExtractMaster: TPgQuery;
    qryExtractDetail: TPgQuery;
    qryExtract0: TPgQuery;
    qryCounter: TPgQuery;
    qryMultD: TPgQuery;
    qrySimplifyD: TPgQuery;
    qryMaxI: TPgQuery;
    qrySimplifyX: TPgQuery;
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
