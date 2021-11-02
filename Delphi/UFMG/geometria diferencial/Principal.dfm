object FormPrincipal: TFormPrincipal
  Left = 122
  Top = 57
  Width = 808
  Height = 580
  Caption = 'Geometria Diferencial (QWE ASD 0 F1 F2 F3 Esc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Lista: TListBox
    Left = -1
    Top = -2
    Width = 145
    Height = 149
    ItemHeight = 13
    Items.Strings = (
      'Faixa de M'#246'bius'
      'Esfera'
      'Elipsoide'
      'Paraboloide El'#237'ptico'
      'Paraboloide Hiperb'#243'lico'
      'Hiperboloide de Uma Folha'
      'Hiperboloide de Duas Folhas'
      'Cilindro'
      'Cone sem o V'#233'rtice'
      'Superf'#237'cie M'#237'nima de Scherk'
      'Superf'#237'cie M'#237'nima de Costa')
    TabOrder = 0
    OnClick = ListaClick
  end
  object TimerInit: TTimer
    Interval = 500
    OnTimer = TimerInitTimer
    Left = 392
    Top = 288
  end
end
