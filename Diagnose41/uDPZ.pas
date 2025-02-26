unit uDPZ;
//----------------------------------------------------------------------------------------
// �������� ������ TIDPZ - ��������� ���
//
// �����: ��������� �.�. semenikhinav@mail.ru
// ���� ��������: 15.10.2015
//----------------------------------------------------------------------------------------

interface

uses uGenTech, uBuffer,IniFiles,SysUtils,uStringOperation, uSrvCoreTVS, uCalcParam, uKStudent;

type TSVRD = class(TObject)
             private
              FDPZ:array [1..7] of TParam;
          //    FQED:array [1..7] of TParam;
              FNTVS:integer;
    function GetDPZ(i: integer): TParam;
    procedure SetDPZ(i: integer; const Value: TParam);
  //  function GetQED(i: integer): TParam;
  //  procedure SetQED(i: integer; const Value: TParam);
             protected

             public
               property DPZ[i:integer]:TParam read GetDPZ write SetDPZ;
           //    property QED[i:integer]:TParam read GetQED write SetQED;

               property NTVS:integer read FNTVS write FNTVS;

               constructor Create;
               destructor Destroy;
             published 

             end;


type TIDPZ = class(TObject)
    private
      FSVRD:array [1..54]of TSVRD;
      FK1NED:TParam;
      FSrvCoreTVS:TSrvCoreTVS;
    function GetSVRD(i: integer): TSVRD;
    procedure SetSVRD(i: integer; const Value: TSVRD);
    protected

    public
      property SVRD[i:integer]:TSVRD read GetSVRD write SetSVRD;
      property K1NED:TParam read FK1NED write FK1NED;
      procedure LinkBuffer(Buffer:TBuffer);
      procedure Calc_Power(KN:double;Buffer:TBuffer);//���� �� ���� ������� �� ��, �� ����� ���� �� � ���� ��������  

      constructor Create(DPZIni:TIniFile);
      destructor Destroy;
    published

    end;

implementation

{ TSVRD }

constructor TSVRD.Create;
var i:integer;
begin
 inherited Create;
 for i:=1 to 7 do
  FDPZ[i]:=TParam.Create;
end;

destructor TSVRD.Destroy;
var i:integer;
begin
 for i:=1 to 7 do
  FDPZ[i].Destroy;
 inherited Destroy; 
end;

function TSVRD.GetDPZ(i: integer): TParam;
begin
 Result:=FDPZ[i];
end;
{

function TSVRD.GetQED(i: integer): TParam;
begin
Result:=FQED[i];
end;
 }
procedure TSVRD.SetDPZ(i: integer; const Value: TParam);
begin
 FDPZ[i]:=Value;
end;
  {
procedure TSVRD.SetQED(i: integer; const Value: TParam);
begin
 FQED[i]:=Value;
end;
   }
{ TIDPZ }

procedure TIDPZ.Calc_Power(KN: double; Buffer: TBuffer);
var KZj:array[1..7] of double;
    Sumj:array[1..7] of double;
    Sum:double;
    i,j,k:integer;
    KOk:array[1..19] of double;
    Sumk:array [1..19] of double;
    AverIOrb:array[1..19]of array[1..7] of double;
    CountOrb:array[1..19]of array[1..7] of integer;
begin
//������� ��������� ��������� KZj - ����������� �������������� �������� ���� ��� � ���� �[1..7]
 Sum:=0;
 for i:=1 to 7 do
  for j:=1 to 54 do
  begin
   if FSVRD[j].DPZ[i].CalcValue.Mean<>-1 then
   Sum:=Sum+FSVRD[j].DPZ[i].CalcValue.Mean;
 end;
 for i:=1 to 7 do
 begin
  KZj[i]:=0;
  Sumj[i]:=0;
  for j:=1 to 54 do
  begin
   if FSVRD[j].DPZ[i].CalcValue.Mean<>-1 then
   Sumj[i]:=Sumj[i]+FSVRD[j].DPZ[i].CalcValue.Mean;
  end;
  if sum>0 then
  KZj[i]:=Sumj[i]/Sum;
 end;
 //  ��������� ��������� KOk - ����������� �������������� �������� ���� ��� � ������ ��������� �[1..19]
 for i:=1 to 7 do
  for k:=1 to 19 do
   begin
    AverIOrb[k][i]:=0;
    CountOrb[k][i]:=0;
   end;
 for i:=1 to 7 do
 begin
  for j:=1 to 54 do
   begin
    for k:=1 to 19 do
     if FSrvCoreTVS.SearchByNTVS(FSVRD[j].NTVS).NOrb=k then
      if FSVRD[j].DPZ[i].CalcValue.Mean<>-1 then
        begin
         AverIOrb[k][i]:=AverIOrb[k][i]+FSVRD[j].DPZ[i].CalcValue.Mean;
         inc(CountOrb[k][i]);
        end;
   end;
 end;
 for i:=1 to 7 do
   for k:=1 to 19 do
    if CountOrb[k][i]>0 then
      AverIOrb[k][i]:=AverIOrb[k][i]/CountOrb[k][i];
//
 for k:=1 to 19 do
  begin
   Sumk[k]:=0;
   for i:=1 to 7 do
    Sumk[k]:=Sumk[k]+AverIOrb[k][i];
  end;
 for k:=1 to 19 do
  if sum>0 then
  KOk[k]:=Sumk[k]/Sum;
 //������ ������ ��������� ��������
//--- ���������� CalcInfo

  for j:=1 to 54 do
   for i:=1 to 7 do
      begin
        FSVRD[j].DPZ[i].CalcParamInfo:=TOneCalcParam.Create;
        FSVRD[j].DPZ[i].CalcParamInfo.NomMax:=2.12*KN*KZj[i]*KOk[FSrvCoreTVS.Item[FSVRD[j].NTVS].NOrb];
        FSVRD[j].DPZ[i].CalcParamInfo.Delta:=0.005;
      end;
//������ ���������� �������� �� �����������������
//
 // �� �������� ��� ������ ���������� ������
  for j:=1 to 54 do
   for i:=1 to 7 do
      begin
       if FSVRD[j].DPZ[i].description.ID<>-1 then
       FSVRD[j].DPZ[i].Error:= Buffer.CalcValues[FSVRD[j].DPZ[i].description.ID].MSE*KStudent(Buffer.LengthBuf);
       FSVRD[j].DPZ[i].Serviceable:=not (FSVRD[j].DPZ[i].Error> FSVRD[j].DPZ[i].CalcParamInfo.Delta);
       if not FSVRD[j].DPZ[i].Serviceable then FSVRD[j].DPZ[i].Note:='��� ('+FloattoStrF(FSVRD[j].DPZ[i].Error,ffFixed,3+FSVRD[j].DPZ[i].CalcParamInfo.Precision ,FSVRD[j].DPZ[i].CalcParamInfo.Precision)+') ������ ����������� ������('+FLoattoSTrF(FSVRD[j].DPZ[i].CalcParamInfo.Delta,ffFixed,FSVRD[j].DPZ[i].CalcParamInfo.Precision+3,FSVRD[j].DPZ[i].CalcParamInfo.Precision)+');';
      end;
 // ������ ������������� �� �������� ��������� ��������
  for j:=1 to 54 do
   for i:=1 to 7 do
      begin
        FSVRD[j].DPZ[i].Valid:=True; // ������� ������� ��� �������� ����������
         FSVRD[j].DPZ[i].Valid:=( FSVRD[j].DPZ[i].CalcValue.Mean<=FSVRD[j].DPZ[i].CalcParamInfo.NomMax);
         if not FSVRD[j].DPZ[i].Valid then FSVRD[j].DPZ[i].Note:=FSVRD[j].DPZ[i].Note+' �� �����. ���.;';
      end;
end;

constructor TIDPZ.Create(DPZIni:TIniFile);
var i,j:integer;
begin
 inherited Create;
 for i:=1 to 54 do
  FSVRD[i]:=TSVRD.Create;
  // �������� �� INI �����
   with DPZIni do
 begin
 //------------------I DPZ ----------------------------------
 for i:=1 to 54 do
  for j:=1 to 7 do
   begin
    FSVRD[i].DPZ[j].Description.KKS:=ReadString('DPZ','SVRD'+NumberToStr(i)+'_Level'+IntToStr(j),'');
    FSVRD[i].DPZ[j].Description.Name:='��� ��� � ���� '+intToStr(i)+' � ���� '+IntToStr(j);
    FSVRD[i].DPZ[j].Description.MUnit:='���';
    end;
 //------------------I DPZ ----------------------------------
{ for i:=1 to 54 do
  for j:=1 to 7 do
   begin
    FSVRD[i].QED[j].Description.KKS:=ReadString('QED','SVRD'+NumberToStr(i)+'_Level'+IntToStr(j),'');
    FSVRD[i].QED[j].Description.Name:='QED � ���� '+intToStr(i)+' � ���� '+IntToStr(j);
    FSVRD[i].QED[j].Description.MUnit:='���/�';
    end;
 }
 end;
 FSrvCoreTVS:=TSrvCoreTVS.Create;
 FSrvCoreTVS.LoadFromMunit(DPZIni.ReadString('SrvCoreTVS','FileName','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose3\Res\SrvCoreTvs.idb' ));

 FK1NED:=TParam.Create;
 FK1NED.Description.KKS:='K1NED';
 FK1NED.Description.Name:='������������� �����������, ������������ ������� ��������������� � ������ ������������ ���'

end;

destructor TIDPZ.Destroy;
var i:integer;
begin
 for i:=1 to 54 do
  FSVRD[i].Destroy;
 inherited destroy;
end;

function TIDPZ.GetSVRD(i: integer): TSVRD;
begin
 Result:=FSVRD[i];
end;

procedure TIDPZ.LinkBuffer(Buffer: TBuffer);
var i,j,k:integer;
begin
///------------I DPZ  ---------------------
 for i:=1 to 54 do
 begin
  for j:=1 to 7 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FSVRD[i].DPZ[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FSVRD[i].DPZ[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FSVRD[i].DPZ[j].Description.ID:=k;// ������ �� ������� � ������
      FSVRD[i].DPZ[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
 end;
///------------QED  ---------------------
{
 for i:=1 to 54 do
 begin
  for j:=1 to 7 do
   begin
    k:=0;
    while (k<Buffer.CountParam) and
    (FSVRD[i].QED[j].Description.KKS<>Buffer.CalcValues[k].KKS )do
    inc(k);
    if k<Buffer.CountParam then
    if FSVRD[i].QED[j].Description.KKS=Buffer.CalcValues[k].KKS then
     begin
      FSVRD[i].QED[j].Description.ID:=k;// ������ �� ������� � ������
      FSVRD[i].QED[j].CalcValue:=Buffer.CalcValues[k];
     end;
   end;
 end;
 }
end;

procedure TIDPZ.SetSVRD(i: integer; const Value: TSVRD);
begin
 FSVRD[i]:=Value;
end;

end.
