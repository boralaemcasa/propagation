object Form1: TForm1
  Left = 192
  Top = 19
  Width = 544
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
    Width = 169
    Height = 353
    DataSource = PgDataSource2
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 73
    Height = 495
    Align = alLeft
    DataSource = PgDataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBGrid3: TDBGrid
    Left = 256
    Top = 0
    Width = 169
    Height = 353
    DataSource = PgDataSource3
    TabOrder = 2
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
      'from polymaster'
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
      'select i, coef::varchar(200)'
      'from polymaster'
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
