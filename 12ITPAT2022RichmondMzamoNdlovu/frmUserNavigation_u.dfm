object frmUserNavigation: TfrmUserNavigation
  Left = 0
  Top = 0
  Caption = 'frmUserNavigation'
  ClientHeight = 352
  ClientWidth = 715
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
  object pnlMain: TPanel
    Left = 8
    Top = 15
    Width = 697
    Height = 329
    TabOrder = 0
    object imgDisplay: TImage
      Left = 336
      Top = 74
      Width = 273
      Height = 191
    end
    object btnGetNewWork: TButton
      Left = 56
      Top = 42
      Width = 121
      Height = 41
      Caption = 'Get New Work'
      TabOrder = 0
      OnClick = btnGetNewWorkClick
    end
    object btnSubmitWork: TButton
      Left = 56
      Top = 105
      Width = 121
      Height = 41
      Caption = 'Submit Work'
      TabOrder = 1
      OnClick = btnSubmitWorkClick
    end
    object btnJoinVideoConference: TButton
      Left = 56
      Top = 168
      Width = 121
      Height = 41
      Caption = 'Join Video Conference'
      TabOrder = 2
      OnClick = btnJoinVideoConferenceClick
    end
    object btnExit: TBitBtn
      Left = 56
      Top = 224
      Width = 121
      Height = 41
      Kind = bkClose
      TabOrder = 3
      OnClick = btnExitClick
    end
  end
end
