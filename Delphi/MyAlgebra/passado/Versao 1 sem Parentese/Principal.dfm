object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 125
  Width = 888
  Height = 410
  Caption = 'My Algebra - Release with no Parenthesis'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 872
    Height = 100
    Align = alTop
    TabOrder = 0
    object MemoIn: TMemo
      Left = 1
      Top = 1
      Width = 870
      Height = 98
      Hint = 'a + b - c * d / e ^ f'#13#10'a^(-b) = a#b'
      Align = alClient
      Lines.Strings = (
        '-2^0 + 3^2 * 5^3 - 7 * 9 + 11 / 13^4 / 15 / 17^5')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 100
    Width = 872
    Height = 40
    Hint = 'a + b - c * d / e ^ f'#13#10'a^(-b) = a#b'
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object BtnEval: TButton
      Left = 398
      Top = 8
      Width = 75
      Height = 25
      Hint = 'a + b - c * d / e ^ f'#13#10'a^(-b) = a#b'
      Caption = 'Evaluate'
      TabOrder = 0
      OnClick = BtnEvalClick
    end
  end
  object MemoOut: TMemo
    Left = 0
    Top = 140
    Width = 872
    Height = 231
    Hint = 'a + b - c * d / e ^ f'#13#10'a^(-b) = a#b'
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
end
