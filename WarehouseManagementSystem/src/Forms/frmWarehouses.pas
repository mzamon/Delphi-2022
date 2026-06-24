unit frmWarehouses;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Warehouse, WarehouseService, AuditService;

type
  TfrmWarehouses = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    FService: TWarehouseService;
    FList: TObjectList<TWarehouse>;
    procedure LoadWarehouses;
    function GetSelected: TWarehouse;
  public
  end;

var
  frmWarehouses: TfrmWarehouses;

implementation

{$R *.dfm}

procedure TfrmWarehouses.FormCreate(Sender: TObject);
begin
  FService := TWarehouseService.Create;
  FList := TObjectList<TWarehouse>.Create(False);
  LoadWarehouses;
end;

procedure TfrmWarehouses.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmWarehouses.LoadWarehouses;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllWarehouses);
end;

function TfrmWarehouses.GetSelected: TWarehouse;
begin
  Result := nil;
end;

procedure TfrmWarehouses.btnAddClick(Sender: TObject);
begin
  // add
end;

procedure TfrmWarehouses.btnEditClick(Sender: TObject);
var
  WH: TWarehouse;
begin
  WH := GetSelected;
  if WH <> nil then
    // edit
end;

procedure TfrmWarehouses.btnDeleteClick(Sender: TObject);
var
  WH: TWarehouse;
begin
  WH := GetSelected;
  if WH <> nil then
    if MessageDlg('Delete warehouse?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteWarehouse(WH.WarehouseID, 1); // user id
      LoadWarehouses;
    end;
end;

procedure TfrmWarehouses.btnRefreshClick(Sender: TObject);
begin
  LoadWarehouses;
end;

end.