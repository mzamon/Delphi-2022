object frmBankAccount: TfrmBankAccount
  Left = 0
  Top = 0
  Caption = 'Bank Account'
  ClientHeight = 460
  ClientWidth = 445
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
  object pnlBankAccount: TPanel
    Left = 16
    Top = 8
    Width = 407
    Height = 441
    TabOrder = 0
    object lblAccountNumber: TLabel
      Left = 56
      Top = 51
      Width = 83
      Height = 13
      Caption = 'Account Number:'
    end
    object btnClose: TBitBtn
      Left = 16
      Top = 407
      Width = 369
      Height = 25
      DoubleBuffered = True
      Kind = bkClose
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnReset: TBitBtn
      Left = 16
      Top = 376
      Width = 369
      Height = 25
      DoubleBuffered = True
      Kind = bkRetry
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = btnResetClick
    end
    object grpTransactions: TGroupBox
      Left = 16
      Top = 113
      Width = 369
      Height = 121
      Caption = 'Transactions'
      TabOrder = 2
      object ledAmount: TLabeledEdit
        Left = 16
        Top = 40
        Width = 169
        Height = 21
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = 'Enter An Amount'
        TabOrder = 0
      end
      object btnDeposit: TButton
        Left = 264
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Deposit'
        TabOrder = 1
      end
      object btnWithdraw: TButton
        Left = 264
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Withdraw'
        TabOrder = 2
      end
    end
    object grpViewInformation: TGroupBox
      Left = 16
      Top = 240
      Width = 369
      Height = 130
      Caption = 'View Information'
      TabOrder = 3
      object memDisplay: TMemo
        Left = 16
        Top = 21
        Width = 185
        Height = 106
        Lines.Strings = (
          'memDisplay')
        TabOrder = 0
      end
      object btnBalance: TButton
        Left = 264
        Top = 89
        Width = 75
        Height = 25
        Caption = 'View Balance'
        TabOrder = 1
      end
      object btnDetails: TButton
        Left = 264
        Top = 33
        Width = 75
        Height = 25
        Caption = 'View Details'
        TabOrder = 2
        OnClick = btnDetailsClick
      end
    end
    object edtAccountNumber: TEdit
      Left = 145
      Top = 48
      Width = 152
      Height = 21
      TabOrder = 4
      Text = 'edtAccountNumber'
    end
    object btnCreate: TButton
      Left = 168
      Top = 82
      Width = 97
      Height = 25
      Caption = 'Create Account'
      TabOrder = 5
      OnClick = btnCreateClick
    end
  end
end
