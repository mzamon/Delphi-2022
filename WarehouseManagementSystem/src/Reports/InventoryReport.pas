unit InventoryReport;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.Graphics;

type
  TInventoryReport = class
  public
    class procedure Generate;
  end;

implementation

class procedure TInventoryReport.Generate;
begin
  // Use QuickReport or FastReport to print inventory list
end;

end.