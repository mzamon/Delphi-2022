unit frmPurchases;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Purchase, PurchaseService, AuditService;

type
  TfrmPurchases = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnReceive: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnReceiveClick(Sender: TObject);
  private
    FService: TPurchaseService;
    FList: TObjectList<TPurchase>;
    procedure LoadPurchases;
    function GetSelected: TPurchase;
  public
  end;

var
  frmPurchases: TfrmPurchases;

implementation

{$R *.dfm}

procedure TfrmPurchases.FormCreate(Sender: TObject);
begin
  FService := TPurchaseService.Create;
  FList := TObjectList<TPurchase>.Create(False);
  LoadPurchases;
end;

procedure TfrmPurchases.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmPurchases.LoadPurchases;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllPurchases);
end;

function TfrmPurchases.GetSelected: TPurchase;
begin
  Result := nil;
end;

procedure TfrmPurchases.btnAddClick(Sender: TObject);
begin
  // Show purchase edit dialog
end;

procedure TfrmPurchases.btnEditClick(Sender: TObject);
var
  P: TPurchase;
begin
  P := GetSelected;
  if P <> nil then
    // edit
end;

procedure TfrmPurchases.btnDeleteClick(Sender: TObject);
var
  P: TPurchase;
begin
  P := GetSelected;
  if P <> nil then
    if MessageDlg('Delete purchase?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeletePurchase(P.PurchaseID, 1);
      LoadPurchases;
    end;
end;

procedure TfrmPurchases.btnRefreshClick(Sender: TObject);
begin
  LoadPurchases;
end;

procedure TfrmPurchases.btnReceiveClick(Sender: TObject);
var
  P: TPurchase;
begin
  P := GetSelected;
  if P <> nil then
    if MessageDlg('Receive this purchase (add to inventory)?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.ReceivePurchase(P.PurchaseID, 1);
      LoadPurchases;
    end;
end;

end.