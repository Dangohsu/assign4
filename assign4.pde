
//Declare constants
final int START_MENU = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
final int CLICKED = 0;
final int RELEASED = 1;
final int ENABLED = 2;
final int TREASURE = 1;
final int ENEMY = -2;
final int MAX_HP = 190;

//Declare field variables
PImage bg1, bg2, fighter, enemy1, treasure, hpFrame, end1, end2, start1, start2;
int gameState, bg1X, bg2X, bgY, hpFrameX, hpFrameY, treasureX, treasureY;
int fighterX, fighterY, enemyX, enemyY, start1Y, start2Y, end1Y, end2Y;
boolean upPressed, downPressed, leftPressed, rightPressed;
int mouse = CLICKED;
int hp = MAX_HP;
int wave = 1;

PImage[] enemy = new PImage[9];
PImage[] flame = new PImage[5];
int[] enemyX1 = new int[5];
int[] enemyY1 = new int[5];
int[] enemyX2 = new int[5];
int[] enemyY2 = new int[5];
int[] enemyX3 = new int[9];
int[] enemyY3 = new int[9];

void setup () {
  //setting frame
  size(640, 480);

  //loading img
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  fighter = loadImage("img/fighter.png");
  enemy1 = loadImage("img/enemy.png");
  treasure = loadImage("img/treasure.png");
  hpFrame = loadImage("img/hp.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  for(int i = 0; i < flame.length; ++i){
   flame[i] = loadImage("img/flame" + (i+1) +".png");    
  }
    
      
  //intialize variables
    //set game state
    gameState = START_MENU;
  
    //set bg
    start1Y = height + 1;
    start2Y = 0;
    end1Y = height + 1;
    end2Y = height + 1;
    bg1X = width;
    bg2X = 0;
    bgY = height;
  
    //set hp
    hpFrameX = 5;
    hpFrameY = 5;
  
    //set treasure -
    //treasure never start touching eny boundaries or the hp bar
    treasureX = (int)random(3, width - 44);
  
    if (treasureX <= 211 + hpFrameX) {
      treasureY = (int)random(34 + hpFrameY, height - 44);
    } else {
      treasureY = (int)random(3, height - 44);
    }
  
    //set enemy - 
    //enemy never start touching the lower boundary
    enemyX = -309;
    enemyY = (int)random(3, height - 64);
    
   
      for(int i = 0; i < enemy.length; ++i){
        enemy[i] = loadImage("img/enemy.png");
      }
    
    /** wave1
    *
    * enemy number
    *
    * 0 1 2 3 4
    *
    */
    
      for(int i = 0; i < enemyX1.length; ++i){
        enemyX1[i] = enemyX + 62 * i;
      }
    
      for(int i = 0; i < enemyY1.length; ++i){
        enemyY1[i] = enemyY;
      }
    /** wave2
    *
    * enemy number
    *
    *             4
    *          3
    *       2
    *    1
    * 0 
    *
    */
    
      for(int i = 0; i < enemyX2.length; ++i){
        enemyX2[i] = enemyX + 62 * i;
      }
    
      for(int i = 0; i < enemyY2.length; ++i){
        enemyY2[i] = enemyY - 30 * i;
      }
      
    /** wave3
    *
    * enemy number
    *
    *       6
    *    3     7
    * 0    (4)    8  
    *    1     5
    *       2
    *
    */
   
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyX3[i + j] = enemyX + 62 * j + 62 * i / 3;
          }
        }
    
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyY3[i + j] = enemyY + 40 * j - 40 * i / 3;
          }
        }
        
        
        
        
        
        
    //set fighter
    fighterX = width - 54;
    fighterY = height / 2 - 25;
}

void draw() {
  switch(gameState) { 

  case START_MENU: 
    //starting bg
      //set
      image(start2, 0, start2Y);
      image(start1, 0, start1Y);
  
      //When mouse is on the button, light the button on
      //When mouse both clicked & released while it's on the button, start the game
      if (mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413) {
        start1Y = 0;
        if (mouse == RELEASED) {
          nextGameState();
        }
      } else {
        initialize("start1Y");
      }
      break;

  case GAME_RUN: 



    //hide menu
    start1Y = height + 1;
    start2Y = height + 1;

    //bg
      //set
      image(bg1, bg1X - width, 0);
      image(bg2, bg2X - width, 0);
  
      //move
      ++bg1X;
      ++bg2X;
      bg1X %= width * 2;
      bg2X %= width * 2;
    //hp
      //set
      fill(RGB);
      noStroke();
      fill(255, 0, 0, 220);
      rect(hpFrameX + 13, hpFrameY, hp, 25);
      image(hpFrame, hpFrameX, hpFrameY);
      fill(255, 255, 255);
      textSize(18);
      text((int)(((float)hp / MAX_HP) * 100) + "%", 100, 25);
      //game over
      if (hp == 0) nextGameState(); 
      
      if(gameState == GAME_OVER) draw();
      
      //anti-copying
        textSize(10);
        text("102208026", hpFrameX + 320, 25);
     
      //lose-hp alert
        textSize(15);
        text("You lose hp if you touch the enemies!", 200, 460);

    //treasure
      //set           
      //treasure won't be touching fighter when appears
      int treaFiDisX = abs(fighterX - treasureX);
      int treaFiDisY = abs(fighterY - treasureY);
      image(treasure, treasureX, treasureY);
      //gain hp           
      if (treaFiDisX < 60 && treaFiDisY < 60) {
        gainHp(TREASURE);
        do {
          initialize("treasureX");
          initialize("treasureY");
          treaFiDisX = abs(fighterX - treasureX);
          treaFiDisY = abs(fighterY - treasureY);
        } while (treaFiDisX < 60 && treaFiDisY < 60);
      }
  


    //fighter
      //set
      image(fighter, fighterX, fighterY);
      //move
      if (fighterY > 5 && upPressed) fighterY -= 5;
      if (fighterY < height - 59 && downPressed) fighterY += 5;
      if (fighterX > 5 && leftPressed) fighterX -= 5;
      if (fighterX < width - 59 && rightPressed) fighterX += 5;



    //enemies
    switch(wave) {
      
    /** wave1
    *
    * enemy number
    *
    * 0 1 2 3 4
    *
    */
    case 1:
    //set enemies
      
      for(int i = 0; i < 5; ++i){
        image(enemy[i], enemyX1[i], enemyY1[i]);
      }
      //move right
      for(int i = 0; i < 5; ++i) enemyX1[i] += 4;
      enemyX += 4;
      
  /**    //move towards fighter
     *   if (enemyX > -245) {
     *     if (enemyY1[4]+30 > fighterY + 25 && enemyY1[4] >= 5) {
     *       for(int i = 0; i < 5 ; ++i) enemyY1[i] -= 2;
     *     }
     *     if (enemyY1[4]+30 < fighterY + 25 && enemyY1[4] <= 414) {
     *       for(int i = 0; i < 5 ; ++i) enemyY1[i] += 2;
     *     }
     *   }
     */
      
      //lose hp
      for(int i = 0; i < 5; ++i){
        int eneFiDisX = abs(fighterX - enemyX1[i]);
        int eneFiDisY = abs(fighterY - enemyY1[i]);
        if (eneFiDisX <= 50 && eneFiDisY <= 50) {
          gainHp(ENEMY);
          
          enemyX1[i] = -2000;
        }
      }
        
      //hit the right boundary
        if (enemyX > 644) {
          initialize("enemyX");
          initialize("enemyX1");
          initialize("enemyY");
          initialize("enemyY1");
          wave = 2;
        }
        
    break;    
        
        
      
   
    /** wave2
    *
    * enemy number
    *
    *             4
    *          3
    *       2
    *    1
    * 0 
    *
    */
    case 2:
    //ensure that enemies don't touch the upper boundary
     while(enemyY < 123) {
       enemyY = (int)(random(123, height - 64));
       initialize("enemyY2");
     }
     
    //set enemies

    for(int i = 0; i < 5; ++i){
        image(enemy[i], enemyX2[i], enemyY2[i]);
      }
      //move right      
      for(int i = 0; i < 5; ++i) enemyX2[i] += 4;
       enemyX += 4;
/**     //move towards fighter
  *   if (enemyX > -245) {
  *      if (enemyY2[2]+30 > fighterY + 25 && enemyY2[4] >= 5) {
  *        for(int i = 0; i < 5 ; ++i){
  *          enemyY2[i] -= 2;
  *        }
  *      }
  *      if (enemyY2[2]+30 < fighterY + 25 && enemyY2[0] <= 414) {
  *        for(int i = 0; i < 5 ; ++i) enemyY2[i] += 2;
  *      }
  *   }
  */
     //lose hp
      for(int i = 0; i < 5; ++i){
        int eneFiDisX = abs(fighterX - enemyX2[i]);
        int eneFiDisY = abs(fighterY - enemyY2[i]);
        if (eneFiDisX <= 50 && eneFiDisY <= 50) {
          gainHp(ENEMY);
          enemyX2[i] = -2000;
        }
      }
      //hit the right boundary
        if (enemyX > 644) {
          initialize("enemyX");
          initialize("enemyX2");
          initialize("enemyY");
          initialize("enemyY2");
          wave = 3;
        }
        
    break;    
    
    /** wave3
    *
    * enemy number
    *
    *       6
    *    3     7
    * 0    (4)    8  
    *    1     5
    *       2
    *
    */
    
    case 3:
    //ensure that enemies don't touch both upper & lower boundary
    while(enemyY > 336 || enemyY < 83){
      enemyY = (int)(random(83, 337));
      initialize("enemyY3");
    }
    
    //set enemies

    for(int i = 0; i < 9; ++i){
      if(i != 4) image(enemy[i], enemyX3[i], enemyY3[i]);
      }
    //move right
      for(int i = 0; i < 9; ++i) if(i != 4) enemyX3[i] += 4;
       enemyX += 4;
/**     //move towards fighter
  *   if (enemyX > -245) {
  *      if (enemyY3[8]+30 > fighterY + 25 && enemyY3[6] >= 5) {
  *        for(int i = 0; i < 9 ; ++i) if(i != 4) enemyY3[i] -= 2;
  *      }
  *      if (enemyY3[8]+30 < fighterY + 25 && enemyY3[2] <= 414) {
  *        for(int i = 0; i < 9 ; ++i) if(i != 4) enemyY3[i] += 2;
  *      }
  *   }
  */  
    //lose hp
      for(int i = 0; i < 9; ++i){
        if(i != 4){
          int eneFiDisX = abs(fighterX - enemyX3[i]);
          int eneFiDisY = abs(fighterY - enemyY3[i]);
          if (eneFiDisX <= 50 && eneFiDisY <= 50) {
            gainHp(ENEMY);
            enemyX3[i] = -2000;
          }
        }
      }
    
    //hit the right boundary
        if (enemyX > 644) {
          initialize("enemyX");
          initialize("enemyX3");
          initialize("enemyY");
          initialize("enemyY3");
          wave = 1;
        }
    break; //switch(wave) case3
   
    } //switch(wave)
    
    break; //switch(gameState)
    
    case GAME_OVER: 
      //game over bg
      //set
      image(end2, 0, 0);
      image(end1, 0, end1Y);
      //When mouse is on the button, light the button on
      //When mouse both clicked & released while it's on the button, restart the game  
      if (mouseX > 212 && mouseY > 316 && mouseX < 432 && mouseY < 347) {
        end1Y = 0;
        if (mouse == RELEASED) {
          nextGameState();
        }
      } else {
        initialize("end1Y");
      }
      break;
    }
}
  
  void nextGameState() {

    switch(gameState) {
    case START_MENU:
      gameState = GAME_RUN;
      mouse = CLICKED;
      break;

    case GAME_RUN:
      gameState = GAME_OVER;
      break;

    case GAME_OVER:
      initializeAll();
      gameState = GAME_RUN;
      mouse = CLICKED;
      break;
    }
  }


  void gainHp(int i) {
    if (gameState == GAME_RUN) {
      switch(i) {
      case TREASURE:
        if (hp != MAX_HP) hp += i * (MAX_HP / 10); //hp won't get higher than MAX_HP
        break;

      case ENEMY:
        if (hp > (MAX_HP / 10)) hp += i * (MAX_HP / 10);
        else if (hp == (MAX_HP / 10)) hp = 0; //hp won't get lower than 0
        break;
      }
    }
  }


  void mousePressed() {
    switch(gameState) {
    case START_MENU:
      if (mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413 && mouseButton == LEFT) {
        mouse = ENABLED;
      }
      break;
      
    case GAME_OVER:
      if (mouseX > 212 && mouseY > 316 && mouseX < 432 && mouseY < 347){
        mouse = ENABLED;
      }
      break;
    }
  }





  void mouseReleased() {
    switch(gameState) {
    case START_MENU:
      if (mouse == ENABLED && mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413) {
        mouse = RELEASED;
      } else mouse = CLICKED;
      break;
      
    case GAME_OVER:
      if (mouse == ENABLED && mouseX > 212 && mouseY > 316 && mouseX < 432 && mouseY < 347){
        mouse = RELEASED;
      } else mouse = CLICKED;
      break;
    }
  }

  void keyPressed() {
    if (key == CODED) {
      switch(keyCode) {
      case UP: 
        if (fighterY > 0) upPressed = true;
        break;
      case DOWN:
        if (fighterY < height - 54) downPressed = true;
        break;
      case LEFT:
        if (fighterX > 0) leftPressed = true;
        break;
      case RIGHT:
        if (fighterX < width - 54) rightPressed = true;
        break;
      }
    }
  }

  void keyReleased() {

    if (key == CODED) {
      switch(keyCode) {
      case UP: 
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      }
    }
  }

  void initializeAll() {
    //intialize variables
    mouse = CLICKED;
    hp = MAX_HP;
    wave = 1;
    //set bg
    start1Y = height + 1;
    start2Y = 0;
    end1Y = height + 1;
    end2Y = height + 1;
    bg1X = width;
    bg2X = 0;
    bgY = height;

    //set hp
    hpFrameX = 5;
    hpFrameY = 5;
    hp = MAX_HP;
    
    //set treasure -
    //treasure never start touching eny edges or the hp bar
    treasureX = (int)random(3, width - 44);

    if (treasureX <= 211 + hpFrameX) {
      treasureY = (int)random(34 + hpFrameY, height - 44);
    } else {
      treasureY = (int)random(3, height - 44);
    }

    //set enemy - 
    //enemy never start touching the lower edge or the hp bar
    enemyX = -309;
    enemyY = (int)random(34 + hpFrameY, height - 64);
    
    //enemy wave1
    for(int i = 0; i < enemyX1.length; ++i){
        enemyX1[i] = enemyX + 62 * i;
      }
    
      for(int i = 0; i < enemyY1.length; ++i){
        enemyY1[i] = enemyY;
      }
    //enemy wave2
    
      for(int i = 0; i < enemyX2.length; ++i){
        enemyX2[i] = enemyX + 62 * i;
      }
    
      for(int i = 0; i < enemyY2.length; ++i){
        enemyY2[i] = enemyY - 30 * i;
      }
      
    //enemy wave3
   
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyX3[i + j] = enemyX + 62 * j + 62 * i / 3;
          }
        }
    
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyY3[i + j] = enemyY + 40 * j - 40 * i / 3;
          }
        }

    //set fighter
    fighterX = width - 54;
    fighterY = height / 2 - 25;
  }

  void initialize(String s) {
    switch(s) {
    case "start1Y":
      start1Y = height + 1;
      break;

    case "start2Y":  
      start2Y = 0;
      break;

    case "end1Y":
      end1Y = height + 1;
      break;

    case "end2Y":
      end2Y = height + 1;
      break;

    case "bg1X":
      bg1X = width;
      break;

    case "bg2X":
      bg2X = 0;
      break;

    case "bgY":
      bgY = height;
      break;

    case "hpFrameX":
      hpFrameX = 5;
      break;

    case "hpFrameY":
      hpFrameY = 5;
      break;

    case "treasureX":
      treasureX = (int)random(3, width - 44);
      break;

    case "treasureY":
      if (treasureX <= 211 + hpFrameX) {
        treasureY = (int)random(34 + hpFrameY, height - 44);
      } else {
        treasureY = (int)random(3, height - 44);
      }
      break;

    case "enemyX":
      enemyX = -309;
      break;
    
    case "enemyY":
      enemyY = (int)random(3, height - 64);
      break;
    
    case "enemyX1":
      for(int i = 0; i < enemyX1.length; ++i){
        enemyX1[i] = enemyX + 62 * i;
      }
      break;
    
    case "enemyY1":
      for(int i = 0; i < enemyY1.length; ++i){
        enemyY1[i] = enemyY;
      }
      break;
    
    case "enemyX2":
      for(int i = 0; i < enemyX2.length; ++i){
        enemyX2[i] = enemyX + 62 * i;
      }
      break;
    
    case "enemyY2":
      for(int i = 0; i < enemyY2.length; ++i){
        enemyY2[i] = enemyY - 30 * i;
      }
      break;
    
    case "enemyX3":
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyX3[i + j] = enemyX + 62 * j + 62 * i / 3;
          }
        }
      break;
    
    case "enemyY3":
      for(int i = 0; i <= 6; i += 3){
          for(int j = 0; j < 3; ++j){
            enemyY3[i + j] = enemyY + 40 * j - 40 * i / 3;
          }
        }
      break;

    case "fighterX":
      fighterX = width - 54;
      break;

    case "fighterY":
      fighterY = height / 2 - 25;
      break;
    }
  }
