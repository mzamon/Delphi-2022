unit frmExpiryTracking;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  InventoryItem, InventoryService, AlertService;

type
  TfrmExpiryTracking = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    btnRefresh: TButton;
    btnAlert: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAlertClick(Sender: TObject);
  private
    FInvService: TInventoryService;
    FAlertService: TAlertService;
    FList: TObjectList<TInventoryItem>;
    procedure LoadExpiring;
  public
  end;

var
  frmExpiryTracking: TfrmExpiryTracking;

implementation

{$R *.dfm}

procedure TfrmExpiryTracking.FormCreate(Sender: TObject);
begin
  FInvService := TInventoryService.Create;
  FAlertService := TAlertService.Create;
  FList := TObjectList<TInventoryItem>.Create(False);
  LoadExpiring;
end;

procedure TfrmExpiryTracking.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FInvService.Free;
  FAlertService.Free;
  FList.Free;
end;

procedure TfrmExpiryTracking.LoadExpiring;
begin
  FList.Clear;
  FList.AddRange(FInvService.GetExpiringItems(30));
end;

procedure TfrmExpiryTracking.btnRefreshClick(Sender: TObject);
begin
  LoadExpiring;
end;

procedure TfrmExpiryTracking.btnAlertClick(Sender: TObject);
begin
  FAlertService.LogAlerts;
  ShowMessage('Alerts logged to audit.');
end;

end.