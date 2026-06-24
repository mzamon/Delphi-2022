unit frmInventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  InventoryItem, InventoryService, AuditService;

type
  TfrmInventory = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnAdjust: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAdjustClick(Sender: TObject);
  private
    FService: TInventoryService;
    FList: TObjectList<TInventoryItem>;
    procedure LoadItems;
    function GetSelected: TInventoryItem;
  public
  end;

var
  frmInventory: TfrmInventory;

implementation

{$R *.dfm}

procedure TfrmInventory.FormCreate(Sender: TObject);
begin
  FService := TInventoryService.Create;
  FList := TObjectList<TInventoryItem>.Create(False);
  LoadItems;
end;

procedure TfrmInventory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmInventory.LoadItems;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllItems);
end;

function TfrmInventory.GetSelected: TInventoryItem;
begin
  Result := nil;
end;

procedure TfrmInventory.btnAddClick(Sender: TObject);
begin
  // add new batch
end;

procedure TfrmInventory.btnEditClick(Sender: TObject);
var
  Item: TInventoryItem;
begin
  Item := GetSelected;
  if Item <> nil then
    // edit
end;

procedure TfrmInventory.btnDeleteClick(Sender: TObject);
var
  Item: TInventoryItem;
begin
  Item := GetSelected;
  if Item <> nil then
    if MessageDlg('Delete inventory item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteInventoryItem(Item.InventoryID, 1);
      LoadItems;
    end;
end;

procedure TfrmInventory.btnRefreshClick(Sender: TObject);
begin
  LoadItems;
end;

procedure TfrmInventory.btnAdjustClick(Sender: TObject);
var
  Item: TInventoryItem;
  Qty: Double;
begin
  Item := GetSelected;
  if Item = nil then
    Exit;
  if InputQuery('Adjust Stock', 'Enter quantity (positive to add, negative to subtract):', Qty) then
  begin
    FService.AdjustStock(Item.InventoryID, Qty, 1, 'Manual adjustment');
    LoadItems;
  end;
end;

end.