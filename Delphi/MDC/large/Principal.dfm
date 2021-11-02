object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 124
  Width = 870
  Height = 450
  Caption = 'MDC'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 162
    Top = 41
    Width = 692
    Height = 371
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssHorizontal
    TabOrder = 0
  end
  object MemoY: TMemo
    Left = 81
    Top = 41
    Width = 81
    Height = 371
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssHorizontal
    TabOrder = 1
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 41
    Align = alTop
    TabOrder = 2
    object EditX: TEdit
      Left = 8
      Top = 12
      Width = 257
      Height = 21
      TabOrder = 0
      Text = '55'
    end
    object EditY: TEdit
      Left = 272
      Top = 12
      Width = 305
      Height = 21
      TabOrder = 1
      Text = '34'
    end
    object btnOK: TButton
      Left = 584
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = btnOKClick
    end
    object btnrandom: TButton
      Left = 672
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Random'
      TabOrder = 3
      OnClick = btnrandomClick
    end
  end
  object MemoX: TMemo
    Left = 0
    Top = 41
    Width = 81
    Height = 371
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssHorizontal
    TabOrder = 3
    Visible = False
  end
end
