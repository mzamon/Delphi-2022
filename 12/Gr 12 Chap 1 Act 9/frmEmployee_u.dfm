object frmEmployee: TfrmEmployee
  Left = 0
  Top = 0
  Caption = 'Employee'
  ClientHeight = 303
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object redtDisplay: TRichEdit
    Left = 32
    Top = 176
    Width = 265
    Height = 113
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'redtDisplay')
    ParentFont = False
    TabOrder = 0
  end
  object ledName: TLabeledEdit
    Left = 104
    Top = 48
    Width = 121
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Name'
    TabOrder = 1
  end
  object btnStart: TBitBtn
    Left = 128
    Top = 104
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 2
  end
end
