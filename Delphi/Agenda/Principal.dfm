object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'Pessoas    ^N = NULL; F5 = Contador; ^D = De Onde;  shift+DEL'
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
  object grid: TDBGrid
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    DataSource = dsPessoas
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnColEnter = gridColEnter
    OnKeyDown = gridKeyDown
    OnKeyPress = gridKeyPress
    OnTitleClick = gridTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Nome'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 166
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        PopupMenu = popTiposCivis
        ReadOnly = True
        Title.Caption = 'Tipo Civil'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Pendencia'
        Title.Caption = 'Pend'#234'ncia'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 67
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'De_Onde'
        PopupMenu = popDeOnde
        Title.Caption = 'De Onde'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 163
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DDD'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Fones'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 133
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Email'
        Title.Caption = 'E-Mail'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 129
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Endereco'
        Title.Caption = 'Endere'#231'o'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Observacao'
        Title.Caption = 'Observa'#231#227'o'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsBold]
        Width = 162
        Visible = True
      end>
  end
  object dsPessoas: TDataSource
    DataSet = qryPessoas
    Left = 32
    Top = 72
  end
  object qryPessoas: TQuery
    CachedUpdates = True
    AfterInsert = qryPessoasAfterInsert
    BeforePost = qryPessoasBeforePost
    AfterPost = qryPessoasAfterPost
    AfterScroll = qryPessoasAfterScroll
    DatabaseName = 'N:\Trabalho\Programacao\Delphi\Agenda'
    SQL.Strings = (
      'select p.*, t.descricao'
      'from pessoas p left join tipos_civis t'
      'on p.cod_tipocivil = t.codigo'
      'order by nome')
    UpdateObject = UpdateSQL1
    Left = 88
    Top = 72
    object qryPessoasNome: TStringField
      FieldName = 'Nome'
      Size = 255
    end
    object qryPessoasDe_Onde: TStringField
      FieldName = 'De_Onde'
      Size = 255
    end
    object qryPessoasCod_TipoCivil: TIntegerField
      FieldName = 'Cod_TipoCivil'
    end
    object qryPessoasPendencia: TIntegerField
      FieldName = 'Pendencia'
    end
    object qryPessoasDDD: TStringField
      FieldName = 'DDD'
      Size = 6
    end
    object qryPessoasFones: TStringField
      FieldName = 'Fones'
      Size = 255
    end
    object qryPessoasEmail: TStringField
      FieldName = 'Email'
      Size = 255
    end
    object qryPessoasEndereco: TStringField
      FieldName = 'Endereco'
      Size = 255
    end
    object qryPessoasObservacao: TStringField
      FieldName = 'Observacao'
      Size = 255
    end
    object qryPessoasdescricao: TStringField
      FieldName = 'descricao'
      Size = 255
    end
  end
  object UpdateSQL1: TUpdateSQL
    ModifySQL.Strings = (
      'update pessoas'
      'set'
      '  Nome = :Nome,'
      '  De_Onde = :De_Onde,'
      '  Cod_TipoCivil = :Cod_TipoCivil,'
      '  Pendencia = :Pendencia,'
      '  DDD = :DDD,'
      '  Fones = :Fones,'
      '  Email = :Email,'
      '  Endereco = :Endereco,'
      '  Observacao = :Observacao'
      'where'
      '  Nome = :OLD_Nome and'
      '  De_Onde = :OLD_De_Onde')
    InsertSQL.Strings = (
      'insert into pessoas'
      
        '  (Nome, De_Onde, Cod_TipoCivil, Pendencia, DDD, Fones, Email, E' +
        'ndereco, '
      '   Observacao)'
      'values'
      
        '  (:Nome, :De_Onde, :Cod_TipoCivil, :Pendencia, :DDD, :Fones, :E' +
        'mail, :Endereco, '
      '   :Observacao)')
    DeleteSQL.Strings = (
      'delete from pessoas'
      'where'
      '  Nome = :OLD_Nome and'
      '  De_Onde = :OLD_De_Onde')
    Left = 88
    Top = 120
  end
  object popTiposCivis: TPopupMenu
    Left = 160
    Top = 120
    object TipoCivilNull: TMenuItem
      OnClick = itemTipoCivilClick
    end
  end
  object tbTiposCivis: TTable
    DatabaseName = 'N:\Trabalho\Programacao\Delphi\Agenda'
    TableName = 'Tipos_Civis.db'
    Left = 160
    Top = 72
    object tbTiposCivisCodigo: TAutoIncField
      FieldName = 'Codigo'
      ReadOnly = True
    end
    object tbTiposCivisDescricao: TStringField
      FieldName = 'Descricao'
      Size = 255
    end
  end
  object qryDeOnde: TQuery
    CachedUpdates = True
    AfterInsert = qryPessoasAfterInsert
    BeforePost = qryPessoasBeforePost
    AfterPost = qryPessoasAfterPost
    AfterScroll = qryPessoasAfterScroll
    DatabaseName = 'N:\Trabalho\Programacao\Delphi\Agenda'
    SQL.Strings = (
      'select distinct de_onde'
      'from pessoas'
      'order by 1')
    Left = 232
    Top = 72
    object qryDeOndede_onde: TStringField
      FieldName = 'de_onde'
      Size = 255
    end
  end
  object popDeOnde: TPopupMenu
    Left = 232
    Top = 120
  end
  object qryContador: TQuery
    CachedUpdates = True
    AfterInsert = qryPessoasAfterInsert
    BeforePost = qryPessoasBeforePost
    AfterPost = qryPessoasAfterPost
    AfterScroll = qryPessoasAfterScroll
    DatabaseName = 'N:\Trabalho\Programacao\Delphi\Agenda'
    SQL.Strings = (
      'select count(*) nro'
      'from pessoas')
    Left = 296
    Top = 72
    object qryContadornro: TIntegerField
      FieldName = 'nro'
    end
  end
end
