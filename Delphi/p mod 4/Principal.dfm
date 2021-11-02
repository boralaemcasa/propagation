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
  object Button1: TButton
    Left = 256
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 392
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 72
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'primos.txt'
    OnDblClick = Edit1DblClick
  end
  object Memo: TMemo
    Left = 112
    Top = 104
    Width = 369
    Height = 297
    TabOrder = 3
  end
  object Button3: TButton
    Left = 512
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 512
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
    OnClick = Button4Click
  end
end
