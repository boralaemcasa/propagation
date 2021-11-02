object FormPrincipal: TFormPrincipal
  Left = 233
  Top = 84
  Width = 714
  Height = 579
  Caption = 'My Algebra - Release with binom'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFF87733788FFFFFFFFFFFFFFFFFFFFFF88788887318FFFFFFFFFFFFFFF
    FFFFF878F88FFF87008FFFFFFFFFFFFFFFF888FFF808FFFF8707FFFFFFFFFFFF
    FFFFFFFFFF008FFFF8707FFFFFFFFFFFFF8FF8FFF8000FFFF7F807FFFFFFFFFF
    F8730038F0008FFF80FF708FFFFFFFFFFFF8300F8000F803008FF17FFFFFFFFF
    FFFF800770737000008FF80FFFFFFFFFFFFF800073333700778FFF08FFFFFFFF
    FFFFF70700000073FFFFF877FFFFFFFFF803F83000000033878FFF77FFFFFFFF
    800000700000000700387783FFFFFFF8333000300000000700000887FFFFFFF8
    8FF303700000000737008F87FFFFFFFFFFFFF87300000071F878FF78FFFFFFFF
    FFFFF8073000073008FFFF7FFFFFFFFFFFF700003737770008FFF87FFFFFFFFF
    FFF300008330387008FFF8FFFFFFFFFFFFF30778F7003F80007888FFFFFFFFFF
    FFF77FFF83007F8888888FFFFFFFFFFFFFF88FFF80078FFFFFF8FFFFFFFFFFFF
    FFFFFFFFF707FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF838FF8FFFFFFFFFFFFFFFF
    FFFFFFFFFFF88FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelIn: TPanel
    Left = 0
    Top = 0
    Width = 698
    Height = 300
    Align = alTop
    TabOrder = 0
    object MemoIn: TMemo
      Left = 1
      Top = 1
      Width = 696
      Height = 298
      Hint = 
        '(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ..., x_n)'#13#10'(a + b)c, (a + b)/c, a(b' +
        ' + c)'#13#10'x^(a + b) = x^ax^b'#13#10'x^(a - b) = x^a/x^b'#13#10'x^(ab) = x^a^b'#13#10 +
        'x^(a/b) = x^a^(1/b)'#13#10'binom(n + a/b, p + a/b)'#13#10'log(a/b) gives to ' +
        'you ln with error < 1/100'#13#10'Right click for options and examples'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      Lines.Strings = (
        '2^(2x/5+3y/7)')
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
    Width = 698
    Height = 40
    Hint = 
      '(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ..., x_n)'#13#10'(a + b)c, (a + b)/c, a(b' +
      ' + c)'#13#10'x^(a + b) = x^ax^b'#13#10'x^(a - b) = x^a/x^b'#13#10'x^(ab) = x^a^b'#13#10 +
      'x^(a/b) = x^a^(1/b)'#13#10'binom(n + a/b, p + a/b)'#13#10'log(a/b) gives to ' +
      'you ln with error < 1/100'#13#10'Right click for options and examples'
    Align = alTop
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 1
    object PanelButtons: TPanel
      Left = 228
      Top = 5
      Width = 241
      Height = 32
      TabOrder = 0
      object BtnEval: TButton
        Left = 16
        Top = 3
        Width = 105
        Height = 25
        Hint = 
          '(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ..., x_n)'#13#10'(a + b)c, (a + b)/c, a(b' +
          ' + c)'#13#10'x^(a + b) = x^ax^b'#13#10'x^(a - b) = x^a/x^b'#13#10'x^(ab) = x^a^b'#13#10 +
          'x^(a/b) = x^a^(1/b)'#13#10'binom(n + a/b, p + a/b)'#13#10'log(a/b) gives to ' +
          'you ln with error < 1/100'#13#10'Right click for options and examples'
        Caption = '&Evaluate (F5)'
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
      object BtnCancel: TButton
        Left = 128
        Top = 3
        Width = 99
        Height = 25
        Cancel = True
        Caption = 'Cancel (ESC)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnCancelClick
      end
    end
  end
  object MemoOut: TMemo
    Left = 0
    Top = 340
    Width = 698
    Height = 200
    Hint = 
      '(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ..., x_n)'#13#10'(a + b)c, (a + b)/c, a(b' +
      ' + c)'#13#10'x^(a + b) = x^ax^b'#13#10'x^(a - b) = x^a/x^b'#13#10'x^(ab) = x^a^b'#13#10 +
      'x^(a/b) = x^a^(1/b)'#13#10'binom(n + a/b, p + a/b)'#13#10'log(a/b) gives to ' +
      'you ln with error < 1/100'#13#10'Right click for options and examples'
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 248
    object Loadfromfile1: TMenuItem
      Caption = 'L&oad From File'
      ShortCut = 16463
      OnClick = Loadfromfile1Click
    end
    object ShowLog1: TMenuItem
      Caption = '&Show Log'
      ShortCut = 112
      OnClick = ShowLog1Click
    end
    object Evaluate1: TMenuItem
      Caption = '&Evaluate'
      ShortCut = 116
      OnClick = Evaluate1Click
    end
    object Cancel1: TMenuItem
      Caption = 'Ca&ncel'
      ShortCut = 27
    end
    object Clear1: TMenuItem
      Caption = '&Clear'
      ShortCut = 16430
      OnClick = Clear1Click
    end
    object IncreaseSize1: TMenuItem
      Caption = '&Increase Size'
      ShortCut = 16604
      OnClick = IncreaseSize1Click
    end
    object DecreaseSize1: TMenuItem
      Caption = '&Decrease Size'
      ShortCut = 16605
      OnClick = DecreaseSize1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AbsoluteValue1: TMenuItem
      Caption = '&Absolute Value'
      ShortCut = 16449
      OnClick = AbsoluteValue1Click
    end
    object GreatestCommonDivisor1: TMenuItem
      Caption = '&Greatest Common Divisor'
      ShortCut = 16455
      OnClick = GreatestCommonDivisor1Click
    end
    object Floor1: TMenuItem
      Caption = 'Floo&r'
      ShortCut = 16466
      OnClick = Floor1Click
    end
    object Fraction1: TMenuItem
      Caption = '&Fraction'
      ShortCut = 16454
      OnClick = Fraction1Click
    end
    object Gamma1: TMenuItem
      Caption = 'Ga&mma'
      ShortCut = 16461
      OnClick = Gamma1Click
    end
    object Logarithm1: TMenuItem
      Caption = 'Natural &Log'
      ShortCut = 16460
      OnClick = Logarithm1Click
    end
    object NewtonBinomial1: TMenuItem
      Caption = 'Newton &Binomial'
      ShortCut = 16450
      OnClick = NewtonBinomial1Click
    end
    object Solveforx1: TMenuItem
      Caption = 'Solve for &x'
      ShortCut = 118
      OnClick = Solveforx1Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'Text File|*.txt'
    Title = 'Load from file'
    Left = 248
    Top = 264
  end
end
