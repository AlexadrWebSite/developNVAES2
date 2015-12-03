object fParal: TfParal
  Left = 560
  Top = 596
  Width = 446
  Height = 290
  Caption = #1055#1072#1088#1072#1083#1083#1077#1083#1100#1085#1099#1077' '#1082#1072#1085#1072#1083#1099' '#1082#1086#1085#1090#1088#1086#1083#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object leMask: TLabeledEdit
    Left = 104
    Top = 16
    Width = 169
    Height = 21
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = #1052#1072#1089#1082#1072' KKS'
    LabelPosition = lpLeft
    TabOrder = 0
  end
  object sgParal: TStringGrid
    Left = 8
    Top = 48
    Width = 417
    Height = 161
    ColCount = 2
    FixedCols = 0
    TabOrder = 1
    ColWidths = (
      175
      64)
  end
  object bClose: TButton
    Left = 328
    Top = 224
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = bCloseClick
  end
end
