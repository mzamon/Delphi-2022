unit frmMedicines;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Medicine, MedicineService, AuditService;

type
  TfrmMedicines = class(TForm)
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
    FService: TMedicineService;
    FList: TObjectList<TMedicine>;
    procedure LoadMedicines;
    function GetSelected: TMedicine;
  public
  end;

var
  frmMedicines: TfrmMedicines;

implementation

{$R *.dfm}

procedure TfrmMedicines.FormCreate(Sender: TObject);
begin
  FService := TMedicineService.Create;
  FList := TObjectList<TMedicine>.Create(False);
  LoadMedicines;
end;

procedure TfrmMedicines.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FService.Free;
  FList.Free;
end;

procedure TfrmMedicines.LoadMedicines;
begin
  FList.Clear;
  FList.AddRange(FService.GetAllMedicines);
end;

function TfrmMedicines.GetSelected: TMedicine;
begin
  Result := nil;
end;

procedure TfrmMedicines.btnAddClick(Sender: TObject);
begin
  // show add/edit dialog
end;

procedure TfrmMedicines.btnEditClick(Sender: TObject);
var
  M: TMedicine;
begin
  M := GetSelected;
  if M <> nil then
    // edit
end;

procedure TfrmMedicines.btnDeleteClick(Sender: TObject);
var
  M: TMedicine;
begin
  M := GetSelected;
  if M <> nil then
    if MessageDlg('Delete medicine?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.DeleteMedicine(M.MedicineID, 1);
      LoadMedicines;
    end;
end;

procedure TfrmMedicines.btnRefreshClick(Sender: TObject);
begin
  LoadMedicines;
end;

end.