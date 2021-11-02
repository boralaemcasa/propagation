object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 6
  Width = 787
  Height = 527
  Caption = 'Polyhedra (QWE ASD C Z F1 F2 F3 Esc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 121
    TabOrder = 0
    object cbAxis: TCheckBox
      Left = 1
      Top = 0
      Width = 87
      Height = 16
      Caption = 'Show Axis'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbAxisClick
    end
    object cb6: TCheckBox
      Left = 1
      Top = 32
      Width = 87
      Height = 16
      Caption = '6-hedra'
      TabOrder = 1
      OnClick = cbAxisClick
    end
    object cb20: TCheckBox
      Left = 1
      Top = 83
      Width = 87
      Height = 16
      Caption = '20-hedra'
      TabOrder = 2
      OnClick = cbAxisClick
    end
    object cb12B: TCheckBox
      Left = 1
      Top = 100
      Width = 87
      Height = 16
      Caption = '12-hedra B'
      TabOrder = 3
      OnClick = cbAxisClick
    end
    object cb4: TCheckBox
      Left = 1
      Top = 16
      Width = 82
      Height = 16
      Caption = '4-hedra'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = cbAxisClick
    end
    object cb8: TCheckBox
      Left = 1
      Top = 49
      Width = 87
      Height = 16
      Caption = '8-hedra'
      TabOrder = 5
      OnClick = cbAxisClick
    end
    object cb12a: TCheckBox
      Left = 1
      Top = 66
      Width = 87
      Height = 16
      Caption = '12-hedra A'
      TabOrder = 6
      OnClick = cbAxisClick
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 416
    Width = 771
    Height = 72
    Align = alBottom
    ParentShowHint = False
    ScrollBars = ssHorizontal
    ShowHint = True
    TabOrder = 1
    Visible = False
    OnDblClick = MemoDblClick
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
