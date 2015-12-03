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
   Tlibicis= class(TObject)
                private
                  FClientSocket:TClientSocket;
                protected

                public
                  constructor Create;
                  destructor Destroy;
                published

                end;
var
  lib:Tlibicis;
  f1: TForm1;
  currentIndex,current:integer;
  //инициализация подключения и переменных
  //возвращает id клиента

function InitModLib(name:Pchar): integer; cdecl;
begin

end;

//создание канала подключения и переменных
//возвращает id соединения
function CreateChannel(ClientID:integer;IPAdress:Pchar;Port:integer;TypeChannel:integer;Options:integer):integer;cdecl;
begin
end;

//получение id по kks нваэс
//возвращает id для переданного kks
function Insert(ClientId:integer;GetID:integer;KKS:Pchar;XX:integer;YY:integer):integer;cdecl;
begin

end;

//инициализация данных
procedure Subscribe(ClientID,GetID:integer); cdecl;
var
begin
end;

//возвращает статус канала
function GetChannelStatus(ClientID,GetID:integer):integer;cdecl;
begin
  GetChannelStatus:=$02;
end;

procedure CopyLayer(ClientID,GetID:integer);cdecl;
begin

end;

//возвращает значение параметра по его Id, если id не найдено, то возвращает -1
function GetFloat(ClientId,GetId,index:integer): real; cdecl;
begin

end;

// окончание работы с данным соеденением
procedure Unsubscribe(ClientId,GetId:integer); cdecl;
begin

end;

procedure ShutdownModLib(clientId:integer);  cdecl;
begin

end;

function GetStatus( ClientID:integer; ChannelID:integer;ParamID:integer):integer;cdecl;
begin

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


begin

end.

