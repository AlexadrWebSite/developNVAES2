library libicis;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  ScktComp,
  Dialogs,
  log4d,
  dllForm in 'dllForm.pas' {Form1};

{$R *.res}
type
  TDetector = record
      localId:integer;
      serverId:integer;
      KKS:string;
      value:double;
      status:byte;
      end;
var
  clientSocket: TClientSocket;
  f1: TForm1;
  //����������� �� ����������
  isOpenConnection:boolean;
  //������ �� ���� ��������
  detectorList: array of TDetector;
  //����� ������� ��������
  lenDetectorList:integer;
  //���
  logger:TLogLogger;

//����� ������� ������� �� ��������� idServer
function findIndexByServerID(index:integer):integer; cdecl;
var
  i:integer;
begin
  i:=0;
  while (i<lenDetectorList) and (detectorList[i].serverId<>index) do inc(i);
  if (i<lenDetectorList) and (detectorList[i].serverId=index) then findIndexByServerID:=i
  else findIndexByServerID:=-1;
end;

//����� ������� ������� �� ��������� localId
function findIndexByLocalID(index:integer):integer; cdecl;
var
  i:integer;
begin
  i:=0;
  while (i<lenDetectorList) and (detectorList[i].localId<>index) do inc(i);
  if (i<lenDetectorList) and (detectorList[i].localId=index) then findIndexByLocalID:=i
  else findIndexByLocalID:=-1;
end;

function InitModLib(name:Pchar): integer; cdecl;
begin
     clientSocket := clientSocket.Create(nil);
     f1:= TForm1.Create(nil);

     TLogBasicConfigurator.Configure;
     TLogLogger.GetRootLogger.Level:= All;
     logger := TLogLogger.GetLogger('myLogger');
     logger.AddAppender(TLogFileAppender.Create('filelogger','log4d.log'));
     logger.Debug('initializing logging');

     clientSocket:=f1.clientSocket2;
   //������������� ������� ��������
      lenDetectorList:=0;
      SetLength(detectorList,lenDetectorList);
      InitModLib:=1;
end;

//�������� ������ ����������� � ����������
//���������� id ����������
function CreateChannel(ClientID:integer;IPAdress:Pchar;Port:integer;TypeChannel:integer;Options:integer):integer;cdecl;
begin
  logger.Debug('start create channel');
  //������������� ����������
  clientSocket.Address:=IPAdress;
  clientSocket.Port:=port;
  //�������� ����������
  try
      clientSocket.Open;
      isOpenConnection:=true;
  Except
     isOpenConnection:=false;
  end;
  CreateChannel:=1;
  logger.Debug('close create channel');
end;

//���������� ��������� id ��� ����������� kks
function Insert(ClientId:integer;GetID:integer;KKS:Pchar;XX:integer;YY:integer):integer;cdecl;
begin
    logger.Debug('start insert');
  //���� ���������� �����������
   if(isOpenConnection) then
   begin
      //��������� ������ � ������ � ��������� ��� localid
      lenDetectorList:=lenDetectorList+1;
      SetLength(detectorList,lenDetectorList);
      detectorList[lenDetectorList-1].KKS:=string(kks);
      detectorList[lenDetectorList-1].localId:=lenDetectorList;
      Insert:= lenDetectorList;
      logger.Debug('insert id = ' + IntToStr(lenDetectorList));
   end
    else
    begin
      ShowMessage('���������� �� ������������');
      Insert:=-1;
    end;
    logger.Debug('close insert');
end;

//�������� id � ������� � ������ � ������������ � ��������� id
procedure Subscribe(ClientID,GetID:integer); cdecl;
var
  i,position:integer;
  countGet:integer;
  sendStr,getStr:string;
begin
      logger.Debug('start Subscribe');
  //���� ���������� �����������
   if(isOpenConnection) then
   begin
      //��������� �� kks ��� ��������� serverId
      sendStr:=IntToStr(lenDetectorList-1)+#9;
      for i:=0 to lenDetectorList-1 do
         sendStr:=sendStr+detectorList[i].KKS+#9;
      logger.Debug('send - ' + sendStr);
      //���������� ������ �� ������
      clientSocket.Socket.SendText(sendStr);
      Sleep(10);

      //�������� ������ � servId
      getStr:= clientSocket.Socket.ReceiveText;
     // logger.Debug('subscribe = ' + getstr);
      //��������� ���������� ���������� �������
      countGet:=StrToInt(Copy(getStr,1,Pos(#9,getStr)));
      logger.Debug('count - '+ IntToStr(countGet));
      getStr:= Copy(getStr,Pos(#9,getStr),Length(getStr)- Pos(#9,getStr));
      logger.Debug('str - '+ getStr);
      if(countGet<>0) then
      begin
        //��������� ��� id
        i:=0;
        while((Length(getStr)>0) and (i<countGet)) do
        begin
          position:= Pos(#9,getStr);
          //�������� ���� id �� ������ � ��������� ��� � ������
          detectorList[i].serverId:= StrToInt(Copy(getStr,1,position));
          //������� �� ������ ��� id
          getStr:= Copy(getStr,position+1,Length(getStr)-position);
          logger.Debug('id = ' + IntToStr(detectorList[i].localId)+ ' serverid = ' +IntToStr(detectorList[i].serverId) );
          inc(i);
        end;
        if(i<countGet) then ShowMessage('�������� �� ��� id �������');
      end
        else
        begin
            ShowMessage('������ ��� ��������� id � �������');
            logger.Debug('�� ������� id');
        end;
   end
       else
    begin
      ShowMessage('���������� �� ������������');
    end;
    logger.Debug('close Subscribe');
end;

//���������� ������ ������
function GetChannelStatus(ClientID,GetID:integer):integer;cdecl;
begin
//���� ���������� �����������
if(isOpenConnection) then
  GetChannelStatus:=$02
else
  GetChannelStatus:=0;
end;

procedure CopyLayer(ClientID,GetID:integer);cdecl;
var
  i,index,position,getCount:integer;
  getStr,detectorStr,valueStr:string;
  valD:double;
  valI:integer;
begin
logger.Debug('start CopyLayer');
   //���� ���������� �����������
   if(isOpenConnection) then
   begin
     //��������� ������ �� ������
     clientSocket.Socket.SendText('2');
     Sleep(10);

     //�������� ��� �������� ����������
     getStr:=clientSocket.Socket.ReceiveText;
              logger.Debug('CopyLayer = ' + getStr);
     //�������� ���������� ����������
     position:= Pos(#9,getStr);
     getCount:= StrToInt(Copy(getStr,1,position));
     getStr:= Copy(getStr,position+1,Length(getStr)-position);

     //�������� ��� ���������
     i:=1;
     while((i<getCount) and(Length(getStr)>1)) do
     begin
       //�������� �������� ������ �������
       position:=Pos(#9,getStr);
       if(position>0) then
       begin
        detectorStr:=Copy(getStr,1,position);
        //�������� ������ ���� "id value status"
        //������� �� ��� ��� ��������

        //������� id
        position:= Pos(' ',getStr);
        valueStr:= Copy(detectorStr,1,position);

        //������� �� ������
        detectorStr:= Copy(detectorStr,position+1, Length(detectorStr)-position);
        valI:=StrToInt(valueStr);
        //�������� index �� serverId
        index := findIndexByServerID(valI);

        //�������� value �� ������
        position:= Pos(' ',getStr);
        valueStr:= Copy(detectorStr,1,position);

        //������� �� ������
        detectorStr:= Copy(detectorStr,position+1, Length(detectorStr)-position);
        valD:=StrToFloat(valueStr);
        detectorList[index].value:=valD;

        //�������� status �� ������
        valueStr:= Copy(detectorStr,1,Length(valueStr));
        valI:=StrToInt(valueStr);
        detectorList[index].status:=valI;

        //������� ��� ���������
        getStr:=Copy(getStr,position+1,Length(getStr)-position);
       end
        else getStr:='';
        inc(i);
     end;

   end
       else
    begin
      ShowMessage('���������� �� ������������');
    end;
        logger.Debug('close CopyLayer');
end;

//���������� �������� ��������� �� ��� Id, ���� id �� �������, �� ���������� -1
function GetFloat(ClientId,GetId,index:integer): real; cdecl;
var
  i:integer;
begin
  //���� ���������� �����������
   if(isOpenConnection) then
   begin
     i:=findIndexByLocalID(index);
     GetFloat:= detectorList[i].value;
   end
       else
    begin
      ShowMessage('���������� �� ������������');
      GetFloat:= -1;
    end;
end;

//���������� ������ ��������� �� ��� Id, ���� id �� �������, �� ���������� -1
function GetStatus( ClientID:integer; ChannelID:integer;ParamID:integer):integer;cdecl;
var
  i:integer;
begin
  //���� ���������� �����������
   if(isOpenConnection) then
   begin
      i:=findIndexByLocalID(ParamID);
      GetStatus:=detectorList[i].status;
   end
       else
    begin
      ShowMessage('���������� �� ������������');
      GetStatus:=7;
    end;
end;

// ��������� ������ � ������ �����������
procedure Unsubscribe(ClientId,GetId:integer); cdecl;
begin
  //���� ���������� �����������
   if(isOpenConnection) then
   begin
     clientSocket.Close;
     isOpenConnection:=false;
   end
       else
    begin
      ShowMessage('���������� �� ������������');
    end;
end;

procedure ShutdownModLib(clientId:integer);  cdecl;
begin

end;

exports
 InitModLib,
 CreateChannel,
 Insert,
 Subscribe,
 GetChannelStatus,
 CopyLayer,
 GetFloat,
 Unsubscribe,
 ShutdownModLib,
 GetStatus;

begin

end.

