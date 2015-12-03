object Form1: TForm1
  Left = 132
  Top = 228
  Width = 928
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
  object memo1: TMemo
    Left = 24
    Top = 16
    Width = 849
    Height = 345
    Lines.Strings = (
      'memo1')
    TabOrder = 0
  end
  object clientSocket2: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Left = 32
    Top = 392
  end
end
