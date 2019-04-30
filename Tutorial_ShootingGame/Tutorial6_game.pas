unit Tutorial6_game;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm2 = class(TForm)
    Rectangle_bg1: TRectangle;
    Rectangle_bg2: TRectangle;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    Rectangle4_missile: TRectangle;
    Rectangle3_player: TRectangle;
    Button_upClick: TButton;
    Button_dwnClick: TButton;
    Button_missile: TButton;
    FloatAnimation_playerY: TFloatAnimation;
    FloatAnimation_mssleX: TFloatAnimation;
    Button: TButton;
    FloatAnimation_playerX: TFloatAnimation;
    Rectangle_enm1: TRectangle;
    BitmapAnimation_enm1: TBitmapAnimation;
    Timer1_enm: TTimer;
    FloatAnimation_enm1: TFloatAnimation;
    Rectangle_enm2: TRectangle;
    BitmapAnimation_enm2: TBitmapAnimation;
    FloatAnimation_enm2: TFloatAnimation;
    Rectangle_enm3: TRectangle;
    BitmapAnimation_enm3: TBitmapAnimation;
    FloatAnimation_enm3: TFloatAnimation;
    Timer1_enmAtck: TTimer;
    Rectangle_enmAtck: TRectangle;
    FloatAnimation_enmAtck: TFloatAnimation;
    Timer1_overlap: TTimer;
    Label1_score: TLabel;
    Rectangle3_title: TRectangle;
    Text1_start: TText;
    ColorAnimation_start: TColorAnimation;
    Rectangle_gameover: TRectangle;
    Text2_gameover: TText;
    ColorAnimation_gameover: TColorAnimation;
    Label1_lastscore: TLabel;
    procedure FloatAnimation2Finish(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure Button_upClickClick(Sender: TObject);
    procedure Button_dwnClickClick(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure Button_missileClick(Sender: TObject);
    procedure FloatAnimation_mssleXFinish(Sender: TObject);
    procedure FloatAnimation_enm1Finish(Sender: TObject);
    procedure Timer1_enmTimer(Sender: TObject);
    procedure FloatAnimation_enm2Finish(Sender: TObject);
    procedure FloatAnimation_enm3Finish(Sender: TObject);
    procedure FloatAnimation_playerXFinish(Sender: TObject);
    procedure Text1_startClick(Sender: TObject);
    procedure Timer1_enmAtckTimer(Sender: TObject);
    procedure FloatAnimation_enmAtckFinish(Sender: TObject);
    procedure Timer1_overlapTimer(Sender: TObject);
    procedure Rectangle_gameoverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { private �錾 }
    procedure GameReset;

  public
    { public �錾 }
  end;

var
  Form2: TForm2;
  RectEnmBuf: TRectangle=nil; //enemy which is nearest to player.
  PlayScore: Integer=0;
  PlayTime: TDateTime=0;

const
  MISSILE_MAX: Single = 900;

implementation

{$R *.fmx}

procedure TForm2.ButtonClick(Sender: TObject);
begin
  ShowMessage(Rectangle3_player.Position.Y.ToString+' '+Self.Height.ToString+' '+Rectangle3_player.Height.ToString);
end;

procedure TForm2.Button_missileClick(Sender: TObject);
//Declaration
var
  i: Integer;
  enm_buf:      TRectangle;
  enm_x_temp:   Single;
  enm_x_stop:   Single;
  //iEnX:         Single;

   //Check whether the enemy is front of player and missile hit the enemy.
   function EnmExit(enm: TRectangle): Single;
    begin
      Result := MISSILE_MAX;

      if enm.Visible and (enm.Position.X > (Rectangle3_player.Position.X + Rectangle3_player.Width)) then
        if   ((enm.Position.Y <= Rectangle4_missile.Position.Y)
          and (enm.Position.Y+(enm.Height*enm.Scale.Y) >= Rectangle4_missile.Position.Y)) then

      begin
        Result := enm.Position.X;
      end;

    end;
//Procedure Start
begin
  Button_missile.Enabled           := False;
  FloatAnimation_mssleX.StartValue := Rectangle3_player.Position.X+60;
  FloatAnimation_mssleX.StopValue  := MISSILE_MAX;
  Rectangle4_missile.Position.Y    := Rectangle3_player.Position.Y+25;
  enm_x_stop := MISSILE_MAX;
  //iEnX       := MISSILE_MAX;

  //For deciding FloatAnimation_mssleX.StopValue
  for i := 0 to 2 do   //Check each enmy
  begin
    case i of
    0:enm_buf := Rectangle_enm1;
    1:enm_buf := Rectangle_enm2;
    2:enm_buf := Rectangle_enm3;
    end;

    enm_x_temp := EnmExit(enm_buf);
    //Deside enemy nearest to player.
    if (enm_x_temp < MISSILE_MAX) and (enm_x_temp < enm_x_stop)  then
    begin
      enm_x_stop   := enm_x_temp;
      RectEnmBuf   := enm_buf;
    end;

    //In case of enemy exists which is hit by missile.
    //if Assigned(rect_enm_buf) then
      //iEnX := rect_enm_buf.Position.X;

  end;

  FloatAnimation_mssleX.StopValue  := enm_x_stop;

  //Missile animation starts.
  Rectangle4_missile.Visible       := True;
  FloatAnimation_mssleX.Start
end;

procedure TForm2.Button_dwnClickClick(Sender: TObject);
begin
  FloatAnimation_playerY.StartValue := Rectangle3_player.Position.Y;
  if Rectangle3_player.Position.Y+50 < (Self.ClientHeight - Rectangle3_player.Height-50) then
    FloatAnimation_playerY.StopValue := Rectangle3_player.Position.Y + 50
  else
    FloatAnimation_playerY.StopValue := Self.ClientHeight - Rectangle3_player.Height;
  FloatAnimation_playerY.Start;
end;

procedure TForm2.Button_upClickClick(Sender: TObject);
begin
  FloatAnimation_playerY.StartValue := Rectangle3_player.Position.Y;
  if Rectangle3_player.Position.Y-50 > 0 then
    FloatAnimation_playerY.StopValue := Rectangle3_player.Position.Y - 50
  else
    FloatAnimation_playerY.StopValue := 0;
  FloatAnimation_playerY.Start;
end;

procedure TForm2.FloatAnimation1Finish(Sender: TObject);
begin
  case Round(Rectangle_bg1.Position.X) of
      0:
      begin
        FloatAnimation1.StartValue :=0;
        FloatAnimation1.StopValue  :=-Self.Width;
      end;
      else
      begin
        FloatAnimation1.StartValue :=Self.Width;
        FloatAnimation1.StopValue  :=0;
      end;
  end;
  FloatAnimation1.Start;
end;

procedure TForm2.FloatAnimation2Finish(Sender: TObject);
begin
  case Round(Rectangle_bg2.Position.X) of
    0:
    begin
      FloatAnimation2.StartValue :=0;
      FloatAnimation2.StopValue  :=-Self.Width;
    end;
    else
    begin
      FloatAnimation2.StartValue :=Self.Width;
      FloatAnimation2.StopValue  :=0;
    end;
  end;
  FloatAnimation2.Start;
end;

procedure TForm2.FloatAnimation_enm1Finish(Sender: TObject);
begin
  Rectangle_enm1.Visible := False;
end;

procedure TForm2.FloatAnimation_enm2Finish(Sender: TObject);
begin
  Rectangle_enm2.Visible := False;
end;

procedure TForm2.FloatAnimation_enm3Finish(Sender: TObject);
begin
  Rectangle_enm3.Visible := False;
end;

procedure TForm2.FloatAnimation_enmAtckFinish(Sender: TObject);
begin
  Rectangle_enmAtck.Visible := False;
end;

procedure TForm2.FloatAnimation_mssleXFinish(Sender: TObject);
begin
  Rectangle4_missile.Visible := False;
  Button_missile.Enabled     := True;
  if Assigned(RectEnmBuf) then
  begin
    PlayScore := PlayScore + 1;
    RectEnmBuf.Visible := False;
  end;

  RectEnmBuf := nil;

end;

//Player Operation Start
procedure TForm2.FloatAnimation_playerXFinish(Sender: TObject);
begin
  Timer1_enm.Enabled := True;
  Timer1_enmAtck.Enabled := True;
  Timer1_overlap.Enabled := True;
  PlayTime := Now;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  GameReset;
end;

procedure TForm2.Text1_startClick(Sender: TObject);
begin
  Rectangle3_player.Visible := True;
  Rectangle3_title.Visible  := False;
  FloatAnimation_playerX.Start;
end;

procedure TForm2.Timer1_enmAtckTimer(Sender: TObject);
var
  numEnmy: Integer;

  procedure LaserStart(enm: TRectangle);
  begin
    if (not Rectangle_enmAtck.Visible) and (enm.Visible) then
    begin
      Rectangle_enmAtck.Position.Y      := (enm.Position.Y + (enm.Height/2));
      Rectangle_enmAtck.Visible         := True;
      FloatAnimation_enmAtck.StartValue := (enm.Position.x - Rectangle_enmAtck.Width);
      FloatAnimation_enmAtck.StopValue  := FloatAnimation_enmAtck.StartValue - (Self.Width+50);
      FloatAnimation_enmAtck.Start;
    end;
  end;

begin

  numEnmy := Random(4);
  case numEnmy of
  1:LaserStart(Rectangle_enm1);
  2:LaserStart(Rectangle_enm2);
  3:LaserStart(Rectangle_enm3);
  end;

  Label1_score.Text := Format('Time %s / Total Score %0.9d',
                        [FormatDateTime('hh:nn:ss',Now - PlayTime), PlayScore]);

end;

procedure TForm2.Timer1_enmTimer(Sender: TObject);
var
  numEnmy: Integer;
  posyEnmy: Integer;

  procedure EnmStart(enm: TRectangle; ani: TFloatAnimation; bani: TBitmapAnimation);
  begin
    if not enm.Visible then
    begin
      enm.Position.Y := posyEnmy;
      enm.Visible    := True;
      ani.StartValue := Self.Width+10;
      ani.StopValue  := -Self.Width-10;
      ani.Start;
      bani.Start;
    end;
  end;

begin
  numEnmy  := Random(5);
  posyEnmy := Random(Self.ClientHeight-100);
  case numEnmy of
    1:EnmStart(Rectangle_enm1, FloatAnimation_enm1, BitmapAnimation_enm1);
    2:EnmStart(Rectangle_enm2, FloatAnimation_enm2, BitmapAnimation_enm2);
    3:EnmStart(Rectangle_enm3, FloatAnimation_enm3, BitmapAnimation_enm3);
  end;
end;

procedure TForm2.Timer1_overlapTimer(Sender: TObject);
var
  i: Integer;
  atari: Boolean;

  //Hit detection
  function overlap(rect1, rect2: TRectangle): Boolean;
  var
    rectf1, rectf2: TRectF;
  begin

    Result := False;
    if rect2.Visible then
    begin

      rectf1 := TRectF.Create(rect1.Position.X, rect1.Position.Y,

        rect1.Position.X + rect1.Width, rect1.Position.Y + rect1.Height);

      rectf2 := TRectF.Create(rect2.Position.X, rect2.Position.Y,

        rect2.Position.X + rect2.Width, rect2.Position.Y + rect2.Height);

      if(rectf1.Left   < rectf2.Right) and
        (rectf1.Right  > rectf2.Left) and
        (rectf1.top    < rectf2.Bottom) and
        (rectf1.Bottom > rectf2.top) then
      begin
        Result := True;
      end

    end

  end;

begin
  atari                  := False;
  Timer1_overlap.Enabled := False;
  for i := 0 to 3 do
  case i of
  0:
    begin
    atari := overlap(Rectangle3_player, Rectangle_enm1);
    if atari then
    break;
    end;
  1:
    begin
    atari := overlap(Rectangle3_player, Rectangle_enm2);
    if atari then
    break;
    end;
  2:
    begin
    atari := overlap(Rectangle3_player, Rectangle_enm3);
    if atari then
    break;
    end;
  3:
    begin
    atari := overlap(Rectangle3_player, Rectangle_enmAtck);
    if atari then
    break;
    end;
  end;

  if atari then
  begin
    Rectangle3_player.Visible := False;
    Rectangle_gameover.Visible   := True;
    Label1_lastscore.Text := Label1_score.Text;
    //ShowMessage('Game Over');
    //GameReset;
  end
  else
  begin
    Timer1_overlap.Enabled     := True
  end

end;

procedure TForm2.GameReset;
begin
  Rectangle3_player.Visible := False;
  Rectangle4_missile.Visible := False;

  Timer1_enm.Enabled         := False;
  Timer1_enmAtck.Enabled     := False;
  Timer1_overlap.Enabled     := False;
  Rectangle_enm1.Visible     := False;
  Rectangle_enm2.Visible     := False;
  Rectangle_enm3.Visible     := False;
  Rectangle_enmAtck.Visible  := False;
  Rectangle_gameover.Visible := False;
  Rectangle3_title.Visible   := True;
end;

procedure TForm2.Rectangle_gameoverClick(Sender: TObject);
begin
  GameReset;
end;

end.
