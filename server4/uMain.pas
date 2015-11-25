unit uMain;
//------------------------------------------------------------------------------
//Имитатор сервер СВРК для подключения mbcli.dll - чтение онлайн данных
//22.02.2013 Автор: Семенихин А.В.
//16.07.2014 - модификация - посылка изменненых данных через строку
//------------------------------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,ScktComp,ComCtrls, TeeProcs, TeEngine,
   Chart, Series, TeeTools,
  //Ниже перечисленны написанные мной units
  uFEP_File,uCommon, Grids,uStringOperation,uNetSend ;

type
  TfMain = class(TForm)
    bbOpen: TBitBtn;
    Timer: TTimer;
    OpenDialog: TOpenDialog;
    pbLoading: TProgressBar;
    lStart: TLabel;
    lEnd: TLabel;
    lCur: TLabel;
    Label1: TLabel;
    cbParam: TComboBox;
    Chart: TChart;
    Series1: TLineSeries;
    ChartTool1: TCursorTool;
    lProcess: TLabel;
    sgModeBus: TStringGrid;
    Memo1: TMemo;
    ServerSocket: TServerSocket;
    lValue: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure bbOpenClick(Sender: TObject);
    procedure cbParamChange(Sender: TObject);
    procedure ChartTool1Change(Sender: TCursorTool; x, y: Integer;
      const XValue, YValue: Double; Series: TChartSeries;
      ValueIndex: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);

  private

    { Private declarations }
  public
    { Public declarations }
     Params:TStrings;
     IndexArray:array of integer;
     CountIndex:integer;
     procedure Subscribe;
     function SendValues():String;
     procedure GetParams(s:string);
     procedure SendParams(s:string);
  end;
  TParam = record
      Id:integer;
      value:real;
      time:string;
      status:integer;
      end;
var
  fMain: TfMain;

  FEPFile:TFEPFile;
  Data: TValueArray;
  SendData:TSendData;
  ReadFileInfo:TReadFileInfo;
  FilesFormatSettings:TFormatSettings;
  CurPosition:double;// текущее положение на шкале времени
  PATH:string;
  TXT,Codes:TextFile;
  Busher_NV2:array of array [0..3] of String;
  procedure GetLastTimeValues(CurPosition:double);

  procedure ShowLastValues;
  procedure LoadKKS;

implementation




{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
begin
  path:=ExtractFilePath(Application.ExeName);
  AssignFile(TXT,PATH+'\ExpFile.txt');

  AssignFile(Codes,PATH+'\Codes.txt');
  LoadKKS;
  Params:=TStringList.Create;
  SendData:=TSendData.Create;
  ServerSocket.Active:=True;
end;

procedure TfMain.TimerTimer(Sender: TObject);
var i:integer;
begin
 CurPosition:=CurPosition+1;
 if CurPosition>pbLoading.Max then
 begin
   Timer.Enabled:=False;
   MessageDlg('Данные закончились!',mtInformation,[mbOk],0);
 end;
 ChartTool1.XValue:=CurPosition;
 GetLastTimeValues(CurPosition);
 if SendData.Initilized then
  begin
   SendData.NewSendData(Data);
   Memo1.Lines.Add(IntToStr(ServerSocket.Socket.ActiveConnections));
//   for i:=0 to ServerSocket.Socket.ActiveConnections-1 do
//     ServerSocket.Socket.Connections[i].SendText(SendData.SendStr);
  end;
 lCur.Caption:='Текущ. полож: '+intToStr(Round(ChartTool1.xvalue));
 ShowLastValues;
{ Rewrite(Txt);
 for i:=0 to FEPFile.CountFields-1 do
 WriteLn(txt,FloattoStr(Data[i].Value));
 CloseFile(txt);
 WinExec(PAnsiChar('cmd.exe /c copy /y '+PATH+'\ExpFile.txt '+PATH+'\Data.txt'),0);
 }
 lValue.Caption:=SendData.SendStr;
end;

procedure TfMain.bbOpenClick(Sender: TObject);
var i,j,k,Count:integer;
    FieldFepInfo:TFieldFEPInfo;
Found:boolean;
begin
if OpenDialog.Execute then
begin
// set up euro date time format
    GetLocaleFormatSettings(sysutils.Languages.LocaleID[0],FilesFormatSettings);
     FilesFormatSettings.LongDateFormat:='dd.mm.yyyy';
     FilesFormatSettings.ShortDateFormat:='dd.mm.yy';
     FilesFormatSettings.LongTimeFormat:= 'hh:mm:ss.zzz';
     FilesFormatSettings.ShortTimeFormat:= 'hh:mm:ss.zzz';
     FilesFormatSettings.DecimalSeparator:='.';
     FilesFormatSettings.DateSeparator:='.';
     FilesFormatSettings.TimeSeparator:=':';
 
// ---------
 lProcess.Caption:='Загрузка '+inttoStr(OpenDialog.Files.Count)+' файлов';
 ReadFileInfo:=TReadFileInfo.Create;
 FEPFile:=TFEPFile.Create;
 for i:=0 to OpenDialog.Files.Count-1 do
 ReadFileInfo.Add(OpenDialog.Files.Strings[i]);
 for i:=0 to ReadFileInfo.CountFiles-1 do
  for j:=0 to ReadFileInfo.FileInfo[i].CountFields-1 do
  begin
   k:=0;
  while (k<(Length(Busher_NV2)-1)) and (Busher_NV2[k][0]<>ReadFileInfo.FileInfo[i].FieldInfo[j].KKS) do inc(k);
  if (Busher_NV2[k][0]=ReadFileInfo.FileInfo[i].FieldInfo[j].KKS) then
  begin
   FieldFepInfo:= ReadFileInfo.FileInfo[i].FieldInfo[j];
   FieldFepInfo.Checked:=True;
   ReadFileInfo.FileInfo[i].FieldInfo[j]:=FieldFepInfo;
  end;
  end;
// ReadFileInfo.CheckAll;
 FEPFile.LoadFiles(ReadFileInfo,pbLoading);
 pbLoading.Max:=Round((FEPFile.EndTime-FEPFile.StartTime)*86400);
 SetLength(Data,FEPFile.CountFields);
 sgModeBus.RowCount:=FEPFile.CountFields+1;
 for i:=1 to sgModeBus.RowCount-1 do
 sgModeBus.Rows[i].Clear;
 sgModeBus.Cells[0,0]:='Значение';
 sgModeBus.Cells[1,0]:='KKS Бушер';
 sgModeBus.Cells[2,0]:='KKS НВАЭС-2';
 sgModeBus.Cells[3,0]:='Наименование';
 sgModeBus.Cells[4,0]:='Ед. изм.';
 for i:=0 to FEPFile.CountFields-1 do
 begin
  sgModeBus.Cells[1,i+1]:=FEPFile.Data[i].FieldInfo.KKS;
//  sgModeBus.Cells[2,i+1]:=FEPFile.Data[i].FieldInfo.Name;
  j:=0;
  while (j<(Length(Busher_NV2)-1)) and (Busher_NV2[j][0]<>sgModeBus.Cells[1,i+1]) do inc(j);
  if Busher_NV2[j][0]=sgModeBus.Cells[1,i+1] then
   begin
    sgModeBus.Cells[2,i+1]:=Busher_NV2[j][1];
    sgModeBus.Cells[3,i+1]:=Busher_NV2[j][2];
    sgModeBus.Cells[4,i+1]:=Busher_NV2[j][3];
   end;
 end;
 Rewrite(Codes);
 for i:=0 to FEPFile.CountFields-1 do
 if sgModeBus.Cells[2,i+1]<>'' then
 Writeln(Codes,sgModeBus.Cells[2,i+1]);
 CloseFile(Codes);

 pbLoading.Hide;

 lStart.Caption:='0 сек.';
 lEnd.Caption:=InttoStr( round((FepFile.EndTime - FepFile.StartTime)*86400))+' сек.';
 cbParam.Items.Clear;
 for i:=0 to FEPFile.CountFields-1 do
 cbParam.Items.Add(FepFile.Data[i].FieldInfo.KKS+' '+FepFile.Data[i].FieldInfo.Name+' '+FepFile.Data[i].FieldInfo.MUnit);
 if cbParam.Items.Count>0 then cbParam.ItemIndex:=0;
 cbParamChange(self);
 GetLastTimeValues(0);
 Timer.Enabled:=True;

end;
end;

procedure TfMain.cbParamChange(Sender: TObject);
var i:integer;
begin
 Series1.Clear;
 if FEPFile.CountFields>0 then
 for i:=0 to FEPFile.Data[cbParam.ItemIndex].Count-1 do
 series1.AddXY((FEPFile.Data[cbParam.ItemIndex].Data[i].DateTime-FEPFile.StartTime)*86400,FEPFile.Data[cbParam.ItemIndex].Data[i].Value);
end;

procedure TfMain.ChartTool1Change(Sender: TCursorTool; x, y: Integer;
  const XValue, YValue: Double; Series: TChartSeries; ValueIndex: Integer);
begin
 CurPosition:=ChartTool1.XValue;
 if FEPFIle<>nil then
 GetLastTimeValues(CurPosition);
 lCur.Caption:='Текущ. полож: '+intToStr(Round(ChartTool1.xvalue));
end;


procedure GetLastTimeValues(CurPosition:double);
var i,j:integer;
begin
 for i:=0 to FEPFile.CountFields-1 do
   if ((FEPFIle.Data[i].Data[0].DateTime-FEPFIle.StartTime)*86400)<=CurPosition
    then
     begin
      j:=0;
      while (j<FEPFIle.Data[i].Count) and
       (((FEPFIle.Data[i].Data[j].DateTime-FEPFIle.StartTime)*86400)<=CurPosition)
       do
       begin
         Data[i].Value:=FEPFIle.Data[i].Data[j].Value;
         Data[i].DateTime:=FEPFIle.Data[i].Data[j].DateTime;
         Data[i].Status:=FEPFIle.Data[i].Data[j].Status;
         inc(j);
       end;
     end;
end;

procedure ShowLastValues;
var i:integer;
begin
 for i:=0 to FEPFile.CountFields-1 do
  fMain.sgModeBus.Cells[0,i+1]:=FloattoStr(Data[i].Value);
end;

procedure LoadKKS;
var i:integer;
    tf:textFile;
    s,substr:string;
begin


 AssignFile(tf,Path+'\KKS_Busher_NV.txt');
 Reset(tf);
 while not eof(tf) do
 begin
  ReadLn(tf,s);
  SetLength(Busher_NV2,Length(Busher_NV2)+1);
  for i:=0 to 3 do
   begin
    GetFirstSubStr(Substr,s,#9);
    Busher_NV2[Length(Busher_NV2)-1][i]:=Substr;
   end;
 end;
 CloseFile(tf);
end;

procedure TfMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
  var l,cs:integer;
  ClientName,s,ParamName:string;
begin
  l := Socket.ReceiveLength;
  s:=Socket.ReceiveText;
  if length(s)>=1 then
  begin
//  cs:=StrtoInt(s[1]);
    case s[1] of
      '0': begin memo1.Lines.Add('Client name: '+copy(s,2,l-1));Params.Clear; end;
      '1': begin  SendParams(s) end;
      '2': begin memo1.Lines.Add('<Subscribe>'); SendValues;  end;
    end;
  end;
end;

//ищет все параметры в таблице и отправляет их
procedure TfMain.Subscribe;
var i,j:integer;
    s:string;
begin
  s:='0';
  SetLength(IndexArray,0);
  CountIndex:=0;
  SendData.Clear;
  for i:=0 to Params.Count-1 do
  begin
   j:=1;
   while (j<sgModeBus.RowCount-1) and
    (Params.Strings[i]<>sgModeBus.Cells[2,j]) do
    inc(j);
    case Params.Strings[i]=sgModeBus.Cells[2,j] of
    False: s:=s+#9+IntToStr(-1);
    True : begin s:=s+#9+IntToStr(j); SendData.AddNewIndex(j);end;
    end;
  end;

  //отправка параметров
 for i:=0 to ServerSocket.Socket.ActiveConnections-1 do
  ServerSocket.Socket.Connections[i].SendText(s);

  SendData.Initalize(data);
  //Params.Clear;

end;


procedure TfMain.GetParams(s: string);
var
i:integer;
SubStr:string;
begin
  if Length(s)>1 then
  if s[1]='1' then
  begin
   s:=copy(s,2,Length(s)-1);
   while GetFirstSubStr(SubStr,s,#9) do
    Params.Add(SubStr);
  end;
end;

 procedure TfMain.SendParams(s:string);
 var
   i,retValue:integer;
   retBuf:array[0..3] of byte absolute retValue;
   returnString:string;
 begin
   if Length(s)>1 then
   if s[1]='1' then
  begin
    s:=copy(s,2,Length(s)-1);
   //получение KKS бушера по KKS НВАЭС
   i:=1;
   while (i<sgModeBus.RowCount-1) and
    (s<>sgModeBus.Cells[2,i]) do inc(i);
    if(i<sgModeBus.RowCount) and(s=sgModeBus.Cells[2,i]) then
     retValue:= i
     else    retValue:=-1;
     Params.Add(IntToStr(retValue));
    // отправка
    for i:=0 to ServerSocket.Socket.ActiveConnections-1 do
    begin
     ServerSocket.Socket.Connections[i].SendBuf(retBuf,SizeOf(retBuf));
    // memo1.Lines.Add(IntToStr(sizeOf(retBuf)));
     end;
  end;
 end;

function TfMain.SendValues():String;
 var
  i,j,k:integer;
  s:string;
  param:TParam;
  buf:array [0..23] of byte absolute param;
begin
  s:='';
  for i:=0 to Params.Count-1 do
  begin
   j:=1;
// Memo1.Lines.Add(Params.Strings[i]+' params');
 //  while (j<sgModeBus.RowCount-1)and(Params.Strings[i]<>sgModeBus.Cells[2,j]) do
   // inc(j);
   j:=StrToInt(Params.Strings[i]);
     if(j>0) then
     begin
       param.Id:=j;
       param.value:= StrToFloat(sgModeBus.Cells[0,j]);
       param.status:= 0;
     end
     else
     begin
     param.Id:=-1;
       param.value:= StrToFloat('-1');
       param.status:= 0;
     end;
             //отправка параметров
      for k:=0 to ServerSocket.Socket.ActiveConnections-1 do
         ServerSocket.Socket.Connections[k].SendBuf(buf,SizeOf(buf));
         SendData.Initalize(data);
        // Memo1.Lines.Add(IntToStr(Params.Count-1));

    //  s:=s+sgModeBus.Cells[2,j]+';'+sgModeBus.Cells[0,j]+';'+TimeToStr(Time)+';1#9';

  end;

end;

procedure TfMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
 i:integer;
begin
  Memo1.Lines.Add(Socket.RemoteAddress+ ' - adress');
end;

procedure TfMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Params.Clear;
end;

end.

