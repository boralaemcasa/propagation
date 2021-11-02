object FormPrincipal: TFormPrincipal
  Left = 191
  Top = 26
  Width = 928
  Height = 683
  Caption = 'Principal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnExata: TButton
    Left = 32
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Exata'
    TabOrder = 0
    OnClick = btnExataClick
  end
  object Memo: TMemo
    Left = 136
    Top = 16
    Width = 697
    Height = 609
    TabOrder = 1
  end
  object btnGradiente: TButton
    Left = 32
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Gradiente'
    TabOrder = 2
    OnClick = btnGradienteClick
  end
end
