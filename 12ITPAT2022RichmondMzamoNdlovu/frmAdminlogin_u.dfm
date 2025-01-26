object frmAdminLogin: TfrmAdminLogin
  Left = 0
  Top = 0
  Caption = 'frmAdminLogin'
  ClientHeight = 292
  ClientWidth = 615
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
  object pnlLogin: TPanel
    Left = 40
    Top = 22
    Width = 505
    Height = 241
    Color = clRed
    ParentBackground = False
    TabOrder = 0
    object lblHeading: TLabel
      Left = 216
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Login'
    end
    object ledUserName: TLabeledEdit
      Left = 192
      Top = 64
      Width = 129
      Height = 21
      EditLabel.Width = 49
      EditLabel.Height = 13
      EditLabel.Caption = 'UserName'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object ledPassword: TLabeledEdit
      Left = 192
      Top = 111
      Width = 129
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Password'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object btnContinue: TBitBtn
      Left = 192
      Top = 176
      Width = 75
      Height = 25
      Kind = bkOK
      TabOrder = 2
      OnClick = btnContinueClick
    end
    object btnTerminate: TBitBtn
      Left = 72
      Top = 176
      Width = 75
      Height = 25
      Kind = bkClose
      TabOrder = 3
      OnClick = btnTerminateClick
    end
    object btnHelp: TBitBtn
      Left = 296
      Top = 176
      Width = 75
      Height = 25
      Kind = bkHelp
      TabOrder = 4
      OnClick = btnHelpClick
    end
    object btnUserScreen: TButton
      Left = 408
      Top = 176
      Width = 75
      Height = 25
      Caption = 'User Screen'
      TabOrder = 5
      OnClick = btnUserScreenClick
    end
  end
end
