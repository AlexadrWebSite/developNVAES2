unit uMain;
//----------------------------------------------------------------------------------------
// Главная форма Diagnose.exe - Программа "Диагностика инфомрации СВРК в режиме реального времени"
// на НВАЭС-2
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 20/04/2015
//----------------------------------------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, Sockets,ExtCtrls,
  //=====files below written by myself=====================================
  uStringOperation, uBuffer, ComCtrls,uNPPUnit, Grids,uRegime,uCheckState,
  Menus, ImgList, TeEngine, TeeTools, Series, Buttons, ToolWin, TeeProcs,
  Chart,uTimeScheduler,uCalcParam,uGenTech, uTC, IniFiles,uDPZ,uN,uConnectDLL;

type
  TfMain = class(TForm)
    MainMenu: TMainMenu;
    N1: TMenuItem;
    miConnect: TMenuItem;
    miDisconnect: TMenuItem;
    miAddres: TMenuItem;
    N4: TMenuItem;
    miStability: TMenuItem;
    miAuto: TMenuItem;
    miRegime: TMenuItem;
    N10: TMenuItem;
    miTermoControl: TMenuItem;
    miGenTech: TMenuItem;
    miMixUp: TMenuItem;
    miTermoField: TMenuItem;
    miKV: TMenuItem;
    miOpenFiles: TMenuItem;
    N6: TMenuItem;
    miAlgorithm: TMenuItem;
    miAbout: TMenuItem;
    sbState: TStatusBar;
    PageControl: TPageControl;
    TabSheet3: TTabSheet;
    lvData: TListView;
    TabSheet1: TTabSheet;
    Chart: TChart;
    tbChart: TToolBar;
    tbSaveAsPicture: TToolButton;
    tbSetDiapason: TToolButton;
    tbClear: TToolButton;
    tbSaveAs: TToolButton;
    tbSaveCurrentChart: TToolButton;
    tbChartFormat: TToolButton;
    tbAddToTemplate: TToolButton;
    tbAddLabel: TToolButton;
    tbCopyToClipboard: TToolButton;
    tbStatistics: TToolButton;
    tbLastPoint: TToolButton;
    lInfo: TLabel;
    tbChartEditor: TToolButton;
    tbSetTimeInterval: TToolButton;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    lCountNote: TLabel;
    lProcess: TLabel;
    pN: TPanel;
    pTC: TPanel;
    pDPZ: TPanel;
    sgNote: TStringGrid;
    bbCopyNote: TBitBtn;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    pbLoading: TProgressBar;
    TabSheet4: TTabSheet;
    sgLog: TStringGrid;
    BitBtn1: TBitBtn;
    chHistory: TChart;
    Series1: TBarSeries;
    ChartTool1: TMarksTipTool;
    ImageList2: TImageList;
    pmKKS: TPopupMenu;
    miBulidCurveOnIndividualAxis: TMenuItem;
    miBuildbyUnit: TMenuItem;
    miAddSeries: TMenuItem;
    N11: TMenuItem;
    miCreateMean: TMenuItem;
    miSum: TMenuItem;
    miMax: TMenuItem;
    miMin: TMenuItem;
    N7: TMenuItem;
    miSaveFieldData: TMenuItem;
    miSaveFieldData1: TMenuItem;
    miSaveFile: TMenuItem;
    miMakeafilewithfixedintervalselectedparameters: TMenuItem;
    Makeeventfile: TMenuItem;
    MenuItem2: TMenuItem;
    imSmoothing: TMenuItem;
    miCalcAveragingout: TMenuItem;
    Algorithm1: TMenuItem;
    Calc1: TMenuItem;
    miCaclRateofchange: TMenuItem;
    CaclRateofchangeSVRK: TMenuItem;
    pmChartLabels: TPopupMenu;
    miChangeLabel: TMenuItem;
    miMoveLabel: TMenuItem;
    N8: TMenuItem;
    miDeleteLabel: TMenuItem;
    N5: TMenuItem;
    miDeleteAllLabels: TMenuItem;
    Timer1: TTimer;
    miDebugInfo: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ShowNPPUnit;
    procedure SaveTxt(Var Txt:TextFile);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miDebugInfoClick(Sender: TObject);
    procedure miAutoClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure pTCClick(Sender: TObject);
    procedure pDPZClick(Sender: TObject);
    procedure pNClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }

    Buffer:TBuffer;
    FirstPost:boolean;
    NPPUnit:TNPPUnit;
    CalcParams:TCalcParams;//класс для хранения настроек по проверки на достоверность параметров
    CheckState:TCheckState;//класс для определения стабильности показаний
    TimeScheduler:TTimeScheduler; // класс для определения момента запуска расчетов
    GenTech:TGenTech;// класс для проверки общетехнологических параметров
    TC:TTC; //класс для проверки температурного контроля
    IDPZ:TIDPZ;
    N:TN;
    function ConnectToServer:Boolean; // подключение к серверу СВРК, сообщение имени подключения
    procedure LoadKKSSendKKS; // считываение списка запрашиваемых кодов и запрос
    procedure InitializeNPPUnit;//инициализация объекта NPPUnit, описывающего блок АЭС
    procedure CheckStateInitalize;//инициализация объекта CheckState, для определения стабильного участка
    procedure CalcRegime; // отобразить текущие состояние РУ (не определен, горячее, на мощности и тп)
    procedure InitalizeCheckState;
    procedure InitalizeCalcParam;// Инициализация CalcParams (запрос к БД)
    procedure InitalizeGenTech; //Инициализация общетехнологических параметров
    procedure InitalizeTC; //Инициализация Температурного контроля
    procedure InitalizeDPZ; //Инициализация проверки токов ДПЗ
    procedure InitalizeN;// Инициализация расчета мощности
    procedure ShowPTKZ(Nptkz:integer);
    procedure ShowDPZ; //показать токи ДПЗ
    procedure ShowN;// показать расчет мощности РУ
    procedure ColorIndicator;
    procedure FilllvData(Buffer:TBuffer);
    procedure lvDataNewData(Buffer:TBuffer);
    procedure MakeNameNoteTable; // Заголовки для таблиц обнаруженных недостоверных параметров
    procedure ShowNoteParam; //Заполнение таблиц недостоверными параметрами
    procedure AddToChartHistory; // Добавление на график количество недостоверных параметров
    procedure SaveToArchive; // Сохранить в архив
  end;
type
  indexkks=record
    index:integer;
    kks:String
    end;
const

    getDataparam=1;
    options=1;

var
  fMain: TfMain;
  Txt:TextFile;
   IpAddress:string;//'127.0.0.1';
   port:integer;//=1050;
   clientId:integer;
   PTKZPanel:array [1..6] of TPanel;
   TC_power_ini,NIni: TIniFile;
   getId:integer;
   sgTemp:TStringGrid; // скрытая таблица с значениями, что бы не моргала основная таблица при обновлении


implementation

uses uNetSend, uWelcome, uRegimeForm, uDebugForm, uAutoCalcSettings  ,
  uPTKZ, uDescription, uTCform, uArchive, uFormDPZ, uPowerCalcForm ;

{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
var  IniName:string;
     IniFile:TIniFile;
begin
 Buffer:=TBuffer.Create(5);
 DecimalSeparator:='.';
 NPPUnit:=TNPPUnit.Create;
 TimeScheduler:=TTimeScheduler.Create(20);
 PTKZPanel[1]:=Panel1;
 PTKZPanel[2]:=Panel2;
 PTKZPanel[3]:=Panel3;
 PTKZPanel[4]:=Panel4;
 PTKZPanel[5]:=Panel5;
 PTKZPanel[6]:=Panel6;
 TC_power_ini:=TIniFile.Create(ExtractFilePath(Application.exename)+'TC_power.ini' );
 MakeNameNoteTable;//Заголовок для таблиц со списком недостоверных параметров

 IniName:=copy(Application.ExeName,1,length(Application.ExeName)-3)+'ini';
 Inifile:=TIniFile.Create(iniName);
 IpAddress:=IniFile.ReadString('Server','IpAddress','127.0.0.1');
 Port:=IniFile.ReadInteger('Server','Port',1050);
 getId:=0;
end;

procedure TfMain.Button3Click(Sender: TObject);

begin
fMain.LoadKKSSendKKS;
end;

procedure TfMain.Timer1Timer(Sender: TObject);
var
  i,c:integer;
  val:TValue;
  s:string;
  f:TextFile;
begin
AssignFile(f,'indexes.txt');
REwrite(f);

if getId>0 then
begin
//-----------------чтение через библиотеку
 c:=0;
  //получение среза данных
  try
  CopyLayer(clientId,getId);
   Sleep(100);
  //fDebugForm.Memo.Lines.Add(IntToStr(Buffer.CountParam));
  //добавление данных в буфер
  for i:=0 to Buffer.CountKKSIndex-1 do
   if  Buffer.KKSIndex[i].index>0 then
    begin
     val.Value:= GetFloat(clientId,getId,Buffer.KKSIndex[i].index);
     val.Status:=GetStatus(clientId,getId,Buffer.KKSIndex[i].index);
     Buffer.AddValue(Buffer.KKSIndex[i].index, val);
     writeln(f, Buffer.KKsindex[i].kks+ ' ' +IntToStr( Buffer.KKSIndex[i].Index)+' '+floattostr(val.Value));
     // fDebugForm.Memo.Lines.Add(IntToStr(kksList[i].index) + ' '+ floatToStr(val.value));
    end;
 // fDebugForm.Memo.Lines.Add(IntToStr(Buffer.CountParam) + ' count '+ IntToStr(currentIndex));
  //заполнение таблиц
 
  lvDataNewData(Buffer);
  Buffer.StartFilling;
   except
     ShowMessage('Error');
     end;
   CloseFile(f);
//-----------------
  if TimeScheduler.LastTime<>0 then
  sbState.Panels.Items[3].Text:='Последняя проверка '+DateTimeToStr(TimeScheduler.LastTime )+' прошло '+IntToStr(round((Now-TimeScheduler.LastTime)*86400)) +' сек.';
 if Buffer.Filled then
 begin
//  CalcRegime; // определить режим

  if CheckState.Stable then sbState.Panels.Items[1].Text:='Stable' else sbState.Panels.Items[1].Text:='Non stable';

 if TimeScheduler.AutoCalc(checkState) then
  case NPPUnit.Regim(Buffer) of
  rt_Unknown:sbState.Panels.Items[2].Text:='rt_Unknown';
  rtHot:sbState.Panels.Items[2].Text:='rtHot';
  rtN1_10:sbState.Panels.Items[2].Text:='rtN1_10';
  rtN10_100:begin
              GenTech.Calc(buffer,NPPUnit.RU.Nakz.Value.Value);
              sbState.Panels.Items[2].Text:='rtN10_100';
              if fPTKZ.Visible then ShowPTKZ(fPTKZ.Tag);
              //-------------
              TC.Calc_Power(TC_power_ini,NPPUnit.RU.Nakz.Value.Value/3000,Buffer);
              IDPZ.Calc_Power(NPPUnit.RU.Nakz.Value.Value/3000,Buffer);
              N.Calculate(TC,GenTech,Buffer,NIni);

              //Сохранить в архиве
              SaveToArchive;

            end;
  end;
  fMain.ColorIndicator;
  ShowNoteParam;  
 end;
 end;
end;


procedure TfMain.ShowNPPUnit;
var i,j,k:integer;
begin
if buffer.Calced  then
with fDebugForm.Memo.Lines do
begin

if Nppunit.RU.Nakz.Description.ID<>-1 then
 begin
  Nppunit.RU.Nakz.Value:=Buffer.LastValues[Nppunit.RU.Nakz.Description.ID];
 add('Nakz '+Nppunit.RU.Nakz.Description.KKS+' : '+FloattoSTr(Nppunit.RU.Nakz.Value.Value));
 end;
if Nppunit.RU.Naknp.Description.ID<>-1 then
 begin
  Nppunit.RU.Naknp.Value:=Buffer.LastValues[Nppunit.RU.Naknp.Description.ID];
 add('Nakz '+Nppunit.RU.Naknp.Description.KKS+' : '+FloattoSTr(Nppunit.RU.Naknp.Value.Value));
 end;
if Nppunit.RU.Ndpz.Description.ID<>-1 then
 begin
  Nppunit.RU.Ndpz.Value:=Buffer.LastValues[Nppunit.RU.Ndpz.Description.ID];
 add('Nakz '+Nppunit.RU.Ndpz.Description.KKS+' : '+FloattoSTr(Nppunit.RU.Ndpz.Value.Value));
 end;

 for i:=1 to 4 do
  for j:=0 to NPPUnit.RU.Loops[i].ColdLeg.CountTSens-1 do
  if NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Description.ID<>-1 then
  begin
   NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Value:=Buffer.LastValues[NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Description.ID];
    fDebugForm.Memo.Lines.add(NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Description.KKS+ ' Loop '+InttoSTR(i)+' T Cold '+IntToStr(j)+' : '+FloattoSTR(NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Value.Value));
  end;
 for i:=1 to 4 do
  for j:=0 to NPPUnit.RU.Loops[i].HotLeg.CountTSens-1 do
  if NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.ID<>-1 then
  begin
   NPPUnit.RU.Loops[i].HotLeg.TSens[j].Value:=Buffer.LastValues[NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.ID];
    fDebugForm.Memo.Lines.add(NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.KKS+ ' Loop '+InttoSTR(i)+' T Hot '+IntToStr(j)+' : '+FloattoSTR(NPPUnit.RU.Loops[i].HotLeg.TSens[j].Value.Value));
  end;

  for i:=0 to Buffer.CountParam-1 do
  begin
   fDebugForm.Memo.lines.Add(Buffer.CalcValues[i].KKS+' : '+  FloattoSTr( Buffer.CalcValues[i].Mean ));
  end;
{
 for i:=1 to 4 do
  for j:=0 to NPPUnit.RU.Loops[i].HotLeg.CountTSens-1 do
  if NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.ID<>-1 then
  begin
   NPPUnit.RU.Loops[i].HotLeg.TSens[j].Value:=Buffer.CalcValues[NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.ID];
   if NPPUnit.RU.Loops[i].HotLeg.TSens[j].Value<>nil then
    memo3.Lines.add(NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.KKS+ ' Loop '+InttoSTR(i)+' T Hot '+IntToStr(j)+' : '+FloattoSTR(NPPUnit.RU.Loops[i].HotLeg.TSens[j].Value.Mean));
  end;
 } 
// memo3.show;
end;
end;
procedure TfMain.SaveTxt(Var Txt:TextFile);
var i,j:integer;
    s:string;
begin
 AssignFile(txt,ExtractfilePath(Application.exeName)+'Save.txt');
 Rewrite(txt);
 s:=#9;
 s:=s+NPPUnit.RU.Nakz.Description.KKS+#9;
 for i:=1 to 4 do
  for j:=0 to NPPUnit.RU.Loops[i].HotLeg.CountTSens-1 do
  s:=s+NPPUnit.RU.Loops[i].HotLeg.TSens[j].Description.KKS+#9;
 for i:=1 to 4 do
  for j:=0 to NPPUnit.RU.Loops[i].ColdLeg.CountTSens-1 do
  s:=s+NPPUnit.RU.Loops[i].ColdLeg.TSens[j].Description.KKS+#9;
  WriteLn(Txt,s);
end;

function TfMain.ConnectToServer:boolean;
begin
Result:=False;
with fWelcome do
  begin
   lInfo.Caption:='Установление связи с сервером...';
   application.processmessages;
   try
    clientId:=InitModLib('Diagnose_NVATE');


  //  getId:= CreateChannel(clientId,'192.168.103.71',port, CH_CALC_GET_DATA,OPT_ENABLE_REAL_TIME or OPT_BLOCKING_COPY_LAYER or OPT_INVALIDATE_STATUS or OPT_ENABLE_DIAGNOSTICS or OPT_ENABLE_INPUT_BUFFER);
    getId:= CreateChannel(clientId,PChar(ipAddress),port, CH_CALC_GET_DATA,OPT_ENABLE_REAL_TIME or OPT_BLOCKING_COPY_LAYER or OPT_INVALIDATE_STATUS or OPT_ENABLE_DIAGNOSTICS or OPT_ENABLE_INPUT_BUFFER);
    if getId>0 then Result:=True;
   except
    MessageDlg('Не удалось подключится к серверу',mtWarning,[mbOk],0);
   end;
   lInfo.Caption:='Связь с сервером установлена!';
   application.processmessages;
  end;
end;

procedure TfMain.LoadKKSSendKKS;
var
 i:integer;
  KKSIndex:TKKSIndex;
begin
with fWelcome do
  begin
   lInfo.Caption:='Формирование списка запрашиваемых параметров у сервера ...';
   fDebugForm.Memo.Lines.Add(lInfo.Caption);

   Buffer.LoadKKSFromFile(ExtractFileDir(application.ExeName)+'\KKS.txt');
   fWelcome.ProgressBar.Position:=0;
   fWelcome.ProgressBar.Max:=Buffer.CountKKSIndex div 10;
//   MessageDlg('Max='+InttoStr(fWelcome.ProgressBar.Max),mtInformation,[mbOk],0);
   application.processmessages;

   for i:=0  to Buffer.CountKKSIndex-1 do
    begin
     KKSIndex:=Buffer.KKSIndex[i];
     KKSIndex.Index:=Insert(clientId,getId,Pchar(string(Buffer.KKSIndex[i].KKS)),0,0);
      Buffer.KKSIndex[i]:=KKSIndex;
     if (i div 10)=i/10 then
      begin
        fWelcome.ProgressBar.Position:=fWelcome.ProgressBar.Position+1;
        SendMessage(fWelcome.ProgressBar.Handle,WM_PAINT,0,0);
      end;
    end;


    lInfo.Caption:='Формирование списка запрашиваемых параметров у сервера завершено!';
    lInfo.Caption:='Подписка на список параметров....';
   Subscribe(ClientID,GetID);
   fWelcome.ProgressBar.Position:=0;
   while (GetChannelStatus(ClientID,GetID)and D_STATUS_SUBSCRIBED)<>D_STATUS_SUBSCRIBED do
   begin
    fWelcome.ProgressBar.Position:=fWelcome.ProgressBar.Position+1;
    SendMessage(fWelcome.ProgressBar.Handle,WM_PAINT,0,0);
    sleep(500);
   end;
   Buffer.Initalize;
   FilllvData(Buffer);
   lInfo.Caption:='Подписка завершена!';
   fWelcome.ProgressBar.Position:=0;
   application.processmessages;
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if getId>0 then
   Unsubscribe(clientId,getId);
end;

procedure TfMain.InitializeNPPUnit;
var i,j:integer;
  Strings:TStrings;
begin
  fWelcome.lInfo.Caption:='Инициализация объекта, описывающего блок АЭС...';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);

 if not NPPUnit.Initalize(ExtractFilePath( Application.ExeName)+'NPPUnit.ini')
 then MessageDlg('Не иницилизованы датчики в классе NPPUnit',mtWarning,[mbOk],0);
 strings:=TStringList.Create;
 if not NPPUnit.Link(Buffer,strings) then
  for i:=0 to Strings.Count-1 do
   fDebugForm.Memo.Lines.Add(strings.Strings[i]);

 ShowNPPUnit;

end;

procedure TfMain.CheckStateInitalize;
begin
  fWelcome.lInfo.Caption:='Создание класса для определения интервала стабильности...';
  CheckState:=TCheckState.Create(Buffer);
  Checkstate.LoadFromIni(ExtractFilePath(Application.exename)+'ControlParams.ini');
  CheckState.Initalize;
end;

procedure TfMain.miDebugInfoClick(Sender: TObject);
begin
 fDebugForm.ShowModal;
end;

procedure TfMain.CalcRegime;
begin
 case NPPUnit.Regim(Buffer) of
  rt_Unknown:sbState.Panels.Items[0].Text:='rt_Unknown';
  rtHot:sbState.Panels.Items[0].Text:='rtHot';
  rtN1_10:sbState.Panels.Items[0].Text:='rtN1_10';
  rtN10_100:sbState.Panels.Items[0].Text:='rtN10_100';
  end;

end;

procedure TfMain.InitalizeCheckState;
begin
 fWelcome.lInfo.Caption:='Инициализация объекта TCheckState для определения стабильного состояния РУ';

CheckState:=TCheckState.Create(Buffer);
Checkstate.LoadFromIni(ExtractFilePath(Application.exename)+'ControlParams.ini');
CheckState.Initalize;

end;

procedure TfMain.miAutoClick(Sender: TObject);
begin
 fAutoCalcSettings.eTime.Text:=IntToStr(TimeScheduler.Time );
 if fAutoCalcSettings.ShowModal=mrOk then
 begin
  //
 end;
end;

procedure TfMain.InitalizeCalcParam;
begin
  Screen.Cursor:=crSQLWait;
  fWelcome.lInfo.Caption:='Запрос к базе данных ...';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);
  CalcParams:=TCalcParams.Create;
  if CalcParams.LoadFromDB then
  begin
   fWelcome.lInfo.Caption:='Запрос к базе данных ...выполнен!';
   fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfMain.InitalizeGenTech;
begin
   Screen.Cursor:=crSQLWait;
  fWelcome.lInfo.Caption:='Запрос к базе данных по общетехнологическим параметрам...';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);
  GenTech:=TGenTech.Create;
  GenTech.LoadFromDB;
  fWelcome.lInfo.Caption:='Запрос к базе данных по общетехнологическим параметрам... выполнен!';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);
  fWelcome.lInfo.Caption:='Привязка информации по обработке к общетехнологическим параметрам...';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);
   GenTech.LinkCalcInfo(CalcParams);// привязка CalcParams к общетехнологическим параметрам
  fWelcome.lInfo.Caption:='Привязка общетехнологических параметров к расчетным значениям в буфере...';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);

   GenTech.LinkBuffer(Buffer);
  fWelcome.lInfo.Caption:='Привязка общетехнологических параметров к расчетным значениям в буфере...выполнено!';
  fDebugForm.Memo.Lines.Add(fWelcome.lInfo.Caption);

   Screen.Cursor:=crDefault;

end;

procedure TfMain.Panel1Click(Sender: TObject);
begin
 ShowPTKZ(1);
end;

procedure TfMain.ShowPTKZ(Nptkz: integer);
var i,j:integer;
begin
  case Nptkz of
  1:  fPTKZ.Caption:='ПТК-3 :: комплект 1:: канал 1';
  2:  fPTKZ.Caption:='ПТК-3 :: комплект 1:: канал 2';
  3:  fPTKZ.Caption:='ПТК-3 :: комплект 1:: канал 3';
  4:  fPTKZ.Caption:='ПТК-3 :: комплект 2:: канал 1';
  5:  fPTKZ.Caption:='ПТК-3 :: комплект 2:: канал 2';
  6:  fPTKZ.Caption:='ПТК-3 :: комплект 2:: канал 3';
  end;
  fPTKZ.Tag:=Nptkz;
  fPTKZ.StringGrid.RowCount:= GenTech.PTKZ[Nptkz].Count+1;
 for i:=0 to GenTech.PTKZ[Nptkz].Count-1 do
  with fPTKZ.StringGrid do
  begin

   Objects[1,i+1]:=GenTech.PTKZ[Nptkz].Params[i];
   Cells[0,i+1]:=GenTech.PTKZ[Nptkz].Params[i].Description.KKS;
   Cells[1,i+1]:=GenTech.PTKZ[Nptkz].Params[i].Description.Name;
   Cells[2,i+1]:=GenTech.PTKZ[Nptkz].Params[i].Description.MUnit;
   Cells[3,i+1]:=FloatToStr(GenTech.PTKZ[Nptkz].Params[i].CalcValue.Mean );
   Cells[4,i+1]:=FloatToStr(GenTech.PTKZ[Nptkz].Params[i].CalcValue.MSE );
   if GenTech.PTKZ[Nptkz].Params[i].Serviceable then
    Cells[5,i+1]:='Да' else Cells[5,i+1]:='Нет';

   if GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo<> nil then
   begin
    Cells[3,i+1]:=FloatToStrF(GenTech.PTKZ[Nptkz].Params[i].CalcValue.Mean,ffFixed,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision+3 ,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision );
    Cells[4,i+1]:=FloatToStrF(GenTech.PTKZ[Nptkz].Params[i].CalcValue.MSE,ffFixed,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision+3 ,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision );

    for j:=1 to 3 do
     begin
       if GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.ParallelChannel[j].Done then
       begin
         Cells[3+j*2+1,i+1]:=FloatToStrF(GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.ParallelChannel[j].Value,ffFixed,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision+3,GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.Precision);
         if GenTech.PTKZ[Nptkz].Params[i].CalcParamInfo.ParallelChannel[j].Valid then
           Cells[3+j*2+2,i+1]:='Да' else Cells[3+j*2+2,i+1]:='Нет';
       end
       else
       begin
         Cells[3+j*2+1,i+1]:=' - ';
         Cells[3+j*2+2,i+1]:=' - ';
       end;
     end;
    end;
   if GenTech.PTKZ[Nptkz].Params[i].Valid then
    Cells[12,i+1]:='Да' else Cells[12,i+1]:='Нет';
    Cells[13,i+1]:=GenTech.PTKZ[Nptkz].Params[i].Note;
  end;
  {if not fPTKZ.Visible then} fPTKZ.Show;
end;

procedure TfMain.Panel2Click(Sender: TObject);
begin
 ShowPTKZ(2);
end;

procedure TfMain.Panel3Click(Sender: TObject);
begin
 ShowPTKZ(3);
end;

procedure TfMain.Panel4Click(Sender: TObject);
begin
 ShowPTKZ(4);
end;

procedure TfMain.Panel5Click(Sender: TObject);
begin
 ShowPTKZ(5);
end;

procedure TfMain.Panel6Click(Sender: TObject);
begin
 ShowPTKZ(6);
end;

procedure TfMain.ColorIndicator;

 var i,j,k,CountCorrect,CountSens:integer;
begin
 for i:=1 to 6 do
   begin
    CountCorrect:=0;
    for j:=0 to GenTech.PTKZ[i].Count-1 do
    begin
     if GenTech.PTKZ[i].Params[j].Valid and
        GenTech.PTKZ[i].Params[j].Serviceable
      then inc(CountCorrect);
    end;
    PTKZPanel[i].Caption:=inttoStr(CountCorrect)+'/'+inttoStr(GenTech.PTKZ[i].Count);
    if CountCorrect<GenTech.PTKZ[i].Count then PTKZPanel[i].Color:=clYellow else PTKZPanel[i].Color:=clLime ;
 // проверка работоспособности комплекта стоек ПТК-З
 CountCorrect:=3;

 if fMain.panel1.Color=clYellow then dec(CountCorrect);
 if fMain.panel2.Color=clYellow then dec(CountCorrect);
 if fMain.panel3.Color=clYellow then dec(CountCorrect);
 if CountCorrect<2 then fMain.GroupBox1.Color:=clRed else fMain.GroupBox1.Color:=clGreen;
 CountCorrect:=3;
 if fMain.panel4.Color=clYellow then dec(CountCorrect);
 if fMain.panel5.Color=clYellow then dec(CountCorrect);
 if fMain.panel6.Color=clYellow then dec(CountCorrect);
 if CountCorrect<2 then fMain.GroupBox2.Color:=clRed else fMain.GroupBox2.Color:=clGreen;
 end;
// Температурный контроль
 CountCorrect:=0;
 CountSens:=0;
 for i:=1 to 4 do
  for j:=0 to TC.Loops[i].HotLeg.Count-1 do
  begin
    inc(CountSens);
    if TC.Loops[i].HotLeg.TC[j].Valid
       and TC.Loops[i].HotLeg.TC[j].Serviceable
       then inc(CountCorrect);
  end;
 for i:=1 to 4 do
  for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
  begin
    inc(CountSens);
    if TC.Loops[i].ColdLeg.TC[j].Valid
       and TC.Loops[i].ColdLeg.TC[j].Serviceable
       then inc(CountCorrect);
  end;
   for i:=0 to TC.CountKNIT-1 do
   begin
    inc(CountSens);
    if TC.KNIT[i].TP3.Valid and
       TC.KNIT[i].TP3.Serviceable then
       inc(CountCorrect);

    inc(CountSens);
    if TC.KNIT[i].TPA.Valid and
       TC.KNIT[i].TPA.Serviceable then
       inc(CountCorrect);

    inc(CountSens);
    if TC.KNIT[i].TPB.Valid and
       TC.KNIT[i].TPB.Serviceable then
       inc(CountCorrect);

    inc(CountSens);
    if TC.KNIT[i].TC.Valid and
       TC.KNIT[i].TC.Serviceable then
       inc(CountCorrect);
   end;
  if CountCorrect<CountSens then pTC.Color:=clYellow else pTC.Color:=clLime ;

 //токи ДПЗ
 CountCorrect:=0;
 CountSens:=0;
 for i:=1 to 54 do
  for j:=1 to 7 do
    if IDPZ.SVRD[i].DPZ[j].Description.ID<>-1 then
     begin
      inc(CountSens);
      if IDPZ.SVRD[i].DPZ[j].Valid and
         IDPZ.SVRD[i].DPZ[j].Serviceable then
         inc(CountCorrect);
     end;

   if CountCorrect<CountSens then pDPZ.Color:=clYellow else pDPZ.Color:=clLime ;


 end;


procedure TfMain.FilllvData(Buffer: TBuffer);
var  ListItem: TListItem;
     i:integer;
begin
 lvData.Hide;
 lvData.Items.Count:=Buffer.CountParam;
 for i:=0 to Buffer.CountParam-1 do
  begin
   ListItem:= lvData.Items.Add;
   ListItem.Caption:=Buffer.CalcValues[i].KKS;
  end;
 lvData.Show;
end;

procedure TfMain.lvDataNewData(Buffer: TBuffer);
var i:integer;
begin

 for i:=0 to Buffer.CountParam-1 do
 if lvData.Items.Item[i].SubItems.Count>1 then
 begin
  lvData.Items.Item[i].SubItems.Strings[0]:=floattoStr(buffer.LastValues[i].Value);
  if buffer.LastValues[i].Status=D_STATUS_UNDEF then
    lvData.Items.Item[i].SubItems.Strings[1]:='Не дост.'
   else
    lvData.Items.Item[i].SubItems.Strings[1]:='Дост.' ;
 end
 else
  begin
   lvData.Items.Item[i].SubItems.Add(floattoStr(buffer.LastValues[i].Value));
    if buffer.LastValues[i].Status=D_STATUS_UNDEF then
    lvData.Items.Item[i].SubItems.Add('Не дост.')
   else
    lvData.Items.Item[i].SubItems.Add('Дост.') ;
  end;
end;

procedure TfMain.InitalizeTC;
var LoopIni,KNITIni:TIniFile;
begin
  LoopIni:=TIniFile.Create(ExtractFilePath(Application.exename)+'TLoop.ini');
  KNITIni:=TIniFile.Create(ExtractFilePath(Application.exename)+'TKNIT.ini');
  TC:=TTC.Create(LoopIni,KNITIni);
  TC.LinkBuffer(Buffer);

end;

procedure TfMain.pTCClick(Sender: TObject);
begin
 fTCform.show;
 fTCform.ShowLoops(TC);
 fTCform.ShowTPKNIT(TC,fTCform.rgKNIT.ItemIndex);
end;

procedure TfMain.MakeNameNoteTable;
begin
 with fMain.sgNote do
 begin
  Cells[0,0]:='№';
  Cells[1,0]:='Код KKS';
  Cells[2,0]:='Название';
  Cells[3,0]:='Ед. изм.';
  Cells[4,0]:='Работоспособность';
  Cells[5,0]:='Достоверность';
  Cells[6,0]:='Причина';
 end;
 sgTemp:=TStringGrid.Create(fMain.sgNote);
 sgTemp.RowCount:=1;
 sgTemp.ColCount:=FMain.sgNote.ColCount;
 sgTemp.Rows[0].Assign(fMain.sgNote.Rows[0]);

 // заполнить заголовками таблицу "История сообщений"
  with fMain.sgLog do
 begin
  Cells[0,0]:='Время появления';
  Cells[1,0]:='Время исчезновения';
  Cells[2,0]:='Код KKS';
  Cells[3,0]:='Название';
  Cells[4,0]:='Ед. изм.';
  Cells[5,0]:='Работоспособность';
  Cells[6,0]:='Достоверность';
  Cells[7,0]:='Причина';
 end;

end;

procedure TfMain.ShowNoteParam;
var i,j,CountNote,k:integer;
    Changed,exist:boolean;
begin
if GenTech<>nil then
 with sgTemp do
 begin
 CountNote:=0;
 // сначала параметры по общей технологии
 for i:=1 to 6 do
   for j:=0 to GenTech.PTKZ[i].Count-1 do
    begin
      if GenTech.PTKZ[i].Params[j].CalcParamInfo<>nil then
        if not GenTech.PTKZ[i].Params[j].Serviceable or not GenTech.PTKZ[i].Params[j].Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=GenTech.PTKZ[i].Params[j].Description.KKS;
            Objects[1,CountNote]:=GenTech.PTKZ[i].Params[j];
            Cells[2,CountNote]:=GenTech.PTKZ[i].Params[j].Description.Name;
            Cells[3,CountNote]:=GenTech.PTKZ[i].Params[j].Description.MUnit;

        case GenTech.PTKZ[i].Params[j].Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case GenTech.PTKZ[i].Params[j].Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=GenTech.PTKZ[i].Params[j].Note;
       end;
    end;

  //теперь параметры по темоконтролю
  for i:=1 to 4 do
   for j:=0 to TC.Loops[i].HotLeg.Count-1 do
    begin
      if TC.Loops[i].HotLeg.TC[j].CalcParamInfo<>nil then
        if not TC.Loops[i].HotLeg.TC[j].Serviceable or not TC.Loops[i].HotLeg.TC[j].Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.Loops[i].HotLeg.TC[j].Description.KKS;
            Objects[1,CountNote]:=TC.Loops[i].HotLeg.TC[j];
            Cells[2,CountNote]:=TC.Loops[i].HotLeg.TC[j].Description.Name;
            Cells[3,CountNote]:=TC.Loops[i].HotLeg.TC[j].Description.MUnit;

        case TC.Loops[i].HotLeg.TC[j].Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.Loops[i].HotLeg.TC[j].Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.Loops[i].HotLeg.TC[j].Note;
       end;
    end;
  for i:=1 to 4 do
   for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
    begin
      if TC.Loops[i].ColdLeg.TC[j].CalcParamInfo<>nil then
        if not TC.Loops[i].ColdLeg.TC[j].Serviceable or not TC.Loops[i].ColdLeg.TC[j].Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.Loops[i].ColdLeg.TC[j].Description.KKS;
            Objects[1,CountNote]:=TC.Loops[i].ColdLeg.TC[j];
            Cells[2,CountNote]:=TC.Loops[i].ColdLeg.TC[j].Description.Name;
            Cells[3,CountNote]:=TC.Loops[i].ColdLeg.TC[j].Description.MUnit;

        case TC.Loops[i].ColdLeg.TC[j].Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.Loops[i].ColdLeg.TC[j].Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.Loops[i].ColdLeg.TC[j].Note;
       end;
    end;
    for i:=0 to 49 do
    if TC.KNIT[i].TP3.CalcParamInfo<>nil then
        if not TC.KNIT[i].TP3.Serviceable or not TC.KNIT[i].TP3.Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.KNIT[i].TP3.Description.KKS;
            Objects[1,CountNote]:=TC.KNIT[i].TP3;
            Cells[2,CountNote]:=TC.KNIT[i].TP3.Description.Name;
            Cells[3,CountNote]:=TC.KNIT[i].TP3.Description.MUnit;

        case TC.KNIT[i].TP3.Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.KNIT[i].TP3.Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.KNIT[i].TP3.Note;
       end;
    for i:=0 to 49 do
    if TC.KNIT[i].TPA.CalcParamInfo<>nil then
        if not TC.KNIT[i].TPA.Serviceable or not TC.KNIT[i].TPA.Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.KNIT[i].TPA.Description.KKS;
            Objects[1,CountNote]:=TC.KNIT[i].TPA;
            Cells[2,CountNote]:=TC.KNIT[i].TPA.Description.Name;
            Cells[3,CountNote]:=TC.KNIT[i].TPA.Description.MUnit;

        case TC.KNIT[i].TPA.Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.KNIT[i].TPA.Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.KNIT[i].TPA.Note;
       end;
    for i:=0 to 49 do
    if TC.KNIT[i].TPB.CalcParamInfo<>nil then
        if not TC.KNIT[i].TPB.Serviceable or not TC.KNIT[i].TPB.Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.KNIT[i].TPB.Description.KKS;
            Objects[1,CountNote]:=TC.KNIT[i].TPB;
            Cells[2,CountNote]:=TC.KNIT[i].TPB.Description.Name;
            Cells[3,CountNote]:=TC.KNIT[i].TPB.Description.MUnit;

        case TC.KNIT[i].TPB.Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.KNIT[i].TPB.Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.KNIT[i].TPB.Note;
       end;
    for i:=0 to 49 do
    if TC.KNIT[i].TC.CalcParamInfo<>nil then
        if not TC.KNIT[i].TC.Serviceable or not TC.KNIT[i].TC.Valid then
          begin
            inc(CountNote);
            RowCount:=CountNote+1;
            Cells[0,CountNote]:=DateTimeTostr(TimeScheduler.LastTime);
            Cells[1,CountNote]:=TC.KNIT[i].TC.Description.KKS;
            Objects[1,CountNote]:=TC.KNIT[i].TC;
            Cells[2,CountNote]:=TC.KNIT[i].TC.Description.Name;
            Cells[3,CountNote]:=TC.KNIT[i].TC.Description.MUnit;

        case TC.KNIT[i].TC.Serviceable of
          False: Cells[4,CountNote]:='Нет';
          True : Cells[4,CountNote]:='Да';
        end;
        case TC.KNIT[i].TC.Valid of
          False: Cells[5,CountNote]:='Нет';
          True : Cells[5,CountNote]:='Да';
        end;
        // заполнение столбца "Причина"
        Cells[6,countNote]:=TC.KNIT[i].TC.Note;
       end;
 end;
 //Changed:
 Changed:=not (sgTemp.RowCount=fMain.sgNote.RowCount);
 if not changed then
 for i:=1 to sgTemp.RowCount-1 do
   if sgTemp.Rows[i].GetText<>fMain.sgNote.Rows[i].GetText then Changed:=True;

 if Changed then
 begin
   fMain.sgNote.RowCount:=sgTemp.RowCount;
   for i:=1 to sgTemp.RowCount-1 do
    begin
     for j:=0 to sgTemp.ColCount-1 do
       fMain.sgNote.Cells[j,i]:=sgTemp.Cells[j,i];
     fMain.sgNote.Objects[1,i]:=sgTemp.Objects[1,i];
 end;
 fMain.lCountNote.Caption:=InttoStr(CountNote);

 AddToChartHistory;

//Добавление записей в ЛОГ (log)
 // сначала проверка, есть ли запись с данным KKS
 for i:=1 to fMain.sgNote.RowCount-1 do // по всем текущим сообщениям
 begin
   exist:=false;
   for j:=1 to fMain.sgLog.RowCount-1 do // по всем записям в Log
     if (fMain.sgLog.Cells[1,j]='') then
     if (fMain.sgNote.Cells[1,i]=fMain.sgLog.Cells[2,j] )then Exist:=True;
   if not exist then // добавление новой записи в ЛОГ
    begin
      fMain.sgLog.Rows[fMain.sgLog.RowCount-1].Strings[0]:=fMain.sgNote.Cells[0,i];
      for k:=2 to fMain.sgLog.ColCount-1 do
      fMain.sgLog.Rows[fMain.sgLog.RowCount-1].Strings[k]:=fMain.sgNote.Cells[k-1,i];
      fMain.sgLog.RowCount:=fMain.sgLog.RowCount+1;
    end;
 end;
 // Запись времени исчезновения сообщения
 for j:=1 to fMain.sgLog.RowCount-2 do
  if fMain.sgLog.Cells[1,j]='' then
   begin
     Exist:=False;
     for i:=1 to fMain.sgNote.RowCount-1 do
     if fMain.sgLog.Cells[2,j]=fMain.sgNote.Cells[1,i] then Exist:=True;
     if not exist then
     fMain.sgLog.Cells[1,j]:=DateTimeToStr(now);
   end;

 end;
end;

procedure TfMain.AddToChartHistory;
begin
 fMain.Series1.XValues.DateTime:=True;
 fMain.Series1.AddXY(TimeScheduler.LastTime,StrToInt(fMain.lCountNote.caption));
// fMain.chHistory.BottomAxis.Maximum:=fMain.Chart.BottomAxis.Maximum;
// fMain.chHistory.BottomAxis.Minimum:=fMain.Chart.BottomAxis.Minimum;
end;

procedure TfMain.pDPZClick(Sender: TObject);
begin
 ShowDPZ;
end;

procedure TfMain.SaveToArchive;
var i,j:integer;
begin
  // сначала ПТК-3
  for i:=1 to 6 do
   for j:=0 to GenTech.PTKZ[i].Count-1 do
   begin
    if GenTech.PTKZ[i].Params[j].Description.ID<>-1 then
    Save(Now,GenTech.PTKZ[i].Params[j]);
   end;

  // теперь ТС
  for i:=1 to 4 do
   for j:=0 to TC.Loops[i].HotLeg.Count-1 do
    if TC.Loops[i].HotLeg.TC[j].Description.ID<>-1 then
    Save(Now,TC.Loops[i].HotLeg.TC[j]);

  for i:=1 to 4 do
   for j:=0 to TC.Loops[i].ColdLeg.Count-1 do
    if TC.Loops[i].ColdLeg.TC[j].Description.ID<>-1 then
    Save(Now,TC.Loops[i].ColdLeg.TC[j]);
  for i:=1 to TC.CountKNIT-1 do
   if TC.KNIT[i].TP3.Description.ID<>-1 then
    Save(Now,TC.KNIT[i].TP3);
  for i:=1 to TC.CountKNIT-1 do
   if TC.KNIT[i].TPA.Description.ID<>-1 then
    Save(Now,TC.KNIT[i].TPA);
  for i:=1 to TC.CountKNIT-1 do
   if TC.KNIT[i].TPB.Description.ID<>-1 then
    Save(Now,TC.KNIT[i].TPB);
  for i:=1 to TC.CountKNIT-1 do
   if TC.KNIT[i].TC.Description.ID<>-1 then
    Save(Now,TC.KNIT[i].TC);
  //теперь токи ДПЗ
   for i:=1 to 7 do
  for j:=1 to 54 do
  begin
   if IDPZ.SVRD[j].DPZ[i].Description.ID<>-1 then
   Save(Now,IDPZ.SVRD[j].DPZ[i]);
 end;

end;

procedure TfMain.InitalizeDPZ;
var DPZini:TIniFile;
begin
  DPZini:=TIniFile.Create(ExtractFilePath(Application.exename)+'DPZ.ini');
  fWelcome.lInfo.Caption:='Привязка токов ДПЗ к расчетным значениям в буфере...';

  IDPZ:=TIDPZ.Create(DPZini);
  IDPZ.LinkBuffer(Buffer);

   GenTech.LinkBuffer(Buffer);
  fWelcome.lInfo.Caption:='Привязка токов ДПЗ к расчетным значениям в буфере...выполнено!';

end;

procedure TfMain.ShowDPZ;
var i,j:integer;
begin
 for i:=1 to 54 do
  for j:=1 to 7 do
  if IDPZ.SVRD[i].DPZ[j].Valid and IDPZ.SVRD[i].DPZ[j].Serviceable then
  fFormDPZ.sgDPZ.Cells[j,i]:='Ok' else
  begin
   if not IDPZ.SVRD[i].DPZ[j].Valid then fFormDPZ.sgDPZ.Cells[j,i]:='не дост.' else fFormDPZ.sgDPZ.Cells[j,i]:='';
   if not IDPZ.SVRD[i].DPZ[j].Serviceable then fFormDPZ.sgDPZ.Cells[j,i]:=fFormDPZ.sgDPZ.Cells[j,i]+' не работ.';
  end;
 fFormDPZ.Show; 
end;

procedure TfMain.pNClick(Sender: TObject);
begin
 fPowerCalcform.show;
 ShowN;
end;

procedure TfMain.InitalizeN;
var IniName:string;
    IniFile:TIniFile;
begin
 N:=TN.Create;
 IniName:=copy(Application.ExeName,1,length(Application.ExeName)-3)+'ini';
  Inifile:=TIniFile.Create(iniName);

// N.LoadRCPChar(Inifile.ReadString('RCPCharacteristics','FileName','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose3\1RCP.txt'));
 N.LoadRCPChar(Inifile.ReadString('ABC','FileName','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose3\gcn.dat'));
 N.QLosses:=IniFile.ReadFloat('N','Qlosses',2.8);
 N.S:=IniFile.ReadFloat('N','S',0.865);//проверить

 NIni:=TIniFile.Create(IniFile.ReadString('Nini','FileName','d:\Semenikhin\Develop_NVAES2\Diagnose\Diagnose3\N.ini'));

end;

procedure TfMain.ShowN;
var i:integer;
begin
 with fPowerCalcForm.Memo1.Lines do
 begin
 Clear;

 Add('-------First circle ----------');
   //проверка статуса значений, если статус недостоверно, то расчет N не возможен
  for i:=1 to 4 do
   begin
    if N.N1.Loops[i].Tcold.Status=Status_Invalid then
     Add('Т хол. нитки № '+InttoStr(i)+' не достоверно');
    if N.N1.Loops[i].THot.Status=Status_Invalid then
     Add('Т гор. нитки № '+InttoStr(i)+' не достоверно');
    if N.N1.Loops[i].dP.Status=Status_Invalid then
     Add('dP ГЦНА № '+InttoStr(i)+' не достоверно');
    if N.N1.Loops[i].freq.Status=Status_Invalid then
     Add('Частота питания ГЦНА № '+InttoStr(i)+' не достоверно');
   end;
  if N.N1.P.Status=Status_Invalid then
    Add('Давление над а.з. не достоверно');
  if N.N1.dP.Status=Status_Invalid then
    Add('Перепад давление на а.з. не достоверно');



 Add('N='+Floattostr(N.N1.Value.Value)+' Error '+Floattostr(N.N1.Value.Error));


 Add('N.P='+Floattostr(N.N1.P.Value));
 Add('N.dP='+Floattostr(N.N1.dP.Value));

 for i:=1 to 4 do
 begin
 Add(' ------- Loop'+Inttostr(i)+'---------------');

 Add('N '+Floattostr(N.N1.Loops[i].N.Value ) +' Error '+Floattostr(N.N1.Loops[i].N.Error ));
 Add('Hcold '+Floattostr(N.N1.Loops[i].hcold.Value ) +' Error '+Floattostr(N.N1.Loops[i].hcold.Error ));
 Add('Hhot '+Floattostr(N.N1.Loops[i].hhot.Value ) +' Error '+Floattostr(N.N1.Loops[i].hhot.Error ));
 Add('Ro '+Floattostr(N.N1.Loops[i].Ro.Value ) +' Error '+Floattostr(N.N1.Loops[i].Ro.Error ));
 Add('F '+Floattostr(N.N1.Loops[i].F.Value )+ ' Error = '+Floattostr(N.N1.Loops[i].F.Error ));
 Add('Freq '+Floattostr(N.N1.Loops[i].freq.Value ));
 Add('dP '+Floattostr(N.N1.Loops[i].dP.Value ));
 Add('deltaP '+Floattostr(N.N1.Loops[i].F.deltaP ));
 Add('A '+Floattostr(N.N1.Loops[i].F.A ));
 Add('B '+Floattostr(N.N1.Loops[i].F.B ));
 Add('C '+Floattostr(N.N1.Loops[i].F.C ));

 end;
{ Add('-------Second circle ----------');

 Add('N='+Floattostr(N.N2.Value.Value)+' Error '+Floattostr(N.N2.Value.Error));

 Add('N.QLCQ='+Floattostr(N.N2.QLCQ));
 Add('N.QRCP='+Floattostr(N.N2.QRCP));
 Add('N.QLosses='+Floattostr(N.Qlosses));
 Add('N.RoTarrir='+Floattostr(N.RoTarrir));

 for i:=1 to 4 do
 begin
 Add(' ------- Loop'+Inttostr(i)+'---------------');
 Add('N '+Floattostr(N.N2.Loops[i].N.Value )+' Error '+Floattostr(N.N2.Loops[i].N.Error));

 Add('Ffw '+Floattostr(N.N2.Loops[i].Ffw.Value )+' Error '+Floattostr(N.N2.Loops[i].Ffw.Error));
 Add('Pst '+Floattostr(N.N2.Loops[i].Pst.Value )+' Error '+Floattostr(N.N2.Loops[i].Pst.Error));
 Add('Tfw '+Floattostr(N.N2.Loops[i].Tfw.Value )+' Error '+Floattostr(N.N2.Loops[i].Tfw.Error));

 Add('H water '+Floattostr(N.N2.Loops[i].hwater.Value)+' Error '+Floattostr(N.N2.Loops[i].hwater.Error));
 Add('Hst '+Floattostr(N.N2.Loops[i].hst.Value )+' Error '+Floattostr(N.N2.Loops[i].hst.Error));
 Add('Hfw '+Floattostr(N.N2.Loops[i].hfw.Value )+' Error '+Floattostr(N.N2.Loops[i].hfw.Error));
 end;

 Add('----------------------');

 Add('N NFME= '+Floattostr(N.NNFME.Value));
 Add('N SPND= '+Floattostr(N.NDPZ.Value));

 Add('---------- PVD -----------');
 Add('Npvd '+Floattostr(N.Npvd.Value.Value)+' Error '+Floattostr(N.Npvd.Value.Error));
 Add('N st '+Floattostr(N.Npvd.Qst));
// Add('N (Glcq*Hst) '+Floattostr(N.Npvd.Qst));


 Add('-----Weigth calc by tools error -----------------');

  Add('W N1 '+Floattostr(N.N1.Omega));
  Add('W N2 '+Floattostr(N.N2.Omega));
  Add('W NSPND '+Floattostr(N.OmegaDPZ));
  Add('W NNFME '+Floattostr(N.OmegaNFME));
  Add('W NPVD '+Floattostr(N.Npvd.Omega));

 Add('-----Weigth calc by MRSE of  -----------------');

  Add('W N1 '+Floattostr(N.N1.W));
  Add('W N2 '+Floattostr(N.N2.W));
  Add('W NSPND '+Floattostr(N.WDPZ));
  Add('W NNFME '+Floattostr(N.WNFME));
  Add('W NPVD '+Floattostr(N.NPvd.W));
  }
 end;

end;

end.
