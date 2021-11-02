object Form1: TForm1
  Left = 192
  Top = 125
  Width = 1042
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
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 450
    Height = 441
    Align = alLeft
    ScrollBars = ssBoth
    TabOrder = 0
    OnDblClick = Memo1DblClick
  end
  object Memo2: TMemo
    Left = 576
    Top = 0
    Width = 450
    Height = 441
    Align = alRight
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 480
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 480
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 480
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 480
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
    OnClick = Button4Click
  end
end
