object FormPrincipal: TFormPrincipal
  Left = -8
  Top = -8
  Width = 400
  Height = 780
  Caption = 'Peano and UnLimited Fractions'
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
    Width = 384
    Height = 700
    Align = alClient
    Lines.Strings = (
      '314159'
      '100000'
      '1')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnEnumerar: TButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = '2 Successors'
      Default = True
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
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
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
      Text = 'FULL'
      Items.Strings = (
        'y > 0'
        'y < 0'
        'x > 0'
        'x < 0'
        'FULL')
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
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
end
