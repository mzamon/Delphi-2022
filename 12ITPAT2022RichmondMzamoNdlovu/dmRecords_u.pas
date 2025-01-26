unit dmRecords_u;

interface

uses
  SysUtils, Classes, ADODB, DB; //Add ADOB and DB

type
  TDataModuleRecords = class(TDataModule)
    procedure DataModuleSetup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //Declare objects to be used in the dm
    conRecords  : TADOConnection; //connect to database
    //Connect tables in databas
    tblSchool : TADOTable;
    tblUserLogin  : TADOTable;
    tblAdministratorLogin : TADOTable;
    dscRecords  : TDataSource;
    dscSchool : TDataSource;
    {USE SQL!!}
    qryAdmin : TADOQuery;
    dscLogin  : TDataSource;
  end;

var
  DataModuleRecords: TDataModuleRecords;

implementation

{$R *.dfm}

procedure TDataModuleRecords.DataModuleSetup(Sender: TObject);
begin
  //Instantiate Objects
  conRecords  := TADOConnection.Create(DataModuleRecords);
  //change ADO table to ADO query
  tblSchool := TADOTable.Create(DataModuleRecords);
  tblUserLogin  := TADOTable.Create(DataModuleRecords);
  tblAdministratorLogin := TADOTable.Create(DataModuleRecords);
  dscRecords  := TDataSource.Create(DataModuleRecords);

  //create adoquery objects
  qryAdmin := TADOQuery.Create(DataModuleRecords);
  dscLogin  := TDataSource.Create(DataModuleRecords);

  //setup connection string
  conRecords.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Records.mdb;Mode=ReadWrite;Persist Security Info=False';
  conRecords.LoginPrompt  := False;
  conRecords.Open;

  //Set up tables
  tblUserLogin.Connection := conRecords;
  tblUserLogin.TableName  := 'tblUserLogin';
  tblAdministratorLogin.Connection  := conRecords;
  tblAdministratorLogin.TableName :=  'tblAdministratorLogin';
  tblSchool.Connection  := conRecords;
  tblSchool.TableName := 'tblSchool';

  //connect ado query to connection
  qryAdmin.Connection  := conRecords;

  {Swop tables for SQL
  tblUserLogin.Connection := conRecords;
  tblAdministratorLogin.Connection  := conRecords;
  tblSchool.Connection  := conRecords;}

  //Set up data source
  dscSchool.DataSet  := tblSchool;



  tblSchool.Open;
  dscRecords.DataSet  := tblUserLogin;
  tblUserLogin.Open;
  dscRecords.DataSet  := tblAdministratorLogin;
  tblAdministratorLogin.Open;

  //connect datasource to ado query
  dscRecords.DataSet  := qryAdmin;
end;

end.
