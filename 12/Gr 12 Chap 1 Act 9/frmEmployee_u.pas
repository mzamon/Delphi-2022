unit frmEmployee_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfrmEmployee = class(TForm)
    redtDisplay: TRichEdit;
    ledName: TLabeledEdit;
    btnStart: TBitBtn;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmployee: TfrmEmployee;

implementation

{$R *.dfm}

procedure TfrmEmployee.FormActivate(Sender: TObject);
begin
  redtDisplay.Lines.Clear;
end;

end.
