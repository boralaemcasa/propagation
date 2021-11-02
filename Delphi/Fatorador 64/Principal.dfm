object Form1: TForm1
  Left = 31
  Top = 11
  Width = 768
  Height = 559
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
  object Memo: TMemo
    Left = 8
    Top = 140
    Width = 737
    Height = 375
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object BtnCancel: TButton
    Left = 592
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object BtnFatorar: TButton
    Left = 424
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Fatorar'
    Default = True
    TabOrder = 2
    OnClick = BtnFatorarClick
  end
  object BtnPausar: TButton
    Left = 672
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Pausar'
    TabOrder = 3
    OnClick = BtnPausarClick
  end
  object MemoEntrada: TMemo
    Left = 7
    Top = 6
    Width = 314
    Height = 131
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
end
