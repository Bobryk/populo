class Person{
  int idNumber;
  int attribute;
  int CONTENT = 0;
  int AGGRESSIVE = 1;
  int DEPRESSED = 2;
  int SCARED = 3;
  int LOVING = 4;
  int CHEERFUL = 5;
  int closest = 999;
  int timeWithPerson = 0;
  
  float locX;
  float locY;
  float tempX;
  float tempY;
  int opacity = 0;
  
  Person(int number){
    idNumber = number;
    attribute = int(random(0,5.99));
    locX = int(random(displayWidth*.05, displayWidth*.972));
    locY = int(random(displayWidth*.05, displayWidth*.972));
    ellipseMode(CENTER);
  }
  
  void drawPerson(){
    ellipseMode(CENTER);
    //sets boundary of person's motion
    if(locX>=displayWidth*.95){
      locX = displayWidth*.95; 
    }
    else if(locX<=displayWidth*.05){
      locX = displayWidth*.05;
    }
    if(locY>=displayWidth*.95){
      locY = displayWidth*.95;
    }
    else if(locY<=displayWidth*.05){
      locY = displayWidth*.05;
    }
    
    //draws person based on attribute
    switch(attribute){
      case 0:
        fill(255,255,255,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;
      case 1:
        fill(255,0,0,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;
      case 2:
        fill(100,100,100,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;  
      case 3:
        fill(81,78,120,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;
      case 4:
        fill(255,105,180,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;
      case 5:
        fill(255,255,0,opacity);
        ellipse(locX,locY,displayWidth*.027,displayWidth*.027);
        break;
      default:
        break;
    }  
  }
  
  //gets attribute string for main class
  String getAttribute(){
    String att = null;
    switch(attribute){
      case 0:
        att = "content";
        break;
      case 1:
        att = "aggressive";
        break;
      case 2:
        att = "depressed";
        break;  
      case 3:
        att = "scared";
        break;
      case 4:
        att = "loving";
        break;
      case 5:
        att = "cheerful";
        break;
      default:
        break;
    } 
   return att; 
  }
  
  //motion based on attribute
  void move(){
    if(attribute==CONTENT){
      tempX = random(-1,1);
      tempY = random(-1,1);
      locX += tempX;
      locY += tempY;
    }
    else if(attribute==AGGRESSIVE){
      tempX = random(-5,5);
      tempY = random(-5,5);
      locX += tempX;
      locY += tempY;
    }
    else if(attribute==DEPRESSED){
      tempX = random(-.1,.1);
      tempY = random(-.1,.1);
      locX += tempX;
      locY += tempY;
    }
    else if(attribute==SCARED){
      tempX = random(-3,3);
      tempY = random(-3,3);
      locX += tempX;
      locY += tempY;
    }
    else if(attribute==LOVING){
      tempX = random(-4,4);
      tempY = random(-4,4);
      locX += tempX;
      locY += tempY;
    }
    else if(attribute==CHEERFUL){
      tempX = random(-2,2);
      tempY = random(-2,2);
      locX += tempX;
      locY += tempY;
    }
  }

  void react(String att){
    if(att.equals("content")){
      if(attribute==CONTENT){
        attribute = LOVING;
      }
    }
    else if(att.equals("aggressive")){
      if(attribute==CONTENT){
        int chance = int(random(0,1.99));
        if(chance==0){
          attribute=SCARED;
        }
        else{attribute=AGGRESSIVE;}
      }
      else if(attribute==DEPRESSED){
        attribute=SCARED;
      }
      else if(attribute==AGGRESSIVE){
        int chance = int(random(0,1.99));
        if(chance==0){
          attribute=SCARED;
        }
        else{attribute=AGGRESSIVE;}
      }
      else if(attribute==CHEERFUL){
        attribute=DEPRESSED;
      }
      else if(attribute==LOVING){
        int chance = int(random(0,1.99));
        if(chance==0){
          attribute=DEPRESSED;
        }
        else{attribute=AGGRESSIVE;}
      }
      
    }
    else if(att.equals("depressed")){
      if(attribute==CHEERFUL){
        attribute=SCARED;
      }
    }
    else if(att.equals("scared")){
      if(attribute==CHEERFUL){
        attribute=LOVING;
      }
      else if(attribute==AGGRESSIVE){
        attribute=CONTENT;
      }
      else if(attribute==DEPRESSED){
        attribute=AGGRESSIVE;
      }
    }
    else if(att.equals("loving")){
      if(attribute==SCARED){
        attribute=CONTENT;
      }
      else if(attribute==CONTENT){
        attribute=CHEERFUL;
      }
      else if(attribute==CHEERFUL){
        attribute=LOVING;
      }
      else if(attribute==DEPRESSED){
        attribute=CONTENT;
      }
      
    }
    else if(att.equals("cheerful")){
      if(attribute==DEPRESSED){
        attribute=AGGRESSIVE;
      }
      else if(attribute==CONTENT){
        int chance = int(random(0,1.99));
        if(chance==0){
          attribute=CHEERFUL;
        }
        else{attribute=AGGRESSIVE;}
      }      
    }
  }
}
