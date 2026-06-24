unit frmPurchaseOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons,
  PurchaseOrder, PurchaseOrderService, AuditService;

type
  TfrmPurchaseOrders = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnSubmit: TButton;
    btnReceive: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure btnReceiveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FService: TPurchaseOrderService;
    FList: TObjectList<TPurchaseOrder>;
    procedure LoadPOs;
    function GetSelectedPO: TPurchaseOrder;
  public
  end;

var
  frmPurchaseOrders: TfrmPurchaseOrders;

implementation

{$R *.dfm}

procedure TfrmPurchaseOrders.FormCreate(Sender: TObject);
begin
  FService := TPurchaseOrderService.Create;
  FList := TObjectList<TPurchaseOrder>.Create(False);
  LoadPOs;
end;

procedure TfrmPurchaseOrders.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmPurchaseOrders.LoadPOs;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllPOs);
end;

function TfrmPurchaseOrders.GetSelectedPO: TPurchaseOrder;
begin
  Result := nil;
end;

procedure TfrmPurchaseOrders.btnAddClick(Sender: TObject);
begin
  // show PO edit form
end;

procedure TfrmPurchaseOrders.btnEditClick(Sender: TObject);
var
  PO: TPurchaseOrder;
begin
  PO := GetSelectedPO;
  if PO <> nil then
    // edit
end;

procedure TfrmPurchaseOrders.btnDeleteClick(Sender: TObject);
var
  PO: TPurchaseOrder;
begin
  PO := GetSelectedPO;
  if PO <> nil then
    if MessageDlg('Delete PO?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.FRepo.DeletePO(PO.POID);
      LoadPOs;
    end;
end;

procedure TfrmPurchaseOrders.btnRefreshClick(Sender: TObject);
begin
  LoadPOs;
end;

procedure TfrmPurchaseOrders.btnSubmitClick(Sender: TObject);
var
  PO: TPurchaseOrder;
begin
  PO := GetSelectedPO;
  if PO <> nil then
    FService.SubmitPO(PO.POID, 1);
end;

procedure TfrmPurchaseOrders.btnReceiveClick(Sender: TObject);
var
  PO: TPurchaseOrder;
begin
  PO := GetSelectedPO;
  if PO <> nil then
    FService.ReceivePO(PO.POID, 1);
end;

procedure TfrmPurchaseOrders.btnCancelClick(Sender: TObject);
var
  PO: TPurchaseOrder;
begin
  PO := GetSelectedPO;
  if PO <> nil then
    FService.CancelPO(PO.POID, 1);
end;

end.