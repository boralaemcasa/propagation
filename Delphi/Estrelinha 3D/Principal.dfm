object FormPrincipal: TFormPrincipal
  Left = 22
  Top = 13
  Width = 783
  Height = 547
  Caption = 'Cubo (QWE ASD 123 ZC Esc)'
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
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object img: TImage
    Left = 0
    Top = 0
    Width = 775
    Height = 520
    Align = alClient
  end
  object cbEixos: TCheckBox
    Left = 1
    Top = 16
    Width = 97
    Height = 17
    Caption = 'Mostrar Ei&xos'
    TabOrder = 0
    OnClick = cbEixosClick
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
