import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer[] musica = new AudioPlayer[3];
AudioPlayer beer;
AudioPlayer beer2;
AudioPlayer firecracker;
AudioPlayer boo;
AudioPlayer woo;

Serial port;

boolean man;
boolean mon;

PImage title;
PImage players;
PImage oneP;
PImage twoP;
PImage playerOne;
PImage playerTwo;
PImage bestSingle;
PImage bestVS;
PImage mano;
PImage monona;
PImage j1;
PImage j2;

int bestTime = 0;
int moment = 1;
int counter = 1000;
int y;
int puntajeSingle;
int timeSingle;
int puntajeOne;
int puntajeTwo;
int timeOne;
int timeTwo;
int screen;
int min;
int seg;
int turn = 0;
int r;

float time = 60;
float lasttimecheck;
float timeinterval;
float sensor;

void setup(){
  //port = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  port= new Serial(this,Serial.list()[0],9600); 
  
  minim = new Minim(this);
  for(int i = 0; i < 3; i++){
    musica[i] = minim.loadFile("m" + i + ".mp3");
  }
  beer = minim.loadFile("beer0.mp3");
  beer2 = minim.loadFile("beer0.mp3");
  firecracker = minim.loadFile("mecha.mp3");
  boo = minim.loadFile("boo.mp3");
  woo = minim.loadFile("woo.mp3");
  r = (int) random(0, 3);
  
  man = false;
  mon = false;
  
  title = loadImage("IS_01.png");
  players = loadImage("IS_02.png");
  oneP = loadImage("IS_03.png");
  twoP = loadImage("IS_04.png");
  playerOne = loadImage("IS_05.png");
  playerTwo = loadImage("IS_06.png");
  bestSingle = loadImage("IS_07.png");
  bestVS = loadImage("IS_08.png");
  monona = loadImage("Moñona.png");
  mano = loadImage("Mano.png");
  j1 = loadImage("Jugador1.png");
  j2 = loadImage("Jugador2.png");
  
  screen = 0;
  lasttimecheck = millis();
  timeinterval = 1000;
  
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);
  size(1280,1024);
}
void draw(){
  musica[r].play();
  musica[r].setGain(-20.0);
  beer.setGain(2.0);

  //SCREEN ONE
  /*The screens on this game work through an int called "screen"
  depending on the value of 'screen', the game shows the corresponding option*/
  if(screen == 0){
    background(100);
    image(title, width / 2, height / 2);
    
    if(keyPressed){
      if(key == ENTER){
        screen = 3;
      }
    }
  }
  
  //SCREEN TO SELECT THE NUMBER OF PLAYERS
  else if(screen == 3){
    background(100);
    image(players, width / 2, height / 2);
    
    if(port.available() > 0){
        sensor = port.read();
        println(sensor);
        if(sensor == 6){
          screen = 1;
          delay(500);
        }
        else if(sensor == 5){
          screen = 2;
          delay(500);
        }
    }
    
    if(keyPressed){
      if(key == '1'){
        screen = 1;
      }
      else if(key == '2'){
        screen =2;
      }
    }
  }
  //SINGLE PLAYER
  else if(screen == 1){
    if(moment == 1){
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        image(oneP, 640, 540);
        beer.play();
        println(counter);
        counter -= 500;
      }
      
      if (counter <= 0){
        moment = 0;
        counter = 1000;
      }
    }
    else if(moment == 0){
      background(100);
      image(playerOne, width / 2, height / 2);
        textSize(250);
        text(puntajeSingle, width / 2, 900);
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        min = (int) time / 60;
        seg = (int) time % 60;
        time--;
      }
      if(time <= 20 && puntajeSingle < 15){
        boo.play();
      }
      else if(time <= 20 && puntajeSingle > 15){
        woo.play();
      }
      /*Reds the information that comes fro Arduino*/
      if(port.available() > 0){
        sensor = port.read();
        println(sensor);
        if(sensor == 13){
          puntajeSingle += 9;
          firecracker.play();
          firecracker.rewind();
          mon = true;
        }
        else if(sensor == 7){
          puntajeSingle += 1;
          man = true;
        }
      }
      /*Manual controls*/
      else{
        if(keyPressed){
          if(key == 'Q' || key == 'q'){
            puntajeSingle += 1;
            man = true;
            delay(100);
          }
          else if(key == 'W' || key == 'w'){
            puntajeSingle += 3;
            delay(100);
          }
          else if(key == 'E' || key == 'e'){
            puntajeSingle += 6;
            delay(100);
          }
          else if(key == 'R' || key == 'r'){
            puntajeSingle += 9;
            mon = true;
            firecracker.play();
            firecracker.rewind();
            delay(100);
          }
        }
      }
      /*Time display*/
      if(seg > 9){
        text("0" + min + ":" + seg, 640, 400);
      }
      else{
        text("0" + min + ":0" + seg, 640, 400);
      }
      
      if(man == true && counter > 0){
        image(mano, width / 2, height / 2);
        counter -= 30;
        println(counter);
      }
      else if(man == true && counter < 1){
        counter = 1000;
        man = false;
      }
      if(mon == true && counter > 0){
        image(monona, width / 2, height / 2);
        counter -= 30;
        println(counter);
      }
      else if(mon == true && counter < 1){
        counter = 1000;
        mon = false;
      }
    
      if(time <= 0 || puntajeSingle >= 27){
        timeSingle = (int) time;
        if(timeSingle > bestTime){
          bestTime = (int) timeSingle;
        }
        screen = 5;
        puntajeSingle = 0;
        counter = 10;
        time = 60;
        boo.rewind();
        woo.rewind();
      }
    } 
  }
  //TWO PLAYERS
  else if(screen == 2){
    if(moment == 1){
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        image(twoP, 640, 540);
        println(counter);
        beer.play();
        beer.rewind();
        counter -= 500;
      }
      
      if (counter <= 0){
        moment = 2;
        counter = 1000;
      }
    }
    else if(moment == 2){
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        image(j1, 640, 540);
        println(counter);
        counter -= 250;
      }
      if(counter <= 0){
        moment = 0;
        counter = 1000;
      }
    }
    else if(moment == 3){
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        image(j2, 640, 540);
        println(counter);
        counter -= 250;
      }
      if(counter <= 0){
        moment = 0;
        counter = 1000;
      }
    }
    else if(moment == 0){
      background(100);
      if(turn == 0){
        image(playerOne, width / 2, height / 2);
        textSize(250);
        text(puntajeOne, width / 2, 900);
      }
      else if(turn == 1){
        image(playerTwo, width / 2, height / 2);
        textSize(250);
        text(puntajeTwo, width / 2, 900);
      }
      
      if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        min = (int) time / 60;
        seg = (int) time % 60;
        time--;
      }
      
      if(seg > 9){
        text("0" + min + ":" + seg, 640, 400);
      }
      else{
        text("0" + min + ":0" + seg, 640, 400);
      }
      
      if(port.available() > 0){
        sensor = port.read();
        println(sensor);
        if(sensor == 7){
          if(turn == 0){
            puntajeOne += 1;
            man = true;
          }
            
           else{
             puntajeTwo += 1;
             man = true;
           }
        }
        if(sensor == 13){
          if(turn == 0){
            puntajeOne += 9;
            firecracker.play();
            firecracker.rewind();
            mon = true;
          }
            
          else{
             puntajeTwo += 9;
             firecracker.play();
             firecracker.rewind();
             mon = true;
          }
        }
      }
      {
        if(keyPressed){
          if(key == 'U' || key == 'u'){
            if(turn == 0){
              puntajeOne += 1;
              man = true;
              delay(100);
            }
            else{
              puntajeTwo += 1;
              man = true;
              delay(100);
            }
          }
          else if(key == 'I' || key == 'i'){
            if(turn == 0){
              puntajeOne += 3;
              delay(100);
            }
            else{
              puntajeTwo += 3;
              delay(100);
            }
          }
          else if(key == 'O' || key == 'o'){
            if(turn == 0){
              puntajeOne += 6;
              delay(100);
            }
            else{
              puntajeTwo += 6;
              delay(100);
            }
          }
          else if(key == 'P' || key == 'p'){
            if(turn == 0){
              puntajeOne += 9;
              firecracker.play();
              firecracker.rewind();
              mon = true;
              delay(100);
            }
            else{
              puntajeTwo += 9;
              firecracker.play();
              firecracker.rewind();
              mon = true;
              delay(100);
            }
          }
        }
        
      if(man == true && counter > 0){
        image(mano, width / 2, height / 2);
        counter -= 30;
        println(counter);
      }
      else if(man == true && counter < 1){
        counter = 1000;
        man = false;
      }
      if(mon == true && counter > 0){
        image(monona, width / 2, height / 2);
        counter -= 30;
        println(counter);
      }
      else if(mon == true && counter < 1){
        counter = 1000;
        mon = false;
      }
    
      if((time < 0 && turn == 1)){
        screen = 4;
        counter = 10;
      }
      else if((time < 0 && turn == 0)){
        turn = 1;
        moment = 3;
        time = 60;
      }
    }
   }    
  }
  //TWO PLAYERS SCOREBOARD
  else if (screen == 4){
    background(255, 200, 100);
    image(bestVS, width / 2, height / 2);
    textSize(300);
    text(puntajeOne, width/4, 800);
    text(puntajeTwo, 3*(width/4), 800);
    
    if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        counter--;
        println(counter);
      }
    if(counter == 0){
      moment = 1;
      screen = 0;
      counter = 1000;
      puntajeOne = 0;
      puntajeTwo = 0;
      time = 60;
    }
  }
  //HIGH SCORES
  else if(screen == 5){
    y = 200;
    if(moment == 0){
      background(10);
      image(bestSingle, width / 2, height / 2);
    
      int converter = 60 - bestTime;
      int converter2 = 60 - timeSingle;
      int m = (int) converter / 60;
      int s = (int) converter % 60;
      int m2 = (int) converter2 / 60;
      int s2 = (int) converter2 % 60;
      if(s > 9){
          text("0" + m + ":" + s, 850, 400);
          text("0" + m2 + ":" + s2, 700, 930);
        }
        else{
          text("0" + m + ":0" + s, 850, 400);
          text("0" + m2 + ":0" + s2, 700, 930);
        }
    }
    if(millis() > lasttimecheck + timeinterval){
        lasttimecheck = millis();
        counter--;
        println(counter);
      }
    if(counter == 0){
      moment = 1;
      screen = 0;
      counter = 1000;
      timeSingle = 0;
      time = 60;
    }
  }
}

/*if(port.available() > 0){
      sensor = port.read();
      println(sensor);
      if(sensor == 2){
        puntaje = puntaje + 3;
      }
      else if(sensor == 3 || sensor == 4 || sensor == 5 || sensor == 6){
        puntaje = puntaje + 1;
      }
    }*/
