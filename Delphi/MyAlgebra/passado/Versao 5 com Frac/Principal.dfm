object FormPrincipal: TFormPrincipal
  Left = 413
  Top = 13
  Width = 523
  Height = 590
  Caption = 'My Algebra - Release with frac'
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
    Width = 507
    Height = 165
    Align = alTop
    TabOrder = 0
    object MemoIn: TMemo
      Left = 1
      Top = 1
      Width = 505
      Height = 163
      Hint = 
        'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
        ' x_n)'#13#10'frac(a)(b)'
      Align = alClient
      Lines.Strings = (
        
          '7 = ( frac(( i - 5 ) b + 3)(d^2) - 2 frac(i - 5)(d^3) - 11 ) g +' +
          ' ( h frac(i - 5)(d^2) - 13 ) m;'
        'isolate i;'
        '')
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 0
    end
  end
  object PanelEval: TPanel
    Left = 0
    Top = 165
    Width = 507
    Height = 40
    Hint = 
      'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
      ' x_n)'#13#10'frac(a)(b)'
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object BtnEval: TButton
      Left = 216
      Top = 8
      Width = 75
      Height = 25
      Hint = 
        'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
        ' x_n)'#13#10'frac(a)(b)'
      Cancel = True
      Caption = '&Evaluate'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnEvalClick
    end
  end
  object MemoOut: TMemo
    Left = 0
    Top = 205
    Width = 507
    Height = 346
    Hint = 
      'a + abs(b) - c * d / e ^ (-f)'#13#10'(a)(b)'#13#10'a(b)'#13#10'(a)b'#13#10'gcd(x_1, ...,' +
      ' x_n)'#13#10'frac(a)(b)'
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 288
    object Loadfromfile1: TMenuItem
      Caption = 'Load from file'
      OnClick = Loadfromfile1Click
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
