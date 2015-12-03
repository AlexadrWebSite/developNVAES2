object FDataModule: TFDataModule
  OldCreateOrder = False
  Left = 620
  Top = 202
  Height = 228
  Width = 267
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 96
    Top = 16
  end
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 24
    Top = 16
  end
  object ADOConnectionArc: TADOConnection
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 24
    Top = 88
  end
  object ADOQueryArc: TADOQuery
    Connection = ADOConnectionArc
    Parameters = <>
    Left = 96
    Top = 88
  end
end
