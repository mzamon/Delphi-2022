unit AuditReport;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.Graphics;

type
  TAuditReport = class
  public
    class procedure Generate;
  end;

implementation

class procedure TAuditReport.Generate;
begin
  // Print audit log
end;

end.