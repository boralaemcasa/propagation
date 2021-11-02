object Form1: TForm1
  Left = -2
  Top = 1
  Width = 791
  Height = 558
  Caption = 'Form1'
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
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 137
    Height = 25
    Caption = 'Maiores incrementos'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo: TMemo
    Left = 168
    Top = 11
    Width = 601
    Height = 350
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object Button2: TButton
    Left = 16
    Top = 40
    Width = 137
    Height = 25
    Caption = 'Eliminar (ini, min linhas)'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 24
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Button4: TButton
    Left = 16
    Top = 160
    Width = 137
    Height = 25
    Caption = 'Base V'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 16
    Top = 192
    Width = 137
    Height = 25
    Caption = 'Algoritmo Tree (liimte)'
    Default = True
    TabOrder = 6
    OnClick = Button5Click
  end
  object Tree: TTreeView
    Left = 168
    Top = 368
    Width = 601
    Height = 145
    Indent = 19
    TabOrder = 7
    OnDblClick = TreeDblClick
  end
  object Button6: TButton
    Left = 16
    Top = 224
    Width = 137
    Height = 25
    Caption = 'Base (b, num linhas)'
    TabOrder = 8
    OnClick = Button6Click
  end
end
