unit uWelcome;
//----------------------------------------------------------------------------------------
// Окно при загрузке программы
//02.04.2015 Автор: Семенихин А.В.
//
//----------------------------------------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, jpeg, ExtCtrls;

type
  TfWelcome = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    lInfo: TLabel;
    bCancel: TButton;
    procedure bCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fWelcome: TfWelcome;

implementation

uses uMain;

{$R *.dfm}

procedure TfWelcome.bCancelClick(Sender: TObject);
begin
 fMain.Close;
 fWelcome.Close;
end;

end.
