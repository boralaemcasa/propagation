object FormPrincipal: TFormPrincipal
  Left = 14
  Top = 125
  Width = 1302
  Height = 593
  Caption = 'Continued Fractions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ed: TEdit
    Left = 8
    Top = 16
    Width = 1081
    Height = 21
    TabOrder = 0
    Text = '123456/654321'
  end
  object Memo1: TMemo
    Left = 8
    Top = 48
    Width = 193
    Height = 497
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btn1: TButton
    Left = 1104
    Top = 16
    Width = 75
    Height = 25
    Caption = '1'
    TabOrder = 2
    OnClick = btn1Click
  end
  object Memo2: TMemo
    Left = 232
    Top = 48
    Width = 1033
    Height = 497
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object btn2: TButton
    Left = 1192
    Top = 16
    Width = 75
    Height = 25
    Caption = '2'
    TabOrder = 4
    OnClick = btn2Click
  end
end
