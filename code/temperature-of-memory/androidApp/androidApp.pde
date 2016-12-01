import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.os.Handler;
import android.os.Message;
import com.neurosky.thinkgear.*;
import android.os.Environment;

//BLUETOOTH
BluetoothAdapter bluetoothAdapter;
TGDevice tgDevice;

//NEUROSKY
final boolean rawEnabled = true;
int connected, connecting, notPaired, disconnected, cantFind;
boolean btState;
int attention, meditation, blink, raw1;

import ketai.sensors.*;
KetaiAudioInput mic;
short[] data;

int butRad = 250;
int xPos;
int yPos;
boolean butClicked;
boolean micStarted;
PFont font;

void setup() {
  size(720, 1280);

  bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
  if (bluetoothAdapter == null) {
    btState = false;
  } else {
    /* create the TGDevice */
    tgDevice = new TGDevice(bluetoothAdapter, handler);
    btState = true;
  }

  orientation(PORTRAIT);
  mic = new KetaiAudioInput(this);
  font = createFont("Ubuntu-48.vlw", 28);
  textFont(font);
  xPos = width/2;
  yPos = height - height/4;
  butClicked = false;
  micStarted = false;
}

void draw() {
  background(128);

  if (btState) {
    if (tgDevice.getState() != TGDevice.STATE_CONNECTING && tgDevice.getState() != TGDevice.STATE_CONNECTED) {
      tgDevice.connect(rawEnabled);
    }
    initState();
  } else {
    text("Bluetooth not available", 20, 40);
  }

  if (butClicked) {
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  ellipse(xPos, yPos, butRad, butRad);
  drawData();
}

void initState() {
  int posX = width/2;
  int posY = 80;
  textAlign(CENTER);
  textSize(22);
  fill(255);
  
  text("Attention: " + str(attention), posX, posY+40);
  
  if (connected == TGDevice.STATE_CONNECTED) {
    text("Connected.\n", posX, posY);
  } else if (connecting == TGDevice.STATE_CONNECTING) {
    text("Connecting...\n", posX, posY);
  } else if (cantFind == TGDevice.STATE_NOT_FOUND) {
    text("Can't find\n", posX, posY);
  } else if (notPaired == TGDevice.STATE_NOT_PAIRED) {
    text("not paired\n", posX, posY);
  } else if (disconnected == TGDevice.STATE_DISCONNECTED) {
    text("Disconnected mang\n", posX, posY);
  }
}

void drawData() {
  //fill(255);
  if (data != null) {  
    for (int i = 0; i < data.length; i++) {
      if (i != data.length-1) {
        line(i, map(data[i], -32768, 32767, height, 0), i+1, map(data[i+1], -32768, 32767, height, 0));
      }
    }
  }
}

void onAudioEvent(short[] _data) {
  data= _data;
}

void mouseReleased() {
  if (mouseX >= (xPos - butRad/2) && mouseX <= (xPos + butRad/2) && mouseY >= (yPos - butRad/2) && mouseY <= (yPos + butRad/2)) {
    butClicked = !butClicked;
    micStarted = !micStarted;
    println(mic.isActive());
    if (micStarted) {
      mic.start();
    } else {
      mic.stop();
    }
  }
}