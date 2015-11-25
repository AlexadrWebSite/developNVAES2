unit uCalcParam;
//----------------------------------------------------------------------------------------
// Описание класса описывающего информацию для проведения проверки на достоверность
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 20/04/2015
//----------------------------------------------------------------------------------------

interface
uses SysUtils;

 type TParallChannel=record
     Name:string[50];
     KKSMask:string[255];
     Psi:double;
     PsiDB:double;
     Value:double;
     Dev:double;
     Valid:boolean;
     Done:boolean;
     end;
const NullParallChannel:TParallChannel=(Name:'';KKSMask:'';Psi:0;PsiDB:0;Value:0;Dev:0;Valid:False;Done:False);

 type TOneCalcParam = class(TObject)
      private
        FMask:String;
        FName:string;
        FMUnit:string;
        FNomMin:double;
        FNomMax:double;

        FDelta:double;
        FPrecision:integer;// количество знаков после запятой
        FNomMinCoef: double;
        FNomMaxCoef: double;
        FNomMinCalc:double;
        FNomMaxCalc:double;
        FParallChannels:array[1..3] of TParallChannel;
        procedure SetDelta(const Value: double);
        procedure SetMask(const Value: String);
        procedure SetMUnit(const Value: string);
        procedure SetName(const Value: string);
        procedure SetNomMax(const Value: double);
        procedure SetNomMin(const Value: double);
        procedure SetPrecision(const Value: integer);

        procedure SetNomMaxCoef(const Value: double);
        procedure SetNomMinCoef(const Value: double);
    function GetParallelChannel(i: Integer): TParallChannel;
    procedure SetParallelChannel(i: Integer; const Value: TParallChannel);
      protected

      public
       property Mask:String read FMask write SetMask;
       property Name:string read FName write SetName;
       property MUnit:string read FMUnit write SetMUnit;
       property NomMin:double read FNomMin write SetNomMin;
       property NomMax:double read FNomMax write SetNomMax;
       property NomMinCoef:double read FNomMinCoef write SetNomMinCoef;
       property NomMaxCoef:double read FNomMaxCoef write SetNomMaxCoef;

       property NomMinCalc:double read FNomMinCalc write FNomMinCalc;
       property NomMaxCalc:double read FNomMaxCalc write FNomMinCalc;

       property Delta:double read FDelta write SetDelta;
       property ParallelChannel[i:Integer]:TParallChannel read GetParallelChannel write SetParallelChannel;
       property Precision:integer read FPrecision write SetPrecision;// количество знаков после запятой

        constructor Create;
        destructor Destroy;
      published

      end;

function EqualMask(KKS:string;Mask:string):boolean;

type TCalcParams = class(TObject)
     private
      FItems:array of TOneCalcParam;
      FCount:integer;
    function GetItems(i: integer): TOneCalcParam;
    procedure SetItems(i: integer; const Value: TOneCalcParam);
    procedure SetCount(const Value: integer);
     protected

     public

       property Items[i:integer]:TOneCalcParam read GetItems write SetItems;
       property Count:integer read FCount write SetCount;
       function FindInMask(KKS:string):integer;
       function LoadFromDB:boolean;
       constructor Create;
       destructor Destroy;
     published 

     end;

implementation

uses uDataModule, DB;

{ TOneCalcParam }

constructor TOneCalcParam.Create;
begin
 FMask:='';
 FName:='';
 FMUnit:='';
 FNomMin:=-1;
 FNomMax:=0;

 FDelta:=0;
 inherited Create;
end;

destructor TOneCalcParam.Destroy;
begin
 inherited Destroy;
end;

function TOneCalcParam.GetParallelChannel(i: Integer): TParallChannel;
begin
 Result:=FParallChannels[i];
end;

procedure TOneCalcParam.SetDelta(const Value: double);
begin
  FDelta := Value;
end;

procedure TOneCalcParam.SetMask(const Value: String);
begin
  FMask := Value;
end;

procedure TOneCalcParam.SetMUnit(const Value: string);
begin
  FMUnit := Value;
end;

procedure TOneCalcParam.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TOneCalcParam.SetNomMax(const Value: double);
begin
  FNomMax := Value;
end;

procedure TOneCalcParam.SetNomMaxCoef(const Value: double);
begin
  FNomMaxCoef := Value;
end;

procedure TOneCalcParam.SetNomMin(const Value: double);
begin
  FNomMin := Value;
end;

procedure TOneCalcParam.SetNomMinCoef(const Value: double);
begin
  FNomMinCoef := Value;
end;

procedure TOneCalcParam.SetParallelChannel(i: Integer;
  const Value: TParallChannel);
begin
 FParallChannels[i]:=Value;
end;

procedure TOneCalcParam.SetPrecision(const Value: integer);
begin
  FPrecision := Value;
end;


{ TCalcParams }

constructor TCalcParams.Create;
begin
 inherited Create;
 FCount:=0;
 SetLength(FItems,FCount);
end;

destructor TCalcParams.Destroy;
begin
 SetLength( FItems,0);
 inherited Destroy;
end;

function TCalcParams.FindInMask(KKS: string): integer;
var i,j:integer;
Stop:boolean;
begin
// поиск подходящей маски
result:=-1;// значит нет подходящей маски

i:=0;
while (Result=-1) and (i<FCount) do
begin
 if Length(KKS)=Length(FItems[i].Mask) then
    begin
     Stop:=False;
     j:=1;
     while (not stop)and (j<Length(KKS)) do
     begin
      if FItems[i].Mask[j]<>'?' then
        if KKS[j]<>FItems[i].Mask[j] then Stop:=True;
      inc(j);
      if (j=Length(KKS)) and (not stop) then Result:=i;
     end;
     j:=0;
    end;
 inc(i);
end;

end;

function TCalcParams.GetItems(i: integer): TOneCalcParam;
begin
 Result:=FItems[i];
end;

function TCalcParams.LoadFromDB: boolean;
var i,j:integer;
   s:string;
   PCh:TParallChannel;
begin
  Result:=False;
  with uDataModule.DataModule do
  begin
    ADOQuery.Active:=False;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('SELECT ParamTest.Код, ParamTest.ModeName, ParamTest.KKSMask, ParamTest.NomMinConst, ParamTest.NomMinCoef, ParamTest.NomMaxConst, ParamTest.NomMaxCoef, ');
    ADOQuery.SQL.Add('ParamTest.Delta, ParamTest.ParalName1, ParamTest.ParalKKSMask1, ParamTest.ParalPsi1, ParamTest.ParalName2, ParamTest.ParalKKSMask2, ParamTest.ParalPsi2, ParamTest.ParalName3, ');
    ADOQuery.SQL.Add('ParamTest.ParalKKSMask3, ParamTest.ParalPsi3, ParamTest.Precision');
    ADOQuery.SQL.Add('FROM ParamTest;');

    ADOQuery.Active:=True;
    Count:=ADOQuery.RecordCount;

    for i:=0 to ADOQuery.RecordCount-1 do
    begin
       FItems[i].Mask:=ADOQuery.FieldByName('KKSMask').AsString;
       FItems[i].NomMin:=ADOQuery.FieldByName('NomMinConst').AsFloat;
       FItems[i].NomMinCoef:=ADOQuery.FieldByName('NomMinCoef').AsFloat;
       FItems[i].NomMax:=ADOQuery.FieldByName('NomMaxConst').AsFloat;
       FItems[i].NomMaxCoef:=ADOQuery.FieldByName('NomMaxCoef').AsFloat;
       FItems[i].Delta:=ADOQuery.FieldByName('Delta').AsFloat;
       for j:=1 to 3 do
       begin
        PCh:=NullParallChannel;
        PCh.Name:=ADOQuery.FieldByName('ParalName'+IntToStr(j)).AsString;
        PCh.KKSMask:=ADOQuery.FieldByName('ParalKKSMask'+IntToStr(j)).AsString;
        PCh.PsiDB:=ADOQuery.FieldByName('ParalPsi'+IntToStr(j)).AsFloat;
        FItems[i].ParallelChannel[j]:=PCh;
       end;
      FItems[i].Precision:=ADOQuery.FieldByName('Precision').AsInteger;
      ADOQuery.RecNo:=ADOQuery.RecNo+1;
     end;
    ADOQuery.Active:=False;
    Result:=True;
end;
end;

procedure TCalcParams.SetCount(const Value: integer);
var i:integer;
begin
  SetLength(FItems,value);
  for i:=fcount to value-1 do
   FItems[i]:=TOneCalcParam.Create;
  FCount := Value;
end;

procedure TCalcParams.SetItems(i: integer; const Value: TOneCalcParam);
begin
 FItems[i]:=Value;
end;

function EqualMask(KKS:string;Mask:string):boolean;
var j:integer;
Stop:boolean;
begin
// поиск подходящей маски
result:=false;// значит нет подходящей маски
 if Length(KKS)=Length(Mask) then
    begin
     Stop:=False;
     j:=1;
     while (not stop)and (j<Length(KKS)) do
     begin
      if Mask[j]<>'?' then
        if KKS[j]<>Mask[j] then Stop:=True;
      inc(j);
      if (j=Length(KKS)) and (not stop) then Result:=True;
     end;
     j:=0;
    end;
end;

end.
