object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 632
  Height = 93
  Caption = 'Produt'#243'rio 253'
  Color = 10996034
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnDefault: TButton
    Left = 3
    Top = 23
    Width = 75
    Height = 25
    Caption = 'Default'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnDefaultClick
  end
  object mp: TMediaPlayer
    Left = 360
    Top = 16
    Width = 29
    Height = 30
    VisibleButtons = [btPlay]
    FileName = 'c:\windows\media\chord.wav'
    Visible = False
    TabOrder = 1
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 176
    Top = 16
  end
end
