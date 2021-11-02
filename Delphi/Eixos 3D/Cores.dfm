object FormCores: TFormCores
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cores'
  ClientHeight = 287
  ClientWidth = 314
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
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 0
    OnClick = Panel1Click
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 1
    OnClick = Panel1Click
  end
  object Panel3: TPanel
    Left = 0
    Top = 82
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 2
    OnClick = Panel1Click
  end
  object Panel4: TPanel
    Left = 0
    Top = 123
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 3
    OnClick = Panel1Click
  end
  object Panel5: TPanel
    Left = 0
    Top = 164
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 4
    OnClick = Panel1Click
  end
  object Panel6: TPanel
    Left = 0
    Top = 205
    Width = 314
    Height = 41
    Align = alTop
    TabOrder = 5
    OnClick = Panel1Click
  end
  object Button1: TButton
    Left = 27
    Top = 256
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object Button2: TButton
    Left = 119
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 7
  end
  object btnPadroes: TButton
    Left = 211
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Padrões'
    TabOrder = 8
    OnClick = btnPadroesClick
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 264
    Top = 240
  end
end
