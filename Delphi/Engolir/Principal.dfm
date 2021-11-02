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
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 912
    Height = 400
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 910
      Height = 398
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 536
      Top = 80
      Width = 281
      Height = 281
      Lines.Strings = (
        'Memo2')
      ScrollBars = ssHorizontal
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'nepe'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'ocaminho'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = 'ocaminho 2'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 272
      Top = 8
      Width = 75
      Height = 25
      Caption = 'ocaminho 3'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Edit1: TEdit
      Left = 368
      Top = 11
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '7'
    end
    object Edit2: TEdit
      Left = 499
      Top = 10
      Width = 121
      Height = 21
      TabOrder = 5
      Text = '8'
    end
    object Button5: TButton
      Left = 648
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button5'
      TabOrder = 6
      OnClick = Button5Click
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 432
    Top = 112
  end
end
