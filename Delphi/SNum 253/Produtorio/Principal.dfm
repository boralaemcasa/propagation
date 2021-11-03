object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 439
  Height = 98
  Caption = 'Produt'#243'rio'
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
  object btnCancelar: TButton
    Left = 134
    Top = 44
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnCancelarClick
  end
  object btnHTML: TButton
    Left = 220
    Top = 44
    Width = 75
    Height = 25
    Caption = 'HTML'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnHTMLClick
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
  object btnDividir: TButton
    Left = 306
    Top = 44
    Width = 75
    Height = 25
    Caption = 'Dividir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnDividirClick
  end
  object Edit: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    Color = 15397587
    TabOrder = 4
    Text = '1000'
  end
  object btnASCII: TButton
    Left = 49
    Top = 44
    Width = 75
    Height = 25
    Caption = 'ASCII'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnASCIIClick
  end
end
