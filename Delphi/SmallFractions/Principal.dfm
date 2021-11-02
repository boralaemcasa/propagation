object FormPrincipal: TFormPrincipal
  Left = -8
  Top = -8
  Width = 1382
  Height = 784
  Caption = 'Peano and Small Fractions'
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
    Width = 1366
    Height = 704
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1366
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnEnumerar: TButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = '1,000 successors'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnEnumerarClick
    end
    object cbCoprime: TCheckBox
      Left = 200
      Top = 12
      Width = 81
      Height = 17
      Caption = 'CoPrime'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object cbHalf: TComboBox
      Left = 128
      Top = 9
      Width = 65
      Height = 22
      Style = csOwnerDrawFixed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 16
      ItemIndex = 4
      ParentFont = False
      TabOrder = 2
      Text = 'Todos'
      Items.Strings = (
        'y > 0'
        'y < 0'
        'x > 0'
        'x < 0'
        'Todos')
    end
  end
end
