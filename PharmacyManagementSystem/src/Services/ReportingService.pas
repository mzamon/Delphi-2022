unit ReportingService;

interface

uses
  System.SysUtils, System.Generics.Collections,
  InventoryItem, Medicine, Supplier, User, AuditLog, DispenseTransaction,
  InventoryRepository, MedicineRepository, SupplierRepository, UserRepository,
  DispenseRepository, AuditRepository;

type
  TReportingService = class
  private
    FInvRepo: TInventoryRepository;
    FMedRepo: TMedicineRepository;
    FSuppRepo: TSupplierRepository;
    FUserRepo: TUserRepository;
    FDispRepo: TDispenseRepository;
    FAuditRepo: TAuditRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function GetInventoryReport: TObjectList<TInventoryItem>;
    function GetMedicinesReport: TObjectList<TMedicine>;
    function GetSuppliersReport: TObjectList<TSupplier>;
    function GetUsersReport: TObjectList<TUser>;
    function GetDispensingReport(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
    function GetAuditReport(ALimit: Integer = 100): TObjectList<TAuditLog>;
  end;

implementation

{ TReportingService }

constructor TReportingService.Create;
begin
  FInvRepo := TInventoryRepository.Create;
  FMedRepo := TMedicineRepository.Create;
  FSuppRepo := TSupplierRepository.Create;
  FUserRepo := TUserRepository.Create;
  FDispRepo := TDispenseRepository.Create;
  FAuditRepo := TAuditRepository.Create;
end;

destructor TReportingService.Destroy;
begin
  FInvRepo.Free;
  FMedRepo.Free;
  FSuppRepo.Free;
  FUserRepo.Free;
  FDispRepo.Free;
  FAuditRepo.Free;
  inherited;
end;

function TReportingService.GetInventoryReport: TObjectList<TInventoryItem>;
begin
  Result := FInvRepo.GetAllInventoryItems;
end;

function TReportingService.GetMedicinesReport: TObjectList<TMedicine>;
begin
  Result := FMedRepo.GetAllMedicines;
end;

function TReportingService.GetSuppliersReport: TObjectList<TSupplier>;
begin
  Result := FSuppRepo.GetAllSuppliers;
end;

function TReportingService.GetUsersReport: TObjectList<TUser>;
begin
  Result := FUserRepo.GetAllUsers;
end;

function TReportingService.GetDispensingReport(AStartDate, AEndDate: TDateTime): TObjectList<TDispenseTransaction>;
begin
  Result := FDispRepo.GetDispensesByDateRange(AStartDate, AEndDate);
end;

function TReportingService.GetAuditReport(ALimit: Integer): TObjectList<TAuditLog>;
begin
  Result := FAuditRepo.GetAuditLogs(ALimit);
end;

end.