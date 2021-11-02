object FormPrincipal: TFormPrincipal
  Left = 481
  Top = 192
  Width = 612
  Height = 480
  Caption = 'Principal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 441
    Align = alLeft
    TabOrder = 0
    object btnSchmidt: TButton
      Left = 24
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Gram Schmidt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSchmidtClick
    end
    object btnRefletores: TButton
      Left = 24
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Refletores'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnRefletoresClick
    end
    object btnPotencia: TButton
      Left = 136
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Pot'#234'ncia'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnPotenciaClick
    end
    object btnSVD: TButton
      Left = 136
      Top = 56
      Width = 97
      Height = 25
      Caption = 'SVD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnSVDClick
    end
    object sg: TStringGrid
      Left = 8
      Top = 152
      Width = 265
      Height = 137
      DefaultColWidth = 50
      FixedCols = 0
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 4
    end
    object combo: TComboBox
      Left = 72
      Top = 112
      Width = 145
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 3
      TabOrder = 5
      Text = '5'
      Items.Strings = (
        '2'
        '3'
        '4'
        '5')
    end
  end
  object Memo: TMemo
    Left = 297
    Top = 0
    Width = 299
    Height = 441
    Align = alClient
    TabOrder = 1
  end
end
