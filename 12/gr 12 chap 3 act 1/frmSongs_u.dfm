object frmSongs: TfrmSongs
  Left = 296
  Top = 122
  Caption = 'Most popular songs'
  ClientHeight = 545
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object pnlDisplay: TPanel
    Left = 24
    Top = 16
    Width = 545
    Height = 513
    TabOrder = 0
    object lblSong: TLabel
      Left = 64
      Top = 40
      Width = 157
      Height = 16
      Caption = 'Enter the name of the song'
    end
    object redOutput: TRichEdit
      Left = 272
      Top = 24
      Width = 257
      Height = 465
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object btnPlaceSong: TButton
      Left = 64
      Top = 104
      Width = 137
      Height = 25
      Caption = '&Place Song'
      TabOrder = 1
      OnClick = btnPlaceSongClick
    end
    object bmbClose: TBitBtn
      Left = 96
      Top = 144
      Width = 75
      Height = 25
      DoubleBuffered = True
      Kind = bkClose
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = bmbCloseClick
    end
    object edtSong: TEdit
      Left = 32
      Top = 64
      Width = 209
      Height = 24
      TabOrder = 3
    end
  end
end
