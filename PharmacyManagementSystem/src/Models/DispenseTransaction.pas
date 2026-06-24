unit DispenseTransaction;

interface

uses
  System.SysUtils;

type
  TDispenseTransaction = class
  private
    FTransactionID: Integer;
    FMedicineID: Integer;
    FInventoryID: Integer;
    FQuantityDispensed: Double;
    FDispenseDate: TDateTime;
    FProcessedBy: Integer;
  public
    constructor Create; overload;
    constructor Create(ATransactionID, AMedicineID, AInventoryID: Integer;
      AQuantityDispensed: Double; ADispenseDate: TDateTime; AProcessedBy: Integer); overload;

    function Validate: Boolean;

    property TransactionID: Integer read FTransactionID write FTransactionID;
    property MedicineID: Integer read FMedicineID write FMedicineID;
    property InventoryID: Integer read FInventoryID write FInventoryID;
    property QuantityDispensed: Double read FQuantityDispensed write FQuantityDispensed;
    property DispenseDate: TDateTime read FDispenseDate write FDispenseDate;
    property ProcessedBy: Integer read FProcessedBy write FProcessedBy;
  end;

implementation

{ TDispenseTransaction }

constructor TDispenseTransaction.Create;
begin
  FTransactionID := 0;
  FDispenseDate := Now;
end;

constructor TDispenseTransaction.Create(ATransactionID, AMedicineID, AInventoryID: Integer;
  AQuantityDispensed: Double; ADispenseDate: TDateTime; AProcessedBy: Integer);
begin
  FTransactionID := ATransactionID;
  FMedicineID := AMedicineID;
  FInventoryID := AInventoryID;
  FQuantityDispensed := AQuantityDispensed;
  FDispenseDate := ADispenseDate;
  FProcessedBy := AProcessedBy;
end;

function TDispenseTransaction.Validate: Boolean;
begin
  Result := (FMedicineID > 0) and (FInventoryID > 0) and
            (FQuantityDispensed > 0) and (FProcessedBy > 0);
end;

end.