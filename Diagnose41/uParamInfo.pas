unit uParamInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, ComCtrls, StdCtrls, ExtCtrls, Buttons,

  //my files:
  uGenTech,uBuffer  ;


type
  TfParamInfo = class(TForm)
    sbClose: TSpeedButton;
    leName: TLabeledEdit;
    leMUnit: TLabeledEdit;
    leKKS: TLabeledEdit;
    leValue: TLabeledEdit;
    leSKO: TLabeledEdit;
    Label3: TLabel;
    leTime: TLabeledEdit;
    gbParallel1: TGroupBox;
    leParal1: TLabeledEdit;
    leParalDeltaDop1: TLabeledEdit;
    leParalDelta1: TLabeledEdit;
    gbNominal: TGroupBox;
    leNominalMax: TLabeledEdit;
    leNominalMin: TLabeledEdit;
    gbSKO: TGroupBox;
    leSigmaMax: TLabeledEdit;
    Bevel1: TBevel;
    lValue: TLabel;
    lSKO: TLabel;
    sbChangeCalcParamInfo: TSpeedButton;
    lParallName1: TLabel;
    gbParallel2: TGroupBox;
    lParallName2: TLabel;
    leParal2: TLabeledEdit;
    leParalDeltaDop2: TLabeledEdit;
    leParalDelta2: TLabeledEdit;
    gbParallel3: TGroupBox;
    lParallName3: TLabel;
    leParal3: TLabeledEdit;
    leParalDeltaDop3: TLabeledEdit;
    leParalDelta3: TLabeledEdit;
    bParal1: TButton;
    bParal2: TButton;
    bParal3: TButton;
    procedure sbCloseClick(Sender: TObject);
    procedure sbChangeCalcParamInfoClick(Sender: TObject);
    procedure sbParalClick(Sender: TObject);
    procedure bParal1Click(Sender: TObject);
    procedure bParal2Click(Sender: TObject);
    procedure bParal3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Sensor:TParam;
    procedure showSensor(Time:string);
    procedure ShowParal(Param:TParam;ParalIndex:integer;Buffer:TBuffer);
  end;

var
  fParamInfo: TfParamInfo;

implementation

uses uCalcParam, uParal, uMain;



{$R *.dfm}

{ TfParamInfo }

procedure TfParamInfo.showSensor(Time:string);
begin

    leTime.Text:=Time;
    leKKS.Text:=Sensor.Description.KKS;
    leValue.Text:=FloatToStr(Sensor.CalcValue.Mean);
    leSKO.Text:=FloatToStr(Sensor.CalcValue.MSE);
//    leOutliers.Text:=floattoStr(sensor.OutliersPortion*100);
    leName.Text:=Sensor.Description.Name;
     leMUnit.Text:=Sensor.Description.Munit;

    if sensor.CalcParamInfo<>nil then
    begin
     gbParallel1.Visible:=(Sensor.CalcParamInfo.ParallelChannel[1].KKSMask<>'');
     lParallName1.Caption:=Sensor.CalcParamInfo.ParallelChannel[1].Name;
     leParal1.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[1].Value);
     leParalDelta1.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[1].Dev);
     leParalDeltadop1.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[1].Psi);
     if not Sensor.CalcParamInfo.ParallelChannel[1].Done then gbParallel1.Color:=clGray else
      if Sensor.CalcParamInfo.ParallelChannel[1].Valid then gbParallel1.Color:=clLime else gbParallel1.Color:=clRed;

     gbParallel2.Visible:=(Sensor.CalcParamInfo.ParallelChannel[2].KKSMask<>'');
     lParallName2.Caption:=Sensor.CalcParamInfo.ParallelChannel[2].Name;
     leParal2.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[2].Value);
     leParalDelta2.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[2].Dev);
     leParalDeltadop2.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[2].Psi);
     if not Sensor.CalcParamInfo.ParallelChannel[2].Done then gbParallel2.Color:=clGray else
      if Sensor.CalcParamInfo.ParallelChannel[2].Valid then gbParallel2.Color:=clLime else gbParallel2.Color:=clRed;

     gbParallel3.Visible:=(Sensor.CalcParamInfo.ParallelChannel[3].KKSMask<>'');
     lParallName3.Caption:=Sensor.CalcParamInfo.ParallelChannel[3].Name;
     leParal3.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[3].Value);
     leParalDelta3.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[3].Dev);
     leParalDeltadop3.Text:=floattoStr(Sensor.CalcParamInfo.ParallelChannel[3].Psi);
     if not Sensor.CalcParamInfo.ParallelChannel[3].Done then gbParallel3.Color:=clGray else
      if Sensor.CalcParamInfo.ParallelChannel[3].Valid then gbParallel3.Color:=clLime else gbParallel3.Color:=clRed;

 //    leValue.Text:=FloatToStrF(Sensor.CalcValue.Mean,ffFixed,Sensor.CalcParamInfo.Precision+2,Sensor.CalcParamInfo.Precision);
     leNominalMin.Text:=FloattoStr(Sensor.CalcParamInfo.NomMin);
     leNominalMax.Text:=FloattoStr(Sensor.CalcParamInfo.NomMax);
     leSigmaMax.Text:=FloattoStr(Sensor.CalcParamInfo.Delta);
    end;

{    if sensor.LimitParallel then gbParallel.Color:=clRed else gbParallel.Color:=clLime;
    if sensor.LimitNominalUpper or Sensor.LimitNominalLower then gbNominal.Color:=clRed else gbNominal.Color:=clLime;
    if sensor.LimitNominalUpper then leNominalMax.Color:=clYellow else leNominalMax.Color:=clWindow;
    if sensor.LimitNominalLower then leNominalMin.Color:=clYellow else leNominalMin.Color:=clWindow;
 }
end;

procedure TfParamInfo.sbCloseClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TfParamInfo.sbChangeCalcParamInfoClick(Sender: TObject);
var {TempCalcOneParamInfo:TCalcOneParamInfo;}
  i,j:integer;
begin
{ with fChangeCalcParamInfo do
 begin
 TempCalcOneParamInfo:=sensor.CalcOneParmInfo;
 leMask.Text:=TempCalcOneParamInfo.Mask;
 leName.Text:=TempCalcOneParamInfo.ParamName;
 leMUnit.Text:=TempCalcOneParamInfo.Munit;
 if TempCalcOneParamInfo.SigmaMax<>-1 then leSigmaMax.Text:=FloatToStr(TempCalcOneParamInfo.SigmaMax) else leSigmaMax.Text:='<Empty>';
 if TempCalcOneParamInfo.ParallelChannels[0].PsiConst<>0 then leDelta.Text:=FloatToStr(TempCalcOneParamInfo.ParallelChannels[0].PsiConst)else leDelta.Text:='<Empty>';
 if TempCalcOneParamInfo.Min<>-1 then leMin.Text:=FloatToStr(TempCalcOneParamInfo.Min) else leMin.Text:='<Empty>';
 if TempCalcOneParamInfo.Max<>-1 then leMax.Text:=FloatToStr(TempCalcOneParamInfo.Max)else lemax.Text:='<Empty>';
 if TempCalcOneParamInfo.Precesion<>-1 then lePrecesion.Text:=Inttostr(TempCalcOneParamInfo.Precesion) else lePrecesion.Text:='<Empty>';
 if TempCalcOneParamInfo.NominalMax<>-1 then leNominalUp.Text:=FloatToStr(TempCalcOneParamInfo.NominalMax)else leNominalUp.Text:='<Empty>';
 if TempCalcOneParamInfo.NominalMin<>-1 then leNominalDown.Text:=FloatToStr(TempCalcOneParamInfo.NominalMin)else leNominalDown.Text:='<Empty>';
 // filling list for Compare
  lvParallelSensors.Items.Clear;
//  lvParallelSensors.Items.Add.Caption:=(Sensor.CompareGroup[0].Objects[k] as TSensor).


 if TempCalcOneParamInfo.CompareManual then
 begin
   lvParallelSensors.Items.Add.Caption:='Manual';
   lCompareManual.Tag:=1;
   lvParallelSensors.Items.Item[0].SubItems.Add(FloatToStr(TempCalcOneParamInfo.CompareManualValue));
 end
 else
 begin
       lCompareManual.Tag:=0;// Compare by SEnsors
//  TempCalcOneParamInfo.ParallelChannels[0].
 for i:=0 to TempCalcOneParamInfo.CompareParamCount-1 do
  begin
   if TempCalcOneParamInfo.CompareParam[i].Name<>'' then
   lvParallelSensors.Items.Add.Caption:=TempCalcOneParamInfo.CompareParam[i].Name
   else lvParallelSensors.Items.Add.Caption:='Group'+inttostr(i);
   lvParallelSensors.Items.Item[lvParallelSensors.Items.Count-1].SubItems.Add('');

   for j:=0 to TempCalcOneParamInfo.CompareParam[i].Items.Count-1 do
   lvParallelSensors.Items.Item[lvParallelSensors.Items.Count-1].SubItems.Strings[0]:=
   lvParallelSensors.Items.Item[lvParallelSensors.Items.Count-1].SubItems.Strings[0]+
    TempCalcOneParamInfo.CompareParam[i].Items.Strings[j]+', ';
  end;
 end;

 end;

 fChangeCalcParamInfo.ShowModal;
  }
end;

procedure TfParamInfo.sbParalClick(Sender: TObject);
var i,number:integer;
begin
{ number:=0;
 if Sensor<> nil then
 if Sensor.CalcOneParmInfo<> nil then
  for i:=0 to Sensor.CompareGroup[0].Count-1 do
               if (Sensor.CompareGroup[0].Objects[i] is TSensor) then
                    if  (Sensor.CompareGroup[0].Objects[i] as TSensor).Serviceable then
                       begin
                        inc(Number);
                        fParallChannels.sgParallChannels.RowCount:=Number+1;
                        fParallChannels.sgParallChannels.Cells[0,Number]:=inttoStr(i);
                        fParallChannels.sgParallChannels.Cells[1,Number]:=(Sensor.CompareGroup[0].Objects[i] as TSensor).KKS;
                        fParallChannels.sgParallChannels.Cells[2,Number]:=(Sensor.CompareGroup[0].Objects[i] as TSensor).CalcOneParmInfo.ParamName;
                        fParallChannels.sgParallChannels.Cells[3,Number]:=(Sensor.CompareGroup[0].Objects[i] as TSensor).CalcOneParmInfo.Munit;
                        fParallChannels.sgParallChannels.Cells[4,Number]:=FloatToStr((Sensor.CompareGroup[0].Objects[i] as TSensor).MeanValue);

                       end;
 fParallChannels.ShowModal;
 }
end;

procedure TfParamInfo.ShowParal(Param: TParam; ParalIndex: integer;Buffer:TBuffer);
var i,k:integer;
begin
 with fParal do
 begin
  leMask.Text:=Param.CalcParamInfo.ParallelChannel[ParalIndex].KKSMask;
     // ������� ����� �� ����� ������������ �������
       k:=0;
       i:=0;
       while (k<Buffer.CountParam)  do
       begin
         if EqualMask(buffer.KKSIndex[k].KKS, Param.CalcParamInfo.ParallelChannel[ParalIndex].KKSMask)
         then
           begin
            if Param.Description.KKS<>buffer.CalcValues[k].KKS then
            begin
            inc(i);
            sgParal.RowCount:=i+1;
            sgParal.Cells[0,i]:=buffer.CalcValues[k].KKS;
            sgParal.Cells[1,i]:=FloattoSTR( buffer.CalcValues[k].Mean);
            end;
           end;
          inc(k);
        end;
  fParal.ShowModal;
 end;
end;

procedure TfParamInfo.bParal1Click(Sender: TObject);
begin
ShowParal(fParamInfo.Sensor,1,fMain.Buffer);
end;

procedure TfParamInfo.bParal2Click(Sender: TObject);
begin
ShowParal(fParamInfo.Sensor,2,fMain.Buffer);
end;

procedure TfParamInfo.bParal3Click(Sender: TObject);
begin
ShowParal(fParamInfo.Sensor,3,fMain.Buffer);
end;

end.
