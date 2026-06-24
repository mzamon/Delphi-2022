unit frmReports;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  ReportingService;

type
  TfrmReports = class(TForm)
    Panel1: TPanel;
    btnInventory: TButton;
    btnUsers: TButton;
    btnSuppliers: TButton;
    btnAudit: TButton;
    Memo1: TMemo;
    procedure btnInventoryClick(Sender: TObject);
    procedure btnUsersClick(Sender: TObject);
    procedure btnSuppliersClick(Sender: TObject);
    procedure btnAuditClick(Sender: TObject);
  private
    FService: TReportingService;
    procedure ShowReport(const AText: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmReports: TfrmReports;

implementation

{$R *.dfm}

constructor TfrmReports.Create(AOwner: TComponent);
begin
  inherited;
  FService := TReportingService.Create;
end;

destructor TfrmReports.Destroy;
begin
  FService.Free;
  inherited;
end;

procedure TfrmReports.ShowReport(const AText: string);
begin
  Memo1.Lines.Text := AText;
end;

procedure TfrmReports.btnInventoryClick(Sender: TObject);
var
  Items: TObjectList<TInventoryItem>;
  S: string;
  I: Integer;
begin
  Items := FService.GetInventoryReport;
  try
    S := 'Inventory Report' + sLineBreak + '================' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s - %s: %f', [SKU, ItemName, Quantity]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnUsersClick(Sender: TObject);
var
  Users: TObjectList<TUser>;
  S: string;
  I: Integer;
begin
  Users := FService.GetUserReport;
  try
    S := 'User Report' + sLineBreak + '============' + sLineBreak;
    for I := 0 to Users.Count - 1 do
      with Users[I] do
        S := S + Format('%s (%s) - %s', [Username, FullName, Email]) + sLineBreak;
    ShowReport(S);
  finally
    Users.Free;
  end;
end;

procedure TfrmReports.btnSuppliersClick(Sender: TObject);
var
  Suppliers: TObjectList<TSupplier>;
  S: string;
  I: Integer;
begin
  Suppliers := FService.GetSupplierReport;
  try
    S := 'Supplier Report' + sLineBreak + '================' + sLineBreak;
    for I := 0 to Suppliers.Count - 1 do
      with Suppliers[I] do
        S := S + Format('%s - %s', [CompanyName, ContactPerson]) + sLineBreak;
    ShowReport(S);
  finally
    Suppliers.Free;
  end;
end;

procedure TfrmReports.btnAuditClick(Sender: TObject);
var
  Logs: TObjectList<TAuditLog>;
  S: string;
  I: Integer;
begin
  Logs := FService.GetAuditReport;
  try
    S := 'Audit Report' + sLineBreak + '============' + sLineBreak;
    for I := 0 to Logs.Count - 1 do
      with Logs[I] do
        S := S + Format('%s: %s (User %d)', [DateTimeToStr(ActionDate), Action, UserID]) + sLineBreak;
    ShowReport(S);
  finally
    Logs.Free;
  end;
end;

end.