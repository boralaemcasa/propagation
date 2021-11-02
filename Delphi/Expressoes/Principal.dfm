object FormPrincipal: TFormPrincipal
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Express'#245'es'
  ClientHeight = 53
  ClientWidth = 536
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
  object ed: TEdit
    Left = 16
    Top = 16
    Width = 505
    Height = 21
    TabOrder = 0
    Text = '-1$(1/2)'
    OnKeyPress = edKeyPress
  end
end
