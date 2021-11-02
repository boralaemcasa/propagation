object Form1: TForm1
  Left = 192
  Top = 107
  Width = 282
  Height = 152
  Caption = 'Timer Http'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 125
    Top = 23
    Width = 103
    Height = 24
    Alignment = taRightJustify
    Caption = 'Inicializando'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 153
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Disparar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 17
    Top = 71
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '900000'
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 124
    Top = 23
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 188
    Top = 23
  end
end
