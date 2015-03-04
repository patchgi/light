#include<Servo.h>

Servo servo;
int serialWrite = 0;
int sw = LOW, last_sw = LOW;
int psw = LOW, plast_sw = LOW;

void setup() {
  Serial.begin(9600);

  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(11, OUTPUT);
  servo.attach(3);
  pinMode(2, INPUT_PULLUP);
  pinMode(4, INPUT_PULLUP);
}

void loop() {
  sw = digitalRead(2);
  psw = digitalRead(4);
  int valume = analogRead(0) / 4;

  /* if (valume > 253) {
      valume = 253;
    }
  */
  int swipe = analogRead(1) / 4;
  int sendData = swipe;

  

  if (swipe == 254 || swipe == 255) {
    sendData = 253;
  }
  analogWrite(5, sendData + 2);
  analogWrite(6, sendData + 2);
  analogWrite(11, sendData + 2);


  if (sw == LOW && last_sw == HIGH) {
    Serial.print(0);
    Serial.print(",");
    Serial.print(0);
    Serial.print(",");
    Serial.println(0);
    Serial.print("\n");

    serialWrite = 1 - serialWrite;
  }

  if (psw == LOW && plast_sw == HIGH) {
    Serial.print(1);
    Serial.print(",");
    Serial.print(0);
    Serial.print(",");
    Serial.println(0);
    Serial.print("\n");
  }

  if (serialWrite == 1) {

    analogWrite(5, sendData + 2);
    analogWrite(6, sendData + 2);
    analogWrite(11, sendData + 2);
    
    int pulthWidth2 = map(valume, 0, 255, 45, 135);
    servo.write(pulthWidth2);
    Serial.print(sendData);
    Serial.print(",");
    Serial.println(valume);
    Serial.print("\n");
  }

  else {
    if (Serial.available() > 1) {

      int LEDdata = Serial.read();
      int Sdata = Serial.read();
      int Serdata = Sdata;
      int pulthWidth = map(Serdata, 0, 255, 45, 135);


      analogWrite(5, LEDdata + 2);
      analogWrite(6, LEDdata + 2);
      analogWrite(11, LEDdata + 2);

      

      servo.write(pulthWidth);

    }
  }
  last_sw = sw;
  plast_sw = psw;
  delay(10);

}
