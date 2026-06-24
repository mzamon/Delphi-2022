unit frmInventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons,
  InventoryItem, InventoryService, AuditService;

type
  TfrmInventory = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnLowStock: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLowStockClick(Sender: TObject);
  private
    FService: TInventoryService;
    FItems: TObjectList<TInventoryItem>;
    procedure LoadItems;
    function GetSelectedItem: TInventoryItem;
  public
  end;

var
  frmInventory: TfrmInventory;

implementation

{$R *.dfm}

procedure TfrmInventory.FormCreate(Sender: TObject);
begin
  FService := TInventoryService.Create;
  FItems := TObjectList<TInventoryItem>.Create(False);
  LoadItems;
end;

procedure TfrmInventory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FItems.Free;
end;

procedure TfrmInventory.LoadItems;
begin
  FItems.Clear;
  FItems.AddRange(FService.GetAllItems);
  // Refresh grid (would need a DataSource)
end;

function TfrmInventory.GetSelectedItem: TInventoryItem;
begin
  Result := nil; // implement based on grid selection
end;

procedure TfrmInventory.btnAddClick(Sender: TObject);
begin
  // Show edit dialog
end;

procedure TfrmInventory.btnEditClick(Sender: TObject);
var
  Item: TInventoryItem;
begin
  Item := GetSelectedItem;
  if Item <> nil then
    // edit
end;

procedure TfrmInventory.btnDeleteClick(Sender: TObject);
var
  Item: TInventoryItem;
begin
  Item := GetSelectedItem;
  if Item <> nil then
    if MessageDlg('Delete item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteItem(Item.ItemID, 1); // user ID should come from session
      LoadItems;
    end;
end;

procedure TfrmInventory.btnRefreshClick(Sender: TObject);
begin
  LoadItems;
end;

procedure TfrmInventory.btnLowStockClick(Sender: TObject);
begin
  // Show low stock items
  FItems.Clear;
  FItems.AddRange(FService.GetLowStockItems);
  // Refresh grid
end;

end.