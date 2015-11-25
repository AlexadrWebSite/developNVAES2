unit uTC;
//----------------------------------------------------------------------------------------
// Описание класса TTC - обработка термоконтроля
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 01.07.2015
//----------------------------------------------------------------------------------------

interface

uses uGenTEch,IniFiles,SysUtils,uBuffer,uCalcParam,uKStudent,uCartogramM;

type TLeg = class(TObject)
     private
       FTC:array of TParam;
       FCount:integer;
       FT:TParam;
    function GetTC(i: integer): TParam;
    procedure SetTC(i: integer; const Value: TParam);
    procedure SetCount(const Value: integer);
    function GetT: TParam;
    procedure SetT(const Value: TParam);
     protected

     public
       property TC[i:integer]:TParam read GetTC write SetTC;
       property Count:integer read FCount write SetCount;
       property T:TParam read GetT write SetT;
       constructor Create;
       destructor Destroy;
     end;

type TLoop = class(TObject)
     private
      FHotLeg:TLeg;
      FColdLeg:TLeg;
     protected

     public
       property HotLeg:TLeg read FHotLeg write FHotLeg;
       property ColdLeg:TLeg read FColdLeg write FColdLeg;
       constructor Create;
       destructor Destroy;
     end;

type TKNIT = class(TObject)
     private
       FTP3:TParam;
       FTPA:TParam;
       FTPB:TParam;
       FTC :TParam;
       FNTVS:integer;
    procedure SetNTVS(const Value: integer);
    procedure SetTC(const Value: TParam);
    procedure SetTP3(const Value: TParam);
    procedure SetTPA(const Value: TParam);
    procedure SetTPB(const Value: TParam);
     protected

     public
       property TP3:TParam read FTP3 write SetTP3;
       property TPA:TParam read FTPA write SetTPA;
       property TPB:TParam read FTPB write SetTPB;
       property TC :TParam read FTC write SetTC;
       property NTVS:integer read FNTVS write SetNTVS;

       constructor Create;
       destructor Destroy;
     end;

Type TTC = class(TObject)
     private
      FLoops:array[1..4] of TLoop;
      FKNITs:array of TKNIT;
      FCountKNITs:integer;
      FTCold:TParam;
    FCountKNIT: integer;
    function GetLoops(i: integer): TLoop;
    procedure SetLoops(i: integer; const Value: TLoop);
    function GetKNIT(i: integer): TKNIT;
    procedure SetCountKNIT(const Value: integer);
    procedure SetKNIT(i: integer; const Value: TKNIT);
    procedure LinkCalcInfo(IniFile: TIniFile);
    function GetTCold: TParam;
    procedure SetTCold(const Value: TParam);
     protected

     public
       property Loops[i:integer]:TLoop read GetLoops write SetLoops;
       property KNIT[i:integer]:TKNIT read GetKNIT write SetKNIT;
       property CountKNIT:integer read FCountKNIT write SetCountKNIT;
       property TCold:TParam read GetTCold write SetTCold;
       procedure LinkBuffer(Buffer:TBuffer);
       procedure Calc_Power(TC_power_ini:TIniFile;KN:double;Buffer:TBuffer);
       constructor Create(LoopIni:TIniFile;KNITIni:TIniFile);
       destructor Destroy;
     end;


implementation

{ TLeg }

constructor TLeg.Create;
begin
 inherited Create;
 FT:=TParam.Create;
end;

destructor TLeg.Destroy;
begin
 inherited destroy;
end;

function TLeg.GetT: TParam;
begin
 Result:=FT;
end;

function TLeg.GetTC(i: integer): TParam;
begin
 Result:=FTC[i];
end;

procedure TLeg.SetCount(const Value: integer);
var i:integer;
begin
  FCount := Value;
  SetLength(FTC,Fcount);
  for i:=0 to Fcount-1 do
    FTC[i]:=TParam.Create;

end;

procedure TLeg.SetT(const Value: TParam);
begin
 FT:=Value;
end;

procedure TLeg.SetTC(i: integer; const Value: TParam);
begin
 FTC[i]:=Value;
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

{ TKNIT }

constructor TKNIT.Create;
begin
 inherited Create;
 FTP3:=TParam.Create;
 FTPA:=TParam.Create;
 FTPB:=TParam.Create;
 FTC :=TParam.Create;
 FNTVS:=-1;
end;

destructor TKNIT.Destroy;
begin
 FTP3.Destroy;
 FTPA.Destroy;
 FTPB.Destroy;
 FTC.Destroy;
 inherited Destroy;
end;

procedure TKNIT.SetNTVS(const Value: integer);
begin
  FNTVS := Value;
end;

procedure TKNIT.SetTC(const Value: TParam);
begin
  FTC := Value;
end;

procedure TKNIT.SetTP3(const Value: TParam);
begin
  FTP3 := Value;
end;

procedure TKNIT.SetTPA(const Value: TParam);
begin
  FTPA := Value;
end;

procedure TKNIT.SetTPB(const Value: TParam);
begin
  FTPB := Value;
end;

{ TTC }

procedure TTC.Calc_Power(TC_power_ini: TIniFile;KN:double;Buffer:TBuffer);
var     i,j,Count:integer;
         PCh:TParallChannel;
         Sum:double;

begin
//--- Сначала заполнение CalcInfo
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].HotLeg.Count-1 do
      begin
        FLoops[i].HotLeg.TC[j].CalcParamInfo:=TOneCalcParam.Create;
        FLoops[i].HotLeg.TC[j].CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('THotLeg','RegimTopA0',284)+TC_power_ini.ReadFloat('THotLeg','RegimTopA1',39)*KN;
        FLoops[i].HotLeg.TC[j].CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('THotLeg','RegimDownA0',284)+TC_power_ini.ReadFloat('THotLeg','RegimDownA1',49)*KN;
        FLoops[i].HotLeg.TC[j].CalcParamInfo.Delta:=TC_power_ini.ReadFloat('THotLeg','Delta',2);
        PCh.Psi:=TC_power_ini.ReadFloat('THotLeg','PsiA0',0.4)+TC_power_ini.ReadFloat('THotLeg','PsiA1',5)*KN;
        FLoops[i].HotLeg.TC[j].CalcParamInfo.ParallelChannel[1]:=Pch;
      end;
   end;
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].ColdLeg.Count-1 do
      begin
        FLoops[i].ColdLeg.TC[j].CalcParamInfo:=TOneCalcParam.Create;
        FLoops[i].ColdLeg.TC[j].CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('TColdLeg','RegimTopA0',284)+TC_power_ini.ReadFloat('TColdLeg','RegimTopA1',39)*KN;
        FLoops[i].ColdLeg.TC[j].CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('TColdLeg','RegimDownA0',284)+TC_power_ini.ReadFloat('TColdLeg','RegimDownA1',49)*KN;
        FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta:=TC_power_ini.ReadFloat('TColdLeg','Delta',2);
        PCh.Psi:=TC_power_ini.ReadFloat('TColdLeg','PsiA0',0.4)+TC_power_ini.ReadFloat('TColdLeg','PsiA1',5)*KN;
        FLoops[i].ColdLeg.TC[j].CalcParamInfo.ParallelChannel[1]:=PCh;
      end;
   end;
  for i:=0 to CountKNIT-1 do
   begin
   // TP3
    FKNITs[i].TP3.CalcParamInfo:=TOneCalcParam.Create;
    FKNITs[i].TP3.CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('TP3','RegimTopA0',284)+TC_power_ini.ReadFloat('TP3','RegimTopA1',9)*KN;
    FKNITs[i].TP3.CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('TP3','RegimDownA0',284)+TC_power_ini.ReadFloat('TP3','RegimDownA1',16)*KN;
    FKNITs[i].TP3.CalcParamInfo.Delta:=TC_power_ini.ReadFloat('TP3','Delta',0.6);
    PCh.Psi:=TC_power_ini.ReadFloat('TP3','PsiA0',0.4)+TC_power_ini.ReadFloat('TP3','PsiA1',5)*KN;
    FKNITs[i].TP3.CalcParamInfo.ParallelChannel[1]:=PCh;
   // TPA
    FKNITs[i].TPA.CalcParamInfo:=TOneCalcParam.Create;
    FKNITs[i].TPA.CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('TPA','RegimTopA0',284)+TC_power_ini.ReadFloat('TPA','RegimTopA1',9)*KN;
    FKNITs[i].TPA.CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('TPA','RegimDownA0',284)+TC_power_ini.ReadFloat('TPA','RegimDownA1',16)*KN;
    FKNITs[i].TPA.CalcParamInfo.Delta:=TC_power_ini.ReadFloat('TPA','Delta',0.6);
    PCh.Psi:=TC_power_ini.ReadFloat('TPA','PsiA0',0.4)+TC_power_ini.ReadFloat('TPA','PsiA1',5)*KN;
    FKNITs[i].TPA.CalcParamInfo.ParallelChannel[1]:=PCh;
   // TPB
    FKNITs[i].TPB.CalcParamInfo:=TOneCalcParam.Create;
    FKNITs[i].TPB.CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('TPB','RegimTopA0',284)+TC_power_ini.ReadFloat('TPB','RegimTopA1',9)*KN;
    FKNITs[i].TPB.CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('TPB','RegimDownA0',284)+TC_power_ini.ReadFloat('TPB','RegimDownA1',16)*KN;
    FKNITs[i].TPB.CalcParamInfo.Delta:=TC_power_ini.ReadFloat('TPB','Delta',0.6);
    PCh.Psi:=TC_power_ini.ReadFloat('TPB','PsiA0',0.4)+TC_power_ini.ReadFloat('TPB','PsiA1',5)*KN;
    FKNITs[i].TPB.CalcParamInfo.ParallelChannel[1]:=PCh;
   // TC
    FKNITs[i].TC.CalcParamInfo:=TOneCalcParam.Create;
    FKNITs[i].TC.CalcParamInfo.NomMax:=TC_power_ini.ReadFloat('TC','RegimTopA0',284)+TC_power_ini.ReadFloat('TC','RegimTopA1',9)*KN;
    FKNITs[i].TC.CalcParamInfo.NomMin:=TC_power_ini.ReadFloat('TC','RegimDownA0',284)+TC_power_ini.ReadFloat('TC','RegimDownA1',16)*KN;
    FKNITs[i].TC.CalcParamInfo.Delta:=TC_power_ini.ReadFloat('TC','Delta',0.6);
    PCh.Psi:=TC_power_ini.ReadFloat('TC','PsiA0',0.4)+TC_power_ini.ReadFloat('TC','PsiA1',5)*KN;
    FKNITs[i].TC.CalcParamInfo.ParallelChannel[1]:=PCh;

   end;
   //Теперь проверка
//теперь происходит проверка на работоспособность
// HotLeg
 // по признаку СКО меньше допустимой дельта
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].HotLeg.Count-1 do
      begin
       if FLoops[i].HotLeg.TC[j].description.ID<>-1 then
       FLoops[i].HotLeg.TC[j].Error:= Buffer.CalcValues[FLoops[i].HotLeg.TC[j].description.ID].MSE*KStudent(Buffer.LengthBuf);
       FLoops[i].HotLeg.TC[j].Serviceable:=not (FLoops[i].HotLeg.TC[j].Error> FLoops[i].HotLeg.TC[j].CalcParamInfo.Delta);
       if not FLoops[i].HotLeg.TC[j].Serviceable then FLoops[i].HotLeg.TC[j].Note:='СКО ('+FloattoStrF(FLoops[i].HotLeg.TC[j].Error,ffFixed,3+FLoops[i].HotLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].HotLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].HotLeg.TC[j].CalcParamInfo.Delta,ffFixed,FLoops[i].HotLeg.TC[j].CalcParamInfo.Precision+3,FLoops[i].HotLeg.TC[j].CalcParamInfo.Precision)+');';
      end;
   end;
 // расчет достоверности по признаку равенству номиналу
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].HotLeg.Count-1 do
      begin
       FLoops[i].HotLeg.TC[j].Valid:=True; // сначала считаем что параметр достоверен
         FLoops[i].HotLeg.TC[j].Valid:=( FLoops[i].HotLeg.TC[j].CalcValue.Mean<=FLoops[i].HotLeg.TC[j].CalcParamInfo.NomMax) and (FLoops[i].HotLeg.TC[j].CalcValue.Mean>=FLoops[i].HotLeg.TC[j].CalcParamInfo.NomMin);
         if not FLoops[i].HotLeg.TC[j].Valid then FLoops[i].HotLeg.TC[j].Note:=FLoops[i].HotLeg.TC[j].Note+' не соотв. ном.;';
      end;
   end;

//теперь расчет паралельных значений
  for i:=1 to 4 do
   begin
     Sum:=0;
     count:=0;
     for j:=0 to FLoops[i].HotLeg.Count-1 do
       if FLoops[i].HotLeg.TC[j].Valid then
        begin
         Sum:=Sum+Floops[i].HotLeg.TC[j].CalcValue.Mean;
         inc(count);
        end;
     if Count>0 then
      for j:=0 to FLoops[i].HotLeg.Count-1 do
       begin
        PCh.Value:=Sum/Count;
        PCh.Valid:= ABS(FLoops[i].HotLeg.TC[j].CalcValue.Mean-FLoops[i].HotLeg.TC[j].CalcParamInfo.ParallelChannel[1].Value)<=FLoops[i].HotLeg.TC[j].CalcParamInfo.ParallelChannel[1].Psi;
        FLoops[i].HotLeg.TC[j].CalcParamInfo.ParallelChannel[1]:=PCh;
        if not PCh.Valid then
        FLoops[i].HotLeg.TC[j].Valid:=False;
       end;
   end;
 for i:=1 to 4 do
   begin
    Count:=0;
    Sum:=0;
    for j:=0 to FLoops[i].HotLeg.Count-1 do
      begin
       if FLoops[i].HotLeg.TC[j].Valid and FLoops[i].HotLeg.TC[j].Serviceable then
       begin
        Sum:=Sum+FLoops[i].HotLeg.TC[j].CalcValue.Mean;
        inc(Count);
       end;
       if Count>0 then FLoops[i].HotLeg.T.CalcValue.Mean:=Sum/Count;
      end;
  end;
// ColdLeg
 // по признаку СКО меньше допустимой дельта
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].ColdLeg.Count-1 do
      begin
       if FLoops[i].ColdLeg.TC[j].description.ID<>-1 then
       FLoops[i].ColdLeg.TC[j].Error:= Buffer.CalcValues[FLoops[i].ColdLeg.TC[j].description.ID].MSE*KStudent(Buffer.LengthBuf);
       FLoops[i].ColdLeg.TC[j].Serviceable:=not (FLoops[i].ColdLeg.TC[j].Error> FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta);
       if not FLoops[i].ColdLeg.TC[j].Serviceable then FLoops[i].ColdLeg.TC[j].Note:='СКО ('+FloattoStrF(FLoops[i].ColdLeg.TC[j].Error,ffFixed,3+FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta,ffFixed,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision+3,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+');';
      end;
   end;
 // расчет достоверности по признаку равенству номиналу
 for i:=1 to 4 do
   begin
     for j:=0 to FLoops[i].ColdLeg.Count-1 do
      begin
       FLoops[i].ColdLeg.TC[j].Valid:=True; // сначала считаем что параметр достоверен
       FLoops[i].ColdLeg.TC[j].Valid:=( FLoops[i].ColdLeg.TC[j].CalcValue.Mean<=FLoops[i].ColdLeg.TC[j].CalcParamInfo.NomMax) and (FLoops[i].ColdLeg.TC[j].CalcValue.Mean>=FLoops[i].ColdLeg.TC[j].CalcParamInfo.NomMin);
       if not FLoops[i].ColdLeg.TC[j].Valid then FLoops[i].ColdLeg.TC[j].Note:=FLoops[i].ColdLeg.TC[j].Note+' не соотв. ном.;';
      end;
   end;

//теперь расчет паралельных значений
  for i:=1 to 4 do
   begin
     Sum:=0;
     count:=0;
     for j:=0 to FLoops[i].ColdLeg.Count-1 do
       if FLoops[i].ColdLeg.TC[j].Valid then
        begin
         Sum:=Sum+Floops[i].ColdLeg.TC[j].CalcValue.Mean;
         inc(count);
        end;
     if Count>0 then
      for j:=0 to FLoops[i].ColdLeg.Count-1 do
       begin
        PCh.Value:=Sum/Count;
        PCh.Valid:= ABS(FLoops[i].ColdLeg.TC[j].CalcValue.Mean-FLoops[i].ColdLeg.TC[j].CalcParamInfo.ParallelChannel[1].Value)<=FLoops[i].ColdLeg.TC[j].CalcParamInfo.ParallelChannel[1].Psi;
        FLoops[i].ColdLeg.TC[j].CalcParamInfo.ParallelChannel[1]:=PCh;
        if not PCh.Valid then
        FLoops[i].ColdLeg.TC[j].Valid:=False;
       end;
   end;
 for i:=1 to 4 do
   begin
    Count:=0;
    Sum:=0;
    for j:=0 to FLoops[i].ColdLeg.Count-1 do
      begin
       if FLoops[i].ColdLeg.TC[j].Valid and FLoops[i].ColdLeg.TC[j].Serviceable then
       begin
        Sum:=Sum+FLoops[i].ColdLeg.TC[j].CalcValue.Mean;
        inc(Count);
       end;
       if Count>0 then FLoops[i].ColdLeg.T.CalcValue.Mean:=Sum/Count;
      end;
  end;
  // Расчет средней температуры холодных ниток
  Sum:=0;
  for i:=1 to 4 do
   Sum:=Sum+FLoops[i].ColdLeg.T.CalcValue.Mean;
  FTCold.CalcValue.Mean:=Sum/4;
  //Проверка ТП в КНИТ
  // KNINs
   for i:=0 to CountKNIT-1 do
   begin
   // TP3
     if FKNITs[i].TP3.description.ID<>-1 then
     FKNITs[i].TP3.Error:=Buffer.CalcValues[FKNITs[i].TP3.description.ID].MSE*KStudent(Buffer.LengthBuf);
     FKNITs[i].TP3.Serviceable:=not (FKNITs[i].TP3.Error> FKNITs[i].TP3.CalcParamInfo.Delta);
     if not FKNITs[i].TP3.Serviceable then FKNITs[i].TP3.Note:='СКО ('+FloattoStrF(FKNITs[i].TP3.Error,ffFixed,3+FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta,ffFixed,FKNITs[i].TP3.CalcParamInfo.Precision+3,FKNITs[i].TP3.CalcParamInfo.Precision)+');';

     FKNITs[i].TP3.Valid:=( FKNITs[i].TP3.CalcValue.Mean<=FKNITs[i].TP3.CalcParamInfo.NomMax) and (FKNITs[i].TP3.CalcValue.Mean>=FKNITs[i].TP3.CalcParamInfo.NomMin);
     if not FKNITs[i].TP3.Valid then FKNITs[i].TP3.Note:=FKNITs[i].TP3.Note+' не соотв. ном.;';
     if ABS(FKNITs[i].TP3.CalcValue.Mean-FTCold.CalcValue.Mean)>FKNITs[i].TP3.CalcParamInfo.ParallelChannel[1].Psi then
     FKNITs[i].TP3.Valid:=False;
    //TPB
    if FKNITs[i].TPB.description.ID<>-1 then
     FKNITs[i].TPB.Error:=Buffer.CalcValues[FKNITs[i].TPB.description.ID].MSE*KStudent(Buffer.LengthBuf);
     FKNITs[i].TPB.Serviceable:=not (FKNITs[i].TPB.Error> FKNITs[i].TPB.CalcParamInfo.Delta);
     if not FKNITs[i].TPB.Serviceable then FKNITs[i].TPB.Note:='СКО ('+FloattoStrF(FKNITs[i].TPB.Error,ffFixed,3+FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta,ffFixed,FKNITs[i].TPB.CalcParamInfo.Precision+3,FKNITs[i].TPB.CalcParamInfo.Precision)+');';

     FKNITs[i].TPB.Valid:=( FKNITs[i].TPB.CalcValue.Mean<=FKNITs[i].TPB.CalcParamInfo.NomMax) and (FKNITs[i].TPB.CalcValue.Mean>=FKNITs[i].TPB.CalcParamInfo.NomMin);
     if not FKNITs[i].TPB.Valid then FKNITs[i].TPB.Note:=FKNITs[i].TPB.Note+' не соотв. ном.;';
//     if ABS(FKNITs[i].TPB.CalcValue.Mean-FTCold.CalcValue.Mean)>FKNITs[i].TPB.CalcParamInfo.ParallelChannel[1].Psi then
//     FKNITs[i].TPB.Valid:=False;

    //TPA
     if FKNITs[i].TPA.description.ID<>-1 then
     FKNITs[i].TPA.Error:=Buffer.CalcValues[FKNITs[i].TPA.description.ID].MSE*KStudent(Buffer.LengthBuf);
     FKNITs[i].TPA.Serviceable:=not (FKNITs[i].TPA.Error> FKNITs[i].TPA.CalcParamInfo.Delta);
     if not FKNITs[i].TPA.Serviceable then FKNITs[i].TPA.Note:='СКО ('+FloattoStrF(FKNITs[i].TPA.Error,ffFixed,3+FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta,ffFixed,FKNITs[i].TPA.CalcParamInfo.Precision+3,FKNITs[i].TPA.CalcParamInfo.Precision)+');';

     FKNITs[i].TPA.Valid:=( FKNITs[i].TPA.CalcValue.Mean<=FKNITs[i].TPA.CalcParamInfo.NomMax) and (FKNITs[i].TPA.CalcValue.Mean>=FKNITs[i].TPA.CalcParamInfo.NomMin);
     if not FKNITs[i].TPA.Valid then FKNITs[i].TPA.Note:=FKNITs[i].TPA.Note+' не соотв. ном.;';
//     if ABS(FKNITs[i].TPA.CalcValue.Mean-FTCold.CalcValue.Mean)>FKNITs[i].TPA.CalcParamInfo.ParallelChannel[1].Psi then
//     FKNITs[i].TPA.Valid:=False;
    //TC
    if FKNITs[i].TC.description.ID<>-1 then
     FKNITs[i].TC.Error:=Buffer.CalcValues[FKNITs[i].TC.description.ID].MSE*KStudent(Buffer.LengthBuf);
     FKNITs[i].TC.Serviceable:=not (FKNITs[i].TC.Error> FKNITs[i].TC.CalcParamInfo.Delta);
     if not FKNITs[i].TC.Serviceable then FKNITs[i].TC.Note:='СКО ('+FloattoStrF(FKNITs[i].TC.Error,ffFixed,3+FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision ,FLoops[i].ColdLeg.TC[j].CalcParamInfo.Precision)+')больше допустимого дельта('+FLoattoSTrF(FLoops[i].ColdLeg.TC[j].CalcParamInfo.Delta,ffFixed,FKNITs[i].TC.CalcParamInfo.Precision+3,FKNITs[i].TC.CalcParamInfo.Precision)+');';

     FKNITs[i].TC.Valid:=( FKNITs[i].TC.CalcValue.Mean<=FKNITs[i].TC.CalcParamInfo.NomMax) and (FKNITs[i].TC.CalcValue.Mean>=FKNITs[i].TC.CalcParamInfo.NomMin);
     if not FKNITs[i].TC.Valid then FKNITs[i].TC.Note:=FKNITs[i].TC.Note+' не соотв. ном.;';

   end;

end;

constructor TTC.Create(LoopIni:TIniFile;KNITIni:TIniFile);
var i,j,XX,YY:integer;
    CoordTVS:string;
begin
 inherited Create;
 for i:=1 to 4 do
 FLoops[i]:=TLoop.Create;
 FCountKNITs:=0;
 with LoopIni do
 begin
 //------------------Hot Leg ----------------------------------
  FLoops[1].HotLeg.Count:= ReadInteger('HotLeg','CountSens',6);
  for i:=2 to 4 do
   FLoops[i].HotLeg.Count:=Floops[1].HotLeg.Count;
  for i:=1 to 4 do
   for j:=1 to FLoops[i].HotLeg.Count do
    begin
    FLoops[i].HotLeg.TC[j-1].Description.KKS:=ReadString('HotLeg','Loop'+IntToStr(i)+'Sens'+IntToStr(j),'');
    FLoops[i].HotLeg.TC[j-1].Description.Name:='Гор. нитка петли №'+intToStr(i);
    FLoops[i].HotLeg.TC[j-1].Description.MUnit:='гр. Цельсия';
    end;
 //------------------Cold Leg ----------------------------------
  FLoops[1].ColdLeg.Count:= ReadInteger('ColdLeg','CountSens',6);
  for i:=2 to 4 do
   FLoops[i].ColdLeg.Count:=Floops[1].ColdLeg.Count;
  for i:=1 to 4 do
   for j:=1 to FLoops[i].ColdLeg.Count do
    begin
    FLoops[i].ColdLeg.TC[j-1].Description.KKS:=ReadString('ColdLeg','Loop'+IntToStr(i)+'Sens'+IntToStr(j),'');
    FLoops[i].ColdLeg.TC[j-1].Description.Name:='Хол. нитка петли №'+intToStr(i);
    FLoops[i].ColdLeg.TC[j-1].Description.MUnit:='гр. Цельсия';
    end;
 end;
 with KNITIni do
 begin
  CountKNIT:=ReadInteger('KNIT','Count',50);
  for i:=1 to 50 do
    begin
      FKNITs[i-1].TP3.Description.KKS:=ReadString(IntToStr(i),'TP3','');
      FKNITs[i-1].TPA.Description.KKS:=ReadString(IntToStr(i),'TPA','');
      FKNITs[i-1].TPB.Description.KKS:=ReadString(IntToStr(i),'TPB','');
      FKNITs[i-1].TC.Description.KKS:=ReadString(IntToStr(i),'TC','');
      CoordTVS:=ReadString(IntToStr(i),'CoordTVS','');
      XX:=StrToInt(copy(CoordTVS,1,2));
      YY:=StrToInt(copy(CoordTVS,4,2));
      FKNITs[i-1].NTVS:=GetIndexTVS(XX,YY);
    end;
 end;
 FTCold:=TParam.Create;
end;

destructor TTC.Destroy;
var i:integer;
begin
 for i:=1 to 4 do
  FLoops[i].Destroy;
 inherited Destroy;
end;

function TTC.GetKNIT(i: integer): TKNIT;
begin
 Result:=FKNITS[i];
end;

function TTC.GetLoops(i: integer): TLoop;
begin
 Result:=FLoops[i];
end;

function TTC.GetTCold: TParam;
begin
 Result:=FTCold;
end;

procedure TTC.LinkBuffer(Buffer: TBuffer);
var i,j,k:integer;
begin
///------------ Hot Leg ---------------------
 for i:=1 to 4 do
 begin
  for j:=0 to FLoops[i].HotLeg.Count-1 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FLoops[i].HotLeg.TC[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FLoops[i].HotLeg.TC[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FLoops[i].HotLeg.TC[j].Description.ID:=k;// ссылка на элемент в буфере
      FLoops[i].HotLeg.TC[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
 end;
///------------ Cold Leg ---------------------
 for i:=1 to 4 do
 begin
  for j:=0 to FLoops[i].ColdLeg.Count-1 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FLoops[i].ColdLeg.TC[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FLoops[i].ColdLeg.TC[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FLoops[i].ColdLeg.TC[j].Description.ID:=k;// ссылка на элемент в буфере
      FLoops[i].ColdLeg.TC[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
 end;
///------------ KNITs ---------------------
 for i:=0 to FCountKNIT-1 do
  begin
  //----------- TP3------------------
    k:=0;
    while (k<Buffer.CountParam) and
    (FKNITs[i].TP3.Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FKNITs[i].TP3.Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FKNITs[i].TP3.Description.ID:=k;// ссылка на элемент в буфере
      FKNITs[i].TP3.CalcValue:=Buffer.CalcValues[k];
     end;
  //----------- TP-1A------------------
    k:=0;
    while (k<Buffer.CountParam) and
    (FKNITs[i].TPA.Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FKNITs[i].TPA.Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FKNITs[i].TPA.Description.ID:=k;// ссылка на элемент в буфере
      FKNITs[i].TPA.CalcValue:=Buffer.CalcValues[k];
     end;
  //----------- TP-1B------------------
    k:=0;
    while (k<Buffer.CountParam) and
    (FKNITs[i].TPB.Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FKNITs[i].TPB.Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FKNITs[i].TPB.Description.ID:=k;// ссылка на элемент в буфере
      FKNITs[i].TPB.CalcValue:=Buffer.CalcValues[k];
     end;
  //----------- TC------------------
    k:=0;
    while (k<Buffer.CountParam) and
    (FKNITs[i].TC.Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FKNITs[i].TC.Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FKNITs[i].TC.Description.ID:=k;// ссылка на элемент в буфере
      FKNITs[i].TC.CalcValue:=Buffer.CalcValues[k];
     end;

  end;
end;

procedure TTC.LinkCalcInfo(IniFile: TIniFile);
begin

end;

procedure TTC.SetCountKNIT(const Value: integer);
var i:integer;
begin
  FCountKNIT := Value;
  SetLength(FKNITs,FCountKNIT);
  for i:=0 to FCountKNIT-1 do
  FKNITs[i]:=TKNIT.Create;
end;

procedure TTC.SetKNIT(i: integer; const Value: TKNIT);
begin
 FKNITs[i]:=Value;
end;

procedure TTC.SetLoops(i: integer; const Value: TLoop);
begin
 FLoops[i]:=Value;
end;

procedure TTC.SetTCold(const Value: TParam);
begin

end;

end.
