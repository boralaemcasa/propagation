object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 480
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
  object DBGrid1: TDBGrid
    Left = 145
    Top = 0
    Width = 543
    Height = 453
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object FileListBox1: TFileListBox
    Left = 0
    Top = 0
    Width = 145
    Height = 453
    Align = alLeft
    ItemHeight = 13
    Mask = '*.xml'
    TabOrder = 1
    OnChange = FileListBox1Change
    OnClick = FileListBox1Change
    OnKeyDown = FileListBox1KeyDown
  end
  object q: TClientDataSet
    Aggregates = <>
    FileName = 'D:\XML READER\TFGRD.xml'
    Params = <>
    Left = 80
    Top = 32
  end
  object DataSource1: TDataSource
    DataSet = q
    Left = 168
    Top = 24
  end
end
