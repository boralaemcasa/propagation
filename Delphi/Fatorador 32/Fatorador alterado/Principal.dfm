object Form1: TForm1
  Left = 31
  Top = 11
  Width = 762
  Height = 555
  Caption = 'Fatorador'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Lb: TLabel
    Left = 344
    Top = 16
    Width = 54
    Height = 13
    Caption = 'Maior primo'
  end
  object Edit: TEdit
    Left = 8
    Top = 8
    Width = 321
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyDown = EditKeyDown
  end
  object Memo: TMemo
    Left = 8
    Top = 40
    Width = 737
    Height = 474
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object BtnCancel: TButton
    Left = 592
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object BtnFatorar: TButton
    Left = 424
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Fatorar'
    Default = True
    TabOrder = 3
    OnClick = BtnFatorarClick
  end
  object BtnPausar: TButton
    Left = 672
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Pausar'
    TabOrder = 4
    OnClick = BtnPausarClick
  end
  object BtnSaltar: TButton
    Left = 511
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Saltar'
    TabOrder = 5
    OnClick = BtnSaltarClick
  end
end
