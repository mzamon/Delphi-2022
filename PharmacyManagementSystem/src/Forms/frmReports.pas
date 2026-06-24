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
    btnMedicines: TButton;
    btnSuppliers: TButton;
    btnUsers: TButton;
    btnDispensing: TButton;
    btnAudit: TButton;
    Memo1: TMemo;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnInventoryClick(Sender: TObject);
    procedure btnMedicinesClick(Sender: TObject);
    procedure btnSuppliersClick(Sender: TObject);
    procedure btnUsersClick(Sender: TObject);
    procedure btnDispensingClick(Sender: TObject);
    procedure btnAuditClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FService: TReportingService;
    procedure ShowReport(const AText: string);
  public
  end;

var
  frmReports: TfrmReports;

implementation

{$R *.dfm}

procedure TfrmReports.FormCreate(Sender: TObject);
begin
  FService := TReportingService.Create;
  DateTimePicker1.Date := Date - 30;
  DateTimePicker2.Date := Date;
end;

procedure TfrmReports.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
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
        S := S + Format('Batch %s: %f', [BatchNumber, QuantityInStock]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnMedicinesClick(Sender: TObject);
var
  Items: TObjectList<TMedicine>;
  S: string;
  I: Integer;
begin
  Items := FService.GetMedicinesReport;
  try
    S := 'Medicines Report' + sLineBreak + '================' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s (%s)', [MedicineName, GenericName]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnSuppliersClick(Sender: TObject);
var
  Items: TObjectList<TSupplier>;
  S: string;
  I: Integer;
begin
  Items := FService.GetSuppliersReport;
  try
    S := 'Suppliers Report' + sLineBreak + '================' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s - %s', [SupplierName, ContactPerson]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnUsersClick(Sender: TObject);
var
  Items: TObjectList<TUser>;
  S: string;
  I: Integer;
begin
  Items := FService.GetUsersReport;
  try
    S := 'Users Report' + sLineBreak + '============' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s (%s)', [Username, FullName]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnDispensingClick(Sender: TObject);
var
  Items: TObjectList<TDispenseTransaction>;
  S: string;
  I: Integer;
begin
  Items := FService.GetDispensingReport(DateTimePicker1.Date, DateTimePicker2.Date);
  try
    S := 'Dispensing Report' + sLineBreak + '================' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s: %f', [DateToStr(DispenseDate), QuantityDispensed]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

procedure TfrmReports.btnAuditClick(Sender: TObject);
var
  Items: TObjectList<TAuditLog>;
  S: string;
  I: Integer;
begin
  Items := FService.GetAuditReport(100);
  try
    S := 'Audit Report' + sLineBreak + '============' + sLineBreak;
    for I := 0 to Items.Count - 1 do
      with Items[I] do
        S := S + Format('%s: %s', [DateTimeToStr(ActionDate), Action]) + sLineBreak;
    ShowReport(S);
  finally
    Items.Free;
  end;
end;

end.