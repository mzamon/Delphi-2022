unit dmQueries;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client;

type
  TdmQueries = class(TDataModule)
    qryGeneric: TFDQuery;
  private
  public
  end;

var
  dmQueries: TdmQueries;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.