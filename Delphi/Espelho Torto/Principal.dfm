object FormPrincipal: TFormPrincipal
  Left = -3
  Top = 0
  Width = 1023
  Height = 757
  Caption = 'Form1'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbStatus: TLabel
    Left = 184
    Top = 684
    Width = 38
    Height = 13
    Caption = 'lbStatus'
  end
  object btnDefault: TButton
    Left = 8
    Top = 680
    Width = 75
    Height = 20
    Caption = 'Default'
    Default = True
    TabOrder = 0
    OnClick = btnDefaultClick
  end
  object btnFechar: TButton
    Left = 96
    Top = 680
    Width = 75
    Height = 20
    Cancel = True
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = btnFecharClick
  end
end
