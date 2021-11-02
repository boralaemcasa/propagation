object FormPrincipal: TFormPrincipal
  Left = 10
  Top = 0
  Hint = 'Clique com o direito'
  BorderStyle = bsSingle
  Caption = 'Simplex'
  ClientHeight = 642
  ClientWidth = 1247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 16
    Width = 97
    Height = 13
    Hint = 'Clique com o direito'
    Caption = 'max c^T x + w_0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label2: TLabel
    Left = 4
    Top = 40
    Width = 44
    Height = 13
    Hint = 'Clique com o direito'
    Caption = 'Ax <= b'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label3: TLabel
    Left = 4
    Top = 64
    Width = 36
    Height = 13
    Hint = 'Clique com o direito'
    Caption = 'x >= 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object Label6: TLabel
    Left = 672
    Top = 96
    Width = 6
    Height = 13
    Caption = 'b'
  end
  object lblSalvar: TLabel
    Left = 24
    Top = 217
    Width = 63
    Height = 26
    Hint = 'Clique com o direito'
    Caption = 'Somente'#13#10'fim do jogo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lblSalvarClick
  end
  object Label10: TLabel
    Left = 775
    Top = 21
    Width = 5
    Height = 13
    Caption = 'x'
  end
  object Label17: TLabel
    Left = 880
    Top = 17
    Width = 26
    Height = 13
    Caption = 'Piv'#244's'
  end
  object Label4: TLabel
    Left = 117
    Top = 24
    Width = 19
    Height = 13
    Hint = 'Clique com o direito'
    Caption = 'c^T'
  end
  object lblA: TLabel
    Left = 117
    Top = 96
    Width = 9
    Height = 13
    Hint = 'Clique com o direito'
    Caption = 'A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnInit: TButton
    Left = 4
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Init'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnInitClick
  end
  object w0: TLabeledEdit
    Left = 672
    Top = 39
    Width = 98
    Height = 21
    Hint = 'Clique com o direito'
    EditLabel.Width = 20
    EditLabel.Height = 13
    EditLabel.Caption = 'w_0'
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 1
  end
  object b: TStringGrid
    Left = 672
    Top = 112
    Width = 100
    Height = 158
    Hint = 'Clique com o direito'
    DefaultColWidth = 90
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 2
  end
  object btnFind: TButton
    Left = 4
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Find First'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnFindClick
  end
  object Memo: TMemo
    Left = 880
    Top = 34
    Width = 113
    Height = 239
    Hint = 'Clique duplo para limpar Memo de linhas e colunas'
    ParentShowHint = False
    ScrollBars = ssHorizontal
    ShowHint = True
    TabOrder = 4
    OnDblClick = MemoDblClick
  end
  object cbSalvar: TCheckBox
    Left = 4
    Top = 201
    Width = 97
    Height = 17
    Caption = 'Salvar'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    State = cbChecked
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 995
    Top = 208
    Width = 247
    Height = 64
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object lblNegativos: TLabel
      Left = 7
      Top = 11
      Width = 179
      Height = 40
      Caption = '0 negativos em nova c'#13#10'0 negativos em novo b'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Lucida Sans Unicode'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object x: TStringGrid
    Left = 775
    Top = 37
    Width = 100
    Height = 236
    Hint = 'Clique com o direito'
    DefaultColWidth = 90
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 7
  end
  object PanelCalcular: TPanel
    Left = 0
    Top = 277
    Width = 1247
    Height = 365
    Hint = 'Clique com o direito'
    Align = alBottom
    TabOrder = 8
    object Label7: TLabel
      Left = 384
      Top = 5
      Width = 46
      Height = 13
      Caption = 'nova c^T'
    end
    object lblNovaA: TLabel
      Left = 384
      Top = 77
      Width = 41
      Height = 13
      Caption = 'nova A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 1162
      Top = 77
      Width = 33
      Height = 13
      Caption = 'novo b'
    end
    object Label11: TLabel
      Left = 8
      Top = 5
      Width = 37
      Height = 13
      Caption = 'OP c^T'
    end
    object Label12: TLabel
      Left = 8
      Top = 77
      Width = 25
      Height = 13
      Caption = 'OP A'
    end
    object novaCT: TStringGrid
      Left = 384
      Top = 21
      Width = 764
      Height = 41
      Hint = 'Clique com o direito'
      DefaultColWidth = 50
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 0
    end
    object novow0: TLabeledEdit
      Left = 1162
      Top = 21
      Width = 78
      Height = 21
      Hint = 'Clique com o direito'
      EditLabel.Width = 47
      EditLabel.Height = 13
      EditLabel.Caption = 'novo w_0'
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 1
    end
    object novaA: TStringGrid
      Left = 384
      Top = 93
      Width = 763
      Height = 268
      Hint = 'Clique com o direito'
      DefaultColWidth = 50
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 2
    end
    object novoB: TStringGrid
      Left = 1160
      Top = 93
      Width = 81
      Height = 268
      Hint = 'Clique com o direito'
      DefaultColWidth = 70
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 3
    end
    object opNovaCT: TStringGrid
      Left = 8
      Top = 21
      Width = 369
      Height = 41
      Hint = 'Clique com o direito'
      DefaultColWidth = 50
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 4
    end
    object opNovaA: TStringGrid
      Left = 8
      Top = 93
      Width = 369
      Height = 268
      Hint = 'Clique com o direito'
      DefaultColWidth = 50
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu2
      ShowHint = True
      TabOrder = 5
    end
    object cTmenosyTA: TStringGrid
      Left = 734
      Top = 69
      Width = 100
      Height = 236
      DefaultColWidth = 90
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = False
      TabOrder = 6
      Visible = False
    end
  end
  object btnCancelar: TButton
    Left = 5
    Top = 165
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = btnCancelarClick
  end
  object cT: TStringGrid
    Left = 116
    Top = 40
    Width = 545
    Height = 41
    Hint = 'Clique com o direito'
    DefaultColWidth = 50
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 10
  end
  object A: TStringGrid
    Left = 116
    Top = 112
    Width = 545
    Height = 153
    Hint = 'Clique com o direito'
    DefaultColWidth = 50
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    TabOrder = 11
  end
  object MemoTemp: TMemo
    Left = 760
    Top = 2
    Width = 113
    Height = 295
    Hint = 'Clique duplo para limpar Memo de linhas e colunas'
    ParentShowHint = False
    ScrollBars = ssHorizontal
    ShowHint = True
    TabOrder = 12
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.ini'
    FileName = '*.ini'
    Filter = '*.txt|Separado por Espa'#231'os|*.ini|Formatado em Colchetes'
    Left = 136
    Top = 208
  end
  object PopupMenu1: TPopupMenu
    Left = 572
    Top = 184
    object FPI: TMenuItem
      Caption = 'Colocar em F. P. Igualdade'
      OnClick = FPIClick
    end
    object Descerdireto: TMenuItem
      Caption = 'Descer direto'
      OnClick = DescerdiretoClick
    end
    object Criarvariveisauxiliares: TMenuItem
      Caption = 'Criar vari'#225'veis auxiliares'
      OnClick = CriarvariveisauxiliaresClick
    end
    object FPIVariveisAuxiliares: TMenuItem
      Caption = 'FPI + Vari'#225'veis Auxiliares'
      OnClick = FPIVariveisAuxiliaresClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 552
    Top = 464
    object PivoterColLi: TMenuItem
      Caption = 'Pivotear (col, li) = ...'
      OnClick = PivoterColLiClick
    end
    object rocarosinaldalinha: TMenuItem
      Caption = 'Trocar o sinal da linha...'
      OnClick = rocarosinaldalinhaClick
    end
    object Calcularx: TMenuItem
      Caption = 'Calcular x'
      OnClick = CalcularxClick
    end
    object PrimalNegativosUmMovimento: TMenuItem
      Caption = 'Primal de negativos - um movimento'
      ShortCut = 116
      OnClick = PrimalNegativosUmMovimentoClick
    end
    object Dualummovimento: TMenuItem
      Caption = 'Dual - um movimento'
      ShortCut = 117
      OnClick = DualummovimentoClick
    end
    object PrimalZeroUmmovimento: TMenuItem
      Caption = 'Primal de zero - um movimento'
      ShortCut = 118
      OnClick = PrimalZeroUmmovimentoClick
    end
    object PrimalNegativosPlay: TMenuItem
      Caption = 'Primal de negativos - Play'
      OnClick = PrimalNegativosPlayClick
    end
    object DualPlay: TMenuItem
      Caption = 'Dual - Play'
      OnClick = DualPlayClick
    end
    object PrimalZeroPlay: TMenuItem
      Caption = 'Primal de zero - Play'
      OnClick = PrimalZeroPlayClick
    end
  end
end
