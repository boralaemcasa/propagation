object FormPrincipal: TFormPrincipal
  Left = 51
  Top = 140
  Width = 808
  Height = 580
  Caption = 'Sat'#233'lite (QWE ASD C Z F1 F2 F3 Esc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 69
    TabOrder = 0
    object cbEixos: TCheckBox
      Left = 1
      Top = 0
      Width = 87
      Height = 16
      Caption = '&Mostrar Eixo'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbEixosClick
    end
    object cb12A: TCheckBox
      Left = 1
      Top = 17
      Width = 87
      Height = 16
      Caption = '12-edro A'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbEixosClick
    end
    object cb20: TCheckBox
      Left = 1
      Top = 34
      Width = 87
      Height = 16
      Caption = '20-edro'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cbEixosClick
    end
    object cb12B: TCheckBox
      Left = 1
      Top = 51
      Width = 87
      Height = 16
      Caption = '12-edro B'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbEixosClick
    end
  end
  object Memo: TMemo
    Left = 208
    Top = 56
    Width = 433
    Height = 457
    TabOrder = 1
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
