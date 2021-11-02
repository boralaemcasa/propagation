object frm_principal: Tfrm_principal
  Left = 66
  Top = 66
  Width = 901
  Height = 573
  Caption = 'Derivator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 104
    Top = 145
    Width = 65
    Height = 13
    Caption = 'Em rela'#231#227'o a:'
  end
  object btnDerivate: TButton
    Left = 16
    Top = 138
    Width = 75
    Height = 25
    Caption = 'Derivar'
    TabOrder = 0
    OnClick = btnDerivateClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 893
    Height = 67
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object Label3: TLabel
      Left = 5
      Top = 23
      Width = 52
      Height = 13
      Caption = 'Derivando:'
    end
    object MemoSource: TMemo
      Left = 64
      Top = 1
      Width = 825
      Height = 62
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '(I_3 - A_3)^3 ( 2 w_{xy}^2 w_{yy} - w_{xxy} w_{yy} w_y )')
      ParentFont = False
      PopupMenu = PopupMenu1
      ScrollBars = ssHorizontal
      TabOrder = 0
    end
  end
  object MemoDest: TMemo
    Left = 0
    Top = 200
    Width = 893
    Height = 346
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu2
    ScrollBars = ssHorizontal
    TabOrder = 2
  end
  object btnTeste: TButton
    Left = 8
    Top = 82
    Width = 75
    Height = 25
    Caption = 'teste'
    TabOrder = 3
    OnClick = btnTesteClick
  end
  object Panel2: TPanel
    Left = 112
    Top = 68
    Width = 663
    Height = 59
    Caption = 'Panel1'
    TabOrder = 4
    object Label1: TLabel
      Left = 5
      Top = 23
      Width = 56
      Height = 13
      Caption = 'Constantes:'
    end
    object MemoConst: TMemo
      Left = 72
      Top = 1
      Width = 590
      Height = 56
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'A_3'
        'A_2'
        'A_1'
        'R')
      ParentFont = False
      TabOrder = 0
    end
  end
  object edit: TEdit
    Left = 176
    Top = 140
    Width = 25
    Height = 21
    MaxLength = 1
    TabOrder = 5
    Text = 'x'
  end
  object btnDistribuir: TButton
    Left = 264
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Distributiva'
    TabOrder = 6
    OnClick = btnDistribuirClick
  end
  object OpenDialog: TOpenDialog
    Left = 288
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 400
    Top = 32
    object Loadfromfile1: TMenuItem
      Caption = 'Load from file...'
      OnClick = Loadfromfile1Click
    end
    object LongoProcesso1: TMenuItem
      Caption = 'Longo Processo'
      OnClick = LongoProcesso1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 360
    Top = 416
    object CRLFbeforeand1: TMenuItem
      Caption = 'CR/LF before + and -'
      OnClick = CRLFbeforeand1Click
    end
    object Width2911: TMenuItem
      Caption = 'Width 291'
      OnClick = Width2911Click
    end
    object N30lines1: TMenuItem
      Caption = '30 lines'
      OnClick = N30lines1Click
    end
    object Deletemultline1: TMenuItem
      Caption = 'Delete multline'
      OnClick = Deletemultline1Click
    end
    object Mandarparacima1: TMenuItem
      Caption = 'Mandar para cima'
      OnClick = Mandarparacima1Click
    end
  end
end
