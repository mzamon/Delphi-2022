unit InventoryReport;

interface

uses
  System.Classes, Vcl.Forms;

type
  TInventoryReport = class
  public
    class procedure Generate;
  end;

implementation

class procedure TInventoryReport.Generate;
begin
  // QuickReport or FastReport implementation
end;

end.