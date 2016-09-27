import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.os.Handler;
import android.os.Message;
import java.net.HttpURLConnection;
import com.neurosky.thinkgear.*;
import android.os.Environment;
import ketai.camera.*;
import ketai.sensors.*; 
import java.util.Calendar;
import java.util.Date;
//import java.io.FileOutputStream;
//import java.io.FileWriter;

//GPS
KetaiLocation location;
double longitude, latitude, altitude;

//CAM
KetaiCamera cam;

//BLUETOOTH
BluetoothAdapter bluetoothAdapter;
TGDevice tgDevice;

//ACCELEROMETER
KetaiSensor accel;
float accelerometerX, accelerometerY, accelerometerZ;

//light
KetaiSensor lightSensor;
float light;

//orientation
KetaiSensor orientSensor;
float orientX, orientY, orientZ;

//JSON
JSONObject json, accelJson, orientJson, gpsJson;

final boolean rawEnabled = true;
int connected, connecting, notPaired, disconnected, cantFind;
boolean btState;

int attention, meditation, blink, raw1;
color ac = color(255, 102, 102);
color mc = color(102, 255, 255);
color bc = color(204, 255, 51);

String rawTotal;
float timeLimit = 20000;
float startTime;
boolean isTimerRunning = false;

String title1 = "Agnosis:";
String title2 = "the lost memories...";
PFont f;

int isAttentionHigh = 0;
int pic;

String datetime;
String uniqueTimestamp;
String directory;

void setup() {

  size(720, 1280);
  f = loadFont("Ubuntu-48.vlw");
  fill(200);

  bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
  if (bluetoothAdapter == null) {
    btState = false;
  } else {
    /* create the TGDevice */
    tgDevice = new TGDevice(bluetoothAdapter, handler);
    btState = true;
  }

  orientation(PORTRAIT);

  pic = 0;
  imageMode(CENTER);
  cam = new KetaiCamera(this, 640, 480, 24);
  //cam.setPhotoSize(800, 800);
  cam.start();

  location = new KetaiLocation(this);
  Calendar c = Calendar.getInstance();

  accel = new KetaiSensor(this);
  accel.start();

  lightSensor = new KetaiSensor(this);
  lightSensor.start();

  orientSensor = new KetaiSensor(this);
  orientSensor.start();

  uniqueTimestamp = new String(timeStamp());
}

void draw() {

  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(62);
  text(title1, width/2, 50);
  textSize(36);
  text(title2, width/2, 120);

  if (btState) {
    if (tgDevice.getState() != TGDevice.STATE_CONNECTING && tgDevice.getState() != TGDevice.STATE_CONNECTED) {
      tgDevice.connect(rawEnabled);
    }

    textAlign(CENTER);
    textSize(32);
    fill(ac);
    text("Attention: " + attention, width/2, height - 390);
    fill(mc);
    text("Meditation: " + meditation, width/2, height - 340);
    fill(bc);
    text("Blink: " + blink, width/2, height - 290);
    //println(raw1);

    textSize(22);
    if (location.getProvider() == "none") {
      text("Location data is unavailable. \n" +
        "Please check your location settings.", width/2, height - 250);
    } else {
      text("Latitude: " + latitude + "\n" + 
        "Longitude: " + longitude + "\n" + 
        "Altitude: " + altitude + "\n" + 
        "Provider: " + location.getProvider(), width/2, height - 200);
    }

    text("Accelerometer: \n" + 
      "x: " + nfp(accelerometerX, 1, 3) + "\n" +
      "y: " + nfp(accelerometerY, 1, 3) + "\n" +
      "z: " + nfp(accelerometerZ, 1, 3), width/6, height - 200);

    text("Orientation: \n" + 
      "x: " + orientX + "\n" +
      "y: " + orientY + "\n" +
      "z: " + orientZ, width - width/6, height - 200);

    text("Light: " + light, width/2, height - 50);

    initState();

    image(cam, width/2, (height/2) - 200);

    if (attention > 0 && attention < 40 ) {
      fill(255);
      textAlign(CENTER);
      textSize(22);
      datetime = timeStamp();
      text(datetime, width/2, height - 450);
      if (!isTimerRunning && isAttentionHigh == 0) {
        text("Image Captured: ", width/2, height - 500);
        pic++;
        makePhoto();
        isTimerRunning = true;
        startTime = millis();
      }
      isAttentionHigh++;
    } else {
      isAttentionHigh = 0;
    }
  } else {
    text("Bluetooth not available", width/2, height/2);
  }

  if (isTimerRunning) {
    timer(startTime);
  }
}

void onCameraPreviewEvent() {
  cam.read();
}

void initState() {
  int posX = width/2;
  int posY = 180;
  textAlign(CENTER);
  textSize(22);
  fill(255);

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

void onLocationEvent(double _latitude, double _longitude, double _altitude) {
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  println("lat/lon/alt: " + latitude + "/" + longitude + "/" + altitude);
}

void onAccelerometerEvent(float x, float y, float z) {
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

void onLightEvent(float d) {
  light = d;
}

void onOrientationEvent(float x, float y, float z) {
  orientX = x;
  orientY = y;
  orientZ = z;
}

String timeStamp() {
  Date now = new Date();
  return now.toString();
}

void onDestroy() {
  tgDevice.close();
}

void makePhoto() {
  directory = "//sdcard//agnosis//agnosis_" + uniqueTimestamp;
  //cam.setSaveDirectory(directory);
  cam.savePhoto(directory + "//memory_"+str(pic)+".jpg");
}

void makeJson() {
  directory = "//sdcard//agnosis//agnosis_" + uniqueTimestamp;

  json = new JSONObject();
  json.setInt("attention", attention);
  json.setInt("meditation", meditation);
  json.setString("timestamp", datetime);
  json.setString("image_path", directory);
  json.setString("raw", rawTotal);

  accelJson = new JSONObject();
  accelJson.setFloat("x", accelerometerX);
  accelJson.setFloat("y", accelerometerY);
  accelJson.setFloat("z", accelerometerZ);
  json.setJSONObject("accelerometer", accelJson);

  orientJson = new JSONObject();
  orientJson.setFloat("x", orientX);
  orientJson.setFloat("y", orientY);
  orientJson.setFloat("z", orientZ);
  json.setJSONObject("orientation", orientJson);

  gpsJson = new JSONObject();
  gpsJson.setFloat("lat", (float)latitude);
  gpsJson.setFloat("lon", (float)longitude);
  gpsJson.setFloat("alt", (float)altitude);
  json.setJSONObject("gps", gpsJson);

  println(json.toString());
  //saveJSONObject(json, directory + "/agnosis"+str(pic)+".json");
  String[] data = new String[1];
  data[0] = json.toString(); 

  createOutput(directory + "//memory_" + str(pic) + ".txt");
  saveStrings(directory + "//memory_" + str(pic) + ".txt", data);
}

void timer(float st) {
  if (millis() - st <= timeLimit) {
    rawTotal += str(raw1) + " ";
  }
  else{
   isTimerRunning = false; 
   makeJson();
   println(rawTotal);
   rawTotal = "";
  }
}