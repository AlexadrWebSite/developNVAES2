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
  //установлено ли соединение
  isOpenConnection:boolean;
  //массив из всех датчиков
  detectorList: array of TDetector;
  //длина массива датчиков
  lenDetectorList:integer;
  //лог
  logger:TLogLogger;

//поиск индекса массива по заданному idServer
function findIndexByServerID(index:integer):integer; cdecl;
var
  i:integer;
begin
  i:=0;
  while (i<lenDetectorList) and (detectorList[i].serverId<>index) do inc(i);
  if (i<lenDetectorList) and (detectorList[i].serverId=index) then findIndexByServerID:=i
  else findIndexByServerID:=-1;
end;

//поиск индекса массива по заданному localId
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
   //инициализация массива датчиков
      lenDetectorList:=0;
      SetLength(detectorList,lenDetectorList);
      InitModLib:=1;
end;

//создание канала подключения и переменных
//возвращает id соединения
function CreateChannel(ClientID:integer;IPAdress:Pchar;Port:integer;TypeChannel:integer;Options:integer):integer;cdecl;
begin
  logger.Debug('start create channel');
  //инициализация соединения
  clientSocket.Address:=IPAdress;
  clientSocket.Port:=port;
  //открытие соединения
  try
      clientSocket.Open;
      isOpenConnection:=true;
  Except
     isOpenConnection:=false;
  end;
  CreateChannel:=1;
  logger.Debug('close create channel');
end;

//возвращает локальное id для переданного kks
function Insert(ClientId:integer;GetID:integer;KKS:Pchar;XX:integer;YY:integer):integer;cdecl;
begin
    logger.Debug('start insert');
  //если соединение установлено
   if(isOpenConnection) then
   begin
      //добавляем датчик в массив и назначаем ему localid
      lenDetectorList:=lenDetectorList+1;
      SetLength(detectorList,lenDetectorList);
      detectorList[lenDetectorList-1].KKS:=string(kks);
      detectorList[lenDetectorList-1].localId:=lenDetectorList;
      Insert:= lenDetectorList;
      logger.Debug('insert id = ' + IntToStr(lenDetectorList));
   end
    else
    begin
      ShowMessage('Соединение не установленно');
      Insert:=-1;
    end;
    logger.Debug('close insert');
end;

//получает id с сервера и ставит в соответствии с локальным id
procedure Subscribe(ClientID,GetID:integer); cdecl;
var
  i,position:integer;
  countGet:integer;
  sendStr,getStr:string;
begin
      logger.Debug('start Subscribe');
  //если соединение установлено
   if(isOpenConnection) then
   begin
      //формируем из kks для получения serverId
      sendStr:=IntToStr(lenDetectorList-1)+#9;
      for i:=0 to lenDetectorList-1 do
         sendStr:=sendStr+detectorList[i].KKS+#9;
      logger.Debug('send - ' + sendStr);
      //отправляем строку на сервер
      clientSocket.Socket.SendText(sendStr);
      Sleep(10);

      //получаем строку с servId
      getStr:= clientSocket.Socket.ReceiveText;
     // logger.Debug('subscribe = ' + getstr);
      //считывает количество полученных записей
      countGet:=StrToInt(Copy(getStr,1,Pos(#9,getStr)));
      logger.Debug('count - '+ IntToStr(countGet));
      getStr:= Copy(getStr,Pos(#9,getStr),Length(getStr)- Pos(#9,getStr));
      logger.Debug('str - '+ getStr);
      if(countGet<>0) then
      begin
        //считываем все id
        i:=0;
        while((Length(getStr)>0) and (i<countGet)) do
        begin
          position:= Pos(#9,getStr);
          //получаем одно id из строки и добавляем его в массив
          detectorList[i].serverId:= StrToInt(Copy(getStr,1,position));
          //удаляем из строки это id
          getStr:= Copy(getStr,position+1,Length(getStr)-position);
          logger.Debug('id = ' + IntToStr(detectorList[i].localId)+ ' serverid = ' +IntToStr(detectorList[i].serverId) );
          inc(i);
        end;
        if(i<countGet) then ShowMessage('получены не все id сервера');
      end
        else
        begin
            ShowMessage('ошибка при получении id с сервера');
            logger.Debug('не получен id');
        end;
   end
       else
    begin
      ShowMessage('Соединение не установленно');
    end;
    logger.Debug('close Subscribe');
end;

//возвращает статус канала
function GetChannelStatus(ClientID,GetID:integer):integer;cdecl;
begin
//если соединение установлено
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
   //если соединение установлено
   if(isOpenConnection) then
   begin
     //отправить запрос на сервер
     clientSocket.Socket.SendText('2');
     Sleep(10);

     //получить все значения параметров
     getStr:=clientSocket.Socket.ReceiveText;
              logger.Debug('CopyLayer = ' + getStr);
     //получить количество параметров
     position:= Pos(#9,getStr);
     getCount:= StrToInt(Copy(getStr,1,position));
     getStr:= Copy(getStr,position+1,Length(getStr)-position);

     //получить все параметры
     i:=1;
     while((i<getCount) and(Length(getStr)>1)) do
     begin
       //получаем значение одного датчика
       position:=Pos(#9,getStr);
       if(position>0) then
       begin
        detectorStr:=Copy(getStr,1,position);
        //выделили строку типа "id value status"
        //выделим из нее все значения

        //получим id
        position:= Pos(' ',getStr);
        valueStr:= Copy(detectorStr,1,position);

        //удаляем из строки
        detectorStr:= Copy(detectorStr,position+1, Length(detectorStr)-position);
        valI:=StrToInt(valueStr);
        //получаем index по serverId
        index := findIndexByServerID(valI);

        //получаем value из строки
        position:= Pos(' ',getStr);
        valueStr:= Copy(detectorStr,1,position);

        //удаляем из строки
        detectorStr:= Copy(detectorStr,position+1, Length(detectorStr)-position);
        valD:=StrToFloat(valueStr);
        detectorList[index].value:=valD;

        //получаем status из строки
        valueStr:= Copy(detectorStr,1,Length(valueStr));
        valI:=StrToInt(valueStr);
        detectorList[index].status:=valI;

        //удаляем эти показания
        getStr:=Copy(getStr,position+1,Length(getStr)-position);
       end
        else getStr:='';
        inc(i);
     end;

   end
       else
    begin
      ShowMessage('Соединение не установленно');
    end;
        logger.Debug('close CopyLayer');
end;

//возвращает значение параметра по его Id, если id не найдено, то возвращает -1
function GetFloat(ClientId,GetId,index:integer): real; cdecl;
var
  i:integer;
begin
  //если соединение установлено
   if(isOpenConnection) then
   begin
     i:=findIndexByLocalID(index);
     GetFloat:= detectorList[i].value;
   end
       else
    begin
      ShowMessage('Соединение не установленно');
      GetFloat:= -1;
    end;
end;

//возвращает статус параметра по его Id, если id не найдено, то возвращает -1
function GetStatus( ClientID:integer; ChannelID:integer;ParamID:integer):integer;cdecl;
var
  i:integer;
begin
  //если соединение установлено
   if(isOpenConnection) then
   begin
      i:=findIndexByLocalID(ParamID);
      GetStatus:=detectorList[i].status;
   end
       else
    begin
      ShowMessage('Соединение не установленно');
      GetStatus:=7;
    end;
end;

// окончание работы с данным соеденением
procedure Unsubscribe(ClientId,GetId:integer); cdecl;
begin
  //если соединение установлено
   if(isOpenConnection) then
   begin
     clientSocket.Close;
     isOpenConnection:=false;
   end
       else
    begin
      ShowMessage('Соединение не установленно');
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

