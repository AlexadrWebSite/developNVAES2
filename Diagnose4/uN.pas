unit uN;
//----------------------------------------------------------------------------------------
// �������� ������ ��� �������� ������� �������� ��
// �� �����-2
// �����: ��������� �.�. semenikhinav@mail.ru
// ���� ��������: 23/10/2015
//----------------------------------------------------------------------------------------


interface
 uses uPowerCalc,uTC,uGenTech,uKStudent,uBuffer,uNetSend,IniFiles,SysUtils,uStringOperation,uDPZ;

type TN= class(TObject)
        private
         FN1:TN1;
         FQLosses:double;
         FRotarrir:double;
         FS:double;//����������� ������� ��� (��� ������� ��������� ����)
         FN2:TN2;
         FNAKNP:TNAKNP;
         FNdpz:TNdpz;
        protected

        public
         property QLosses:double read FQLosses write FQLosses;
         property S:double read FS write FS;
         property N1:TN1 read FN1 write FN1;
         property N2:TN2 read FN2 write FN2;
         property NAKNP:TNAKNP read FNAKNP write FNAKNP;
         property Ndpz:TNdpz read  FNdpz write FNdpz;
         property Rotarrir:double read FRotarrir write FRotarrir;
         procedure LoadRCPChar(FileName:string);
         procedure AssingNdpz(GenTech:TGenTech;Ini:TIniFile);
         procedure AssingNAKNP(GenTech:TGenTech;Ini:TIniFile);
         procedure AssingN2(GenTech:TGenTech;Ini:TIniFile);
         procedure CalculateN1(TC:TTC;GenTech:TGenTech;Buffer:TBuffer;Ini:TIniFile);
         procedure CalculateN2(GenTech:TGenTech;Buffer:TBuffer;Ini:TIniFile);
         procedure CalculateNAKNP(GenTech:TGenTech;Buffer:TBuffer;Ini:TIniFile);
         procedure CalculateNdpz(GenTech:TGenTech;Buffer:TBuffer;IDPZ:TIDPZ);
         procedure Calculate(TC:TTC;GenTech:TGenTech;Buffer:TBuffer;Ini:TIniFile;IDPZ:TIDPZ);
         constructor Create(GenTech:TGenTech;NIni:TIniFile);
         destructor Destroy;
        end;


implementation



{ TN }

procedure TN.AssingN2(GenTech: TGenTech; Ini: TIniFile);
var i,k:integer;
  KKS:string[20];
begin
  //�������� ��� ����.
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Pfw'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
      FN2.Loops[i].Pfw.Index:=k;
  end;
  //����������� ��� ����.
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Tfw'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
      FN2.Loops[i].Tfw.Index:=k;
  end;
  //�������� ���� � ��
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Tst'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].Tfw.Index:=k;
  end;
  //������ ��� ���� � ��
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Ffw'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].Ffw.Index:=k;
  end;
 {  Fkarm:TPhysValue;
 Fdn:TPhysValue;
 Fso:TPhysValue;}
  //������ �������� �� �� ��������
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Fkarm'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].Fkarm.Index:=k;
  end;
  //������ �������� �� �� �����
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Fdn'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].Fdn.Index:=k;
  end;
  //������ �������� �� �� �������� ������
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','Fso'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].Fso.Index:=k;
  end;
  //������������� �������� ����
  for i:=1 to 4 do
  begin
     KKS:= Ini.ReadString('N2','W'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.Loops[i].W.Index:=k;
  end;

  //������ �������� �� �� ���-5
      KKS:= Ini.ReadString('N2','GLCQ','');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FN2.GLCQ.Index:=k;
end;

procedure TN.AssingNAKNP(GenTech: TGenTech; Ini: TIniFile);
var i,k:integer;
    KKS:string;
begin
  for i:=1 to 8 do
  begin
     KKS:= Ini.ReadString('NAKNP','KKS'+InttoStr(i),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
     FNAKNP.Channels[i].Index:=k;
  end;
end;

procedure TN.AssingNdpz(GenTech: TGenTech; Ini: TIniFile);
var i,j,k:integer;
    KKS:string;
begin
  for i:=1 to 54 do
   for j:=1 to 7 do
    begin
     KKS:= Ini.ReadString('QED','SVRD'+NumberToStr(i)+'_level'+InttoStr(j),'');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS= KKS then
       FNdpz.QED[i][j].Index:=k;
    end;

end;

procedure TN.Calculate(TC: TTC; GenTech: TGenTech; Buffer: TBuffer;
  Ini: TIniFile;IDPZ:TIDPZ);
begin
 CalculateN1(TC,GenTech,Buffer,Ini);
 CalculateN2(GenTech,Buffer,Ini);
 CalculateNAKNP(GenTech,Buffer,Ini);
 CalculateNdpz(GenTech,Buffer,IDPZ);
end;

procedure TN.CalculateN1(TC: TTC; GenTech: TGenTech;Buffer:TBuffer;Ini:TIniFile);
var i,j,k,Count:integer;
    Sum,SumEr:double;
    KKS:string;
begin
//������� ��������� ������� �������� ����
// � ������ ����� �������� ������ ����������� � ��������������� �������
 Sum:=0;
 SumEr:=0;
 Count:=0;
 for i:=1 to 4 do
  begin
    for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
     if TC.Loops[i].ColdLeg.TC[j].Valid and TC.Loops[i].ColdLeg.TC[j].Serviceable then
      begin
       Sum:=Sum+TC.Loops[i].ColdLeg.TC[j].CalcValue.Mean;
       SumEr:=SumEr+TC.Loops[i].ColdLeg.TC[j].CalcValue.MSE*TC.Loops[i].ColdLeg.TC[j].CalcValue.MSE;
       inc(Count);
      end;
    if Count>0 then
     begin
       FN1.Loops[i].Tcold.Value:=Sum/Count;
       FN1.Loops[i].Tcold.Error:=KStudent(Buffer.LengthBuf)* SQRT(SumEr)/Count;
       FN1.Loops[i].Tcold.status:=Status_OK;// Ok
     end
     else FN1.loops[i].Tcold.Status:=Status_Invalid;// invalid
  end;
//������ � � ���. ������
 Sum:=0;
 SumEr:=0;
 Count:=0;
 for i:=1 to 4 do
  begin
    for j:=0 to TC.Loops[i].HotLeg.Count-1 do
     if TC.Loops[i].HotLeg.TC[j].Valid and TC.Loops[i].HotLeg.TC[j].Serviceable then
      begin
       Sum:=Sum+TC.Loops[i].HotLeg.TC[j].CalcValue.Mean;
       SumEr:=SumEr+TC.Loops[i].HotLeg.TC[j].CalcValue.MSE*TC.Loops[i].HotLeg.TC[j].CalcValue.MSE;
       inc(Count);
      end;
    if Count>0 then
     begin
       FN1.Loops[i].THot.Value:=Sum/Count;
       FN1.Loops[i].THot.Error:=KStudent(Buffer.LengthBuf)* SQRT(SumEr)/Count;
       FN1.Loops[i].THot.status:=Status_OK;// Ok
     end
     else FN1.loops[i].THot.Status:=Status_Invalid;// invalid
  end;
  //������� �������� �� ����
 Sum:=0;
 SumEr:=0;
 Count:=0;
 for i:=1 to 4 do
  begin
    for j:=1 to 6 do
      begin
       KKS:= Ini.ReadString('RCP'+InttoStr(i),'dP'+InttoStr(j),'');
       for k:=0 to GenTech.PTKZ[j].Count-1 do
        if GenTech.PTKZ[j].Params[k].Description.KKS=KKS then
        if GenTech.PTKZ[j].Params[k].valid and GenTech.PTKZ[j].Params[k].Serviceable then
        begin
         Sum:=Sum+GenTech.PTKZ[j].Params[k].CalcValue.Mean;
         SumEr:=SumEr+GenTech.PTKZ[j].Params[k].CalcValue.MSE*GenTech.PTKZ[j].Params[k].CalcValue.MSE;
         inc(Count);
        end;
       end;
      if Count>0 then
       begin
         FN1.Loops[i].dP.Value:=Sum/Count;
         FN1.Loops[i].dP.Error:=KStudent(Buffer.LengthBuf)* SQRT(SumEr)/Count;
         FN1.Loops[i].dP.status:=Status_OK;// Ok
       end
       else FN1.loops[i].dP.Status:=Status_Invalid;// invalid
   end;
  //������� ������� ����
 Sum:=0;
 SumEr:=0;
 Count:=0;
 for i:=1 to 4 do
  begin
    for j:=1 to 6 do
      begin
       KKS:= Ini.ReadString('RCP'+InttoStr(i),'freq'+InttoStr(j),'');
       for k:=0 to GenTech.PTKZ[j].Count-1 do
        if GenTech.PTKZ[j].Params[k].Description.KKS=KKS then
        if GenTech.PTKZ[j].Params[k].valid and GenTech.PTKZ[j].Params[k].Serviceable then
        begin
         Sum:=Sum+GenTech.PTKZ[j].Params[k].CalcValue.Mean;
         SumEr:=SumEr+GenTech.PTKZ[j].Params[k].CalcValue.MSE*GenTech.PTKZ[j].Params[k].CalcValue.MSE;
         inc(Count);
        end;
       end;
      if Count>0 then
       begin
         FN1.Loops[i].freq.Value:=Sum/Count;
         FN1.Loops[i].freq.Error:=KStudent(Buffer.LengthBuf)* SQRT(SumEr)/Count;
         FN1.Loops[i].freq.status:=Status_OK;// Ok
       end
       else FN1.loops[i].freq.Status:=Status_Invalid;// invalid
   end;
 //�������� ��� �.�.
  Sum:=0;
 SumEr:=0;
 Count:=0;
  for j:=1 to 6 do
      begin
       KKS:= Ini.ReadString('Reactor','P'+InttoStr(j),'');
       for k:=0 to GenTech.PTKZ[j].Count-1 do
        if GenTech.PTKZ[j].Params[k].Description.KKS=KKS then
        if GenTech.PTKZ[j].Params[k].valid and GenTech.PTKZ[j].Params[k].Serviceable then
        begin
         Sum:=Sum+GenTech.PTKZ[j].Params[k].CalcValue.Mean;
         SumEr:=SumEr+GenTech.PTKZ[j].Params[k].CalcValue.MSE*GenTech.PTKZ[j].Params[k].CalcValue.MSE;
         inc(Count);
        end;
       end;
      if Count>0 then
       begin
         FN1.P.Value:=Sum/Count;
         FN1.P.Error:=KStudent(Buffer.LengthBuf)* SQRT(SumEr)/Count;
         FN1.P.status:=Status_OK;// Ok
       end
       else FN1.P.Status:=Status_Invalid;// invalid
 //������� �������� �� �.�.
     KKS:= Ini.ReadString('Reactor','dP','');

     for k:=0 to GenTech.Params.Count-1 do
      if GenTech.Params.Params[k].Description.KKS=KKS then
      if GenTech.Params.Params[k].valid and GenTech.Params.Params[k].Serviceable then
      begin
       FN1.dP.Value:=GenTech.Params.Params[k].CalcValue.Mean;
       FN1.dP.Error:=GenTech.Params.Params[k].CalcValue.MSE*GenTech.Params.Params[k].CalcValue.MSE;
       FN1.dP.Status:=Status_OK;
      end
      else FN1.dP.Status:=Status_Invalid;
  //������ ������� N1
  FN1.Status:=Status_OK;
  for i:=1 to 4 do
  begin
   if FN1.Loops[i].Tcold.Status=Status_Invalid then FN1.Status:=Status_Invalid;
   if FN1.Loops[i].THot.Status=Status_Invalid then FN1.Status:=Status_Invalid;
   if FN1.Loops[i].dP.Status=Status_Invalid then FN1.Status:=Status_Invalid;
   if FN1.Loops[i].freq.Status=Status_Invalid then FN1.Status:=Status_Invalid;// ������� ����� �� ��������� = 50 ��, ���� Invalid
  end;
  if FN1.P.Status=Status_Invalid then FN1.Status:=Status_Invalid;
  if FN1.dP.Status=Status_Invalid then FN1.Status:=Status_Invalid;
  if FN1.Status<>Status_Invalid then CalcN1(FN1,FQLosses,FS);
end;

procedure TN.CalculateN2(GenTech:TGenTech;Buffer:TBuffer;Ini:TIniFile);
var i,k:integer;
  KKS:string[20];
  KStudentConst:double;
begin
  KStudentConst:=KStudent(Buffer.LengthBuf);
//������� ��������� ������� �������� ����
// � ������ ����� �������� ������ ����������� � ��������������� �������
  //�������� ��� ����.
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Pfw.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Pfw.Index].valid and GenTech.Params.Params[FN2.Loops[i].Pfw.Index].Serviceable then
      begin
       FN2.Loops[i].Pfw.Value:=GenTech.Params.Params[FN2.Loops[i].Pfw.Index].CalcValue.Mean;
       FN2.Loops[i].Pfw.Error:=GenTech.Params.Params[FN2.Loops[i].Pfw.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Pfw.Status:=Status_OK;
      end
      else FN2.Loops[i].Pfw.Status:=Status_Invalid;
  end;
  //����������� ��� ����.
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Tfw.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Tfw.Index].valid and GenTech.Params.Params[FN2.Loops[i].Tfw.Index].Serviceable then
      begin
       FN2.Loops[i].Tfw.Value:=GenTech.Params.Params[FN2.Loops[i].Tfw.Index].CalcValue.Mean;
       FN2.Loops[i].Tfw.Error:=GenTech.Params.Params[FN2.Loops[i].Tfw.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Tfw.Status:=Status_OK;
      end
      else FN2.Loops[i].Tfw.Status:=Status_Invalid;
  end;
  //�������� ���� � ��
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Tfw.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Tfw.Index].valid and GenTech.Params.Params[FN2.Loops[i].Tfw.Index].Serviceable then
      begin
       FN2.Loops[i].Tfw.Value:=GenTech.Params.Params[FN2.Loops[i].Tfw.Index].CalcValue.Mean;
       FN2.Loops[i].Tfw.Error:=GenTech.Params.Params[FN2.Loops[i].Tfw.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Tfw.Status:=Status_OK;
      end
      else FN2.Loops[i].Tfw.Status:=Status_Invalid;
  end;
  //������ ��� ���� � ��
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Ffw.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Ffw.Index].valid and GenTech.Params.Params[FN2.Loops[i].Ffw.Index].Serviceable then
      begin
       FN2.Loops[i].Ffw.Value:=GenTech.Params.Params[FN2.Loops[i].Ffw.Index].CalcValue.Mean;
       FN2.Loops[i].Ffw.Error:=GenTech.Params.Params[FN2.Loops[i].Ffw.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Ffw.Status:=Status_OK;
      end
      else FN2.Loops[i].Ffw.Status:=Status_Invalid;
  end;
 {  Fkarm:TPhysValue;
 Fdn:TPhysValue;
 Fso:TPhysValue;}
  //������ �������� �� �� ��������
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Fkarm.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Fkarm.Index].valid and GenTech.Params.Params[FN2.Loops[i].Fkarm.Index].Serviceable then
      begin
       FN2.Loops[i].Fkarm.Value:=GenTech.Params.Params[FN2.Loops[i].Fkarm.Index].CalcValue.Mean;
       FN2.Loops[i].Fkarm.Error:=GenTech.Params.Params[FN2.Loops[i].Fkarm.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Fkarm.Status:=Status_OK;
      end
      else FN2.Loops[i].Fkarm.Status:=Status_Invalid;
  end;
  //������ �������� �� �� �����
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Fdn.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Fdn.Index].valid and GenTech.Params.Params[FN2.Loops[i].Fdn.Index].Serviceable then
      begin
       FN2.Loops[i].Fdn.Value:=GenTech.Params.Params[FN2.Loops[i].Fdn.Index].CalcValue.Mean;
       FN2.Loops[i].Fdn.Error:=GenTech.Params.Params[FN2.Loops[i].Fdn.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Fdn.Status:=Status_OK;
      end
      else FN2.Loops[i].Fdn.Status:=Status_Invalid;
  end;
  //������ �������� �� �� �������� ������
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].Fso.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].Fso.Index].valid and GenTech.Params.Params[FN2.Loops[i].Fso.Index].Serviceable then
      begin
       FN2.Loops[i].Fso.Value:=GenTech.Params.Params[FN2.Loops[i].Fso.Index].CalcValue.Mean;
       FN2.Loops[i].Fso.Error:=GenTech.Params.Params[FN2.Loops[i].Fso.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].Fso.Status:=Status_OK;
      end
      else FN2.Loops[i].Fso.Status:=Status_Invalid;
  end;
  //������������� �������� ����
  for i:=1 to 4 do
  begin
     if FN2.Loops[i].W.Index<>-1 then
      if GenTech.Params.Params[FN2.Loops[i].W.Index].valid and GenTech.Params.Params[FN2.Loops[i].W.Index].Serviceable then
      begin
       FN2.Loops[i].W.Value:=GenTech.Params.Params[FN2.Loops[i].W.Index].CalcValue.Mean;
       FN2.Loops[i].W.Error:=GenTech.Params.Params[FN2.Loops[i].W.Index].CalcValue.MSE*KStudentConst;
       FN2.Loops[i].W.Status:=Status_OK;
      end
      else FN2.Loops[i].W.Status:=Status_Invalid;
  end;

  //������ �������� �� �� ���-5
      if FN2.GLCQ.Index<>-1 then
      if GenTech.Params.Params[FN2.GLCQ.Index].valid and GenTech.Params.Params[FN2.GLCQ.Index].Serviceable then
      begin
       FN2.GLCQ.Value:=GenTech.Params.Params[FN2.GLCQ.Index].CalcValue.Mean;
       FN2.GLCQ.Error:=GenTech.Params.Params[FN2.GLCQ.Index].CalcValue.MSE*KStudentConst;
       FN2.GLCQ.Status:=Status_OK;
      end
      else FN2.GLCQ.Status:=Status_Invalid;
// ������ �������� �� 2-�� �������
  FN2.Status:=Status_OK;
  for i:=1 to 4 do
  begin
   if FN2.Loops[i].Ffw.Status=Status_Invalid then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Pst.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Tfw.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Pfw.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Fkarm.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Fdn.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
   if FN2.Loops[i].Fso.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
  end;
  if FN2.GLCQ.Status=Status_Invalid  then FN2.Status:=Status_Invalid;
  if FN2.Status<>Status_Invalid  then
   CalcN2(FN2,FN1,FQLosses,FRotarrir);
end;

procedure TN.CalculateNAKNP(GenTech: TGenTech;Buffer:TBuffer; Ini: TIniFile);
var i,k,Count:integer;
    Sum:double;
begin
  for i:=1 to 8 do
  begin
     if FNAKNP.Channels[i].Index<>-1 then
      if GenTech.Params.Params[FNAKNP.Channels[i].Index].valid and GenTech.Params.Params[FNAKNP.Channels[i].Index].Serviceable then
      begin
       FNAKNP.Channels[i].Value:=GenTech.Params.Params[FNAKNP.Channels[i].Index].CalcValue.Mean;
       FNAKNP.Channels[i].Error:=GenTech.Params.Params[FNAKNP.Channels[i].Index].CalcValue.MSE*KStudent(Buffer.LengthBuf);
       FNAKNP.Channels[i].Status:=Status_OK;
      end
      else FNAKNP.Channels[i].Status:=Status_Invalid;
  end;

  Sum:=0;
  Count:=0;
  for i:=1 to 8 do
  if FNAKNP.Channels[i].Status=Status_OK then
   begin
    Sum:=Sum+FNAKNP.channels[i].Value;
    inc(count);
   end;
  if Count>0 then
  begin
   FNAKNP.Value.Value:=Sum/Count;
   FNAKNP.Value.Status:=Status_OK;
  end
  else
   FNAKNP.Value.Status:=Status_Invalid;
end;

procedure TN.CalculateNdpz(GenTech: TGenTech;Buffer:TBuffer;IDPZ:TIDPZ);
var i,j,k:integer;
begin
 for i:=1 to 54 do
  for j:=1 to 7 do
   if FNdpz.QED[i][j].Index<>-1 then
   begin
    FNdpz.QED[i][j].Value:=GenTech.Params.Params[FNdpz.QED[i][j].Index].CalcValue.Mean;
    FNdpz.QED[i][j].Error:=GenTech.Params.Params[FNdpz.QED[i][j].Index].CalcValue.MSE*KStudent(Buffer.LengthBuf);
    if GenTech.Params.Params[FNdpz.QED[i][j].Index].Valid and GenTech.Params.Params[FNdpz.QED[i][j].Index].Serviceable then
     FNdpz.QED[i][j].Status:=Status_OK else FNdpz.QED[i][j].Status:=Status_Invalid;  
   end;
  CalcNdpz(FNdpz,IDPZ);

end;

constructor TN.Create(GenTech:TGenTech;NIni:TIniFile);
begin
 inherited Create;
 AssingN2(GenTech,NIni);
 AssingNdpz(GenTech,NIni);
 AssingNAKNP(GenTech,NIni);
end;

destructor TN.Destroy;
begin
  inherited Destroy;
end;

procedure TN.LoadRCPChar( FileName: string);
begin
// LoadRCPCharacteristics(FN1,FileName);
 LoadABC(FN1,FileName);
end;

end.
