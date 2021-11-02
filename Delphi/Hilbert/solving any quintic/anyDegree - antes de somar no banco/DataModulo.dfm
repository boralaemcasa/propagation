object dm: Tdm
  OldCreateOrder = False
  Left = 191
  Top = 125
  Height = 477
  Width = 574
  object conn: TPgConnection
    Left = 10
    Top = 10
  end
  object qryCoef: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select i, COEF, coef2'
      'from polymaster p'
      'where who = :w'
      'order by i desc')
    Left = 90
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'w'
      end>
  end
  object qryOldPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select d.p_who, d.p_i, d.j, (d.power + 1) as power, p.COEF'
      'from polymaster p, polydetail d'
      'where p.who = p_who'
      '  and p.i = p_i'
      '  and p.who = :pnew'
      '  and d.j = '#39'1'#39)
    Left = 250
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pnew'
      end>
  end
  object qryByPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      
        'select d1.p_who, d1.p_i, d1.j, d1.power, p.coef, d2.power ordena' +
        'r'
      'from polymaster p, polydetail d1, polydetail d2'
      'where p.who = d1.p_who'
      '  and p.i = d1.p_i'
      '  and p.who = :w'
      '  and d1.j = '#39'1'#39
      '  and d1.power = :p'
      '  and p.who = d2.p_who'
      '  and p.i = d2.p_i'
      '  and d2.j = '#39'2'#39
      'order by ordenar')
    Left = 330
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'w'
      end
      item
        DataType = ftUnknown
        Name = 'p'
      end>
  end
  object qryByI: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select d.p_who, d.p_i, d.j, d.power, p.coef'
      'from polymaster p, polydetail d'
      'where p.who = p_who'
      '  and p.i = p_i'
      '  and p.who = :w'
      '  and p.i = :p3')
    Left = 410
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'w'
      end
      item
        DataType = ftUnknown
        Name = 'p3'
      end>
  end
  object qryMinI: TPgQuery
    Connection = conn
    Left = 90
    Top = 310
  end
  object qryMinPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select -min(power) m'
      'from polydetail'
      'where p_who like :L'
      '  and j = :J'
      '')
    Left = 490
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'L'
      end
      item
        DataType = ftUnknown
        Name = 'J'
      end>
  end
  object qryDelAllDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete from polydetail'
      'where p_who not like '#39'm%'#39)
    Left = 410
    Top = 70
  end
  object qryDelAllMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete from polymaster'
      'where who not like '#39'm%'#39)
    Left = 490
    Top = 70
  end
  object qryInsDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail values (:p1, :p2, :p3, :p4)')
    Left = 90
    Top = 70
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p1'
      end
      item
        DataType = ftUnknown
        Name = 'p2'
      end
      item
        DataType = ftUnknown
        Name = 'p3'
      end
      item
        DataType = ftUnknown
        Name = 'p4'
      end>
  end
  object qryInsMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster values (:p1, :p2, :p3)')
    Left = 170
    Top = 70
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p1'
      end
      item
        DataType = ftUnknown
        Name = 'p2'
      end
      item
        DataType = ftUnknown
        Name = 'p3'
      end>
  end
  object qryDelMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'DELETE'
      'from polymaster'
      'where who = :p1'
      '  and i = :p3'
      '')
    Left = 330
    Top = 70
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p1'
      end
      item
        DataType = ftUnknown
        Name = 'p3'
      end>
  end
  object qryDelDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'DELETE'
      'from polydetail'
      'where p_who = :p1'
      '  and p_i = :p3'
      '')
    Left = 250
    Top = 70
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'p1'
      end
      item
        DataType = ftUnknown
        Name = 'p3'
      end>
  end
  object qryMultM: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster'
      'select '
      '  :newwho,'
      '  row_number() over (order by i1, i2) as newi, '
      '  coef1,'
      '  coef2'
      'from'
      '('
      'select'
      '  m.i i1,'
      '  m.coef coef1'
      '  , d1.power as p1'
      'from polymaster m'
      ', polydetail d1'
      'where m.who = :who1'
      '  and d1.p_who = :who1'
      '  and m.i = d1.p_i'
      '  and d1.j = '#39'1'#39') A,'
      ''
      '(select'
      '  m.i i2,'
      '  m.coef coef2'
      '  , d1.power as p2'
      'from polymaster m'
      ', polydetail d1'
      'where m.who = :who2'
      '  and d1.p_who = :who2'
      '  and m.i = d1.p_i'
      '  and d1.j = '#39'1'#39') B'
      '')
    Left = 170
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'newwho'
      end
      item
        DataType = ftUnknown
        Name = 'who1'
      end
      item
        DataType = ftUnknown
        Name = 'who2'
      end>
  end
  object qryAdd: TPgQuery
    Connection = conn
    Left = 170
    Top = 310
  end
  object qrySimplify: TPgQuery
    Connection = conn
    Left = 250
    Top = 310
  end
  object qrySoma: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select j, sum(power) as soma'
      'from polydetail'
      'where (p_who = :pw1 and p_i = :pi1)'
      '   or (p_who = :pw2 and p_i = :pi2)'
      'group by j'
      '')
    Left = 90
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pw1'
      end
      item
        DataType = ftUnknown
        Name = 'pi1'
      end
      item
        DataType = ftUnknown
        Name = 'pw2'
      end
      item
        DataType = ftUnknown
        Name = 'pi2'
      end>
  end
  object qryMaxPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select max(power) m'
      'from polydetail'
      'where p_who = :w'
      '  and j = '#39'1'#39
      '')
    Left = 170
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'w'
      end>
  end
  object qrySumMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster'
      'select :who, i + :L, coef, null'
      'from polymaster'
      'where who = :mywho'
      '')
    Left = 250
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'L'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qrySumDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail'
      'select :who, p_i + :L, j, power'
      'from polydetail'
      'where p_who = :mywho')
    Left = 330
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'L'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryTimesDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail (p_who, p_i, j, power)'
      'select :who, p_i, j, power'
      'from polydetail'
      'where p_who = :mywho'
      '')
    Left = 490
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryTimesMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster (who, i, coef)'
      'select :who, i, coef'
      'from polymaster'
      'where who = :mywho'
      '')
    Left = 410
    Top = 130
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryUpdateCoef: TPgQuery
    Connection = conn
    SQL.Strings = (
      'update polymaster'
      'set coef = :pc'
      'where who = :pnew'
      '  and i = :pi'
      '')
    Left = 90
    Top = 190
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'pc'
      end
      item
        DataType = ftUnknown
        Name = 'pnew'
      end
      item
        DataType = ftUnknown
        Name = 'pi'
      end>
  end
  object qryDerivMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster (who, i, coef)'
      'select :who, i, coef'
      'from polymaster m, polydetail d'
      'where who = :mywho'
      '  and p_who = who'
      '  and p_i = i'
      '  and j = '#39'1'#39
      '  and power > 0'
      '')
    Left = 170
    Top = 190
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryDerivDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail (p_who, p_i, j, power)'
      'select :who, p_i, j, power'
      'from polydetail'
      'where p_who = :mywho'
      '  and j <> '#39'1'#39
      '  and exists (select 1'
      '              from polymaster'
      '              where who = :who'
      '                and i = p_i)'
      '')
    Left = 250
    Top = 190
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryDerivPlus: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail (p_who, p_i, j, power)'
      'select :who, p_i, j, power - 1'
      'from polydetail'
      'where p_who = :mywho'
      '  and j = '#39'1'#39
      '  and exists (select 1'
      '              from polymaster'
      '              where who = :who'
      '                and i = p_i)'
      '')
    Left = 330
    Top = 190
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryTTMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from polymaster'
      'where who like '#39'TT%'#39' ')
    Left = 410
    Top = 190
  end
  object qryTTDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from polydetail'
      'where p_who like '#39'TT%'#39)
    Left = 490
    Top = 190
  end
  object qryByJ: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select power'
      'from polydetail'
      'where p_who = :who'
      '  and p_i = :pi'
      '  and j = :pj'
      '')
    Left = 90
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'pi'
      end
      item
        DataType = ftUnknown
        Name = 'pj'
      end>
  end
  object qryPowerUp: TPgQuery
    Connection = conn
    SQL.Strings = (
      'update polydetail'
      'set power = power + :P'
      'where p_who like :L'
      '  and j = :J'
      '')
    Left = 170
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P'
      end
      item
        DataType = ftUnknown
        Name = 'L'
      end
      item
        DataType = ftUnknown
        Name = 'J'
      end>
  end
  object qryResetMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from polymaster'
      'where who like '#39'T%'#39
      '   or who like :L')
    Left = 250
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'L'
      end>
  end
  object qryResetDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from polydetail'
      'where p_who like '#39'T%'#39
      '   or p_who like :L')
    Left = 330
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'L'
      end>
  end
  object qry2: TPgQuery
    Connection = conn
    SQL.Strings = (
      ''
      '')
    Left = 330
    Top = 310
  end
  object qryExtractMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polymaster'
      'select :who, i, coef'
      'from polymaster m, polydetail d'
      'where who = :origem'
      '  and p_who = who'
      '  and p_i = i'
      '  and j = '#39'1'#39
      '  and power = :p')
    Left = 410
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'origem'
      end
      item
        DataType = ftUnknown
        Name = 'p'
      end>
  end
  object qryExtractDetail: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail'
      'select :who, p_i, j, power'
      'from polydetail'
      'where p_who = :origem'
      '  and j <> '#39'1'#39
      '  and p_i in (select i'
      '              from polymaster'
      '              where who = :who)')
    Left = 490
    Top = 250
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end
      item
        DataType = ftUnknown
        Name = 'origem'
      end>
  end
  object qryExtract0: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail'
      'select who, i, 1, 0'
      'from polymaster'
      '  where who = :who')
    Left = 410
    Top = 306
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end>
  end
  object qryCounter: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select count(*) c'
      'from polymaster'
      'where who = :who')
    Left = 490
    Top = 306
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end>
  end
  object qryMultD: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into polydetail'
      'select'
      '  :newwho,'
      '  row_number() over (order by i1, i2) as newi'
      '  , :pj j'
      '  , p1 + p2 p'
      'from'
      '('
      'select'
      '  m.i i1,'
      '  m.coef coef1'
      '  , d1.power as p1'
      'from polymaster m'
      ', polydetail d1'
      'where m.who = :who1'
      '  and d1.p_who = :who1'
      '  and m.i = d1.p_i'
      '  and d1.j = :pj) A,'
      ''
      '(select'
      '  m.i i2,'
      '  m.coef coef2'
      '  , d1.power as p2'
      'from polymaster m'
      ', polydetail d1'
      'where m.who = :who2'
      '  and d1.p_who = :who2'
      '  and m.i = d1.p_i'
      '  and d1.j = :pj) B'
      '')
    Left = 170
    Top = 370
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'newwho'
      end
      item
        DataType = ftUnknown
        Name = 'pj'
      end
      item
        DataType = ftUnknown
        Name = 'who1'
      end
      item
        DataType = ftUnknown
        Name = 'who2'
      end>
  end
end
