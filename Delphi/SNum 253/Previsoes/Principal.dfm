object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 589
  Height = 480
  Caption = 'Previs'#245'es'
  Color = 10996034
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnCalcular: TButton
    Left = 10
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Calcular'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnCalcularClick
  end
  object Memo: TMemo
    Left = 10
    Top = 40
    Width = 561
    Height = 401
    Color = 15397587
    TabOrder = 1
  end
  object cbDividir: TCheckBox
    Left = 90
    Top = 13
    Width = 63
    Height = 17
    Caption = 'Dividir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object cb1000: TCheckBox
    Left = 156
    Top = 13
    Width = 129
    Height = 17
    Caption = 'M'#250'ltiplos de 1000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object cbMover: TCheckBox
    Left = 292
    Top = 13
    Width = 129
    Height = 17
    Caption = 'Mover arquivos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
end
