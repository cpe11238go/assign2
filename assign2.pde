//State
final int START = 0;
final int PLAY  = 1;
final int WIN   = 2;
final int LOSE  = 3;
int NowState = START;

//Player
float PlayerX;
float PlayerY;
float PlayerSpeed = 5;
boolean upPressed    = false;
boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;
int PlayerHp = 20;

//Background 
float BGX1 = 0;
float BGX2 = 0;
float BGSpeed = 3;

//Emeny
float EnemyX = 0;
float EnemyY = 0;
float EnemySpeed = 4;

//Treasure
float TreasureX = 0;
float TreasureY = 0;

//Picture
PImage start1;
PImage start2;
PImage bg1;
PImage bg2;
PImage fighter;
PImage enemy;
PImage hp;
PImage treasure;
PImage end1;
PImage end2;

//Distance
float PEDX = 0;    //The distance from Player to Enemy
float PEDY = 0;
float PTDX = 0;    //The distance from Player to treasure
float PTDY = 0;
float max = 0;
float min = 0;

void setup () 
{
  //Picture Load
  start1    = loadImage("img/start1.png");
  start2    = loadImage("img/start2.png");
  bg1       = loadImage("img/bg1.png");
  bg2       = loadImage("img/bg2.png");
  fighter   = loadImage("img/fighter.png");
  enemy     = loadImage("img/enemy.png");
  hp        = loadImage("img/hp.png");
  treasure  = loadImage("img/treasure.png");
  end1      = loadImage("img/end1.png");
  end2      = loadImage("img/end2.png");
  
  //Interface
  size(640, 480) ;
  image(start1,0,0);
}

void draw() 
{
  switch (NowState)
  {
    case START:
      if(mouseX>205 && mouseX<460 && mouseY>375 && mouseY<415)
      {
        image(start1,0,0);
        if(mousePressed)            
        {
          //Reset Player location 
          PlayerX = width - 50;
          PlayerY = height/2;
          
          //Reset Background location
          BGX2 = BGX2-width;
          
          //Reset Enemy location
          EnemyY = random(height-50);
          
          //Reset Treasure location
          TreasureX = random(width-50);
          TreasureY = random(height-50);
          
          NowState = PLAY;
        }
      }
      else
        image(start2,0,0);
      break;
    case PLAY:
      //Background 
      image(bg1,BGX1,0);
      image(bg2,BGX2,0);
      BGX1 += BGSpeed;
      BGX2 += BGSpeed;
      if(BGX1>width)
        BGX1 = 0-width;
      if(BGX2>width)
        BGX2 = 0-width;
        
      //Player HP
      colorMode(RGB);
      fill(255,0,0);
      switch (PlayerHp)
      {
        case 100:
        {
          rect(5,5,200,23);
          break;
        }
        case 90:
        {
          rect(5,5,180,23);
          break;
        }
        case 80:
        {
          rect(5,5,160,23);
          break;
        }
        case 70:
        {
          rect(5,5,140,23);
          break;
        }
        case 60:
        {
          rect(5,5,120,23);
          break;
        }
        case 50:
        {
          rect(5,5,100,23);
          break;
        }
        case 40:
        {
          rect(5,5,80,23);
          break;
        }
        case 30:
        {
          rect(5,5,60,23);
          break;
        }
        case 20:
        {
          rect(5,5,40,23);
          break;
        }
        case 10:
        {
          rect(5,5,20,23);
          break;
        }
      }
      image(hp,0,0);
      
      //Player move
      if (upPressed) 
        PlayerY -= PlayerSpeed;
      if (downPressed) 
        PlayerY += PlayerSpeed;
      if (leftPressed) 
        PlayerX -= PlayerSpeed;
      if (rightPressed) 
        PlayerX += PlayerSpeed;
      
      // boundary detection
      if(PlayerX>width-50)
        PlayerX=width-50;
      if(PlayerX<0)
        PlayerX=0;
      if(PlayerY>height-50)
        PlayerY=height-50;
      if(PlayerY<0)
        PlayerY=0;
      
      //Player Location
      image(fighter,PlayerX,PlayerY);
        
      //Enemy
      image(enemy,EnemyX,EnemyY);
      EnemyX += EnemySpeed; 
      
      if(EnemyX<PlayerX)
      {
        if(abs(PlayerY-EnemyY)>150)
        {
          if(EnemyY < PlayerY)
            EnemyY += 5; 
          else
            EnemyY -= 5; 
        }
      }
      if(EnemyY < PlayerY)
        EnemyY += 1; 
      else
        EnemyY -= 1; 
      if(EnemyX>width)
      {
        EnemyX = 0;
        EnemyY = random(height-50);
      }
      
      //Collision (Player and Enemy)
      if(PlayerX>EnemyX)
      {
        max = PlayerX;
        min = EnemyX;
      }
      else
      {
        max = EnemyX;
        min = PlayerX;
      }
      PEDX = max-min;
      if(PEDX<50)
      {
        if(PlayerY>EnemyY)
        {
          max = PlayerY;
          min = EnemyY;
        }
        else
        {
          max = EnemyY;
          min = PlayerY;
        }
        PEDY = max-min;
        if(PEDY<50)
        {
          PlayerHp = PlayerHp-20;
          EnemyX = 0;
          EnemyY = random(height-50);
        }
      }
      
      //Treasure
      image(treasure,TreasureX,TreasureY);
      
      //Collision (Player and Treasure)
      if(PlayerX>TreasureX)
      {
        max = PlayerX;
        min = TreasureX;
      }
      else
      {
        max = TreasureX;
        min = PlayerX;
      }
      PTDX = max-min;
      if(PTDX<50)
      {
        if(PlayerY>TreasureY)
        {
          max = PlayerY;
          min = TreasureY;
        }
        else
        {
          max = TreasureY;
          min = PlayerY;
        }
        PTDY = max-min;
        if(PTDY<50)
        {
          if(PlayerHp<100)
            PlayerHp = PlayerHp+10;
          TreasureX = random(width-50);
          TreasureY = random(height-50);
        }
      }
      
      //GAMEOVER
      if(PlayerHp <= 0)
        NowState = LOSE;
      break;
    case WIN:
      //It's no way to win.  So sad.
      break;
    case LOSE:
      if(mouseX>205 && mouseX<440 && mouseY>305 && mouseY<350)
      {
        image(end1,0,0);
        if(mousePressed)            
        {
          //Reset Player 
          PlayerHp = 20;
          PlayerX = width - 50;
          PlayerY = height/2;
          
          //Reset Background location
          BGX2 = 0-width;
          BGX1 = 0;
          
          //Reset Enemy location
          EnemyX = 0;
          EnemyY = random(height-50);
          
          //Reset Treasure location
          TreasureX = random(width-50);
          TreasureY = random(height-50);
          
          NowState = PLAY;
        }
      }
      else
        image(end2,0,0);
      break;
      
  }
}
void keyPressed()
{
   if (key == CODED) 
   { 
    switch (keyCode) 
    {
      case UP:
        upPressed    = true;
        break;
      case DOWN:
        downPressed  = true;
        break;
      case LEFT:
        leftPressed  = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}
void keyReleased()
{
   if (key == CODED) 
   {
      switch (keyCode) 
      {
        case UP:
          upPressed    = false;
          break;
        case DOWN:
          downPressed  = false;
          break;
        case LEFT:
          leftPressed  = false;
          break;
        case RIGHT:
          rightPressed = false;
          break;
    }
  }
}
