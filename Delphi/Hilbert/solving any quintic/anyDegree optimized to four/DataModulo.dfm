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
      'select i, COEF::text coef'
      'from poly p'
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
  object qryByPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select'
      '  who, i, p.coef::text as coef, '
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly p'
      'where p.who = :w'
      '  and p1 = :p'
      'order by p2')
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
      'select '
      '  who, i, coef::text as coef,'
      '  p1, p2, p3,'
      '  p4, p5, p6'
      'from poly p'
      'where p.who = :w'
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
  object qryDelAllMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete from poly'
      'where who not like ''m%''')
    Left = 490
    Top = 70
  end
  object qryInsMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into poly values (:p1, :p2, :p3, '
      ':pp1, :pp2, :pp3, '
      ':pp4, :pp5, :pp6)')
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
      end
      item
        DataType = ftUnknown
        Name = 'pp1'
      end
      item
        DataType = ftUnknown
        Name = 'pp2'
      end
      item
        DataType = ftUnknown
        Name = 'pp3'
      end
      item
        DataType = ftUnknown
        Name = 'pp4'
      end
      item
        DataType = ftUnknown
        Name = 'pp5'
      end
      item
        DataType = ftUnknown
        Name = 'pp6'
      end
      item
        DataType = ftUnknown
        Name = 'pp7'
      end
      item
        DataType = ftUnknown
        Name = 'pp8'
      end
      item
        DataType = ftUnknown
        Name = 'pp9'
      end>
  end
  object qryDelMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'DELETE'
      'from poly'
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
  object qryMult: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into poly'
      'select'
      '  :newwho,'
      '  row_number() over (order by c1) as newi,'
      '  sum(coef),'
      '  c1, c2, c3,'
      '  c4, c5, c6 '
      'from'
      '( select'
      '  (coef1 * coef2) as coef,'
      '  a.p1 + b.p1 c1,'
      '  a.p2 + b.p2 c2,'
      '  a.p3 + b.p3 c3,'
      '  a.p4 + b.p4 c4,'
      '  a.p5 + b.p5 c5,'
      '  a.p6 + b.p6 c6 '
      'from'
      '('
      'select'
      '  m.i i1,'
      '  m.coef coef1,'
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where m.who = :who1) A,'
      ''
      '(select'
      '  m.i i2,'
      '  m.coef coef2,'
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where m.who = :who2) B) C'
      'group by c1, c2, c3, c4, c5, c6'
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
  object qryMaxPower: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select max(p1) m'
      'from poly'
      'where who = :w'
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
      'insert into poly'
      'select'
      '  :who, i + :L, coef,'
      '  p1, p2, p3,'
      '  p4, p5, p6'
      'from poly'
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
  object qryUpdateCoef: TPgQuery
    Connection = conn
    SQL.Strings = (
      'update poly'
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
      'insert into poly'
      'select :who, i, coef * p1,'
      '  p1 - 1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where who = :mywho'
      '  and p1 > 0'
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
  object qryTTMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from poly'
      'where who like ''TT%'' ')
    Left = 410
    Top = 190
  end
  object qryResetMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'delete'
      'from poly'
      'where who like ''T%'''
      '   or who like :L')
    Left = 250
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
      'insert into poly'
      'select '
      '  :who, i, coef,'
      '  0 as p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where who = :origem'
      '  and p1 = :p')
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
  object qryCounter: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select count(*) c'
      'from poly'
      'where who = :who')
    Left = 490
    Top = 306
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'who'
      end>
  end
  object qrySimplifyD: TPgQuery
    Connection = conn
    Left = 250
    Top = 371
  end
  object qryMaxI: TPgQuery
    Connection = conn
    SQL.Strings = (
      'select max(i) m'
      'from poly'
      'where who = :w'
      '')
    Left = 90
    Top = 370
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'w'
      end>
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
  object qryTimesMaster: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into poly'
      'select'
      '  :who, i, :k::numeric(1000,0) * coef,'
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly'
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
        Name = 'k'
      end
      item
        DataType = ftUnknown
        Name = 'mywho'
      end>
  end
  object qryPowerUp: TPgQuery
    Connection = conn
    SQL.Strings = (
      'update poly'
      'set pn = pn + :P'
      'where who like :L'
      ''
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
      end>
  end
  object qryMultC: TPgQuery
    Connection = conn
    SQL.Strings = (
      'insert into poly'
      'select'
      '  :newwho,'
      '  :offset + row_number() over (order by c1) as newi,'
      '  sum(coef),'
      '  c1, c2, c3,'
      '  c4, c5, c6 '
      'from'
      '( select'
      '  (coef1 * coef2) as coef,'
      '  a.p1 + b.p1 c1,'
      '  a.p2 + b.p2 c2,'
      '  a.p3 + b.p3 c3,'
      '  a.p4 + b.p4 c4,'
      '  a.p5 + b.p5 c5,'
      '  a.p6 + b.p6 c6 '
      'from'
      '('
      'select'
      '  m.i i1,'
      '  m.coef coef1,'
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where m.who = :who1'
      '  and m.i >= :a1'
      '  and m.i < :b1'
      ') A,'
      ''
      '(select'
      '  m.i i2,'
      '  m.coef coef2,'
      '  p1, p2, p3,'
      '  p4, p5, p6 '
      'from poly m'
      'where m.who = :who2'
      '  and m.i >= :a2'
      '  and m.i < :b2'
      ') B) C'
      'group by c1, c2, c3, c4, c5, c6')
    Left = 242
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'newwho'
      end
      item
        DataType = ftUnknown
        Name = 'offset'
      end
      item
        DataType = ftUnknown
        Name = 'who1'
      end
      item
        DataType = ftUnknown
        Name = 'a1'
      end
      item
        DataType = ftUnknown
        Name = 'b1'
      end
      item
        DataType = ftUnknown
        Name = 'who2'
      end
      item
        DataType = ftUnknown
        Name = 'a2'
      end
      item
        DataType = ftUnknown
        Name = 'b2'
      end>
  end
end
