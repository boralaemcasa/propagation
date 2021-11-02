object FormPrincipal: TFormPrincipal
  Left = -4
  Top = 182
  Width = 808
  Height = 580
  Caption = 'Cubo Chinês (QWE ASD C 0 F1 F2 F3 Esc)'
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
    Width = 89
    Height = 25
    TabOrder = 0
    object cbEixos: TCheckBox
      Left = 1
      Top = 0
      Width = 87
      Height = 17
      Caption = '&Mostrar Eixos'
      TabOrder = 0
      OnClick = cbEixosClick
    end
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
