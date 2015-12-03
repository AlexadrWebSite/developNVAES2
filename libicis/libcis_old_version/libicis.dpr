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
      Id:integer;
      NVATE:String;
      end;
   Tlibicis= class(TObject)
                private
                  FClientName:ShortString;
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
                  property ClientName:ShortString read FClientName write FClientName;
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
begin
    lib:= Tlibicis.Create;
    f1:= TForm1.Create(nil);

    lib.ClientSocket.Name:= String(name);
end;

//�������� ������ ����������� � ����������
//���������� id ����������
function CreateChannel(ClientID:integer;IPAdress:Pchar;Port:integer;TypeChannel:integer;Options:integer):integer;cdecl;
begin
 // lib:= Tlibicis.Create;
 // f1:= TForm1.Create(nil);

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
var
   kksBuf: array[0..3] of byte; // ���������� � ������� id
   idKks:integer absolute kksBuf;
begin
   lib.ClientSocket.Socket.SendText('1'+KKS);
   Sleep(10);
   lib.ClientSocket.Socket.ReceiveBuf(kksBuf,sizeOf(kksBuf));
   if(idKks>0)and (idKks<100000) then
   begin
     //��������� ���� �� ����� kks � ������ � ���� ���, �� �������� � ������
     if(lib.findKKSInList(KKS)<0) then
     begin
       //���������� � ������
       lib.KKSList[lib.lenKKSList-1].Id:=idKks;
       lib.KKSList[lib.lenKKSList-1].NVATE:=KKS;

       Insert:=idKks;
     end
   end
   //���� id �� ������
   else
      begin
       lib.KKSList[lib.lenKKSList-1].Id:=-1;
       lib.KKSList[lib.lenKKSList-1].NVATE:=KKS;

       Insert:=-1;
      end;
    //���������� ����������� �������
    inc(lib.lenKKSList);
    SetLength(lib.KKSList,lib.lenKKSList);
end;

//������������� ������
procedure Subscribe(ClientID,GetID:integer); cdecl;
begin
//           f1.Show;
//  for i:=1 to N do
//  begin
//     lib.paramsRec[i].Id := 0;
//     lib.paramsRec[i].value:=0;
//     lib.paramsRec[i].status:=0;
//  end;
end;

//���������� ������ ������
function GetChannelStatus(ClientID,GetID:integer):integer;cdecl;
begin
  GetChannelStatus:=$02;
end;

//�������� ���� ������ � ��������� ��� ������ � paramsRec
procedure CopyLayer(ClientID,GetID:integer);cdecl;
var
  i,j,len:integer;
  buffs: array[0..8191] of byte;  //���������� �����
  buf: array[0..23] of byte;      // ���������� ������
  rec:TParam absolute buf;
begin
  //������ ������ ������
  SetLength(lib.paramsRec,0);
  //�������������� ������ ������
  lib.lenParamsRec:=1;
  SetLength(lib.paramsRec,lib.lenParamsRec);

  //������ � ������� �� ��������� ������
  lib.FClientSocket.Socket.SendText('2');
  Sleep(10);
  //��������� ���� ������
  while(lib.FClientSocket.Socket.ReceiveLength>0) do
  begin
    len:= lib.FClientSocket.Socket.ReceiveLength;
    lib.ClientSocket.Socket.ReceiveBuf(buffs,len);
    i:=0;

    //�������� �� ������ ���� ������ � ��������� �� � ������
    while(i<len-22) do
    begin
      for j:=0 to 23 do
      begin
        buf[j]:=buffs[i];
        i:=i+1;
      end;

      if rec.Id<=0 then
      begin
        rec.Id:=-1;
        rec.value:=-1;
        rec.status:=0;
      end;

      lib.paramsRec[lib.lenParamsRec-1]:=rec;
      inc(lib.lenParamsRec);
      SetLength(lib.paramsRec,lib.lenParamsRec);
      inc(current);
    end;
  end;
end;

//���������� �������� ��������� �� ��� Id, ���� id �� �������, �� ���������� -1
function GetFloat(ClientId,GetId,index:integer): real; cdecl;
var
  i:integer;
begin
    i:=1;
    while((i<lib.lenParamsRec) and  (lib.paramsRec[i].Id <> index))do inc(i);
    if((i<lib.lenParamsRec)and (lib.paramsRec[i].Id = index)) then
      GetFloat:=lib.paramsRec[i].value
    else
    GetFloat:=-1  
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
begin
  GetStatus:=0;
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
 {
function Tlibicis.Insert(ClientId:integer;GetID:integer;KKS:Pchar;XX:integer;YY:integer):integer;
var s:Pchar;
begin
 Result:=-1;
 FClientSocket.Socket.SendText('1'+KKS);
 s:=FClientSocket.Socket.ReceiveText;//ID KKS
 try
  result:=StrToInt(s);
 except
  MessageDlg('������ ��������� ID ��� ����: '+KKS,mtError,[mbOk],0);
 end;
end;    }

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

