program Server;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  uNetSend in 'uNetSend.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
