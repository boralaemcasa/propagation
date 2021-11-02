object FormPrincipal: TFormPrincipal
  Left = 20
  Top = 26
  Width = 1328
  Height = 683
  Caption = 'Main'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnExata: TButton
    Left = 13
    Top = 24
    Width = 75
    Height = 25
    Caption = '&Exact'
    TabOrder = 0
    OnClick = btnExataClick
  end
  object Memo: TMemo
    Left = 96
    Top = 16
    Width = 1201
    Height = 609
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnGradiente: TButton
    Left = 13
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Gradient'
    TabOrder = 2
    OnClick = btnGradienteClick
  end
  object btnChecar: TButton
    Left = 15
    Top = 104
    Width = 75
    Height = 25
    Caption = '&Check'
    TabOrder = 3
    OnClick = btnChecarClick
  end
  object btnCancel: TButton
    Left = 14
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
end
