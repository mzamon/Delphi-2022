unit frmDispensing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  DispenseService, MedicineService;

type
  TfrmDispensing = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtMedicineID: TEdit;
    Label2: TLabel;
    edtQuantity: TEdit;
    btnDispense: TButton;
    btnCancel: TButton;
    Memo1: TMemo;
    procedure btnDispenseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDispService: TDispenseService;
    FMedService: TMedicineService;
  public
  end;

var
  frmDispensing: TfrmDispensing;

implementation

{$R *.dfm}

procedure TfrmDispensing.FormCreate(Sender: TObject);
begin
  FDispService := TDispenseService.Create;
  FMedService := TMedicineService.Create;
end;

procedure TfrmDispensing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDispService.Free;
  FMedService.Free;
end;

procedure TfrmDispensing.btnDispenseClick(Sender: TObject);
var
  MedID: Integer;
  Qty: Double;
begin
  if not TryStrToInt(edtMedicineID.Text, MedID) then
  begin
    ShowMessage('Invalid Medicine ID.');
    Exit;
  end;
  if not TryStrToFloat(edtQuantity.Text, Qty) then
  begin
    ShowMessage('Invalid quantity.');
    Exit;
  end;

  try
    FDispService.DispenseMedicine(MedID, Qty, 1); // user id from session
    ShowMessage('Dispense successful.');
    Memo1.Lines.Add(Format('Dispensed %f of medicine %d', [Qty, MedID]));
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TfrmDispensing.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.