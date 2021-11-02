object Form1: TForm1
  Left = 196
  Top = 107
  Width = 235
  Height = 172
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 48
    Top = 56
    Width = 113
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 0
    Text = '  crDefault  '
    OnChange = ComboBox1Change
    Items.Strings = (
      '  crDefault  '
      '  crNone     '
      '  crArrow    '
      '  crCross    '
      '  crIBeam    '
      '  crSize     '
      '  crSizeNESW '
      '  crSizeNS   '
      '  crSizeNWSE '
      '  crSizeWE   '
      '  crUpArrow  '
      '  crHourGlass'
      '  crDrag     '
      '  crNoDrop   '
      '  crHSplit   '
      '  crVSplit   '
      '  crMultiDrag'
      '  crSQLWait  '
      '  crNo       '
      '  crAppStart '
      '  crHelp     '
      '  crHandPoint'
      '  crSizeAll  ')
  end
end
