object FormPrincipal: TFormPrincipal
  Left = 51
  Top = 140
  Width = 808
  Height = 580
  Caption = 'Sat'#233'lite (QWE ASD C Z F1 F2 F3 Esc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 132
    TabOrder = 0
    object cbEixos: TCheckBox
      Left = 1
      Top = 0
      Width = 87
      Height = 17
      Caption = '&Mostrar E/C'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbEixosClick
    end
    object EditR1: TLabeledEdit
      Left = 3
      Top = 32
      Width = 79
      Height = 21
      EditLabel.Width = 8
      EditLabel.Height = 13
      EditLabel.Caption = 'R'
      TabOrder = 1
      Text = '2'
      OnChange = EditR1Change
      OnKeyPress = EditNKeyPress
    end
    object Editr2: TLabeledEdit
      Left = 3
      Top = 71
      Width = 79
      Height = 21
      EditLabel.Width = 3
      EditLabel.Height = 13
      EditLabel.Caption = 'r'
      TabOrder = 2
      Text = '0,5'
      OnChange = EditR1Change
      OnKeyPress = EditNKeyPress
    end
    object EditN: TLabeledEdit
      Left = 4
      Top = 107
      Width = 79
      Height = 21
      EditLabel.Width = 6
      EditLabel.Height = 13
      EditLabel.Caption = 'n'
      TabOrder = 3
      Text = '20'
      OnChange = EditR1Change
      OnKeyPress = EditNKeyPress
    end
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
