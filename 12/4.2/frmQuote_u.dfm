object frmQuote: TfrmQuote
  Left = 192
  Top = 124
  Caption = 'Quote Calculator'
  ClientHeight = 351
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object pnlInput: TPanel
    Left = 16
    Top = 8
    Width = 369
    Height = 105
    TabOrder = 0
    object lblLength: TLabel
      Left = 24
      Top = 32
      Width = 188
      Height = 16
      Caption = 'Enter the length of the room (m): '
    end
    object lblWidth: TLabel
      Left = 24
      Top = 72
      Width = 179
      Height = 16
      Caption = 'Enter the width of the room (m):'
    end
    object edtLength: TEdit
      Left = 232
      Top = 24
      Width = 73
      Height = 24
      TabOrder = 0
    end
    object edtWidth: TEdit
      Left = 232
      Top = 64
      Width = 73
      Height = 24
      TabOrder = 1
    end
  end
  object pnlOutput: TPanel
    Left = 16
    Top = 160
    Width = 377
    Height = 153
    TabOrder = 1
    object redOutput: TRichEdit
      Left = 8
      Top = 16
      Width = 361
      Height = 121
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object bmbGenerateQuote: TBitBtn
    Left = 128
    Top = 121
    Width = 129
    Height = 33
    Caption = '&Generate Quote'
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = bmbGenerateQuoteClick
  end
  object bmbReset: TBitBtn
    Left = 88
    Top = 320
    Width = 75
    Height = 25
    Caption = '&Reset '
    DoubleBuffered = True
    Kind = bkRetry
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = bmbResetClick
  end
  object bmbClose: TBitBtn
    Left = 216
    Top = 320
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkClose
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = bmbCloseClick
  end
end
