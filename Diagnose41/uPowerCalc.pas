unit uPowerCalc;
//========================================================
// Author: Semenikhin Alexander, ATE
// 20.09.2007
// Types description for Power calculation
//========================================================

interface
uses uStringOperation,SysUtils,matrices,uDLL,uCalcParamInfo;

const TKelvin0=273.15;
      Pabs=0.1;
      PMPA=1000000;
      g=9.81;

type TPhysValue =record
  Value:double;
  Error:double;
  Status:byte;
  end;
const NullPhysValue:TPhysValue=(Value:0;Error:0;Status:1);

type PPhysValue = ^TPhysValue;
type
 TF = record
  Value,  A,B,C,deltaP,KGS,Error:double;
  end;

const NullF:TF=(Value:0;A:0;B:0;C:0;deltaP:0; KGS:0;Error:0);

type
TN1Loop = record
 N:TPhysValue;
 Tcold,THot:TPhysValue;
 dP:TPhysValue;
 F:TF;
 Ro:TPhysValue;
 hcold,hhot:TPhysValue;
 H0:TPhysValue;
 freq:TPhysValue;
 end;

procedure NullN1Loop(var N1Loop:TN1Loop);

type TN1 = record
  Value:TPhysValue;
  Omega:double;
  W:double;
  P,dP:TPhysValue;
  Loops:array [1..4] of TN1Loop;
  Status:byte;
  end;

procedure NullN1(var N1:TN1);


// --- RCP
procedure LoadRCPCharacteristics(var N1:TN1; FileName:string);
procedure LoadABC(var N1:TN1; FileName:string);
type TRCPCharac=array of array[0..1] of Double;

procedure CalcABC (var X0,X1,X2,Error :double;RCPCharac:TRCPCharac);

procedure CalcN1(var N1:TN1;Qlosses:double;S:double);


// second circle
type
TN2Loop = record
 N:TPhysValue;
 W:TPhysValue;
 Ffw:TPhysValue;
 Gst:TPhysValue;
 Pst:TPhysValue;
 Tfw:TPhysValue;
 Pfw:TPhysValue;
 Fcoun,Fperd:TPhysValue;
 Fprod:TPhysValue;
 Fkarm:TPhysValue;
 Fdn:TPhysValue;
 Fso:TPhysValue;
 GLCQ:TPhysValue;
 hwater,hst,hfw:TPhysValue;
 Qppg:TPhysValue;
 Qpg:TPhysValue;
 end;

procedure NullN2Loop(var N2Loop:TN2Loop);

type TN2 = record
  Value:TPhysValue;
  Omega:double;
  W:double;
  QLCQ:double;
  QRCP:double;
  QRCPi:array [1..4] of double;
  GLCQ:TPhysValue;
  Loops:array [1..4] of TN2Loop;
  Status:byte;
  NConst:double;//поправка для значения мощности по второму контуру
  end;
procedure NullN2(var N2:TN2);
procedure CalcN2(var N2:TN2;N1:TN1; Qlosses:double;Rotarrir:double);

// ------ Power of PVD ----------

type TNpvd = record
  Value:TPhysValue;
  Omega:double;
  W:double;
  Qst:double;
  Gkgtn:TPhysValue;
  Pkgtn:TPhysValue;
  Tkgtn:TPhysValue;
  Gjnb:array [1..4] of TPhysValue;
  Pjnb:array [1..4] of TPhysValue;
  Tjnb:array [1..4] of TPhysValue;
  Gpvd:array [1..2] of TPhysValue;
  Ppvd:array [1..2] of TPhysValue;
  Tpvd:array [1..2] of TPhysValue;
  Hpvd:array [1..2] of TPhysValue;
  Hjnb:array [1..4] of TPhysValue;
  Hkgtn:TPhysValue;
 end;

procedure NullNpvd (var Npvd:TNpvd);

procedure CalcNpvd(var Npvd:TNpvd;N2:TN2;N1:TN1; Qlosses:double);

type TNAKNP=record
  Value:TPhysValue;
  Channels:Array [1..8] of TPhysValue;
  end;

procedure NullNAKNP(var NAKNP:TNAKNP);

type TNDPZ=record
  Value:TPhysValue;
  QED:array[1..54]of array[1..7] of TPhysValue;
  KDPZ:TPhysValue;
  end;

//  stopped here!!!
//-----------Общая мощность--------------
Type TN =record
  Value:TPhysValue;
  N1:TN1;
  N2:TN2;
  Npvd:TNpvd;
  NDPZ:TPhysValue;
  NAKNP:TNAKNP;
  OmegaDPZ,WDPZ:double;
  NNFME:TPhysValue;
  OmegaNFME,WNFME:double;
  Qlosses:double;
  RoTarrir:double;
  S:double;
  KSPND:double;
  QRCP:double;
  end;

procedure NullN(var N:TN);
Procedure CalcOmega(Var N:TN);
Procedure CalcNaver(Var N:TN;Wtool:integer;Wmrse:integer);

type st=string[3];//} array [1..3] of char;

const SensCode:array [0..64] of st=('PC1',	'PC2',	'PR1',	'PR2',	'PR3',	'PR4',	'FR1',	'FR2',	'FR3',	'FR4',	'GF1',	'GF2',	'GF3',	'GF4',	'PS1',	'PS2',	'PS3',	'PS4',	'TF1',	'TF2',	'TF3',	'TF4',	'PF1',	'PF2',	'PF3',	'PF4',	'BC1',	'BC2',	'BC3',	'BC4',	'BP1',	'BP2',	'BP3',	'BP4',	'NC1',	'NC2',	'TH1',	'TC1',	'TH2',	'TC2',	'TH3',	'TC3',	'TH4',	'TC4', 'GK1',	'PK1',	'TK1',	'GJ1',	'GJ2',	'GJ3',	'GJ4',	'PJ1',	'PJ2',	'PJ3',	'PJ4',	'TJ1',	'TJ2','TJ3', 'TJ4',	'GV1',	'GV2',	'PV1',	'PV2',	'TV1',	'TV2');
type TSensorsLinks =array [0..64] of PPhysValue;
procedure Link(var SensorsLinks:TSensorsLinks;var N:TN);
function CalcNNFME(NNFME:double):double;
function CalcNSPND(N:TN):double;

procedure CopySensorsInfoToSensorsLinks(var SensorsInfo:TSensorsInfo; var SensorsLinks:TSensorsLinks);


implementation

procedure NullN1Loop(var N1Loop:TN1Loop);
begin
  with N1Loop do
  begin
   F:=NullF;
   Ro:=NullPhysValue;
   dP:=NullPhysValue;
   hcold:=NullPhysValue;
   hhot:=NullPhysValue;
   H0:=NullPhysValue;
   freq:=NullPhysValue;
  end;
end;

procedure NullN1(var N1:TN1);
var i:integer;
begin
 N1.Value:=NUllPhysValue;
 N1.P:=NUllPhysValue;
 N1.dP:=NUllPhysValue;
 N1.Omega:=0;
 N1.W:=0;

 for i:=1 to 4 do NullN1Loop(N1.Loops[i]);
end;

procedure NullNpvd (var Npvd:TNpvd);
var i:integer;
begin
 with Npvd do
 begin
  Value:=NullPhysValue;
  Omega:=0;
  W:=0;
  Gkgtn:=NullPhysValue;
  Pkgtn:=NullPhysValue;
  Tkgtn:=NullPhysValue;
  for i:=1 to 4 do
   begin
    Gjnb[i]:=NullPhysValue;
    Pjnb[i]:=NullPhysValue;
    Tjnb[i]:=NullPhysValue;
   end;
   for i:=1 to 2 do
   begin
    Gpvd[i]:=NullPhysValue;
    Ppvd[i]:=NullPhysValue;
    Tpvd[i]:=NullPhysValue;
   end;
 end;
end;

procedure LoadRCPCharacteristics(var N1:TN1; FileName:string);
var i,j:integer;
    Txt:TextFile;
    s,SubStr:string;
    Data:TRCPCharac;
    Enough:boolean;
begin
  Assign(txt,FileName);
  Reset(txt);
  s:='';
  Readln(Txt,s);

  for i:=1 to 4 do
  begin
  Readln(Txt,s);
  GetFirstSubStr(SubStr,s,#9);
  if SubStr='DP' then
   begin
    GetFirstSubStr(SubStr,s,#9);
    N1.Loops[i].F.deltaP:=StrToFloat(SubStr);
   end;

  Readln(Txt,s);
  GetFirstSubStr(SubStr,s,#9);
  if SubStr='KGS' then
   begin
    GetFirstSubStr(SubStr,s,#9);
    N1.Loops[i].F.KGS:=StrToFloat(SubStr);
   end;
  j:=0;
  Enough:=False;
  SetLength( Data,0);

  while (not EOF(Txt) ) and (not  Enough) do
  begin
   ReadLn(Txt,s);
   if (Pos('RCP',s)<>1) then
   begin
   SetLength( Data,Length(Data)+1);
   GetFirstSubStr(Substr,s,#9);
   Data[j][0]:=StrToFloat(SubStr);
   Data[j][1]:=StrToFloat(S);
   inc(j);
   end
   else Enough:=True;
  end;
    CalcABC(N1.Loops[i].F.A,N1.Loops[i].F.B,N1.Loops[i].F.C,N1.Loops[i].F.Error,Data);

 end;

end;
procedure CalcABC (var X0,X1,X2,Error :double;RCPCharac:TRCPCharac);
var j,k,ErrorCode,Count:integer;
   A,A_inv:TMatrix;
   X,B:TVector;
   Sum,Sum2,Sum3,Sum4,SumB,SumB2,SumB3:double;
   Det,temp,delta:double;
begin
 Count:=Length(RCPCharac);
 DimVector(X,2);
 DimVector(B,2);
 DimMatrix(A,2,2);
 DimMatrix(A_inv,2,2);
// matrix A we prepary Now:
   Sum:=0;
   Sum2:=0;
   Sum3:=0;
   Sum4:=0;

 for k:=0 to Count-1 do
   begin
   Sum:=Sum+ RCPCharac[k][1];
   Sum2:=Sum2+RCPCharac[k][1]*RCPCharac[k][1];
   Sum3:=Sum3+RCPCharac[k][1]*RCPCharac[k][1]*RCPCharac[k][1];
   Sum4:=Sum4+RCPCharac[k][1]*RCPCharac[k][1]*RCPCharac[k][1]*RCPCharac[k][1];
   end;
 A[0,0]:=Count;     A[0,1]:=Sum;    A[0,2]:=Sum2;
 A[1,0]:=Sum;   A[1,1]:=Sum2;   A[1,2]:=Sum3;
 A[2,0]:=Sum2;  A[2,1]:=Sum3;   A[2,2]:=Sum4;

   SumB:=0;
   SumB2:=0;
   SumB3:=0;
   for k:=0 to Count-1 do
   begin
   SumB:=SumB+ RCPCharac[k][0];
   SumB2:=SumB2+RCPCharac[k][0]*RCPCharac[k][1];
   SumB3:=SumB3+RCPCharac[k][0]*RCPCharac[k][1]*RCPCharac[k][1];
   end;
   B[0]:=SumB;
   B[1]:=SumB2;
   B[2]:=SumB3;
   ErrorCode:=GaussJordan(A,B,0,2,A_inv,X,Det);
   if ErrorCode=MAT_OK then
   begin
   X0:=X[0];
   X1:=X[1];
   X2:=X[2];
   end;
  // calc Error
  temp:=0;
  Delta:=0;
   for k:=0 to Count-1 do
   begin
    Temp:=X0+X1*RCPCharac[k][1]+X2*RCPCharac[k][1]*RCPCharac[k][1] - RCPCharac[k][0];
   delta:=delta+Temp*Temp;
   end;
   if Count>1 then
   Error:=SQRT( Delta/ (Count-1));

end;

procedure CalcN1(var N1:TN1;Qlosses:double;S:double);
var i:integer;
   temp:double;
begin
for i:=1 to 4 do
 begin
  N1.Loops[i].hcold.Value:=wspHPT(PMPA*(N1.P.Value+N1.dP.Value+Pabs),N1.Loops[i].Tcold.Value+TKelvin0);
  N1.Loops[i].hhot.Value:=wspHPT(PMPA*(N1.P.Value+Pabs),N1.Loops[i].Thot.Value+TKelvin0);
  N1.Loops[i].Ro.Value:=1/wspVPT(PMPA*(N1.P.Value+N1.dP.Value+Pabs),N1.Loops[i].Tcold.Value+TKelvin0);
  N1.Loops[i].H0.Value :=(1E6)*(N1.Loops[i].dP.Value+N1.Loops[i].F.deltaP)/(g*N1.Loops[i].Ro.Value);
  case (N1.Loops[i].Tcold.Value> N1.Loops[i].THot.Value) of
  False:
    if (N1.Loops[i].freq.Value>0) and (N1.Loops[i].Ro.Value>0) then
    N1.Loops[i].F.Value:=N1.Loops[i].F.A*N1.Loops[i].freq.Value/50+    {Check formila f/50}
                         N1.Loops[i].F.B*N1.Loops[i].H0.Value*50/N1.Loops[i].freq.Value+
                         N1.Loops[i].F.C*N1.Loops[i].H0.Value*N1.Loops[i].H0.Value*50*50*50/(N1.Loops[i].freq.Value*N1.Loops[i].freq.Value*N1.Loops[i].freq.Value);
  True:
      if (N1.Loops[i].Ro.Value>0) then
    N1.Loops[i].F.Value:=-3.6*(1E6)*S*SQRT( 2* N1.Loops[i].dP.Value/(N1.Loops[i].F.KGS*N1.Loops[i].Ro.Value ));
  end;

 N1.Loops[i].N.Value:=(1E-9)*N1.Loops[i].F.Value*N1.Loops[i].Ro.Value*(N1.Loops[i].hhot.Value-N1.Loops[i].hcold.Value)/3.6+0.125*QLosses;
 // Error
 N1.Loops[i].Ro.Error:=0.5*(1/wspVPT(PMPA*(N1.P.Value+N1.dP.Value+Pabs),N1.Loops[i].Tcold.Value-N1.Loops[i].Tcold.Error+TKelvin0)-
                       1/wspVPT(PMPA*(N1.P.Value+N1.dP.Value+Pabs),N1.Loops[i].Tcold.Value+N1.Loops[i].Tcold.Error+TKelvin0));

 N1.Loops[i].H0.Error:=N1.Loops[i].H0.Value*SQRT(  (N1.Loops[i].Ro.Error*N1.Loops[i].Ro.Error)/(N1.Loops[i].Ro.Value*N1.Loops[i].Ro.Value)+
                      N1.Loops[i].dP.Error*N1.Loops[i].dP.Error/(N1.Loops[i].dP.Value*N1.Loops[i].dP.Value));
  case (N1.Loops[i].Tcold.Value> N1.Loops[i].THot.Value) of
  False:  // LOOP ON
     N1.Loops[i].F.Error:=SQRT( (4*N1.Loops[i].F.Error*N1.Loops[i].F.Error +(N1.Loops[i].F.B+2*N1.Loops[i].F.C*N1.Loops[i].H0.Value)*N1.Loops[i].H0.Error*(N1.Loops[i].F.B+2*N1.Loops[i].F.C*N1.Loops[i].H0.Value)*N1.Loops[i].H0.Error));
  True:  //LOOP OFF
     N1.Loops[i].F.Error:=1.8*(1E6)*S*SQRT(2*N1.loops[i].dP.Error*N1.loops[i].dP.Error/(N1.loops[i].F.KGS*N1.loops[i].dP.Value*N1.loops[i].Ro.Value )
     + 2*N1.loops[i].Ro.Error*N1.loops[i].Ro.Error*N1.loops[i].dP.Value/(N1.loops[i].F.KGS*N1.loops[i].Ro.Value*N1.loops[i].Ro.Value*N1.loops[i].Ro.Value ));
  end;

 N1.Loops[i].hhot.Error:=0.5*(wspHPT(PMPA*(N1.P.Value+Pabs ),N1.Loops[i].THot.Value+N1.Loops[i].THot.Error+TKelvin0) -
                         wspHPT(PMPA*(N1.P.Value+Pabs ),N1.Loops[i].THot.Value-N1.Loops[i].THot.Error+TKelvin0));
 N1.Loops[i].hcold.Error:=0.5*(wspHPT(PMPA*(N1.P.Value+Pabs+N1.dP.Value ),N1.Loops[i].Tcold.Value+N1.Loops[i].Tcold.Error+TKelvin0) -
                         wspHPT(PMPA*(N1.P.Value+Pabs +N1.dP.Value),N1.Loops[i].Tcold.Value-N1.Loops[i].Tcold.Error+TKelvin0));
 // carrifull calculation (step by ster)
 if N1.Loops[i].F.Value<>0 then
 temp:=N1.Loops[i].F.Error*N1.Loops[i].F.Error/(N1.Loops[i].F.Value*N1.Loops[i].F.Value);
 if N1.Loops[i].Ro.Value<>0 then
 temp:=Temp+N1.Loops[i].Ro.Error*N1.Loops[i].Ro.Error/(N1.Loops[i].Ro.Value*N1.Loops[i].Ro.Value);
 if (N1.Loops[i].hhot.Value - N1.Loops[i].hcold.Value)*(N1.Loops[i].hhot.Value - N1.Loops[i].hcold.Value)<>0 then
 temp:=Temp+( N1.Loops[i].hhot.Error*N1.Loops[i].hhot.Error+ N1.Loops[i].hcold.Error*N1.Loops[i].hcold.Error )
 / (  (N1.Loops[i].hhot.Value - N1.Loops[i].hcold.Value)*(N1.Loops[i].hhot.Value - N1.Loops[i].hcold.Value) );

  N1.Loops[i].N.Error:=N1.Loops[i].N.Value*SQRT(temp );
  
 end;
 temp:=0;
 N1.Value.Error:=0;
 for i:=1 to 4 do
  begin
  Temp:=Temp+N1.Loops[i].F.Value*N1.Loops[i].Ro.Value*(N1.Loops[i].hhot.Value-N1.Loops[i].hcold.Value);
  N1.Value.Error:=N1.Value.Error+N1.Loops[i].N.Error*N1.Loops[i].N.Error;
  end;
  N1.Value.Value:=(1E-9)*temp/3.6+0.5*Qlosses;

  N1.Value.Error:=SQRT(N1.Value.Error);

end;

procedure Link(var SensorsLinks:TSensorsLinks;var N:TN);
var i:integer;
begin
 //const TSensCode:array [0..64] of st=('PC1',	'PC2',	'PR1',	'PR2',	'PR3',	'PR4',	'FR1',	'FR2',	'FR3',	'FR4',	'GF1',	'GF2',	'GF3',	'GF4',	'PS1',	'PS2',	'PS3',	'PS4',	'TF1',	'TF2',	'TF3',	'TF4',	'PF1',	'PF2',	'PF3',	'PF4',	'BC1',	'BC2',	'BC3',	'BC4',	'BP1',	'BP2',	'BP3',	'BP4',	'NC1',	'NC2',	'TH1',	'TC1',	'TH2',	'TC2',	'TH3',	'TC3',	'TH4',	'TC4','GK1',	'PK1',	'TK1',	'GJ1',	'GJ2',	'GJ3',	'GJ4',	'PJ1',	'PJ2',	'PJ3',	'PJ4',	'TJ1',	'TJ2','TJ3', 'TJ4',	'GV1',	'GV2',	'PV1',	'PV2',	'TV1',	'TV2');
SensorsLinks[0]:=@N.N1.P;
SensorsLinks[1]:=@N.N1.dP;
for i:=1 to 4 do
SensorsLinks[1+i]:=@N.N1.Loops[i].DP;
for i:=1 to 4 do
SensorsLinks[5+i]:=@N.N1.Loops[i].freq;
for i:=1 to 4 do
SensorsLinks[9+i]:=@N.N2.Loops[i].Ffw;
for i:=1 to 4 do
SensorsLinks[13+i]:=@N.N2.Loops[i].Pst;
for i:=1 to 4 do
SensorsLinks[17+i]:=@N.N2.Loops[i].Tfw;
for i:=1 to 4 do
SensorsLinks[21+i]:=@N.N2.Loops[i].Pfw;
for i:=1 to 4 do
SensorsLinks[25+i]:=@N.N2.Loops[i].FCoun;
for i:=1 to 4 do
SensorsLinks[29+i]:=@N.N2.Loops[i].Fperd;

SensorsLinks[34]:=@N.NNFME;

SensorsLinks[35]:=@N.NDPZ;
for i:=1 to 4 do
SensorsLinks[35+i*2-1]:=@N.N1.Loops[i].THot;
for i:=1 to 4 do
SensorsLinks[35+i*2]:=@N.N1.Loops[i].Tcold;
// N PVD 'GK1',	'PK1',	'TK1',	'GJ1',	'GJ2',	'GJ3',	'GJ4',	'PJ1',	'PJ2',	'PJ3',	'PJ4',	'TJ1',	'TJ2','TJ3', 'TJ4',	'GV1',	'GV2',	'PV1',	'PV2',	'TV1',	'TV2');

SensorsLinks[44]:=@N.Npvd.Gkgtn.Value;
SensorsLinks[45]:=@N.Npvd.Pkgtn.Value;
SensorsLinks[46]:=@N.Npvd.Tkgtn.Value;
for i:=1 to 4 do
 SensorsLinks[46+i]:=@N.Npvd.Gjnb[i].Value;
for i:=1 to 4 do
 SensorsLinks[50+i]:=@N.Npvd.Pjnb[i].Value;
for i:=1 to 4 do
 SensorsLinks[54+i]:=@N.Npvd.Tjnb[i].Value;
for i:=1 to 2 do
 SensorsLinks[58+i]:=@N.Npvd.Gpvd[i].Value;
for i:=1 to 2 do
 SensorsLinks[60+i]:=@N.Npvd.Ppvd[i].Value;
for i:=1 to 2 do
 SensorsLinks[62+i]:=@N.Npvd.Tpvd[i].Value;


end;

procedure CopySensorsInfoToSensorsLinks(var SensorsInfo:TSensorsInfo; var SensorsLinks:TSensorsLinks);
var i,j,Count,CountInSum:integer;
    Value,Error:double;
begin

 Count:=Length(SensorsInfo);
 for j:=0 to 64 do
 begin
  CountInSum:=0;
  Value:=0;
  Error:=0;
  for i:=0 to Count-1 do
   begin
    if Pos(SensCode[j],SensorsInfo[i].CodeName)=1 then
     if (SensorsInfo[i].Delta<>-1) then
      if SensorsInfo[i].FileIndex<>-1 then
       if SensorsInfo[i].Value<>-1 then
      begin
       Value:=Value+SensorsInfo[i].Value;
       Error:=Error+SensorsInfo[i].Delta;//.*SensorsInfo[i].Delta;
       inc(CountInSum);
      end;
    end;

  if CountInSum<>0 then
  begin
   SensorsLinks[j]^.Value:=Value/CountInSum;
   SensorsLinks[j]^.Error:=Error/CountInSum; //SQRT(Error)/CountInSum); // Check in literature
   end
  else
  begin
   SensorsLinks[j]^.Value:=0;
   SensorsLinks[j]^.Error:=0;
  end;

  end;
end;

procedure NullN2(var N2:TN2);
var i:integer;
begin
 N2.Value:=NullPhysValue;
 N2.QLCQ:=0;
 N2.QRCP:=0;
 N2.Omega:=0;
 N2.W:=0;
 for i:=1 to 4 do
 begin
 NullN2Loop(N2.Loops[i]);
 N2.QRCPi[i]:=0;
 end;
 N2.GLCQ:=NullPhysValue;
 N2.Status:=0;
end;
procedure NullN(var N:TN);
begin
 N.Value:=NullPhysValue;
 N.Qlosses:=0;
 N.RoTarrir:=841.2;
 N.KSPND:=1;
 NullN1(N.N1);
 NullN2(N.N2);

 NullNpvd(N.Npvd);
 N.OmegaDPZ:=0;
 N.WDPZ:=0;
 N.OmegaNFME:=0;
 N.WNFME:=0;
 N.S:=Pi*0.85*0.85/4;
end;

procedure CalcN2(var N2:TN2;N1:TN1; Qlosses:double;Rotarrir:double);
var i:integer;
    tempT,TempT2,TempVfw,temp,QLCQ_i:double;
begin
 N2.QLCQ:=0;
 N2.QRCP:=0;
 for i:=1 to 4 do
 begin
 N2.Loops[i].N.Value:=0;
 N2.Loops[i].hfw.Value:=wspHPT(PMPA*(N2.Loops[i].Pfw.Value+Pabs),N2.Loops[i].Tfw.Value+TKelvin0);

 tempT:=wspTSP(PMPA*(N2.Loops[i].Pst.Value+Pabs ));
 N2.Loops[i].hwater.Value:=wspHSWT(tempT);
 N2.Loops[i].hst.Value:=wspHSST(tempT);
 N2.Loops[i].Fprod.Value:=N2.Loops[i].Fkarm.Value+N2.Loops[i].Fdn.Value+N2.loops[i].Fso.Value;

// QLCQ_i:=(1E-6)*N2.Loops[i].GLCQ.Value*(N2.Loops[i].hwater.Value-N2.Loops[i].hfw.Value);
 //N2.QLCQ:=N2.QLCQ+QLCQ_i;
// N2.QRCPi[i]:=N1.Loops[i].F.Value*(N1.Loops[i].dP.Value+N1.Loops[i].F.deltaP)/(3600*0.85);
 N2.QRCPi[i]:=0.85*N2.W;
 N2.QRCP:=N2.QRCP+N2.QRCPi[i] ;
 N2.Loops[i].Qppg.Value:=(1E-3)*N2.loops[i].Fprod.Value*N2.Loops[i].hwater.Value /3.6-(1E-3)*N2.GLCQ.Value*N2.Loops[i].hfw.Value/(4*3.6);

 TempVfw:=wspVPT(PMPA*( N2.Loops[i].Pfw.Value+Pabs),N2.Loops[i].Tfw.Value+TKelvin0);
 if (Rotarrir>0) and (TempVfw>0)then
 N2.Loops[i].Ffw.Value:=N2.Loops[i].Ffw.Value*SQRT( 1/( TempVfw*Rotarrir)); // corrected G

 N2.Loops[i].Gst.Value:=N2.Loops[i].Ffw.Value+0.25*N2.GLCQ.Value-N2.loops[i].Fprod.value;
 N2.Loops[i].Qpg.Value:=(1E-3)*N2.Loops[i].Gst.Value*N2.loops[i].hst.Value-(1E-3)*N2.Loops[i].Ffw.Value*N2.Loops[i].hwater.Value;

{ N2.Loops[i].N.Value:=(1E-6)*( N2.Loops[i].Ffw.Value - N2.Loops[i].GLCQ.Value)*(0.998*N2.Loops[i].hst.Value+0.002*N2.Loops[i].hwater.Value-N2.Loops[i].hfw.Value) +
                (1E-6)*N2.Loops[i].GLCQ.Value*(N2.Loops[i].hwater.Value-N2.Loops[i].hfw.Value)+
                Qlosses/4-
                N2.QRCPi[i];
 }
 N2.Loops[i].N.Value:=N2.Loops[i].Qpg.Value+N2.loops[i].Qppg.Value-N2.Qrcpi[i]+N2.NConst/4;
 // calc error
 N2.Loops[i].GLCQ.Error:=SQRT(N2.Loops[i].FCoun.Error*N2.Loops[i].FCoun.Error+N2.Loops[i].Fperd.Error*N2.Loops[i].Fperd.Error );

 N2.Loops[i].hfw.Error:=0.5*(wspHPT(PMPA*(N2.Loops[i].Pfw.Value+Pabs),N2.Loops[i].Tfw.Value+N2.Loops[i].Tfw.Error + TKelvin0) - wspHPT(PMPA*(N2.Loops[i].Pfw.Value+Pabs),N2.Loops[i].Tfw.Value-N2.Loops[i].Tfw.Error + TKelvin0) );

 TempT:= wspTSP(PMPA*(N2.Loops[i].Pst.Value+N2.Loops[i].Pst.Error +Pabs ));
 TempT2:= wspTSP(PMPA*(N2.Loops[i].Pst.Value-N2.Loops[i].Pst.Error +Pabs ));

 N2.Loops[i].hwater.Error:= 0.5*(wspHSWT(tempT) -wspHSWT(tempT2));
 N2.Loops[i].hst.Error:= 0.5*(wspHSST(tempT2)-wspHSST(tempT) );


 temp:=N2.Loops[i].N.Value*N2.Loops[i].N.Value*( (N2.Loops[i].Ffw.Error*N2.Loops[i].Ffw.Error+N2.Loops[i].GLCQ.Error*N2.Loops[i].GLCQ.Error )/( (N2.Loops[i].Ffw.Value-N2.Loops[i].GLCQ.Value)*(N2.Loops[i].Ffw.Value-N2.Loops[i].GLCQ.Value)  )
       +(N2.Loops[i].hst.Error*N2.Loops[i].hst.Error+N2.Loops[i].hfw.Error*N2.Loops[i].hfw.Error)/( (N2.Loops[i].hst.Value -N2.Loops[i].hfw.Value)*(N2.Loops[i].hst.Value -N2.Loops[i].hfw.Value ) ) );

 temp:=temp+QLCQ_i*QLCQ_i*( N2.Loops[i].GLCQ.Error*N2.Loops[i].GLCQ.Error/(N2.Loops[i].GLCQ.Value *N2.Loops[i].GLCQ.Value) +
            (N2.Loops[i].hwater.Error*N2.Loops[i].hwater.Error+N2.Loops[i].hfw.Error*N2.Loops[i].hfw.Error)/( (N2.Loops[i].hwater.Value-N2.Loops[i].hfw.Value )*(N2.Loops[i].hwater.Value-N2.Loops[i].hfw.Value) )  );

 temp:=temp+N2.QRCPi[i]*N2.QRCPi[i]*( N1.Loops[i].dP.Error*N1.Loops[i].dP.Error/(N1.Loops[i].dP.Value *N1.Loops[i].dP.Value) +
            N1.Loops[i].F.Error*N1.Loops[i].F.Error/( N1.Loops[i].F.Value*N1.Loops[i].F.Value));
 N2.Loops[i].N.Error:=SQRT(temp);
 end;

 N2.Value.Value:=0;
 N2.Value.Error:=0;
 for i:=1 to 4 do
 begin
 N2.Value.Value:=N2.Value.Value+N2.Loops[i].N.Value;
 N2.Value.Error:=N2.Value.Error+N2.Loops[i].N.Error*N2.Loops[i].N.Error;
 end;

 N2.Value.Error:=SQRT( N2.Value.Error);

end;

function CalcNNFME(NNFME:double):double;
begin
 Result:=NNFME*30;
end;

function CalcNSPND(N:TN):double;
begin
 Result:=163*3.55*N.KSPND*N.NDPZ.Value;
end;

procedure NullN2Loop(var N2Loop:TN2Loop);
begin
with N2Loop do
begin
 N:=NullPhysValue;
 W:=NullPhysValue;
 Ffw:=NullPhysValue;
 Pst:=NullPhysValue;
 Tfw:=NullPhysValue;
 Pfw:=NullPhysValue;
 FCoun:=NullPhysValue;
 Fperd:=NullPhysValue;
 GLCQ:=NullPhysValue;
 hwater:=NullPhysValue;
 hst:=NullPhysValue;
 hfw:=NullPhysValue;
end;
end;

Procedure CalcOmega(Var N:TN);
var SumOmega:double;
begin
  SumOmega:=0;
  SumOmega:=1/(N.N1.Value.Error*N.N1.Value.Error)+
  1/(N.N2.Value.Error*N.N2.Value.Error)+
  10000/(N.NDPZ.Value*N.NDPZ.Value*N.NDPZ.Error*N.NDPZ.Error)+
  1/(30*30*N.NNFME.Error*N.NNFME.Error);
  if N.Npvd.Value.Error<>0 then
    SumOmega:=SumOmega+1/(N.Npvd.Value.Error*N.Npvd.Value.Error);

  N.N1.Omega:=1/(N.N1.Value.Error*N.N1.Value.Error)/SumOmega;
  N.N2.Omega:=1/(N.N2.Value.Error*N.N2.Value.Error)/SumOmega;
  if N.Npvd.Value.Error<>0 then
   N.Npvd.Omega:=1/(N.Npvd.Value.Error*N.Npvd.Value.Error)/SumOmega;
  N.OmegaDPZ:=  10000/(N.NDPZ.Value*N.NDPZ.Value*N.NDPZ.Error*N.NDPZ.Error)/SumOmega;
  N.OmegaNFME:=  1/(30*30*N.NNFME.Error*N.NNFME.Error)/SumOmega;
  N.Value.Error:=SQRT(1/SumOmega);

  N.NDPZ.Error:=N.NDPZ.Error*N.NDPZ.Value/100;
  N.NNFME.Error:=N.NNFME.Error*30;
end;

Procedure CalcNAver(Var N:TN;Wtool:integer;Wmrse:integer);
var SumW,SumWOmega:double;
begin
  SumW:=0;
  SumW:=1/(N.N1.W*N.N1.W)+ 1/(N.N2.W*N.N2.W)+
  1/(N.WDPZ*N.WDPZ)+1/(N.WNFME*N.WNFME);
  if N.Npvd.W<>0 then
  SumW:=SumW +1/(N.Npvd.W*N.Npvd.W);

  N.N1.W:=1/(N.N1.W*N.N1.W)/SumW;
  N.N2.W:=1/(N.N2.W*N.N2.W)/SumW;
  N.WDPZ:=1/(N.WDPZ*N.WDPZ)/SumW;
  N.WNFME:=  1/(N.WNFME*N.WNFME)/SumW;
  if ( N.Npvd.W<>0) then N.Npvd.W:=1/(N.Npvd.W*N.Npvd.W)/SumW;

 SumWOmega:=Wtool*(N.N1.Omega+ N.N2.Omega+N.OmegaDPZ+N.OmegaNFME +N.Npvd.Omega)+
            Wmrse*( N.N1.W+ N.N2.W+N.WDPZ+N.WNFME+N.Npvd.W);

 N.Value.Value:=(N.N1.Value.Value*(Wtool*N.N1.Omega+Wmrse*N.N1.W )+
                N.N2.Value.Value*(Wtool*N.N2.Omega+Wmrse*N.N2.W )+
                N.NDPZ.Value*(Wtool*N.OmegaDPZ+Wmrse*N.WDPZ )+
                N.NNFME.Value*(Wtool*N.OmegaNFME+Wmrse*N.WNFME )+
                N.Npvd.Value.Value*(Wtool*N.Npvd.Omega+Wmrse*N.Npvd.W )  )/SumWOmega;


end;


procedure CalcNpvd(var Npvd:TNpvd;N2:TN2;N1:TN1; Qlosses:double);
var i:integer;
    TempN,TempSum:double;
    TempQi:array [1..4] of double;
    TempLCQi:array [1..4] of double;
    TempPVDi:array [1..2] of double;
    TempJNBi:array [1..2] of double;
    TempKGTN:double;
begin
TempN:=0;

TempSum:=0;
// first summand
for i:=1 to 4 do
 begin
  TempQi[i]:=(N2.Loops[i].Ffw.Value+Npvd.Gjnb[i].Value-N2.Loops[i].GLCQ.Value)*N2.Loops[i].hst.Value/1E6; // /1E6 : W ->MW
  TempSum:=TempSum+TempQi[i];
 end; 

Npvd.Qst:=TempSum;
 // second summand
for i:=1 to 4 do
 TempLCQi[i]:=(1E-6)*N2.Loops[i].GLCQ.Value*N2.Loops[i].hwater.Value;
for i:=1 to 4 do
 TempSum:=TempSum+ TempLCQi[i];
 // third summand
 for i:=1 to 2 do
 begin
  Npvd.Hpvd[i].Value:= wspHPT(PMPA*(Npvd.Ppvd[i].Value+Pabs),Npvd.Tpvd[i].Value+TKelvin0);
  TempPVDi[i]:=(1E-6)*Npvd.Gpvd[i].Value*Npvd.Hpvd[i].Value;
 end;

 for i:=1 to 2 do
 TempSum:=TempSum-TempPVDi[i];

// forth summand
 for i:=1 to 4 do
 begin
 Npvd.Hjnb[i].Value:= wspHPT(PMPA*(Npvd.Pjnb[i].Value+Pabs),Npvd.Tjnb[i].Value+TKelvin0);
 Npvd.Hjnb[i].Error:=0.5*( wspHPT(PMPA*(Npvd.Pjnb[i].Value+Pabs),Npvd.Tjnb[i].Value+Npvd.Tjnb[i].Error+ TKelvin0)-
                           wspHPT(PMPA*(Npvd.Pjnb[i].Value+Pabs),Npvd.Tjnb[i].Value-Npvd.Tjnb[i].Error+ TKelvin0)) ;

 end;

 for i:=1 to 4 do
 begin
  TempJNBi[i]:=Npvd.Gjnb[i].Value*Npvd.Hjnb[i].Value/1E6;
  TempSum:=TempSum-TempJNBi[i];
 end;
 // fifth summand
 Npvd.Hkgtn.Value:=wspHPT(PMPA*(Npvd.Pkgtn.Value+Pabs),Npvd.Tkgtn.Value+TKelvin0);
 Npvd.Hkgtn.Error:=0.5*(wspHPT(PMPA*(Npvd.Pkgtn.Value+Pabs),Npvd.Tkgtn.Value+Npvd.Tkgtn.Error+ TKelvin0)-
                        wspHPT(PMPA*(Npvd.Pkgtn.Value+Pabs),Npvd.Tkgtn.Value-Npvd.Tkgtn.Error+TKelvin0));
 TempKGTN:=Npvd.Gkgtn.Value*Npvd.Hkgtn.Value/1E6;
 TempSum:=TempSum-TempKGTN;

 TempSum:=TempSum-N2.QRCP+Qlosses;

 NPvd.Value.Value:=TempSum;

 // calc error
 TempSum:=0;
 // first summand
 for i:=1 to 4 do
 begin
 TempSum:=TempSum+TempQi[i]*TempQi[i]*(
                     ( N2.Loops[i].Ffw.Error*N2.Loops[i].Ffw.Error +
                       N2.Loops[i].GLCQ.Error*N2.Loops[i].GLCQ.Error+
                       Npvd.Gjnb[i].Error*Npvd.Gjnb[i].Error)/(
                     ( N2.Loops[i].Ffw.Value+N2.Loops[i].GLCQ.Value-Npvd.Gjnb[i].Value)*
                     ( N2.Loops[i].Ffw.Value+N2.Loops[i].GLCQ.Value-Npvd.Gjnb[i].Value))
                      +
                      ( (N2.Loops[i].hst.Error*N2.Loops[i].hst.Error)/
                      (N2.Loops[i].hst.Value*N2.Loops[i].hst.Value)
                      )  );
end;
// second summand
for i:=1 to 4 do
begin
TempSum:=TempSum+ TempLCQi[i]*TempLCQi[i]* (
                    N2.Loops[i].GLCQ.Error*N2.Loops[i].GLCQ.Error/
                    (N2.Loops[i].GLCQ.Value*N2.Loops[i].GLCQ.Value))
end;
// third summand
for i:=1 to 2 do
begin
TempSum:=TempSum+ TempPVDi[i]*TempPVDi[i]* (
                    (Npvd.GPVD[i].Error*Npvd.GPVD[i].Error/
                    (Npvd.GPVD[i].Value*Npvd.GPVD[i].Value)+

                    (N2.Loops[i].hfw.Error*N2.Loops[i].hfw.Error)/
                    (N2.Loops[i].hfw.Value*N2.Loops[i].hfw.Value)))
end;
 // thorth summand
 for i:=1 to 4 do
 begin
  TempSum:=TempSum+ TempJNBi[i]*TempJNBi[i]*(
                  (Npvd.GPVD[i].Error*Npvd.GPVD[i].Error)/
                  (Npvd.GPVD[i].Value*Npvd.GPVD[i].Value)+

                  (Npvd.Hjnb[i].Error*Npvd.Hjnb[i].Error)/
                  (Npvd.Hjnb[i].Value*Npvd.Hjnb[i].Value));
 end;
 //tifth summand
 TempSum:=TempSum+TempKGTN*TempKGTN*(
                  (Npvd.Gkgtn.Error*Npvd.Gkgtn.Error)/(Npvd.Gkgtn.Value*Npvd.Gkgtn.Value)+
                  (Npvd.Hkgtn.Error*Npvd.Hkgtn.Error)/(Npvd.Hkgtn.Value*Npvd.Hkgtn.Value) );
 //sixth summand
 for i:=1 to 4 do
  TempSum:=TempSum+N2.QRCPi[i]*N2.QRCPi[i]*(
                    N1.Loops[i].dP.Error*N1.Loops[i].dP.Error/
                    (N1.Loops[i].dP.Value*N1.Loops[i].dP.Value)
                    +
                    N1.Loops[i].F.Error*N1.Loops[i].F.Error/
                    (N1.Loops[i].F.Value*N1.Loops[i].F.Value)
                    );
 // finish result
 Npvd.Value.Error:=SQRT(TempSum);                   
end;

procedure LoadABC(var N1:TN1; FileName:string);
var i,n:integer;
    Txt:TextFile;
     Value,  A,B,C,deltaP,KGS,Error:double;
    s:string;
begin
  Assign(txt,FileName);
  Reset(txt);
  s:='';
  for i:=0 to 4 do
   Readln(Txt,s); // пропустили строки без данных
  for i:=1 to 4 do
   begin
    Read(txt,n);
    Read(txt,N1.Loops[i].F.A);
    Read(txt,N1.Loops[i].F.B);
    Read(txt,N1.Loops[i].F.C);
    Read(txt,N1.Loops[i].F.KGS);
    Read(txt,N1.Loops[i].F.deltaP);
    Read(txt,Value);

   end;
end;
procedure NullNAKNP(var NAKNP:TNAKNP);
var i:integer;
begin
 NAKNP.Value:=NullPhysValue;
 for i:=1 to 8 do
 NAKNP.Channels[i]:=NullPhysValue;
end;
end.
