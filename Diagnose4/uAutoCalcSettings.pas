unit uAutoCalcSettings;
//----------------------------------------------------------------------------------------
// Окно для настройки автоматическхи проверок
//
// Автор: Семенихин А.В. semenikhinav@mail.ru
// Дата создания: 13/04/2015
//----------------------------------------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfAutoCalcSettings = class(TForm)
    Label1: TLabel;
    eTime: TEdit;
    bOk: TButton;
    bCancel: TButton;
    Image1: TImage;
    procedure bOkClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAutoCalcSettings: TfAutoCalcSettings;

implementation

{$R *.dfm}

procedure TfAutoCalcSettings.bOkClick(Sender: TObject);
begin
 ModalResult:=mrOk;
end;

procedure TfAutoCalcSettings.bCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
