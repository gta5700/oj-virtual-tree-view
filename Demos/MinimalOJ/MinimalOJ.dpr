program MinimalOJ;

uses
  Forms,
  MainOJ in 'MainOJ.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

