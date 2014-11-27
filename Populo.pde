import android.view.WindowManager;
import android.view.MotionEvent;
import android.view.WindowManager.LayoutParams;

ArrayList<Person> people;
int spheresBorn = 10;
int spheresDead = 0;
int id=1;
int killTime = 0;
int populationNumber = 1;
float touchX = 0;
float touchY = 0;
int textSiz;
float backOpac = 20;
boolean touch = false;
int buttonPress = 100;
boolean started = false;
int selected = -1;
boolean found = false;
PImage back;
String currentAtt="none";

void setup(){
  back = loadImage("background.png");
  orientation(PORTRAIT);
  frameRate(30);
  noStroke();
  smooth();
  background(0);
  rectMode(CORNER);
  textSiz = int(displayWidth*.035);
  
  //Initializes the first generation
  people = new ArrayList<Person>();
  for(int i=0;i<10;i++){
    people.add(new Person(id));
    id++;
  }
  started=true;
}

void draw(){
  if(touch){
    fill(255,255,255,50);
    //ellipse(touchX,touchY,displayWidth*.041*2,displayWidth*.041*2);
  }
  buttonPress++;
  
  textAlign(LEFT);
  textSize(textSiz);
  
  //Starts a new population
  if(people.size()==0){
    people.clear();
    id = 1;
    spheresBorn = 10;
    spheresDead = 0;
    selected = -1;
    for(int i=0;i<10;i++){
    people.add(new Person(id));
    id++;
    
    }
    populationNumber++;
    killTime=0;
    fill(0);
    rect(0,0,displayWidth,displayWidth);
  }
  
  killTime++;
  
  //sets the background
  noStroke();
  tint(255,70);
  image(back,0,displayWidth*.035,displayWidth,displayWidth-(displayWidth*.035));
  noTint();
  fill(150);
  rect(0,displayWidth,displayWidth/2,displayHeight-displayWidth);
  fill(175);
  rect(displayWidth/2,displayWidth,displayWidth/2,displayHeight-displayWidth);
  fill(175,175,175,35);
  rect(0,0,displayWidth,displayWidth*.035);
  
  //draws people and draws info when mouse hovers over one
  for(int i=0;i<people.size();i++){
    if(people.get(i).opacity<255){
      people.get(i).opacity +=5;
    }
    people.get(i).drawPerson();
    if(dist(touchX,touchY,people.get(i).locX,people.get(i).locY)<=displayWidth*.041&&touch){
      selected = people.get(i).idNumber;
    }
    
  }
  
  //people motion
  for(int i=0;i<people.size();i++){
    people.get(i).move();
  }
  //reaction time
  for(int i=0;i<people.size();i++){
    //finds closest person to each person
    float shortestDistance = 9999;
    int closestPerson = 0;
    for(int j=0;j<people.size();j++){
      if(dist(people.get(i).locX,people.get(i).locY,people.get(j).locX,people.get(j).locY)<shortestDistance){
        if(dist(people.get(i).locX,people.get(i).locY,people.get(j).locX,people.get(j).locY)>0){
          shortestDistance = dist(people.get(i).locX,people.get(i).locY,people.get(j).locX,people.get(j).locY);
          closestPerson = j;
        }
      }
    }
    if(shortestDistance<displayWidth*.1){
      if(people.get(i).closest == closestPerson){
      people.get(i).timeWithPerson++;
      }
      else{
        people.get(i).closest = closestPerson;
        people.get(i).timeWithPerson = 0;
      }
      if(people.get(i).timeWithPerson >=100){
      people.get(i).timeWithPerson = 0;
      //new person conditional
      boolean born = false;
      if(people.get(closestPerson).getAttribute().equals("loving")&&people.get(i).getAttribute().equals("loving")){
        born=true;
      }
      boolean death= false;
      if(people.get(closestPerson).getAttribute().equals("aggressive")&&random(0,9)<1){
        death=true;
      }
        
      if(born&&people.size()<300){
        people.get(i).attribute=0;
        int peopleAmount = int(random(1.01,3.99));
        for(int k=0;k<=peopleAmount;k++){
          people.add(new Person(id));
          people.get(people.size()-1).locX = people.get(closestPerson).locX + random(displayWidth*-.1,displayWidth*.1);
          people.get(people.size()-1).locY = people.get(closestPerson).locY + random(displayWidth*-.1,displayWidth*.1);
          spheresBorn++;
          id++;
        }
      }
      
      //reactions for person and their partner
      String attI = people.get(i).getAttribute();
      String attJ= people.get(closestPerson).getAttribute();
      people.get(closestPerson).react(attI);
      people.get(i).react(attJ);
      if(death){
        people.remove(i);
        spheresDead++;
      }
    }
  }
  float change = random(0,10);
    if(change<.02){
      people.get(i).attribute = int(random(0,6));
    }
  }
  
  //kills the oldest person
  if(killTime>=360){
    if((people.size()/10)<1){
      people.remove(0);
      spheresDead++;
    }
    else{
      for(int i=0;i<int(people.size()/9);i++){
        people.remove(0);
        spheresDead++;
      }
    }
    killTime = 0;
  }
  
  //draws information
  fill(0);
  float space = displayWidth*.03+textSiz;
  text("Population #: " + populationNumber,displayWidth*.03,displayWidth+space);
  text("People born: " + spheresBorn,displayWidth*.075,displayWidth+space*2);
  text("People dead: " + spheresDead,displayWidth*.075,displayWidth+space*3);
  text("People alive: " + people.size(),displayWidth*.075,displayWidth+space*4);
  
  fill(200,50,40);
  rect(displayWidth*.01,displayHeight-2*space-displayWidth*.01,displayWidth/2-(displayWidth*.02),2*space);
  fill(200,220,255);
  textAlign(CENTER);
  textSize(1.5*textSiz);
  text("Reset Population", displayWidth/4, displayHeight-displayWidth*.06);
  textAlign(LEFT);
  textSize(textSiz);
  
  fill(0);
  text("Selected Person:", displayWidth/2+displayWidth*.03,displayWidth+space);
  if(selected==-1){
    text("None Selected",displayWidth/2+displayWidth*.075,displayWidth+2*space);
  }
  else{
    found = false;
    for(int i=0;i<people.size();i++){
      if(people.get(i).idNumber==selected){
        text("Id: "+people.get(i).idNumber, displayWidth/2+displayWidth*.075,displayWidth+2*space);
        text("Attribute: "+people.get(i).getAttribute(), displayWidth/2+displayWidth*.075,displayWidth+3*space);
        found = true;
        noFill();
        stroke(255);
        strokeWeight(2);
        ellipse(people.get(i).locX,people.get(i).locY,displayWidth*.041*1.5,displayWidth*.041*1.5);
        noStroke();
        currentAtt = people.get(i).getAttribute();
        if(touch&&(touchX>=displayWidth/2+displayWidth*.075&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075)&&(touchY>=displayWidth+3*space+textSiz&&touchY<=displayWidth+3*space+textSiz+displayWidth*.075)){
          people.get(i).attribute=0;
        }
        else if(touch&&(touchX>=displayWidth/2+displayWidth*.075+displayWidth*.1&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075+displayWidth*.1)&&(touchY>=displayWidth+3*space+textSiz&&touchY<=displayWidth+3*space+textSiz+displayWidth*.075)){
          people.get(i).attribute=2;
        }
        else if(touch&&(touchX>=displayWidth/2+displayWidth*.075+2*displayWidth*.1&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075+2*displayWidth*.1)&&(touchY>=displayWidth+3*space+textSiz&&touchY<=displayWidth+3*space+textSiz+displayWidth*.075)){
          people.get(i).attribute=4;
        }
        else if(touch&&(touchX>=displayWidth/2+displayWidth*.075&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075)&&(touchY>=displayWidth+3*space+textSiz+displayWidth*.1&&touchY<=displayWidth+3*space+textSiz+displayWidth*.1+displayWidth*.075)){
          people.get(i).attribute=1;
        }
        else if(touch&&(touchX>=displayWidth/2+displayWidth*.075+displayWidth*.1&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075+displayWidth*.1)&&(touchY>=displayWidth+3*space+textSiz+displayWidth*.1&&touchY<=displayWidth+3*space+textSiz+displayWidth*.1+displayWidth*.075)){
          people.get(i).attribute=3;
        }
        else if(touch&&(touchX>=displayWidth/2+displayWidth*.075+2*displayWidth*.1&&touchX<=displayWidth/2+displayWidth*.075+displayWidth*.075+2*displayWidth*.1)&&(touchY>=displayWidth+3*space+textSiz+displayWidth*.1&&touchY<=displayWidth+3*space+textSiz+displayWidth*.1+displayWidth*.075)){
          people.get(i).attribute=5;
        }
        
      }
    }
    if(!found){
      text("Person is gone..",displayWidth/2+displayWidth*.075,displayWidth+2*space);
    }
    
  }
  
  fill(255);
  textAlign(RIGHT);
  textSize(textSiz*.99);
  text("Populo 1.0", displayWidth-displayWidth*.03,displayHeight-displayWidth*.01);
  
  fill(0);
  text("Nicholas Bobryk",displayWidth-displayWidth*.037,displayWidth*.035-textSiz*.12);
  if(people.size()==1){
    fill(255);
    textSize(displayWidth*.08);
    text("This population has died out. Restarting...",displayWidth*.01,displayWidth*.05,displayWidth*.95,displayWidth*.95);
  }
  if(found){
    fill(255);
    noStroke();
    if(currentAtt.equals("content")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075,displayWidth+3*space+textSiz,displayWidth*.075,displayWidth*.075);
    noStroke();
    fill(255,0,0);
    if(currentAtt.equals("aggressive")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075,displayWidth+3*space+textSiz+displayWidth*.1,displayWidth*.075,displayWidth*.075);
    noStroke();
    fill(100,100,100);
    if(currentAtt.equals("depressed")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075+displayWidth*.1,displayWidth+3*space+textSiz,displayWidth*.075,displayWidth*.075);
    noStroke();
    fill(81,78,120);
    if(currentAtt.equals("scared")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075+displayWidth*.1,displayWidth+3*space+textSiz+displayWidth*.1,displayWidth*.075,displayWidth*.075);
    noStroke();
    fill(255,105,180);
    if(currentAtt.equals("loving")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075+2*displayWidth*.1,displayWidth+3*space+textSiz,displayWidth*.075,displayWidth*.075);
    noStroke();
    fill(255,255,0);
    if(currentAtt.equals("cheerful")){
      stroke(0);
      strokeWeight(2);
    }
    rect(displayWidth/2+displayWidth*.075+2*displayWidth*.1,displayWidth+3*space+textSiz+displayWidth*.1,displayWidth*.075,displayWidth*.075);
    noStroke();
  }
  touch = false;
}



void onResume() {
  super.onResume();
  setWindowBright();
}

void setWindowBright(){
  getWindow().addFlags(LayoutParams.FLAG_KEEP_SCREEN_ON | LayoutParams.FLAG_TURN_SCREEN_ON);
}
@Override
public boolean dispatchTouchEvent(MotionEvent event) {
  touchX = event.getX();
  touchY = event.getY();
  touch =true;
  
  
  if(touchX>=(displayWidth*.01)&&touchX<=(displayWidth/2-displayWidth*.01)&&touchY>=(displayHeight-((displayWidth*.06+2*textSiz))-displayWidth*.01)&&buttonPress>20){
      people.clear();
      buttonPress=0;   
  }
  
  return super.dispatchTouchEvent(event);        // pass data along when done!
}
