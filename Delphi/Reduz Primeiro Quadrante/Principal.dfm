object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 125
  Width = 514
  Height = 480
  Caption = 'Reduz Primeiro Quadrante'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 40
    Top = 16
    Width = 305
    Height = 21
    TabOrder = 0
  end
  object Memo: TMemo
    Left = 40
    Top = 56
    Width = 409
    Height = 345
    TabOrder = 1
    OnDblClick = MemoDblClick
  end
  object Button1: TButton
    Left = 368
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
end
