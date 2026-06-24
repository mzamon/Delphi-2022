unit frmStockMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  StockMovement, StockMovementRepository, AuditService;

type
  TfrmStockMovement = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnRefresh: TButton;
    btnAddIn: TButton;
    btnAddOut: TButton;
    btnAdjust: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAddInClick(Sender: TObject);
    procedure btnAddOutClick(Sender: TObject);
    procedure btnAdjustClick(Sender: TObject);
  private
    FRepo: TStockMovementRepository;
    FList: TObjectList<TStockMovement>;
    procedure LoadMovements;
  public
  end;

var
  frmStockMovement: TfrmStockMovement;

implementation

{$R *.dfm}

procedure TfrmStockMovement.FormCreate(Sender: TObject);
begin
  FRepo := TStockMovementRepository.Create;
  FList := TObjectList<TStockMovement>.Create(False);
  LoadMovements;
end;

procedure TfrmStockMovement.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FRepo.Free;
  FList.Free;
end;

procedure TfrmStockMovement.LoadMovements;
begin
  FList.Clear;
  // for simplicity, load all (or by date range)
  // FList.AddRange(FRepo.GetMovementsByDateRange(...));
end;

procedure TfrmStockMovement.btnRefreshClick(Sender: TObject);
begin
  LoadMovements;
end;

procedure TfrmStockMovement.btnAddInClick(Sender: TObject);
begin
  // Show input dialog for receiving stock
end;

procedure TfrmStockMovement.btnAddOutClick(Sender: TObject);
begin
  // Show issue dialog
end;

procedure TfrmStockMovement.btnAdjustClick(Sender: TObject);
begin
  // Show adjustment dialog
end;

end.