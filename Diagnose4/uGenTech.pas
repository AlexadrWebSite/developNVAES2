unit uGenTech;
//----------------------------------------------------------------------------------------
// Описание класса TGenTech - обработка параметров по Общей Технологии (6 стоект ПТК-З)
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 23.04.2015
//----------------------------------------------------------------------------------------


interface

uses SysUtils, uCalcParam,uBuffer,uKStudent,Dialogs,uDescription;

type
TParam = class(TObject) // класс для описания одного значения параметра, используемого при обработке на достоверность
private
  FCalcValue:TCalcValue;
  FDescription:TDescription;
  FError:double;
  FValid:boolean;
  FServiceable:boolean;
  FCalcParamInfo:TOneCalcParam;
  FNomMin:double;
  FNomMax:double;
  FNote:string;
    procedure SetNomMax(const Value: double);
    procedure SetNomMin(const Value: double);
    procedure SetServiceable(const Value: boolean);
    procedure SetError(const Value: double);
    procedure SetValid(const Value: boolean);

public
  property CalcValue:TCalcValue read FCalcValue write FCalcValue;
  property Description:TDescription read FDescription write FDescription;
  property Error:double read FError write SetError;
  property Valid:boolean read FValid write SetValid;
  property Serviceable:boolean read FServiceable write SetServiceable;
  property CalcParamInfo:TOneCalcParam read FCalcParamInfo write FCalcParamInfo;
  property NomMin:double read FNomMin write SetNomMin;
  property NomMax:double read FNomMax write SetNomMax;
  property Note:string read FNote write FNote;


  constructor Create;
  destructor Destroy;
end;

type TParallSensors = class (TObject)
      FMean:double;
      FItems:array of TParam;
      FCount:integer;
  private
    function GetItems(i: integer): TParam;
    procedure SetCount(const Value: integer);
    procedure SetItems(i: integer; const Value: TParam);
    procedure SetMean(const Value: double);
public
      property Mean:double read FMean write SetMean;
      property Items[i:integer]:TParam read GetItems write SetItems;
      property Count:integer read FCount write SetCount;
        constructor Create;
        destructor Destroy;
 end;


// описание датчиков в одном ПТК-З
type
TPTKZ = class(TObject)
private
  FParams:array of TParam;
  FCount:integer;
  FName:string;
  FComplect:byte;
  FChannel:byte;
    function GetParams(i: integer): TParam;
    procedure SetCount(const Value: integer);
    procedure SetName(const Value: string);
    procedure SetParams(i: integer; const Value: TParam);
protected

public
  property Params[i:integer]:TParam read GetParams write SetParams;
  property Count:integer read FCount write SetCount;
  property Name:string read FName write SetName;
  property Complect:byte read FComplect write FComplect;
  property Channel:byte read FChannel write FChannel;
  constructor Create(PTKComplect:byte;PTKChannel:byte; PTKName:string='');
  destructor Destroy;
published 

end;

//Описание класса для обработки общетехнологических параметров (GenTech)
type
TGenTech = class(TObject)
private
 FPTKZ:array [1..6] of TPTKZ;
 FParams:TPTKZ;//параметры, которые не входят в ПТК-З.
    function GetPTKZ(i: integer): TPTKZ;
    procedure SetPTKZ(i: integer; const Value: TPTKZ);
    function GetParams: TPTKZ;
    procedure SetParams(const Value: TPTKZ);
protected

public
  property PTKZ[i:integer]:TPTKZ read GetPTKZ write SetPTKZ;
  property Params:TPTKZ read GetParams write SetParams;
  procedure LoadFromDB;// загрузить списки (коды KKS)датчиков по всем 6-ти ПТК-З и общие параметры
  procedure LinkCalcInfo(CalcParams:TCalcParams);
  procedure LinkBuffer(Buffer:TBuffer);
  procedure Calc(Buffer:TBuffer;Nprocent:double);
  constructor Create;
  destructor Destroy;
published 

end;

implementation

uses uDataModule, DB;

{ TParam }

constructor TParam.Create;
begin
FCalcValue:=TCalcValue.Create;
FDescription:=TDescription.Create;
FNote:='';
inherited Create;
end;

destructor TParam.Destroy;
begin
 inherited Destroy;
end;


procedure TParam.SetNomMax(const Value: double);
begin
  FNomMax := Value;
end;

procedure TParam.SetNomMin(const Value: double);
begin
  FNomMin := Value;
end;

procedure TParam.SetServiceable(const Value: boolean);
begin
  FServiceable := Value;
end;

procedure TParam.SetError(const Value: double);
begin
  FError := Value;
end;

procedure TParam.SetValid(const Value: boolean);
begin
  FValid := Value;
end;

{ TPTKZ }

constructor TPTKZ.Create(PTKComplect:byte;PTKChannel:byte;PTKName: string);
begin
 FName:=PTKName;
 FComplect:=PTKComplect;
 FChannel:=PTKChannel;
 FCount:=0;
 Inherited Create;
end;

destructor TPTKZ.Destroy;
begin
 Inherited Destroy;
end;

function TPTKZ.GetParams(i: integer): TParam;
begin
 Result:=FParams[i];
end;

procedure TPTKZ.SetCount(const Value: integer);
var i:integer;
begin
  SetlENgth(FParams,Value);
  for i:=FCount to Value-1 do
  FParams[i]:=TParam.Create;
  FCount := Value;
end;

procedure TPTKZ.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TPTKZ.SetParams(i: integer; const Value: TParam);
begin
 FParams[i]:=Value;
end;

{ TGenTech }

procedure TGenTech.Calc(Buffer:TBuffer;Nprocent: double);
var i,j,k,l:integer;
    ParallChannel:TParallChannel;
//    found:boolean;
    sum:double;
    count:integer;
begin
buffer.calc;
 {
//сначала копируем данные из буфера
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
    if Buffer.CalcValues[FPTKZ[i].Params[j].description.ID].KKS<>FPTKZ[i].Params[j].CalcValue.KKS then
       MessageDlg('KKS '+Buffer.CalcValues[FPTKZ[i].Params[j].description.ID].KKS+'\'+FPTKZ[i].Params[j].CalcValue.KKS  ,mtInformation,[mbOk],0);

//    Buffer.CalcValues[FPTKZ[i].Params[j].description.ID].Description :=FPTKZ[i].Params[j].CalcValue.description;
    FPTKZ[i].Params[j].CalcValue:=Buffer.CalcValues[FPTKZ[i].Params[j].description.ID];
   end;
  end;
  }
//  MessageDlg('CalcParamInfo firsr time',mtInformation,[mbOk],0);
 //теперь расчитываем CalcParam
for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
  if FPTKZ[i].Params[j].CalcParamInfo<>nil then
   begin
    FPTKZ[i].Params[j].CalcParamInfo.NomMinCalc:=FPTKZ[i].Params[j].CalcParamInfo.NomMin+FPTKZ[i].Params[j].CalcParamInfo.NomMinCoef*Nprocent;
    FPTKZ[i].Params[j].CalcParamInfo.NomMaxCalc:=FPTKZ[i].Params[j].CalcParamInfo.NomMax+FPTKZ[i].Params[j].CalcParamInfo.NomMaxCoef*Nprocent;
    for k:=1 to 3 do
      begin
       ParallChannel:=FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[k];
       if FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[k].Name='Ручной расчет (СВРК)' then
         ParallChannel.Psi:=ParallChannel.PsiDB/SQRT(Buffer.LengthBuf)
          else
         ParallChannel.Psi:=ParallChannel.PsiDB;
       FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[k]:=ParallChannel;
     end;
   end;
  end;
 //теперь происходит проверка на работоспособность
 // по признаку СКО меньше допустимой дельта
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
   FPTKZ[i].Params[j].Note:='';
    if FPTKZ[i].Params[j].description.ID<>-1 then
     FPTKZ[i].Params[j].Error:=Buffer.CalcValues[FPTKZ[i].Params[j].description.ID].MSE*KStudent(Buffer.LengthBuf);
     if FPTKZ[i].Params[j].CalcParamInfo<>nil then
     FPTKZ[i].Params[j].Serviceable:=not (FPTKZ[i].Params[j].Error> FPTKZ[i].Params[j].CalcParamInfo.Delta);
     if not FPTKZ[i].Params[j].Serviceable then FPTKZ[i].Params[j].Note:='СКО ('+FloattoStrF(FPTKZ[i].Params[j].Error,ffFixed,3+FPTKZ[i].Params[j].CalcParamInfo.Precision ,FPTKZ[i].Params[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FPTKZ[i].Params[j].CalcParamInfo.Delta,ffFixed,FPTKZ[i].Params[j].CalcParamInfo.Precision+3,FPTKZ[i].Params[j].CalcParamInfo.Precision)+');';
   end;
  end;
// расчет достоверности по признаку равенству номиналу
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
   FPTKZ[i].Params[j].Valid:=True; // сначала считаем что параметр достоверен
    if FPTKZ[i].Params[j].CalcParamInfo<>nil then
     FPTKZ[i].Params[j].Valid:=( FPTKZ[i].Params[j].CalcValue.Mean<=FPTKZ[i].Params[j].CalcParamInfo.NomMax) and (FPTKZ[i].Params[j].CalcValue.Mean>=FPTKZ[i].Params[j].CalcParamInfo.NomMin);
     if not FPTKZ[i].Params[j].Valid then FPTKZ[i].Params[j].Note:=FPTKZ[i].Params[j].Note+' не соотв. ном.;';
   end;
  end;
//
//теперь расчет паралельных значений
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
    if FPTKZ[i].Params[j].CalcParamInfo<>nil then
    for l:=1 to 3 do
    if FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[l].KKSMask<>'' then // если имя задано, то есть группа параллельных каналов
     begin
     // сначала поиск по маске параллельных каналов
       k:=0;
       sum:=0;
       count:=0;
       while (k<Buffer.CountParam)  do
       begin
         if EqualMask(buffer.CalcValues[k].KKS, FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[l].KKSMask)
          then
            if FPTKZ[i].Params[j].Description.KKS<>buffer.CalcValues[k].KKS then

            begin
             Sum:=sum+buffer.CalcValues[k].Mean;
             inc(count);
            end;
          inc(k);
       end;
       ParallChannel:=FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[l];
       ParallChannel.Value:=0;
       if count>0 then
       begin
         ParallChannel.Value:=Sum/count;
         //------------------------------------
         // !!!проверка на достоверность!!! по каждой группе параллельных каналов
      //  if (i=1) and (j=0) then MessageDlg(FPTKZ[i].Params[j].Description.KKS+' Mean='+FloattoStr(FPTKZ[i].Params[j].CalcValue.Mean)+' Parall='+FloattoSTr(ParallChannel.Value) ,mtInformation,[mbOk],0);
//         FPTKZ[i].Params[j].CalcValue.Mean:=7;
         ParallChannel.Dev:=abs(FPTKZ[i].Params[j].CalcValue.Mean-ParallChannel.Value);
         ParallChannel.Valid:= ParallChannel.Dev <ParallChannel.Psi;
         ParallChannel.Done:=True;
         if not ParallChannel.Valid then FPTKZ[i].Params[j].Valid:=False;
         if not ParallChannel.Valid then  FPTKZ[i].Params[j].Note:=FPTKZ[i].Params[j].Note+' не соотв. || <'+ParallChannel.Name +'>;';
         //------------------------------------
       end;
       FPTKZ[i].Params[j].CalcParamInfo.ParallelChannel[l]:=ParallChannel;

     end;
    end;
  end;

end;

constructor TGenTech.Create;
begin
 inherited Create;
  FPTKZ[1]:=TPTKZ.Create(1,1,'ком. 1 кан. 1');
  FPTKZ[2]:=TPTKZ.Create(1,2,'ком. 1 кан. 2');
  FPTKZ[3]:=TPTKZ.Create(1,3,'ком. 1 кан. 3');
  FPTKZ[4]:=TPTKZ.Create(2,1,'ком. 2 кан. 1');
  FPTKZ[5]:=TPTKZ.Create(2,2,'ком. 2 кан. 2');
  FPTKZ[6]:=TPTKZ.Create(2,3,'ком. 2 кан. 3');
  FParams:=TPTKZ.Create(0,0);
end;

destructor TGenTech.Destroy;
begin
inherited Destroy;
end;

function TGenTech.GetParams: TPTKZ;
begin
 Result:=FParams;
end;

function TGenTech.GetPTKZ(i: integer): TPTKZ;
begin
 Result:=FPTKZ[i];
end;

procedure TGenTech.LinkBuffer(Buffer: TBuffer);
var i,j,k:integer;
begin
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FPTKZ[i].Params[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FPTKZ[i].Params[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FPTKZ[i].Params[j].Description.ID:=k;// ссылка на элемент в буфере
      FPTKZ[i].Params[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
 end;
 //Общие параметры
  for j:=0 to FParams.Count-1 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FParams.Params[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FParams.Params[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FParams.Params[j].Description.ID:=k;// ссылка на элемент в буфере
      FParams.Params[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;

end;

procedure TGenTech.LinkCalcInfo(CalcParams: TCalcParams);
var i,j,Index:integer;
begin
 for i:=1 to 6 do
 begin
  for j:=0 to FPTKZ[i].Count-1 do
   begin
    Index:= CalcParams.FindInMask(FPTKZ[i].Params[j].Description.KKS);
    if Index<>-1 then
     FPTKZ[i].Params[j].CalcParamInfo:=CalcParams.Items[Index];
   end;
 end;
  for j:=0 to FParams.Count-1 do
   begin
    Index:= CalcParams.FindInMask(FParams.Params[j].Description.KKS);
    if Index<>-1 then
     FParams.Params[j].CalcParamInfo:=CalcParams.Items[Index];
   end;

end;

procedure TGenTech.LoadFromDB;
var i,j:integer;
    SQL:string;
begin
  with uDataModule.DataModule do
  begin
    for i:=1 to 6 do
    begin
    ADOQuery.Active:=False;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('SELECT PTKZ.Complect, PTKZ.Channel, PTKZ.KKS FROM PTKZ ');
    ADOQuery.SQL.Add(' where( PTKZ.Complect='+InttoStr( FPTKZ[i].Complect)+')  and( PTKZ.Channel='+InttoStr( FPTKZ[i].Channel)+');');
    ADOQuery.Active:=True;
    FPTKZ[i].Count:= ADOQuery.RecordCount;
     for j:=0 to ADOQuery.RecordCount-1 do
      begin
       FPTKZ[i].Params[j].Description.KKS:=ADOQuery.FieldByName('KKS').AsString;
       ADOQuery.RecNo:=ADOQuery.RecNo+1;
      end;
    end;


   SQL:='SELECT KKS_Name_MUnit.KKS, ParamName.ParamName, MUnit.MUnit FROM MUnit INNER JOIN (ParamName INNER JOIN KKS_Name_MUnit ON ParamName.Id = KKS_Name_MUnit.ParamName) ON MUnit.Id = KKS_Name_MUnit.MUnit where KKS_Name_MUnit.KKS="';

    for i:=1 to 6 do
    for j:=0 to FPTKZ[i].Count-1 do
    begin
      ADOQuery.Active:=False;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add(SQL+FPTKZ[i].Params[j].Description.KKS+'";' );
      ADOQuery.Active:=True;
      if ADOQuery.RecordCount>0 then
        begin
         FPTKZ[i].Params[j].Description.Name:=ADOQuery.FIeldByName('ParamName').AsString;
         FPTKZ[i].Params[j].Description.MUnit:=ADOQuery.FIeldByName('MUnit').AsString;
        end;
    end;
    //данные из таблицы GenTech - те параметры, которые не вошли в ПТК-З (Обшие параметры)
    ADOQuery.Active:=False;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('SELECT * FROM GenTech;');
    ADOQuery.Active:=True;
    FParams.Count:= ADOQuery.RecordCount;
     for j:=0 to ADOQuery.RecordCount-1 do
      begin
       FParams.Params[j].Description.KKS:=ADOQuery.FieldByName('KKS').AsString;
       ADOQuery.RecNo:=ADOQuery.RecNo+1;
      end;

   SQL:='SELECT KKS_Name_MUnit.KKS, ParamName.ParamName, MUnit.MUnit FROM MUnit INNER JOIN (ParamName INNER JOIN KKS_Name_MUnit ON ParamName.Id = KKS_Name_MUnit.ParamName) ON MUnit.Id = KKS_Name_MUnit.MUnit where KKS_Name_MUnit.KKS="';
    for j:=0 to FParams.Count-1 do
    begin
      ADOQuery.Active:=False;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add(SQL+FParams.Params[j].Description.KKS+'";' );
      ADOQuery.Active:=True;
      if ADOQuery.RecordCount>0 then
        begin
         FParams.Params[j].Description.Name:=ADOQuery.FIeldByName('ParamName').AsString;
         FParams.Params[j].Description.MUnit:=ADOQuery.FIeldByName('MUnit').AsString;
        end;
    end;
 end;
end;

procedure TGenTech.SetParams(const Value: TPTKZ);
begin
 FParams:=Value;
end;

procedure TGenTech.SetPTKZ(i: integer; const Value: TPTKZ);
begin
 FPTKZ[i]:=Value;
end;

{ TParallSensors }

constructor TParallSensors.Create;
begin
inherited Create;
end;

destructor TParallSensors.Destroy;
begin
 inherited Destroy;
end;

function TParallSensors.GetItems(i: integer): TParam;
begin
 Result:=FItems[i];
end;

procedure TParallSensors.SetCount(const Value: integer);
begin
  FCount := Value;
end;

procedure TParallSensors.SetItems(i: integer; const Value: TParam);
begin
 FItems[i]:=Value;
end;

procedure TParallSensors.SetMean(const Value: double);
begin
  FMean := Value;
end;



end.
