object Form1: TForm1
  Left = 52
  Top = 19
  Width = 684
  Height = 534
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid2: TDBGrid
    Left = 80
    Top = 0
    Width = 593
    Height = 353
    DataSource = PgDataSource2
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'i'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'coef'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p1'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p2'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p3'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p4'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p5'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p6'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p7'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p8'
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'p9'
        Width = 43
        Visible = True
      end>
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 73
    Height = 507
    Align = alLeft
    DataSource = PgDataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object PgConnection1: TPgConnection
    Username = 'postgres'
    Server = 'localhost'
    LoginPrompt = False
    Database = 'postgres'
    Connected = True
    Left = 184
    Top = 24
    EncryptedPassword = '98FFCFFF9BFF98FFCFFF9BFF'
  end
  object qry: TPgQuery
    Connection = PgConnection1
    SQL.Strings = (
      'select distinct who'
      'from poly'
      'order by 1')
    Active = True
    AfterScroll = qryAfterScroll
    Left = 24
    Top = 80
  end
  object PgDataSource1: TPgDataSource
    DataSet = qry
    Left = 24
    Top = 152
  end
  object qryi: TPgQuery
    Connection = PgConnection1
    SQL.Strings = (
      'select i, coef::varchar(200), p1, p2, p3, p4, p5, p6, p7, p8, p9'
      'from poly'
      'where who = :p'
      'order by 1')
    Active = True
    AfterScroll = qryiAfterScroll
    Left = 104
    Top = 408
    ParamData = <
      item
        DataType = ftString
        Name = 'p'
        ParamType = ptInput
        Value = 'm0'
      end>
  end
  object PgDataSource2: TPgDataSource
    DataSet = qryi
    Left = 104
    Top = 352
  end
  object PgDataSource3: TPgDataSource
    DataSet = PgQuery3
    Left = 304
    Top = 368
  end
  object PgQuery3: TPgQuery
    Connection = PgConnection1
    SQL.Strings = (
      'select j, power'
      'from polydetail'
      'where p_who = :w'
      '  and p_i = :i'
      'order by 1')
    Active = True
    Left = 304
    Top = 424
    ParamData = <
      item
        DataType = ftString
        Name = 'w'
        ParamType = ptInput
        Value = 'm0'
      end
      item
        DataType = ftInteger
        Name = 'i'
        ParamType = ptInput
        Value = 1
      end>
  end
end
