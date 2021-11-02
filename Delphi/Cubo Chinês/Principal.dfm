object FormPrincipal: TFormPrincipal
  Left = -4
  Top = 182
  Width = 808
  Height = 580
  Caption = 'Cubo Chin'#234's (QWE ASD C 0 F1 F2 F3 Esc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object img: TImage
    Left = 0
    Top = 0
    Width = 800
    Height = 553
    Align = alClient
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 73
    TabOrder = 0
    object rgSentido: TRadioGroup
      Left = 198
      Top = 0
      Width = 86
      Height = 45
      Caption = 'Sentido'
      ItemIndex = 0
      Items.Strings = (
        'Positivo (&+)'
        'Negativo (&-)')
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 200
      Top = 44
      Width = 83
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
    end
    object rgEixo: TRadioGroup
      Left = 88
      Top = 0
      Width = 57
      Height = 69
      Caption = 'Eixo'
      ItemIndex = 0
      Items.Strings = (
        '&X'
        '&Y'
        '&Z')
      TabOrder = 2
    end
    object rgPosicao: TRadioGroup
      Left = 143
      Top = 0
      Width = 57
      Height = 69
      Caption = 'Posi'#231#227'o'
      ItemIndex = 0
      Items.Strings = (
        '&1'
        '&2'
        '&3')
      TabOrder = 3
    end
    object cbEixos: TCheckBox
      Left = 1
      Top = 0
      Width = 87
      Height = 17
      Caption = '&Mostrar Eixos'
      TabOrder = 4
      OnClick = cbEixosClick
    end
    object cbPintar: TCheckBox
      Left = 1
      Top = 16
      Width = 87
      Height = 17
      Caption = '&Pintar'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbEixosClick
    end
    object cbNumerar: TCheckBox
      Left = 1
      Top = 32
      Width = 87
      Height = 17
      Caption = '&Numerar'
      TabOrder = 6
      OnClick = cbEixosClick
    end
    object cbDistanciar: TCheckBox
      Left = 0
      Top = 49
      Width = 87
      Height = 17
      Caption = 'D&istanciar'
      TabOrder = 7
      OnClick = cbDistanciarClick
    end
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
