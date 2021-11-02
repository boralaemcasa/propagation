object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 125
  Width = 928
  Height = 480
  Caption = 'Cliente Oracle BDE'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 89
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object Memo: TMemo
      Left = 1
      Top = 1
      Width = 910
      Height = 87
      Align = alClient
      Lines.Strings = (
        'select *'
        'from betj'
        'where numero = 374574')
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 89
    Width = 912
    Height = 352
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object DBGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 910
      Height = 350
      Align = alClient
      DataSource = DataSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object Database: TDatabase
    AliasName = 'SUNAN1-2'
    DatabaseName = 'su_database'
    SessionName = 'Default'
    Left = 112
    Top = 24
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 200
    Top = 185
  end
  object Query: TQuery
    DatabaseName = 'su_database'
    Left = 320
    Top = 145
  end
end
