unit uDebugForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Clipbrd;

type
  TfDebugForm = class(TForm)
    Memo: TMemo;
    bClose: TButton;
    bCopy: TButton;
    procedure bCloseClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDebugForm: TfDebugForm;

implementation

{$R *.dfm}

procedure TfDebugForm.bCloseClick(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TfDebugForm.bCopyClick(Sender: TObject);
begin
 Clipboard.SetTextBuf( memo.Lines.GetText);
end;

end.
