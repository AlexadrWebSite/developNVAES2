object fPTKZ: TfPTKZ
  Left = 227
  Top = 370
  Width = 913
  Height = 426
  Caption = #1055#1058#1050'-'#1047
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 897
    Height = 388
    Align = alClient
    ColCount = 14
    DefaultDrawing = False
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    OnDblClick = StringGridDblClick
    OnDrawCell = StringGridDrawCell
    OnSelectCell = StringGridSelectCell
    ColWidths = (
      141
      159
      66
      51
      45
      45
      44
      32
      33
      32
      35
      38
      37
      115)
  end
end
