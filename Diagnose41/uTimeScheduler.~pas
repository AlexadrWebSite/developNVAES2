unit uTimeScheduler;
//----------------------------------------------------------------------------------------
// Описание класса для запуска автоматических проверок
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 13/04/2015
//----------------------------------------------------------------------------------------

interface

 uses IniFiles,uCheckState;

type TTimeScheduler=Class(TObject)
  private
   FTime:integer;// время в секундах между запусками автоматической проверки
   FLastTime:TDateTime;

    procedure SetLastTime(const Value: TDateTime);// время последнего срабатывания таймера

  protected

  public
    Property Time:integer read FTime write FTime;

    property LastTime:TDateTime read FLastTime write SetLastTime;
    Function AutoCalc( CheckState:TCheckState):boolean ;
    procedure LoadFtomIni(IniFile:TIniFile);
    procedure SaveToIni(IniFile:TIniFile);
    constructor Create(IniTime:integer=60);
    destructor Destroy;
  published

  end;

implementation

uses SysUtils;

{ TTimeScheduler }

function TTimeScheduler.AutoCalc(CheckState: TCheckState): boolean;
begin
Result:=CheckState.Stable and (round((Now-FLastTime)*86400)>FTime);
if Result then FLastTime:=now;
end;

constructor TTimeScheduler.Create(IniTime:integer=60);
begin
 inherited Create;
 FLastTime:=0;//now;
 FTime:=IniTime;// по умолчанию
end;


destructor TTimeScheduler.Destroy;
begin
 inherited Destroy;
end;

procedure TTimeScheduler.LoadFtomIni(IniFile:TIniFile);
begin
 FTime:= IniFile.ReadInteger('TimeScheduler','Time',60);
end;

procedure TTimeScheduler.SaveToIni(IniFile: TIniFile);
begin
 IniFile.WriteInteger('TimeScheduler','Time',FTime);
end;

procedure TTimeScheduler.SetLastTime(const Value: TDateTime);
begin
  FLastTime := Value;
end;

end.
