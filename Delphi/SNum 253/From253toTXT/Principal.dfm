object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 928
  Height = 480
  Caption = '253 to TXT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 185
    Height = 453
    Align = alLeft
    Color = 15397587
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnKeyUp = Memo1KeyUp
  end
  object Memo2: TMemo
    Left = 735
    Top = 0
    Width = 185
    Height = 453
    Align = alRight
    Color = 15397587
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu2
    TabOrder = 1
    OnKeyUp = Memo2KeyUp
  end
  object PopupMenu1: TPopupMenu
    Left = 104
    Top = 72
    object Abrir1: TMenuItem
      Caption = 'Abrir...'
      OnClick = Abrir1Click
    end
    object ConverterparaTXT1: TMenuItem
      Caption = 'Converter para TXT decimal'
      OnClick = ConverterparaTXT1Click
    end
    object Converterpara2531: TMenuItem
      Caption = 'Converter para 253'
      OnClick = Converterpara2531Click
    end
    object Salvarcomo1: TMenuItem
      Caption = 'Salvar como...'
      OnClick = Salvarcomo1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 800
    Top = 80
    object MenuItem1: TMenuItem
      Caption = 'Abrir...'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = 'Converter para TXT decimal'
      OnClick = MenuItem2Click
    end
    object MenuItem3: TMenuItem
      Caption = 'Converter para 253'
      OnClick = MenuItem3Click
    end
    object MenuItem4: TMenuItem
      Caption = 'Salvar como...'
      OnClick = MenuItem4Click
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'TXT & 253|*.txt;*.253|253|*.253|TXT|*.txt'
    Left = 288
    Top = 120
  end
  object SaveDialog: TSaveDialog
    Left = 288
    Top = 160
  end
end
