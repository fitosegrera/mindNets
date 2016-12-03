import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.os.Handler;
import android.os.Message;
import android.os.Environment;
import com.neurosky.thinkgear.*;

//AUDIO
import android.media.MediaRecorder;
import android.os.Environment;
MediaRecorder mRecorder;
String recFileName;
//

//BLUETOOTH
BluetoothAdapter bluetoothAdapter;
TGDevice tgDevice;
//

//NEUROSKY
final boolean rawEnabled = true;
int connected, connecting, notPaired, disconnected, cantFind;
boolean btState;
int attention, meditation, blink, raw1;
String attentionTotal;
boolean recordAttention;
//

//TIMESTAMP
String uniqueTimestamp;
int timeCount = 0;
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

  xPos = width/2;
  yPos = height - (height/4);
  butSize = 220;
  butClicked = false;
  
  uniqueTimestamp = str(timeCount);
  
  attentionTotal = "";
  recordAttention = false;
  
}

void draw() {
  background(120);

  if (btState) {
    if (tgDevice.getState() != TGDevice.STATE_CONNECTING && tgDevice.getState() != TGDevice.STATE_CONNECTED) {
      tgDevice.connect(rawEnabled);
    }
    displayState();
  } else {
    text("Bluetooth not available!", 20, 40);
  }

  if (butClicked) {
    fill(204, 255, 0);
  } else {
    fill(255, 25, 0);
  }
  ellipse(xPos, yPos, butSize, butSize);
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
    if (butClicked) {
      startRecording();
      attentionTotal = "";
      recordAttention = true;
    } else {
      timeCount+=1;
      uniqueTimestamp = str(timeCount);
      // SAVE attentionTotal as a .txt
      recordAttention = false;
      String[] data = new String[1];
      data[0] = attentionTotal; 
      saveStrings("//sdcard//temp_memory//" + uniqueTimestamp + ".txt" , data);
      stopRecording();
    }
  }
}

void startRecording() {
  recFileName = "//sdcard//temp_memory//" + uniqueTimestamp + ".3gp";
  mRecorder = new MediaRecorder();
  mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
  mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
  mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
  mRecorder.setOutputFile(recFileName);
  try {
    mRecorder.prepare();
    mRecorder.start();
  } 
  catch (IllegalStateException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

void stopRecording() {
  mRecorder.stop();
  mRecorder.release();
  mRecorder = null;
}