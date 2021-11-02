object FormPrincipal: TFormPrincipal
  Left = 413
  Top = 13
  Width = 713
  Height = 590
  Caption = 'My Algebra - Release with ax + b = 0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelIn: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 300
    Align = alTop
    TabOrder = 0
    object MemoIn: TMemo
      Left = 1
      Top = 1
      Width = 695
      Height = 298
      Hint = 
        'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
        ' x_n)'#13#10'frac(a)(b)'#13#10'solve for x: ax + b = 0'#13#10'Right click for opti' +
        'ons'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      Lines.Strings = (
        'solve for i: n = ( frac(( i - a ) b + c)(d^2) - e frac(i - a)'
        '(d^3) - f ) g + ( h frac(i - a)(d^2) - j ) m')
      ParentFont = False
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 0
    end
  end
  object PanelEval: TPanel
    Left = 0
    Top = 300
    Width = 697
    Height = 40
    Hint = 
      'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
      ' x_n)'#13#10'frac(a)(b)'#13#10'solve for x: ax + b = 0'#13#10'Right click for opti' +
      'ons'
    Align = alTop
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 1
    object BtnEval: TButton
      Left = 311
      Top = 8
      Width = 75
      Height = 25
      Hint = 
        'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
        ' x_n)'#13#10'frac(a)(b)'#13#10'solve for x: ax + b = 0'#13#10'Right click for opti' +
        'ons'
      Cancel = True
      Caption = '&Evaluate'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = BtnEvalClick
    end
  end
  object MemoOut: TMemo
    Left = 0
    Top = 340
    Width = 697
    Height = 211
    Hint = 
      'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
      ' x_n)'#13#10'frac(a)(b)'#13#10'solve for x: ax + b = 0'#13#10'Right click for opti' +
      'ons'
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 288
    object Loadfromfile1: TMenuItem
      Caption = '&Load From File'
      OnClick = Loadfromfile1Click
    end
    object ShowLog1: TMenuItem
      Caption = '&Show Log'
      OnClick = ShowLog1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AbsoluteValue1: TMenuItem
      Caption = '&Absolute Value'
      OnClick = AbsoluteValue1Click
    end
    object GreatestCommonDivisor1: TMenuItem
      Caption = '&Greatest Common Divisor'
      OnClick = GreatestCommonDivisor1Click
    end
    object Fraction1: TMenuItem
      Caption = '&Fraction'
      OnClick = Fraction1Click
    end
    object Solveforx1: TMenuItem
      Caption = 'Solve for &x'
      OnClick = Solveforx1Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Text File|*.txt'
    Title = 'Load from file'
    Left = 248
    Top = 296
  end
end
