object Form1: TForm1
  Left = 196
  Top = 111
  Width = 123
  Height = 101
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 30
    Top = 16
  end
end
