object FormPrincipal: TFormPrincipal
  Left = 39
  Top = 181
  Width = 728
  Height = 247
  Caption = 'Any Degree'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 97
    Height = 220
    Align = alLeft
    TabOrder = 0
    object btn2: TButton
      Left = 11
      Top = 9
      Width = 75
      Height = 25
      Caption = '2'
      TabOrder = 2
      OnClick = btn2Click
    end
    object btn3: TButton
      Left = 11
      Top = 50
      Width = 75
      Height = 25
      Caption = '3'
      TabOrder = 3
      OnClick = btn3Click
    end
    object btn4: TButton
      Left = 11
      Top = 92
      Width = 75
      Height = 25
      Caption = '4'
      TabOrder = 4
      OnClick = btn4Click
    end
    object btnMoreThan4: TButton
      Left = 11
      Top = 176
      Width = 75
      Height = 25
      Caption = 'n >= 5'
      Default = True
      TabOrder = 1
      OnClick = btnMoreThan4Click
    end
    object edN: TEdit
      Left = 12
      Top = 134
      Width = 73
      Height = 21
      TabOrder = 0
      Text = '7'
    end
  end
  object Panel2: TPanel
    Left = 97
    Top = 0
    Width = 623
    Height = 220
    Align = alClient
    TabOrder = 1
    object MemoY: TMemo
      Left = 1
      Top = 1
      Width = 176
      Height = 218
      Align = alLeft
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object MemoX: TMemo
      Left = 177
      Top = 1
      Width = 445
      Height = 218
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 80
    Top = 24
  end
end
