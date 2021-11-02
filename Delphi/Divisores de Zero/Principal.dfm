object FormPrincipal: TFormPrincipal
  Left = -3
  Top = -18
  Width = 812
  Height = 612
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 508
    Width = 796
    Height = 65
    Align = alBottom
    TabOrder = 0
    object lbStatus: TLabel
      Left = 83
      Top = 8
      Width = 38
      Height = 13
      Caption = 'lbStatus'
    end
    object btnDefault: TButton
      Left = 3
      Top = 5
      Width = 75
      Height = 20
      Caption = 'Default'
      Default = True
      TabOrder = 0
      OnClick = btnDefaultClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 432
    Top = 224
    object ZoomIn1: TMenuItem
      Caption = 'Zoom In'
    end
    object ZoomOut1: TMenuItem
      Caption = 'Zoom Out'
    end
    object ResetZoom1: TMenuItem
      Caption = 'Reset Zoom'
    end
    object Close1: TMenuItem
      Caption = 'Close! Exit! Halt!'
      OnClick = Close1Click
    end
  end
end
