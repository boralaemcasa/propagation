object FormPrincipal: TFormPrincipal
  Left = 275
  Top = 6
  BorderStyle = bsDialog
  Caption = 'Gold Bach'
  ClientHeight = 687
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblNext: TLabel
    Left = 9
    Top = 6
    Width = 40
    Height = 13
    Caption = 'lblNext'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnArquivo: TButton
    Left = 7
    Top = 31
    Width = 129
    Height = 25
    Caption = 'Gravar em arquivo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnArquivoClick
  end
  object btnCancelar: TButton
    Left = 143
    Top = 31
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object Memo: TMemo
    Left = 7
    Top = 58
    Width = 401
    Height = 623
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnDblClick = MemoDblClick
  end
  object btnListar: TButton
    Left = 225
    Top = 31
    Width = 50
    Height = 25
    Caption = 'Listar'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnListarClick
  end
  object btnUmNro: TButton
    Left = 281
    Top = 31
    Width = 104
    Height = 25
    Caption = #218'nico N'#250'mero'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnUmNroClick
  end
  object btnTeste: TButton
    Left = 280
    Top = 1
    Width = 104
    Height = 25
    Caption = 'Teste'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnTesteClick
  end
end
