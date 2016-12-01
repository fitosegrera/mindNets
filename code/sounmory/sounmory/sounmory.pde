import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.os.Handler;
import android.os.Message;
import android.os.Environment;
import com.neurosky.thinkgear.*;

//BLUETOOTH
BluetoothAdapter bluetoothAdapter;
TGDevice tgDevice;
//

//NEUROSKY
final boolean rawEnabled = true;
int connected, connecting, notPaired, disconnected, cantFind;
boolean btState;
int attention, meditation, blink, raw1;
//

//AUDIO
import ketai.sensors.*;
KetaiAudioInput mic;
short[] data;
boolean micStarted;
//

int xPos, yPos;
int butSize;
boolean butClicked;

void setup() {
  size(720, 1280);

  bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
  if (bluetoothAdapter == null) {
    btState = false;
  } else {
    tgDevice = new TGDevice(bluetoothAdapter, handler);
    btState = true;
  }

  orientation(PORTRAIT);
  mic = new KetaiAudioInput(this);

  xPos = width/2;
  yPos = height - (height/4);
  butSize = 220;
  butClicked = false;
  micStarted = false;
}

void draw() {
  background(120);

  if (btState) {
    if(tgDevice.getState() != TGDevice.STATE_CONNECTING && tgDevice.getState() != TGDevice.STATE_CONNECTED){
      tgDevice.connect(rawEnabled);
    }
    displayState();
  }else{
    text("Bluetooth not available!",20,40);
  }

  if (butClicked) {
    fill(204, 255, 0);
  } else {
    fill(255, 25, 0);
  }
  ellipse(xPos, yPos, butSize, butSize);
  drawData();
}

void onAudioEvent(short[] _data) {
  data = _data;
}

void drawData() {
  if (data != null) {
    for (int i=0; i<data.length; i++) {
      if (i != data.length-1) {
        fill(200);
        line(i, map(data[i], -32768, 32767, height, 0), i+1, map(data[i+1], -32768, 32767, height, 0));
      }
    }
  }
}

void displayState() {
  int posX = width/2;
  int posY = 90;
  textSize(30);
  textAlign(CENTER);
  fill(255);

  text("Attention: " + str(attention), posX, posY+40);

  if (connected == TGDevice.STATE_CONNECTED) {
    text("Connected.\n", posX, posY);
  } else if (connecting == TGDevice.STATE_CONNECTING) {
    text("Connecting...\n", posX, posY);
  } else if (cantFind == TGDevice.STATE_NOT_FOUND) {
    text("Can't find.\n", posX, posY);
  } else if (notPaired == TGDevice.STATE_NOT_PAIRED) {
    text("Not Paired.\n", posX, posY);
  } else if (disconnected == TGDevice.STATE_DISCONNECTED) {
    text("Connected.\n", posX, posY);
  }
}

void mouseReleased() {
  if (mouseX >= (xPos - butSize/2) && mouseX <= (xPos + butSize/2) && mouseY >= (yPos - butSize/2) && mouseY <= (yPos + butSize/2)) {
    butClicked = !butClicked;
    micStarted = !micStarted;
    if (micStarted) {
      mic.start();
    } else {
      mic.stop();
    }
  }
}