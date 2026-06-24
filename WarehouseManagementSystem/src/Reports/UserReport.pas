unit UserReport;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.Graphics;

type
  TUserReport = class
  public
    class procedure Generate;
  end;

implementation

class procedure TUserReport.Generate;
begin
  // Print user list
end;

end.