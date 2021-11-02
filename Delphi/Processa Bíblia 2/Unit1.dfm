object Form1: TForm1
  Left = 192
  Top = 125
  Width = 928
  Height = 878
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 240
    Top = 16
    Width = 617
    Height = 777
    Lines.Strings = (
      'Memo')
    ScrollBars = ssHorizontal
    TabOrder = 0
  end
  object Button1: TButton
    Left = 48
    Top = 768
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 80
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
