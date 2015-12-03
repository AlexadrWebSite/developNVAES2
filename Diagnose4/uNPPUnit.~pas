unit uNPPUnit;
//----------------------------------------------------------------------------------------
// Описание класса - блок АЭС
// В классе TNPPUnit содержится структура оборудования, где расположены основные датчики и их описание.
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 12/02/2015
//----------------------------------------------------------------------------------------

interface

uses IniFiles,Classes,
 // ниже файлы, написанные Семенихиным А.В.
 uBuffer,uDescription,uNetSend,uRegime;

type
 TSensor= class(TObject)
 private
   FValue:TValue;
   FDescription:TDescription;
   FExtIndex:integer;
    function GetValue: TValue;
 protected

 public
   property Value:TValue read  FValue write FValue;
   property Description:TDescription read FDescription write FDescription;
   property ExtIndex:integer read FExtIndex write FExtIndex;
   constructor Create;
   destructor Destroy;
 end;

type TLeg = class(TObject)  // нитка ГЦТ c датчиками температуры
     private
       FTSens:array of TSensor;
       FCountTSens:integer;
    function GetTSens(i: integer): TSensor;
    procedure SetCountTSens(const Value: integer);
    procedure SetTSens(i: integer; const Value: TSensor);
     protected

     public
       property TSens[i:integer]:TSensor read GetTSens write SetTSens;
       property CountTSens:integer read FCountTSens write SetCountTSens;
       constructor Create;
       destructor Destroy;
     published 

     end;
type
TLoop = class(TObject)
private
 FHotLeg:Tleg;
 FColdLeg:Tleg;
protected

public
     property HotLeg:Tleg read FHotLeg write FHotLeg;
     property ColdLeg:Tleg read FColdLeg write FColdLeg;
       constructor Create;
       destructor Destroy;

end;


type
TRU = class(TObject)
private
   FLoops:array [1..4] of TLoop;
   FNakz:TSensor;
   FNAKNP:TSensor;
   FNDPZ:TSensor;
   FTCold:TSensor;
   FTHot:TSensor;
    FTH: double;
    FTC: double;
    function GetLoops(i: integer): TLoop;
    procedure SetLoops(i: integer; const Value: TLoop);
    procedure SetNakz(const Value: TSensor);
    function GetTCold: TSensor;
    procedure SetTCOld(const Value: TSensor);
    function GetTHot: TSensor;
    procedure SetTHot(const Value: TSensor);
    procedure SetTH(const Value: double);
    procedure SetTC(const Value: double);
protected

public
  property Nakz:TSensor read FNakz write SetNakz;
  property Naknp:TSensor read FNAKNP write FNAknp;
  property Ndpz:TSensor read FNDPZ write FNDPZ;
  property TCold:TSensor read GetTCold write SetTCOld; // средняя Т хол.
  property THot:TSensor read GetTHot write SetTHot; // средняя Т гор.
  property TH:double read FTH write SetTH;
  property TC:double read FTC write SetTC;
  property Loops[i:integer]:TLoop read GetLoops write SetLoops;
  procedure CalcTCold;
  procedure CalcTH;
  procedure CalcTC;
  constructor Create;
  destructor Destroy;
published

end;


type
TNPPUnit = class(TObject)
private
  FName:string;// имя блока АЭС
  FRU:TRU;
    procedure SetName(const Value: string);
    procedure SetRU(const Value: TRU);
protected

public
  property Name:string  read FName write SetName;
  property RU:TRU read FRU write SetRU;
  function Initalize(IniFileName:string):boolean;
  function Link(Buffer:TBuffer;var LinkError:Tstrings):boolean;
  function Regim(Buffer:TBuffer):TRegimeType;
  constructor Create;
  destructor Destroy;
published 

end;

implementation

uses SysUtils;

{ TNPPUnit }

constructor TNPPUnit.Create;
begin
 inherited Create;
 FRU:=TRU.Create;
end;

destructor TNPPUnit.Destroy;
begin
 FRU.Destroy;
 inherited Destroy;
end;

function TNPPUnit.Initalize(IniFileName: string): boolean;
var Ini:TIniFile;
    i,j:integer;

begin
 Result:=True;
 if FileExists(IniFileName) then
 begin
  Ini:=TIniFile.Create(IniFileName);
  FName:=Ini.ReadString('NPP','UnitName','Новоронежская АЭС блок №6');
  for i:=1 to 4 do
   begin
   // считаем количество и коды датчиков в холодных нитках
    FRU.FLoops[i].ColdLeg.CountTSens:=Ini.ReadInteger('ColdLeg'+IntToStr(i),'CountSensors',0);
    for j:=0 to FRU.Loops[i].ColdLeg.CountTSens-1 do
     begin
      FRU.Loops[i].ColdLeg.TSens[j]:=TSensor.Create;
      FRU.Loops[i].ColdLeg.TSens[j].Description.KKS:=Ini.ReadString('ColdLeg'+IntToStr(i),'TSensorKKS'+inttoSTr(j+1),'');
      if FRU.Loops[i].ColdLeg.TSens[j].Description.KKS='' then Result:=False;
     end;
   // считаем количество и коды датчиков в горячих нитках
    FRU.FLoops[i].HotLeg.CountTSens:=Ini.ReadInteger('HotLeg'+IntToStr(i),'CountSensors',0);
    for j:=0 to FRU.Loops[i].HotLeg.CountTSens-1 do
     begin
      FRU.Loops[i].HotLeg.TSens[j]:=TSensor.Create;
      FRU.Loops[i].HotLeg.TSens[j].Description.KKS:=Ini.ReadString('HotLeg'+IntToStr(i),'TSensorKKS'+inttoSTr(j+1),'');
      if FRU.Loops[i].HotLeg.TSens[j].Description.KKS='' then Result:=False;
     end;
   end; //конец цикла for i:=1 to 4 do по количеству петель
   
   FRU.Nakz.Description.KKS:=Ini.ReadString('Nakz','KKS','');
   if FRU.Nakz.Description.KKS='' then Result:=False;
   FRU.Ndpz.Description.KKS:=Ini.ReadString('Ndpz','KKS','');
   if FRU.Ndpz.Description.KKS='' then Result:=False;
   FRU.Naknp.Description.KKS:=Ini.ReadString('Naknp','KKS','');
   if FRU.Naknp.Description.KKS='' then Result:=False;
 end;
end;

function TNPPUnit.Link(Buffer:TBuffer;var LinkError:Tstrings): boolean;
var i,j,k:integer;
begin
 Result:=True;
// привязка к коду
 for i:=0 to buffer.CountParam-1 do
 begin
 // сначала поищем код средневзвешанной мощности РУ
  if FRU.Nakz.Description.ID=-1 then
    if  FRU.Nakz.Description.KKS=Buffer.CalcValues[i].KKS { CalcValues[i]. Description.KKS} then
     begin FRU.Nakz.Description.ID:= i;FRU.Nakz.Value:=Buffer.LastValues[i];end;

  if FRU.Naknp.Description.ID=-1 then
    if  FRU.Naknp.Description.KKS=Buffer.CalcValues[i].KKS then
     begin FRU.Naknp.Description.ID:= i;FRU.Naknp.Value:=Buffer.LastValues[i];end;

 if FRU.Ndpz.Description.ID=-1 then
    if  FRU.Ndpz.Description.KKS=Buffer.CalcValues[i].KKS then
     begin FRU.Ndpz.Description.ID:= i;FRU.Ndpz.Value:=Buffer.LastValues[i];end;

  // теперь поищем коды датчиков температуры в горячих нитках ГЦТ
  for j:=1 to 4 do
   for k:=0 to FRU.Loops[j].HotLeg.CountTSens-1 do
   if FRU.Loops[j].HotLeg.TSens[k].Description.ID=-1 then
    if FRU.Loops[j].HotLeg.TSens[k].Description.KKS=Buffer.CalcValues[i].KKS  then
      begin FRU.Loops[j].HotLeg.TSens[k].Description.ID:= i;FRU.Loops[j].HotLeg.TSens[k].Value:= Buffer.LastValues[i];end;

  // теперь поищем коды датчиков температуры в холодных нитках ГЦТ
  for j:=1 to 4 do
   for k:=0 to FRU.Loops[j].ColdLeg.CountTSens-1 do
   if FRU.Loops[j].ColdLeg.TSens[k].Description.ID=-1 then
    if FRU.Loops[j].ColdLeg.TSens[k].Description.KKS=Buffer.CalcValues[i].KKS then
      begin FRU.Loops[j].ColdLeg.TSens[k].Description.ID:= i;FRU.Loops[j].ColdLeg.TSens[k].Value:= Buffer.LastValues[i];end;

 end;
 //-----------------------------------------------------------------------------
 // проверка наличия кода в буфере
 // сначала поищем код средневзвешанной мощности РУ
  if FRU.Nakz.Description.ID=-1 then
       begin
        Result:=False;
        LinkError.Add('В полученных данных нет кода средневзвешенной мощности: '+FRU.Nakz.Description.KKS);
       end;
  if FRU.Naknp.Description.ID=-1 then
       begin
        Result:=False;
        LinkError.Add('В полученных данных нет кода мощности по АКНП: '+FRU.Naknp.Description.KKS);
       end;
 if FRU.Ndpz.Description.ID=-1 then
       begin
        Result:=False;
        LinkError.Add('В полученных данных нет кода мощности по ДПЗ: '+FRU.Ndpz.Description.KKS);
       end;

  // теперь поищем коды датчиков температуры в горячих нитках ГЦТ
  for j:=1 to 4 do
   for k:=0 to FRU.Loops[j].HotLeg.CountTSens-1 do
   if FRU.Loops[j].HotLeg.TSens[k].Description.ID=-1 then
       begin
        Result:=False;
        LinkError.Add('В полученных данных нет кода датчика температуры в горячей нитке петли №'+InttoStr(j) +' : '+FRU.Loops[j].HotLeg.TSens[k].Description.KKS);
       end;
  // теперь поищем коды датчиков температуры в холодных нитках ГЦТ
  for j:=1 to 4 do
   for k:=0 to FRU.Loops[j].ColdLeg.CountTSens-1 do
   if FRU.Loops[j].ColdLeg.TSens[k].Description.ID=-1 then
       begin
        Result:=False;
        LinkError.Add('В полученных данных нет кода датчика температуры в холодной нитке петли №'+InttoStr(j) +' : '+FRU.Loops[j].ColdLeg.TSens[k].Description.KKS);
       end;

end;

function TNPPUnit.Regim(Buffer:TBuffer): TRegimeType;
var i,j:integer;
begin
// сначала присвоение внутренностям FRU последних значений из TBuffer
Result:=rt_Unknown;
if FRU.Nakz.Description.ID=-1 then exit;
FRU.Nakz.Value:=Buffer.LastValues[FRU.Nakz.description.id];
if FRU.Naknp.description.id=-1 then exit;
FRU.Naknp.Value:=Buffer.LastValues[FRU.Naknp.description.id];
if FRU.Ndpz.description.id=-1 then exit;
FRU.Ndpz.Value:=Buffer.LastValues[FRU.Ndpz.description.id];
for i:=1 to 4 do
begin
 for j:=0 to FRU.Loops[i].HotLeg.CountTSens-1 do
  FRU.Loops[i].HotLeg.TSens[j].Value:=Buffer.LastValues[FRU.Loops[i].HotLeg.TSens[j].description.id];
 for j:=0 to FRU.Loops[i].ColdLeg.CountTSens-1 do
  FRU.Loops[i].ColdLeg.TSens[j].Value:=Buffer.LastValues[FRU.Loops[i].ColdLeg.TSens[j].description.id];

end;
  FRU.CalcTH;
  FRU.CalcTC;
 // если мощность больше 10% по логике 2 из 3-х, то тогда на мощности, если нет,
// то если температуры Тхол = Т гор и Тхол i >10 Градусов, то Горячее состояние.

 if ((FRU.Nakz.Value.Value>10) and (FRU.Naknp.Value.Value>10))
    or ((FRU.Nakz.Value.Value>10) and (FRU.Ndpz.Value.Value>10))
    or ((FRU.Naknp.Value.Value>10) and (FRU.Ndpz.Value.Value>10))
    then Result:=rtN10_100 //на мощности
     else
 if ((FRU.Nakz.Value.Value>3) and (FRU.Naknp.Value.Value>3))
    or ((FRU.Nakz.Value.Value>3) and (FRU.Ndpz.Value.Value>3))
    or ((FRU.Naknp.Value.Value>3) and (FRU.Ndpz.Value.Value>3))
    then Result:=rtN1_10 //на мощности от 3-х до 10%
     else
//    if (FRU.TCold.Value.Value>260) and (abs(FRU.TCold.Value.Value-FRU.THot.Value.Value)<1)
    if (FRU.TC>260) and (abs(FRU.TC-FRU.TH)<1)
    then Result:=rtHot // горячее и ФП
    else
    Result:=rt_Unknown; // не определено


end;

procedure TNPPUnit.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TNPPUnit.SetRU(const Value: TRU);
begin
  FRU := Value;
end;


{ TSensor }

constructor TSensor.Create;
begin
 inherited Create;

{ FValue:=NilFEPValue;//NilCalcValue;}
 FDescription:=TDescription.Create;
 FExtIndex:=-1;
end;

destructor TSensor.Destroy;
begin
// FValue:=nil;//NilCalcValue;
 FDescription.Destroy;
 FExtIndex:=-1;
  inherited Destroy;
end;

function TSensor.GetValue: TValue;
begin
 Result:=FValue;
end;

{ TRU }

procedure TRU.CalcTC;
var i,j,count:integer;
     tempTCOld:double;
     Value:TValue;
begin
  tempTCOld:=0;
  count:=0;
  for i:=1 to 4 do
   for j:=0 to FLoops[i].ColdLeg.CountTSens-1 do
    if FLoops[i].ColdLeg.TSens[j].Value.Status=Status_OK then
    if FLoops[i].ColdLeg.TSens[j].Value.Value>0 then
    begin
    tempTCOld:=tempTCOld+FLoops[i].ColdLeg.TSens[j].Value.Value;
    inc(count);
    end;
  if Count>0 then
   begin
   Value.Value:=tempTCOld/count;
   Value.status:=Status_ok;
  end
  else
  begin
   Value.Value:=0;
   Value.status:=Status_Invalid;
  end;
  FTC:=Value.Value;
end;

procedure TRU.CalcTCold;
var i,j,CountSum:integer;
    sum:double;
begin
 sum:=0;
 CountSum:=0;
for i:=1 to 4 do
 begin
 for j:=0 to FLoops[i].ColdLeg.CountTSens-1 do
  sum:=sum+Floops[i].ColdLeg.TSens[j].Value.Value;
  countSum:=countSum+Floops[i].ColdLeg.CountTSens;
 end;
// FTCold.Value.Value:=sum/CountSum;

end;

procedure TRU.CalcTH;
var i,j,count:integer;
     tempTHot:double;
     Value:TValue;
begin
  tempTHot:=0;
  count:=0;
  for i:=1 to 4 do
   for j:=0 to FLoops[i].HotLeg.CountTSens-1 do
    if FLoops[i].HotLeg.TSens[j].Value.Status=Status_OK then
    if FLoops[i].HotLeg.TSens[j].Value.Value>0 then
    begin
    tempTHot:=tempTHot+FLoops[i].HotLeg.TSens[j].Value.Value;
    inc(count);
    end;
  if Count>0 then
   begin
   Value.Value:=tempTHot/count;
   Value.status:=Status_ok;
  end
  else
  begin
   Value.Value:=0;
   Value.status:=Status_Invalid;
  end;
  FTH:=Value.Value;
end;

constructor TRU.Create;
var i:integer;
begin
 inherited Create;
 for i:=1 to 4 do
  FLoops[i]:=TLoop.Create;
  FNakz:=TSensor.Create;
  FNAKNP:=TSensor.Create;
  FNDPZ:=TSensor.Create;
  FTCold:=TSensor.Create;
  FTHot:=TSensor.Create;
end;

destructor TRU.Destroy;
var i:integer;
begin
 for i:=1 to 4 do
  FLoops[i].Destroy;
  FNakz.Destroy;
  FNAKNP.Destroy;
  FNDPZ.Destroy;
 inherited Destroy;
end;

function TRU.GetLoops(i: integer): TLoop;
begin
 Result:=FLoops[i];
end;

function TRU.GetTCold: TSensor;
var i,j,count:integer;
     tempTCOld:double;
     Value:TValue;
begin
  tempTCOld:=0;
  count:=0;
  for i:=1 to 4 do
   for j:=0 to FLoops[i].ColdLeg.CountTSens-1 do
    if FLoops[i].ColdLeg.TSens[j].Value.Status=Status_OK then
    if FLoops[i].ColdLeg.TSens[j].Value.Value>0 then
    begin
    tempTCOld:=tempTCOld+FLoops[i].ColdLeg.TSens[j].Value.Value;
    inc(count);
    end;
  if Count>0 then
   begin
   Value.Value:=tempTCOld/count;
   Value.status:=Status_ok;
  end
  else
  begin
   Value.Value:=0;
   Value.status:=Status_Invalid;
  end;
  FTCold.Value:=Value;
end;

function TRU.GetTHot: TSensor;
var i,j,count:integer;
     tempTHot:double;
     Value:TValue;
begin
  tempTHot:=0;
  count:=0;
  for i:=1 to 4 do
   for j:=0 to FLoops[i].HotLeg.CountTSens-1 do
    if FLoops[i].HotLeg.TSens[j].Value.Status=Status_OK then
    if FLoops[i].HotLeg.TSens[j].Value.Value>0 then
    begin
    tempTHot:=tempTHot+FLoops[i].HotLeg.TSens[j].Value.Value;
    inc(count);
    end;
  if Count>0 then
   begin
   Value.Value:=tempTHot/count;
   Value.status:=Status_ok;
  end
  else
  begin
   Value.Value:=0;
   Value.status:=Status_Invalid;
  end;
  FTHot.Value:=Value;
end;

procedure TRU.SetLoops(i: integer; const Value: TLoop);
begin
 FLoops[i]:=Value;
end;

procedure TRU.SetNakz(const Value: TSensor);
begin
  FNakz := Value;
end;

procedure TRU.SetTC(const Value: double);
begin
  FTC := Value;
end;

procedure TRU.SetTCOld(const Value: TSensor);
begin
 FTCold:=Value;
end;

procedure TRU.SetTH(const Value: double);
begin
  FTH := Value;
end;

procedure TRU.SetTHot(const Value: TSensor);
begin
 FTHot:=Value;
end;

{ TLeg }

constructor TLeg.Create;
begin
 FCountTSens:=0;
 SetLength(FTSens,0);
end;

destructor TLeg.Destroy;
begin
 FCountTSens:=0;
 SetLength(FTSens,0);
 inherited Destroy;
end;

function TLeg.GetTSens(i: integer): TSensor;
begin
 if i<FCountTSens then
 Result:=FTSens[i];
end;

procedure TLeg.SetCountTSens(const Value: integer);
var i:integer;
begin
  FCountTSens := Value;
  SetLength(FTSens,Value);
  for i:=0 to FCountTSens-1 do
  FTSens[i]:=TSensor.Create;
end;

procedure TLeg.SetTSens(i: integer; const Value: TSensor);
begin
 FTSens[i]:=Value;
end;

{ TLoop }

constructor TLoop.Create;
begin
  inherited Create;
  FHotLeg:=TLeg.Create;
  FColdLeg:=TLeg.Create;
end;

destructor TLoop.Destroy;
begin
  FHotLeg.Destroy;
  FColdLeg.Destroy;

  inherited Destroy;
end;


end.
