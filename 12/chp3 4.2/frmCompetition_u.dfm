object frmCompetition: TfrmCompetition
  Left = 0
  Top = 0
  Caption = 'Remove Duplicates'
  ClientHeight = 345
  ClientWidth = 539
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
  object redOutput: TRichEdit
    Left = 320
    Top = 48
    Width = 185
    Height = 241
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'redOutput')
    ParentFont = False
    TabOrder = 0
  end
  object btnReadDisplay: TButton
    Left = 72
    Top = 48
    Width = 185
    Height = 81
    Caption = 'btnReadDisplay'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnReadDisplayClick
  end
end
