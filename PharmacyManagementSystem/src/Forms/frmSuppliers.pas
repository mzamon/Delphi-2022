unit frmSuppliers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Supplier, SupplierService, AuditService;

type
  TfrmSuppliers = class(TForm)
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
    FService: TSupplierService;
    FList: TObjectList<TSupplier>;
    procedure LoadSuppliers;
    function GetSelected: TSupplier;
  public
  end;

var
  frmSuppliers: TfrmSuppliers;

implementation

{$R *.dfm}

procedure TfrmSuppliers.FormCreate(Sender: TObject);
begin
  FService := TSupplierService.Create;
  FList := TObjectList<TSupplier>.Create(False);
  LoadSuppliers;
end;

procedure TfrmSuppliers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmSuppliers.LoadSuppliers;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllSuppliers);
end;

function TfrmSuppliers.GetSelected: TSupplier;
begin
  Result := nil;
end;

procedure TfrmSuppliers.btnAddClick(Sender: TObject);
begin
  // add
end;

procedure TfrmSuppliers.btnEditClick(Sender: TObject);
var
  S: TSupplier;
begin
  S := GetSelected;
  if S <> nil then
    // edit
end;

procedure TfrmSuppliers.btnDeleteClick(Sender: TObject);
var
  S: TSupplier;
begin
  S := GetSelected;
  if S <> nil then
    if MessageDlg('Delete supplier?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteSupplier(S.SupplierID, 1);
      LoadSuppliers;
    end;
end;

procedure TfrmSuppliers.btnRefreshClick(Sender: TObject);
begin
  LoadSuppliers;
end;

end.