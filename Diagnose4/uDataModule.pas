unit uDataModule;

interface

uses
  SysUtils, Classes, DB, ADODB,IniFiles;

type
  TFDataModule = class(TDataModule)
    ADOQuery: TADOQuery;
    ADOConnection: TADOConnection;
    ADOConnectionArc: TADOConnection;
    ADOQueryArc: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule: TFDataModule;
function LoadConnectionString(Ini:TiniFile):string;
Function LoadConnectionArcString(Ini:TiniFile):string;
implementation

uses uMain;

{$R *.dfm}
 function LoadConnectionString(Ini:TiniFile):string;
 begin
   //Provider=Microsoft.Jet.OLEDB.4.0;Data Source=d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose\Source\DB_SVRK_2000.mdb;Persist Security Info=False
   Result:='Provider='+
   ini.ReadString('DataBase','Provider','Microsoft.Jet.OLEDB.4.0')+
   ';Data Source='+
   ini.ReadString('DataBase','Data_Source','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose\Source\DB_SVRK_2000.mdb')+
   ';Persist Security Info=False';
 end;
Function LoadConnectionArcString(Ini:TiniFile):string;
 begin
   //Provider=Microsoft.Jet.OLEDB.4.0;Data Source=d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose\Source\DB_SVRK_2000.mdb;Persist Security Info=False
   Result:='Provider='+
   ini.ReadString('DataBase','Provider_Arc','Microsoft.Jet.OLEDB.4.0')+
   ';Data Source='+
   ini.ReadString('DataBase','Data_Source_Arc','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose3\Res\Archive.mdb')+
   ';Persist Security Info=False';
 end;

end.
