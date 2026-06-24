unit dmQueries;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TdmQueries = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmQueries: TdmQueries;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.