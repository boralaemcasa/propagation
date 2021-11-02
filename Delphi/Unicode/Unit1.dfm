object Form1: TForm1
  Left = 192
  Top = 125
  Width = 928
  Height = 480
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
  object memo: TTntMemo
    Left = 152
    Top = 40
    Width = 529
    Height = 345
    Lines.Strings = (
      'memo')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 328
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
end
