object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  Width = 496
  Height = 147
  Caption = 'Teste'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClick = FormClick
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 216
    Top = 48
  end
  object ColorDialog: TColorDialog
    Left = 104
    Top = 48
  end
end
