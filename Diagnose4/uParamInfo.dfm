object fParamInfo: TfParamInfo
  Left = 441
  Top = 206
  Width = 534
  Height = 654
  Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sbClose: TSpeedButton
    Left = 296
    Top = 543
    Width = 129
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    OnClick = sbCloseClick
  end
  object Label3: TLabel
    Left = 288
    Top = 430
    Width = 3
    Height = 13
  end
  object Bevel1: TBevel
    Left = 112
    Top = 170
    Width = 401
    Height = 199
    Shape = bsFrame
  end
  object lValue: TLabel
    Left = 16
    Top = 182
    Width = 3
    Height = 13
  end
  object lSKO: TLabel
    Left = 24
    Top = 362
    Width = 3
    Height = 13
  end
  object sbChangeCalcParamInfo: TSpeedButton
    Left = 16
    Top = 543
    Width = 129
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    OnClick = sbChangeCalcParamInfoClick
  end
  object leName: TLabeledEdit
    Left = 13
    Top = 35
    Width = 253
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
    TabOrder = 0
  end
  object leMUnit: TLabeledEdit
    Left = 277
    Top = 34
    Width = 74
    Height = 21
    EditLabel.Width = 78
    EditLabel.Height = 13
    EditLabel.Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103' '
    LabelPosition = lpRight
    TabOrder = 1
  end
  object leKKS: TLabeledEdit
    Left = 113
    Top = 1
    Width = 153
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'KKS '
    LabelPosition = lpLeft
    TabOrder = 2
  end
  object leValue: TLabeledEdit
    Left = 17
    Top = 154
    Width = 74
    Height = 21
    EditLabel.Width = 95
    EditLabel.Height = 13
    EditLabel.Caption = #1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 3
  end
  object leSKO: TLabeledEdit
    Left = 25
    Top = 441
    Width = 74
    Height = 21
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = #1058#1077#1082#1091#1097#1077#1077' '#1057#1050#1054
    TabOrder = 4
  end
  object leTime: TLabeledEdit
    Left = 136
    Top = 506
    Width = 187
    Height = 21
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = #1044#1072#1090#1072', '#1074#1088#1077#1084#1103' '
    LabelPosition = lpLeft
    TabOrder = 5
  end
  object gbParallel1: TGroupBox
    Left = 123
    Top = 174
    Width = 118
    Height = 187
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1087#1072#1088#1072#1083'.'
    Color = clLime
    ParentColor = False
    TabOrder = 6
    object lParallName1: TLabel
      Left = 10
      Top = 23
      Width = 3
      Height = 13
    end
    object leParal1: TLabeledEdit
      Left = 9
      Top = 64
      Width = 76
      Height = 21
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1083'.'
      TabOrder = 0
    end
    object leParalDeltaDop1: TLabeledEdit
      Left = 9
      Top = 138
      Width = 74
      Height = 21
      EditLabel.Width = 92
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1086#1077' '#1086#1090#1082#1083'.'
      TabOrder = 1
    end
    object leParalDelta1: TLabeledEdit
      Left = 9
      Top = 100
      Width = 74
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
      TabOrder = 2
    end
    object bParal1: TButton
      Left = 8
      Top = 160
      Width = 41
      Height = 25
      Caption = '||'
      TabOrder = 3
      OnClick = bParal1Click
    end
  end
  object gbNominal: TGroupBox
    Left = 123
    Top = 62
    Width = 289
    Height = 105
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1085#1086#1084#1080#1085#1072#1083#1086#1084
    Color = clLime
    ParentColor = False
    TabOrder = 7
    object leNominalMax: TLabeledEdit
      Left = 9
      Top = 31
      Width = 120
      Height = 21
      EditLabel.Width = 152
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1080#1085#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ('#1074#1077#1088#1093')'
      TabOrder = 0
    end
    object leNominalMin: TLabeledEdit
      Left = 9
      Top = 70
      Width = 120
      Height = 21
      EditLabel.Width = 147
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1086#1084#1080#1085#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ('#1085#1080#1079')'
      TabOrder = 1
    end
  end
  object gbSKO: TGroupBox
    Left = 139
    Top = 397
    Width = 289
    Height = 97
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1076#1086#1087#1091#1089#1090#1080#1084#1099#1084' '#1057#1050#1054
    Color = clLime
    ParentColor = False
    TabOrder = 8
    object leSigmaMax: TLabeledEdit
      Left = 7
      Top = 44
      Width = 74
      Height = 21
      EditLabel.Width = 88
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1086#1077' '#1057#1050#1054
      TabOrder = 0
    end
  end
  object gbParallel2: TGroupBox
    Left = 251
    Top = 174
    Width = 118
    Height = 187
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1087#1072#1088#1072#1083'.'
    Color = clLime
    ParentColor = False
    TabOrder = 9
    object lParallName2: TLabel
      Left = 10
      Top = 23
      Width = 3
      Height = 13
    end
    object leParal2: TLabeledEdit
      Left = 9
      Top = 64
      Width = 76
      Height = 21
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1083'.'
      TabOrder = 0
    end
    object leParalDeltaDop2: TLabeledEdit
      Left = 9
      Top = 138
      Width = 74
      Height = 21
      EditLabel.Width = 92
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1086#1077' '#1086#1090#1082#1083'.'
      TabOrder = 1
    end
    object leParalDelta2: TLabeledEdit
      Left = 9
      Top = 100
      Width = 74
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
      TabOrder = 2
    end
    object bParal2: TButton
      Left = 8
      Top = 160
      Width = 41
      Height = 25
      Caption = '||'
      TabOrder = 3
      OnClick = bParal2Click
    end
  end
  object gbParallel3: TGroupBox
    Left = 379
    Top = 174
    Width = 118
    Height = 187
    Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1089' '#1087#1072#1088#1072#1083'.'
    Color = clLime
    ParentColor = False
    TabOrder = 10
    object lParallName3: TLabel
      Left = 10
      Top = 23
      Width = 3
      Height = 13
    end
    object leParal3: TLabeledEdit
      Left = 9
      Top = 64
      Width = 76
      Height = 21
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1083'.'
      TabOrder = 0
    end
    object leParalDeltaDop3: TLabeledEdit
      Left = 9
      Top = 138
      Width = 74
      Height = 21
      EditLabel.Width = 92
      EditLabel.Height = 13
      EditLabel.Caption = #1044#1086#1087#1091#1089#1090#1080#1084#1086#1077' '#1086#1090#1082#1083'.'
      TabOrder = 1
    end
    object leParalDelta3: TLabeledEdit
      Left = 9
      Top = 100
      Width = 74
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
      TabOrder = 2
    end
    object bParal3: TButton
      Left = 8
      Top = 160
      Width = 41
      Height = 25
      Caption = '||'
      TabOrder = 3
      OnClick = bParal3Click
    end
  end
end
