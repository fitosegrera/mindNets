private final Handler handler = new Handler() {
  @Override
    public void handleMessage(Message msg) {
    switch (msg.what) {
    case TGDevice.MSG_STATE_CHANGE:
      switch (msg.arg1) {
      case TGDevice.STATE_IDLE:
        break;
      case TGDevice.STATE_CONNECTING:
        connecting = msg.arg1;
        break;                        
      case TGDevice.STATE_CONNECTED:
        connected = msg.arg1;
        tgDevice.start();
        break;
      case TGDevice.STATE_NOT_FOUND:
        cantFind = msg.arg1;
        break;
      case TGDevice.STATE_NOT_PAIRED:
        notPaired = msg.arg1;
        break;
      case TGDevice.STATE_DISCONNECTED:
        disconnected = msg.arg1;
      }

      break;
    case TGDevice.MSG_POOR_SIGNAL:
      //signal = msg.arg1;
      //text("PoorSignal: " + msg.arg1 + "\n", posX, posY);
      break;
    case TGDevice.MSG_RAW_DATA:    
      raw1 = msg.arg1;
      //tv.append("Got raw: " + msg.arg1 + "\n");
      break;
    case TGDevice.MSG_HEART_RATE:
      //text("Heart rate: " + msg.arg1 + "\n", posX, posY);
      break;
    case TGDevice.MSG_ATTENTION:
      attention = msg.arg1;
      if(recordAttention){
        attentionTotal = attentionTotal + str(attention) + ",";
      }
      //text("Attention: " + msg.arg1 + "\n", posX, posY);
      //Log.v("HelloA", "Attention: " + att + "\n");
      break;
    case TGDevice.MSG_MEDITATION:
      meditation = msg.arg1;
      break;
    case TGDevice.MSG_BLINK:
      blink = msg.arg1;
      //text("Blink: " + msg.arg1 + "\n", posX, posY);
      break;
    case TGDevice.MSG_RAW_COUNT:
      //tv.append("Raw Count: " + msg.arg1 + "\n");
      break;
    case TGDevice.MSG_LOW_BATTERY:
      //Toast.makeText(getApplicationContext(), "Low battery!", Toast.LENGTH_SHORT).show();
      break;
    case TGDevice.MSG_RAW_MULTI:
      //TGRawMulti rawM = (TGRawMulti)msg.obj;
      //tv.append("Raw1: " + rawM.ch1 + "\nRaw2: " + rawM.ch2);
    default:
      break;
    }
  }
};