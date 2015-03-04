import processing.serial.*;
import ddf.minim.*;


Minim minim;
AudioInput in;
AudioRecorder recorder; 

AudioPlayer player;

Serial serial;
ArrayList <String> Idata;
ArrayList <String> LEDdata;
int input, sinput, sendCount;

void setup() {
  serial=new Serial(this, Serial.list()[0], 9600);
  LEDdata=new ArrayList<String>();
  Idata=new ArrayList<String>();

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  recorder = minim.createRecorder(in, "myrecording.wav", true);
}

void draw() {
  noLoop();
}

void serialEvent(Serial port) {
  String inString = port.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);
    String [] value = split(inString, ','); 
    if (value.length>2) {
      if (value[0].equals("0")) {
        AudioOutput out;
        if ( recorder.isRecording() ) {
          recorder.endRecord();
          delay(100);
          recorder.save();
          String []LEDsaveData=new String[LEDdata.size()];
          String []saveData=new String[Idata.size()];
          for (int i=0; i<LEDsaveData.length; i++) {
            LEDsaveData[i]="";
            saveData[i]="";
          }
          for (int  j=0; j<LEDsaveData.length; j++) {
            LEDsaveData[j]=LEDdata.get(j);
            saveData[j]=Idata.get(j);
          }
          saveStrings("LEDdata.txt", LEDsaveData);
          saveStrings("inputdata.txt", saveData);

          print ("save");
          print(LEDdata);
          println("end");
        } else {
          recorder.beginRecord();
          println("start");
        }
      } else if (value[0].equals("1")) {
        print("play");
        sendSequence();
      }
    } else if (value.length > 1) {
      LEDdata.add(value[0]);
      Idata.add(value[1]);
      println("SLED "+value[0]);
      println("SServo "+value[1]);
    }
  }
}

void keyPressed() {
  switch(key) {
  case 's':
    String []LEDsaveData=new String[LEDdata.size()];
    String []saveData=new String[Idata.size()];
    for (int i=0; i<LEDsaveData.length; i++) {
      LEDsaveData[i]="";
      saveData[i]="";
    }
    for (int  j=0; j<LEDsaveData.length; j++) {
      LEDsaveData[j]=LEDdata.get(j);
      saveData[j]=Idata.get(j);
    }
    saveStrings("LEDdata.txt", LEDsaveData);
    saveStrings("inputdata.txt", saveData);

    print ("save");
    print(LEDdata);
    break;
  case 'p':
    print("play");
    sendSequence();
    break;
  }
}
void sendSequence() {
  String []LEDreadData=loadStrings("LEDdata.txt");
  String []readData=loadStrings("inputdata.txt");
  int dataLength = readData.length;
  int []LEDwriteData=new int[dataLength];
  int []writeData=new int[dataLength];
  for (int j = 0; j < dataLength; j++) {
    LEDwriteData[j]=int(LEDreadData[j]);
    writeData[j]=int(readData[j]);
    if (sendCount==1) {
      player=minim.loadFile("myrecording.wav");
      player.play();
    }
    serial.write(LEDwriteData[j]);
    serial.write(writeData[j]);
    println("sendLED "+LEDwriteData[j]);
    println("sendServo "+writeData[j]);
    sendCount++;
    if()
    delay(10);
  }
}

