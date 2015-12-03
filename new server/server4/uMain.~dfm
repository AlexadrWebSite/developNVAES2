object fMain: TfMain
  Left = 302
  Top = 184
  Width = 873
  Height = 460
  Caption = #1057#1080#1084#1091#1083#1103#1090#1086#1088' '#1089#1077#1088#1074#1077#1088#1072' '#1057#1042#1056#1050
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    857
    422)
  PixelsPerInch = 96
  TextHeight = 13
  object lStart: TLabel
    Left = 8
    Top = 80
    Width = 3
    Height = 13
  end
  object lEnd: TLabel
    Left = 240
    Top = 44
    Width = 3
    Height = 13
    Anchors = [akTop, akRight]
  end
  object lCur: TLabel
    Left = 16
    Top = 50
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 8
    Top = 93
    Width = 128
    Height = 13
    Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103' '#1085#1072' '#1075#1088#1072#1092#1080#1082#1077':'
  end
  object lProcess: TLabel
    Left = 11
    Top = 63
    Width = 3
    Height = 13
  end
  object lValue: TLabel
    Left = 14
    Top = 118
    Width = 3
    Height = 13
  end
  object bbOpen: TBitBtn
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = bbOpenClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      88888888888888888888000000000008888800333333333088880B0333333333
      08880FB03333333330880BFB0333333333080FBFB000000000000BFBFBFBFB08
      88880FBFBFBFBF0888880BFB0000000888888000888888880008888888888888
      8008888888880888080888888888800088888888888888888888}
  end
  object pbLoading: TProgressBar
    Left = 8
    Top = 72
    Width = 846
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object cbParam: TComboBox
    Left = 151
    Top = 91
    Width = 482
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnChange = cbParamChange
  end
  object Chart: TChart
    Left = 8
    Top = 135
    Width = 321
    Height = 271
    Title.Text.Strings = (
      'TChart')
    View3D = False
    TabOrder = 3
    Anchors = [akLeft, akTop, akRight, akBottom]
    object Series1: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ShowInLegend = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object ChartTool1: TCursorTool
      Pen.Color = clBlue
      Style = cssVertical
      OnChange = ChartTool1Change
    end
  end
  object sgModeBus: TStringGrid
    Left = 336
    Top = 136
    Width = 516
    Height = 279
    Anchors = [akTop, akRight, akBottom]
    ColCount = 6
    DefaultColWidth = 55
    DefaultRowHeight = 20
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 4
    ColWidths = (
      80
      116
      110
      67
      55
      55)
  end
  object Memo1: TMemo
    Left = 392
    Top = 1
    Width = 393
    Height = 64
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 112
    Top = 8
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #1042#1089#1077' '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1092#1086#1088#1084#1072#1090#1099' '#1092#1072#1081#1083#1086#1074' '#1057#1042#1056#1050'|*.dmk;*.tcf;*.fep;*.rsa;*' +
      '.txt;*.sti;*.scd;*.csv;*.LOG;*.html;*.mht;*.sem|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*)|*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 144
    Top = 8
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 1050
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    Left = 232
    Top = 8
  end
end
