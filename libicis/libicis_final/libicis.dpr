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
  dllForm in 'dllForm.pas' {Form1};

{$R *.res}
  type
  TParam = record
      Id:integer;
      value:real;
      status:byte;
      end;
  TKKS = record
      localId:integer;
      serverId:integer;
      NVATE:String;
      end;
   Tlibicis= class(TObject)
                private
                  FClientSocket:TClientSocket;
                  //������ ������� �������� ���� ������������� ��������� - ��������
                  paramsRec: array of TParam;
                  //����� ������� paramsRec
                  lenParamsRec:integer;
                  //������ �� KKS ������
                  KKSList:array of TKKS;
                  //����� ������� KKSList
                  lenKKSList:integer;
                protected

                public
                  property ClientSocket:TClientSocket read FClientSocket write FClientSocket;
                  //function Insert(ClientId:integer;GetID:integer;KKS:ShortString;XX:integer;YY:integer):integer;
                  //����� ������� �������� �� kks, ���� �������� �� -1
                  function findKKSInList(kks:string):integer;
                  constructor Create;
                  destructor Destroy;
                published

                end;
var
  lib:Tlibicis;
  f1: TForm1;
  currentIndex,current:integer;
  //������������� ����������� � ����������
  //���������� id �������

function InitModLib(name:Pchar): integer; cdecl;
var
  getId:integer;
begin
    getId:=1;
    lib:= Tlibicis.Create;
    f1:= TForm1.Create(nil);
    lib.ClientSocket.Name:= String(name);
    InitModLib:=getId;
end;

//�������� ������ ����������� � ����������
//���������� id ����������
function CreateChannel(ClientID:integer;IPAdress:Pchar;Port:integer;TypeChannel:integer;Options:integer):integer;cdecl;
begin
  //������������� ����������
  lib.ClientSocket :=f1.clientSocket2;
  lib.ClientSocket.Port:=Port;
  lib.ClientSocket.ClientType:= ctNonBlocking;
  lib.ClientSocket.Address:=string(IPAdress);
  lib.ClientSocket.Active:=true;
  current:=1;
  currentIndex:=1;
  CreateChannel :=1;

  //������������� ������������ ��������
  lib.lenParamsRec:=1;
  SetLength(lib.paramsRec,lib.lenParamsRec);
  lib.lenKKSList:=1;
  SetLength(lib.KKSList,lib.lenKKSList);
end;

//��������� id �� kks �����
//���������� id ��� ����������� kks
function Insert(ClientId:integer;GetID:integer;KKS:Pchar;XX:integer;YY:integer):integer;cdecl;
begin

       //���������� � ������
       lib.KKSList[lib.lenKKSList-1].localId:=lib.lenKKSList;
       lib.KKSList[lib.lenKKSList-1].NVATE:=KKS;
       //���������� ����������� �������
       inc(lib.lenKKSList);
       SetLength(lib.KKSList,lib.lenKKSList);
       Insert:=lib.lenKKSList-1;
end;

//������������� ������
procedure Subscribe(ClientID,GetID:integer); cdecl;
var
  i:integer;
  kksBuf: array[0..3] of byte; // ���������� � ������� id
   idKks:integer absolute kksBuf;
begin
   for i:=0 to lib.lenKKSList-1 do
   begin
     lib.ClientSocket.Socket.SendText('1'+lib.kksList[i].NVATE);
     Sleep(10);
     lib.ClientSocket.Socket.ReceiveBuf(kksBuf,sizeOf(kksBuf));
     if idKks>0 then
       begin
       //���������� � ������
       lib.KKSList[i].serverId:=idKks;
       end
   end;
end;

//���������� ������ ������
function GetChannelStatus(ClientID,GetID:integer):integer;cdecl;
begin
  GetChannelStatus:=$02;
end;

procedure CopyLayer(ClientID,GetID:integer);cdecl;
var
  i,j,k:integer;
  rec:TParam;
  str,num:string;
begin
   str:='';

   //������ ������ ������
   SetLength(lib.paramsRec,0);
  //�������������� ������ ������
  lib.lenParamsRec:=1;
  SetLength(lib.paramsRec,lib.lenParamsRec);
  //������ � ������� �� ��������� ������
  lib.FClientSocket.Socket.SendText('2');
  Sleep(10);

  str:= lib.FClientSocket.Socket.ReceiveText;
  sleep(10);
  while(lib.FClientSocket.Socket.ReceiveLength>0) do
  begin
    str:= str + lib.FClientSocket.Socket.ReceiveText;
    sleep(5);
  end;

  while(Length(str)>3) do
  begin
    //��������� id
    num:= Copy(str,1,Pos(' ',str)-1);
    rec.Id:= StrToInt(num);
    str:= Copy(str,Pos(' ',str)+1,length(str) - length(num));
    //��������� value
    num:= Copy(str,1,Pos(' ',str)-1);
    rec.value:= StrToFloat(num);
    str:= Copy(str,Pos(' ',str)+1,length(str) - length(num));
    //��������� status
    num:= Copy(str,1,Pos(' ',str)-1);
    rec.status:= StrToInt(num);
    str:= Copy(str,Pos(' ',str)+1,length(str) - length(num));

    lib.paramsRec[lib.lenParamsRec-1]:=rec;
    inc(lib.lenParamsRec);
    SetLength(lib.paramsRec,lib.lenParamsRec);
  end;
end;

//���������� �������� ��������� �� ��� Id, ���� id �� �������, �� ���������� -1
function GetFloat(ClientId,GetId,index:integer): real; cdecl;
var
  i,j,serverid:integer;
begin
    i:=0;
    if(index<1) then getFloat:=-2
    else
    begin
      //���� idserver �� ���������� id
      while((i<lib.lenKKSList-1) and  (lib.KKSList[i].localId <> index))do inc(i);
      // logger.Debug('id = '+IntToStr(index) + ' value = ' + FloatToStr(lib.paramsRec[i].value));
      if((i<lib.lenKKSList-1) and (lib.KKSList[i].localId = index)) then
        begin
          serverid:= lib.kksList[i].serverId;
          //���� �������� �� idserver
          j:=0;
          while((j<lib.lenParamsRec-1) and(lib.paramsRec[j].Id<>serverid)) do inc(j);
        if((j<lib.lenParamsRec-1) and (lib.paramsRec[j].Id = serverid)) then
           GetFloat:=lib.paramsRec[j].value
           else GetFloat:=-1;
        end
      else
      GetFloat:=-1;
    end;

end;

// ��������� ������ � ������ �����������
procedure Unsubscribe(ClientId,GetId:integer); cdecl;
begin
  //�������� ����������
  lib.ClientSocket.Socket.SendText('0');
  //��������� ���� ������
  lib.lenParamsRec:=0;
  lib.lenKKSList:=0;
  SetLength(lib.paramsRec,lib.lenParamsRec);
  SetLength(lib.KKSList,lib.lenKKSList);
  //�������� ����������
  Lib.ClientSocket.Active := false;
end;

procedure ShutdownModLib(clientId:integer);  cdecl;
begin

end;
function GetStatus( ClientID:integer; ChannelID:integer;ParamID:integer):integer;cdecl;
var
  i,j,serverid:integer;
begin
    i:=0;
    if(ParamID<1) then GetStatus:=7
    else
    begin
      //���� idserver �� ���������� id
      while((i<lib.lenKKSList-1) and  (lib.KKSList[i].localId <> ParamID))do inc(i);
      if((i<lib.lenKKSList-1) and (lib.KKSList[i].localId = ParamID)) then
        begin
          serverid:= lib.kksList[i].serverId;
          //���� �������� �� idserver
          j:=0;
          while((j<lib.lenParamsRec-1) and(lib.paramsRec[j].Id<>serverid)) do inc(j);
        if((j<lib.lenParamsRec-1) and (lib.paramsRec[j].Id = serverid)) then
           GetStatus:=lib.paramsRec[j].status
           else GetStatus:=7;
        end
      else
      GetStatus:=7;
    end;
end;

exports
 CreateChannel,
 Insert,
 Subscribe,
 GetChannelStatus,
 CopyLayer,
 GetFloat,
 Unsubscribe,
 InitModLib,
 ShutdownModLib,
 GetStatus;
{ Tlibicis }

constructor Tlibicis.Create;
begin
 inherited Create;
 FClientSocket:=TClientSocket.Create(nil);
end;

destructor Tlibicis.Destroy;
begin
 inherited Destroy;
end;


//����� KKS � �������
function Tlibicis.findKKSInList(kks:string):integer;
var
  j:integer;
begin
  j:=1;
  while((j<lib.lenKKSList) and(kks<>lib.KKSList[j].NVATE)) do inc(j);
  if(j<lib.lenKKSList) then findKKSInList:=j
  else findKKSInList:=-1;
end;


begin

end.

