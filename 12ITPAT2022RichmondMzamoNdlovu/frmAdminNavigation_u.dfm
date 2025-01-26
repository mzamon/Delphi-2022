object frmAdminNavigation: TfrmAdminNavigation
  Left = 0
  Top = 0
  Caption = 'frmAdminNavigation'
  ClientHeight = 441
  ClientWidth = 864
  Color = clRed
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
    Left = 32
    Top = 48
    Width = 793
    Height = 321
    TabOrder = 0
    object btnClose: TBitBtn
      Left = 54
      Top = 32
      Width = 75
      Height = 25
      Kind = bkClose
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnUsersView: TButton
      Left = 54
      Top = 213
      Width = 75
      Height = 25
      Caption = 'UsersView'
      TabOrder = 1
      OnClick = btnUsersViewClick
    end
    object btnAdminView: TButton
      Left = 54
      Top = 93
      Width = 75
      Height = 25
      Caption = 'AdminView'
      TabOrder = 2
      OnClick = btnAdminViewClick
    end
    object dbgrdAdmin: TDBGrid
      Left = 336
      Top = 32
      Width = 393
      Height = 223
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object btnCheckSubmission: TButton
      Left = 54
      Top = 158
      Width = 83
      Height = 25
      Caption = 'Check Submission'
      TabOrder = 4
      OnClick = btnCheckSubmissionClick
    end
    object btnAddNewAdmin: TButton
      Left = 54
      Top = 272
      Width = 75
      Height = 25
      Caption = 'AddNewAdmin'
      TabOrder = 5
      OnClick = btnAddNewAdminClick
    end
    object btnNewUser: TButton
      Left = 200
      Top = 32
      Width = 75
      Height = 25
      Caption = 'New User'
      TabOrder = 6
      OnClick = btnNewUserClick
    end
    object btnbeginvideo: TButton
      Left = 200
      Top = 93
      Width = 75
      Height = 25
      Caption = 'begin video'
      TabOrder = 7
      OnClick = btnbeginvideoClick
    end
    object btnremoveuser: TButton
      Left = 200
      Top = 149
      Width = 75
      Height = 25
      Caption = 'removeuser'
      TabOrder = 8
      OnClick = btnremoveuserClick
    end
    object btnnewwork: TButton
      Left = 200
      Top = 213
      Width = 75
      Height = 25
      Caption = 'newwork'
      TabOrder = 9
      OnClick = btnnewworkClick
    end
  end
end
