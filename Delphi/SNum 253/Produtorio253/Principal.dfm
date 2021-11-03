object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 632
  Height = 137
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl: TLabel
    Left = 3
    Top = -1
    Width = 51
    Height = 20
    Caption = 'length'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblHora: TLabel
    Left = 3
    Top = 22
    Width = 37
    Height = 20
    Caption = 'hora'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblAcumulado: TLabel
    Left = 3
    Top = 45
    Width = 68
    Height = 20
    Caption = 'ac'#250'mulo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnDefault: TButton
    Left = 3
    Top = 68
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
  object btnCancelar: TButton
    Left = 83
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object mp: TMediaPlayer
    Left = 360
    Top = 16
    Width = 29
    Height = 30
    VisibleButtons = [btPlay]
    FileName = 'c:\windows\media\chord.wav'
    Visible = False
    TabOrder = 2
  end
  object cbDesligar: TCheckBox
    Left = 168
    Top = 72
    Width = 161
    Height = 17
    Caption = 'Desligar ap'#243's cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = cbDesligarClick
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 176
    Top = 16
  end
end
