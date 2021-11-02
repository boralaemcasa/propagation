object Form1: TForm1
  Left = 17
  Top = 170
  Width = 1158
  Height = 280
  Caption = 'Calculadora Inteira'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object A: TEdit
    Left = 3
    Top = 4
    Width = 1134
    Height = 21
    TabOrder = 0
  end
  object B: TEdit
    Left = 3
    Top = 36
    Width = 1134
    Height = 21
    TabOrder = 1
  end
  object BtnSoma: TButton
    Left = 134
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Soma'
    TabOrder = 2
    OnClick = BtnSomaClick
  end
  object BtnSubtrai: TButton
    Left = 222
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Subtrai'
    TabOrder = 3
    OnClick = BtnSubtraiClick
  end
  object BtnMultiplica: TButton
    Left = 310
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Multiplica'
    TabOrder = 4
    OnClick = BtnMultiplicaClick
  end
  object BtnDivide: TButton
    Left = 398
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Divide'
    TabOrder = 5
    OnClick = BtnDivideClick
  end
  object BtnValida: TButton
    Left = 134
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Valida'
    TabOrder = 6
    OnClick = BtnValidaClick
  end
  object BtnCompara: TButton
    Left = 222
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Compara'
    TabOrder = 7
    OnClick = BtnComparaClick
  end
  object BtnOposto: TButton
    Left = 310
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Oposto'
    TabOrder = 8
    OnClick = BtnOpostoClick
  end
  object BtnReduz: TButton
    Left = 398
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Reduz'
    TabOrder = 9
    OnClick = BtnReduzClick
  end
end
