object fDebugForm: TfDebugForm
  Left = 234
  Top = 277
  Width = 726
  Height = 518
  Caption = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' - '#1054#1082#1085#1086' '#1076#1083#1103' '#1086#1090#1083#1072#1076#1082#1080' '#1088#1072#1073#1086#1090#1099' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    710
    480)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 1
    Top = 2
    Width = 704
    Height = 433
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object bClose: TButton
    Left = 600
    Top = 448
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = bCloseClick
  end
  object bCopy: TButton
    Left = 24
    Top = 448
    Width = 145
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1073#1091#1092#1077#1088
    TabOrder = 2
    OnClick = bCopyClick
  end
end
