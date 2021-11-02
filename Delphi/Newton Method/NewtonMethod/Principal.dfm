object FormPrincipal: TFormPrincipal
  Left = 90
  Top = 45
  Width = 400
  Height = 780
  Caption = 'Pi'
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
    Left = 0
    Top = 41
    Width = 392
    Height = 712
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnPI: TButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Pi'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnPIClick
    end
    object btnCancel: TButton
      Left = 280
      Top = 8
      Width = 80
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
