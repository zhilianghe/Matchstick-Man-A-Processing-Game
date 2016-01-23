Matchstick a = new Matchstick();
int distanceOfStep = 50;

PVector moveVector = new PVector(0, 0);
PVector moveMan = new PVector(-40, 40);
Stairs s = new Stairs();
ArrayList<Integer> l = new ArrayList<Integer>();
ArrayList<Step> allSteps = new ArrayList<Step>();
int counterForStep = 0;
boolean leftTurn = true;
float forCurLocX = 0.8 * width;
float forCurLocY = 0.2 * height;
int gameState; // 0--> beginning 1---> in the game 2---> game over

void setup() {
  size(600, 700);
  background(20, 227, 154);
  for (int a = 0;a < 100;a++) {
    l.add((int)random(4, 9));
  }
  frameRate(20);
}
void keyPressed() {
  switch (keyCode) {
  case RIGHT:
    leftTurn = false;
    break;
  case LEFT:
    leftTurn = true;
    break;
   case ENTER:
   gameState = 1;
  }
}

void draw() {
  background(20, 227, 154);
  if(gameState == 1) {
    moveVector.y -= 7;
    translate(0,moveVector.y);
    s.drawStairs(4, 0.8 * width, 0.2 * height);
    s.drawReverseStairs(4, s.initialReversePointX, s.initialReversePointY);
    for (int a = 0;a < 10;a++) {
      s.drawStairs(l.get(a), s.getFinalPointA(), s.getFinalPointB());
      s.drawReverseStairs(l.get(a), s.initialReversePointX, s.initialReversePointY);
    }
    if(leftTurn) {
      if (!a.isOnStep(allSteps)) {
        a.drawMatchstick();
        a.v.y += 5;
        a.v.x -= 5;
      }else {
        a.v.x -= 20;
        a.drawMatchstick();
        a.v.y += 20;
      }
    }else if(!leftTurn) {
      if (!a.isOnStep(allSteps)) {
        a.drawMatchstick();
        a.v2.y += 5;
        a.v2.x += 5;
      }else {
        a.v2.x += 20;
        a.drawMatchstick();
        a.v2.y += 20;
        }
    }
  
    if ( a.curLocY > height || a.curLocX > width || a.curLocX < 0) {
      text("LOST!!", width / 2, height / 2);
    }
  }else if (gameState == 0) {
    PFont font = loadFont("AngsanaUPC-Bold-50.vlw");
   PImage c = loadImage("begin.png");
    image(c,400,50);
    textFont(font);
    text("To start the game, \n  press ENTER. \nPress --> or <-- to change the\n walking direction when you \n are at the corner ", 100, 250);
  }
}

public class Matchstick {
  float curLocX = 0.0;
  float curLocY = 0.0;
  PVector v = new PVector(0, 0);
  PVector v2 = new PVector(0, 0);

  public void drawMatchstick() {
    if (leftTurn) {
      PImage p = loadImage("Matchstick Man.png");
    
      this.curLocX = 0.8 * width + v.x + v2.x;
      this.curLocY = 0.2 * height + v.y + v2.y; ///problem is here, can'determined the location
      image(p, curLocX - 50, curLocY - 40);
    }
    else {
      PImage flip = loadImage("Matchstick Man Flip.png");
      curLocX = 0.8 * width + v.x + v2.x;
      curLocY = 0.2 * height + v.y + v2.y;
      image(flip, curLocX, curLocY - 30);
    }
  }
  void increaseCurLocY(float a) {
    curLocY += a;
  }
  boolean isOnStep(ArrayList<Step> a) {
    boolean onStep = false;
    for (Step s: a) {
      onStep = (curLocY == s.finalY - 45) && ((curLocX >= s.finalX && curLocX <= s.initialX) || (curLocX <= s.finalX && curLocX >= s.initialX));
      if (onStep) return onStep;
    }
    return onStep;
  }
  boolean needGoForward(ArrayList<Step> a) {
    boolean needGoForward = false;
    for (Step s:a) { 
      if (needGoForward) return needGoForward;
      needGoForward = ((curLocX >= s.finalX && curLocX <= s.initialX) || (curLocX <= s.finalX && curLocX >= s.initialX));
    }  
    return needGoForward;
  }
}

public class Stairs {
  float initialReversePointX;  // to start reverse stairs
  float initialReversePointY;  // to start reverse stairs
  float finalPA;  // used to create next iteration
  float finalPB;  // used to create next iteration

  //draw regular stairs
  public void drawStairs(int a, float pX, float pY) {
    //make columns
    float pointX = pX;
    float pointY = pY;
    float finalPointX = pointX;
    float finalPointY = pointY + distanceOfStep;
    for (int i = 0; i < a;i++) {
      Step cur = new Step();
      cur.drawStep(pointX, pointY, finalPointX, finalPointY);
      //line(pointX, pointY, finalPointX, finalPointY);
      pointX -= distanceOfStep; 
      pointY += distanceOfStep;
      finalPointX -= distanceOfStep;
      finalPointY += distanceOfStep;
    }
    //make rows
    float pointA = pX;
    float pointB = pY + distanceOfStep;
    float finalPointA = pointA - distanceOfStep;
    float finalPointB = pY + distanceOfStep;
    for (int j = 0; j < a;j++) {
      // line(pointA, pointB, finalPointA, finalPointB);
      Step cur = new Step();
      cur.drawStep(pointA, pointB, finalPointA, finalPointB);
      allSteps.add(cur);
      pointA -= distanceOfStep; 
      pointB += distanceOfStep;
      finalPointA -= distanceOfStep;
      finalPointB += distanceOfStep;
    }
    line(finalPointA + distanceOfStep, finalPointB - distanceOfStep / 2, finalPointA - distanceOfStep, finalPointB - distanceOfStep / 2);
    line(pX, pY +distanceOfStep, finalPointA + 2 * distanceOfStep, finalPointB - distanceOfStep);
    initialReversePointX = finalPointA + distanceOfStep;
    initialReversePointY = finalPointB - distanceOfStep;
  }

  //make reverse stairs
  public void drawReverseStairs(int a, float x, float y ) {
    //make columns;
    float pInitialX = x;
    float pInitialY = y;
    float pFinalX = x;
    float pFinalY = y + distanceOfStep;
    for (int i = 0; i < a;i++) {
      //  line(pInitialX, pInitialY, pFinalX, pFinalY);
      Step cur = new Step();
      cur.drawStep(pInitialX, pInitialY, pFinalX, pFinalY);
      pInitialX += distanceOfStep; 
      pInitialY += distanceOfStep;
      pFinalX += distanceOfStep;
      pFinalY += distanceOfStep;
    }

    //make rows
    float pInitialA = initialReversePointX;
    float pInitialB = initialReversePointY + distanceOfStep;      
    float pFinalA = initialReversePointX + distanceOfStep;
    float pFinalB = pInitialB;
    for (int i = 0; i < a;i++) {
      // line(pInitialA, pInitialB, pFinalA, pFinalB);
      Step cur = new Step();
      cur.drawStep(pInitialA, pInitialB, pFinalA, pFinalB);
      allSteps.add(cur);
      pInitialA += distanceOfStep; 
      pInitialB += distanceOfStep;
      pFinalA += distanceOfStep;
      pFinalB += distanceOfStep;
    }
    finalPA = pFinalA - distanceOfStep;
    finalPB = pFinalB - distanceOfStep;
    line(finalPA, finalPB + distanceOfStep / 2, finalPA + 2 * distanceOfStep, finalPB + distanceOfStep / 2);
    line(x, y + distanceOfStep, finalPA - distanceOfStep, finalPB);
  }
  public float getFinalPointA() {
    return finalPA;
  }

  public float getFinalPointB() {
    return finalPB;
  }
}

class Step {
  float initialX;
  float initialY;
  float finalX;
  float finalY;

  void drawStep(float x, float y, float fX, float fY) {
    initialX = x;
    initialY = y;
    finalX = fX;
    finalY = fY;
    line(x, y, fX, fY);
  }
}

