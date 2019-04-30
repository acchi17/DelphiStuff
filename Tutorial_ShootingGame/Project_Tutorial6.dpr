program Project_Tutorial6;

uses
  System.StartUpCopy,
  FMX.Forms,
  Tutorial6_game in 'Tutorial6_game.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
