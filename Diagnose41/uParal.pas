unit uParal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls;

type
  TfParal = class(TForm)
    leMask: TLabeledEdit;
    sgParal: TStringGrid;
    bClose: TButton;
    procedure bCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fParal: TfParal;

implementation

{$R *.dfm}

procedure TfParal.bCloseClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

end.
