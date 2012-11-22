object frmMain: TfrmMain
  Left = 534
  Top = 367
  Width = 515
  Height = 274
  Caption = 'frmMain'
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
  object mmo: TMemo
    Left = 88
    Top = 8
    Width = 241
    Height = 217
    Lines.Strings = (
      'mmo')
    TabOrder = 0
  end
  object conn: TADOConnection
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=stock'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 240
    Top = 120
  end
  object ds: TADODataSet
    Connection = conn
    Parameters = <>
    Left = 32
    Top = 80
  end
  object tmr: TTimer
    Interval = 3000
    OnTimer = tmrTimer
    Left = 72
    Top = 112
  end
end
