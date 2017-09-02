import controlP5.*;
import processing.net.*;

ControlP5 cp5;

//STYLE
public int mainYellow       ;
public int mainBlue         ;
public int mainBackground   ;
public int panelBackground  ;
public int label            ;
public int dimYellow        ;
public int thinLines        ;
public int inactive         ;
public int textColor        ;
public int valueLabel       ;


float soundGain;
float soundDecay;
Rectangle soundFocusGUI;

OscInterface osc;
public boolean oscConfigUpdate = false;
public String myIpAddress;
public String remoteIpAddress;
public int incomingPort;
public int outgoingPort;

void initializeGUI() {
  colorMode(HSB);
  mainYellow       = color(27, 228, 251);
  mainBlue         = color(137, 252, 100);
  mainBackground   = color(0, 0, 52);
  panelBackground  = color(156, 16, 48);
  label            = color(0, 0, 202);
  dimYellow        = color(27, 255, 148);
  thinLines        = color(0, 0, 102);
  inactive         = color(0, 0, 61);
  textColor        = color(255, 0, 176);
  valueLabel      = label;

  cp5 = new ControlP5(this);
  cp5.setColorForeground(dimYellow);
  cp5.setColorActive(mainYellow);
  cp5.setColorBackground(mainBlue);
  cp5.setColorCaptionLabel(textColor);
  cp5.setColorValueLabel(valueLabel);

  cp5.addSlider("soundGain")
    .plugTo(soundGain)
    .setPosition(30, height/2+40)
    .setSize((width-60)/2, 50)
    .setRange(0.f, 5.f)
    .setValue(1.f)
    .setCaptionLabel("Gain");  

  cp5.addSlider("soundDecay")
    .plugTo(soundDecay)
    .setPosition(30, height/2+110)
    .setSize((width-60)/2, 50)
    .setRange(0.01f, 0.5f)
    .setValue(0.1f)
    .setCaptionLabel("Decay");  

  soundFocusGUI = new Rectangle(soundWavePanel.x+2, soundWavePanel.y+1, soundWavePanel.width-2, soundWavePanel.height-1);

  osc = new OscInterface();
  myIpAddress = Server.ip();
  cp5.addButton("connectOsc")
    .setPosition(width/2+100, height/2+40)
    .setSize(100, 50)
    .setCaptionLabel("OSC");


  cp5.addTextfield("incomingPortText")
    .setPosition(853, 361)
    .setSize(55, 20)
    .setFocus(true)
    .setAutoClear(false)
    .setCaptionLabel("")
    ;
  cp5.get(Textfield.class, "incomingPortText").hide();

  cp5.addTextfield("outgoingPortText")
    .setPosition(853, 397)
    .setSize(55, 20)
    .setFocus(true)
    .setAutoClear(false)
    .setCaptionLabel("")
    ;
  cp5.get(Textfield.class, "outgoingPortText").hide();

  cp5.addTextfield("remoteIpText")
    .setPosition(705, 397)
    .setSize(130, 20)
    .setFocus(true)
    .setAutoClear(false)
    .setCaptionLabel("")
    ;
  cp5.get(Textfield.class, "remoteIpText").hide();
}

public void connectOsc() {
  println("Attempting to connect OSC");
  osc.setIpAndPort(incomingPort, remoteIpAddress, outgoingPort);
  osc.oscConnect();
}

public void incomingPortText(String theText) {
  println("Incoming Port: " + theText);
  cp5.get(Textfield.class, "incomingPortText").hide();
  if (!theText.equals("")) {
    incomingPort = Integer.valueOf(theText);  
    oscConfigUpdate = true;
  }
}

public void outgoingPortText(String theText) {
  println("Outgoing Port: " + theText);
  cp5.get(Textfield.class, "outgoingPortText").hide();
  if (!theText.equals("")) {
    outgoingPort = Integer.valueOf(theText);  
    oscConfigUpdate = true;
  }
}

public void remoteIpText(String theText) {
  println("Remote IP: " + theText);
  cp5.get(Textfield.class, "remoteIpText").hide();
  if (!theText.equals("")) {
    remoteIpAddress = theText;  
    oscConfigUpdate = true;
  }
}

void mainDecorations() {
  noStroke();
  fill(mainYellow);
  rect(30, 0, width-60, 5);
  rect(30, height-5, width-60, height);

  fill(mainBlue);
  rect(0, 0, 5, height-15);
  rect(width-5, 0, width, height-15);
  drawSoundWavePanel();
  stroke(thinLines);
  strokeWeight(2);
  line(width/2+50, height/2+40, width/2+50, height-50);
  drawOsc();
}

void drawSoundWavePanel() {
  stroke(thinLines);
  strokeWeight(2);
  fill(panelBackground);
  rect(soundWavePanel.x, soundWavePanel.y, soundWavePanel.width, soundWavePanel.height);
}

public void drawSoundFocus(int x_, int y_, int w_, int h_) {
  if (soundFocusGUI.contains(mouseX, mouseY)) {
    fill(255, 50);
    if (mousePressed) {
      soundFocusGUI.x += mouseX-pmouseX;
      soundFocusGUI.width = constrain(soundFocusGUI.width, 4, soundWavePanel.width);
      soundFocusGUI.x = constrain(soundFocusGUI.x, soundWavePanel.x, soundWavePanel.x+soundWavePanel.width-soundFocusGUI.width);
    }
  } else {
    fill(255, 10);
  }
  noStroke();
  rect(soundFocusGUI.x, soundFocusGUI.y, soundFocusGUI.width, soundFocusGUI.height);
}


void drawOsc() {
  strokeWeight(50);
  if (osc.isConnected) {
    stroke(mainYellow);
  } else {
    stroke(mainBlue);
  }
  point(width/2+255, height/2+65);

  fill(textColor);
  textSize(20);
  text("Incoming: " + myIpAddress, 598, 377);
  text(" : " + incomingPort, 836, 377);

  text("Outgoing: " + remoteIpAddress, 598, 412);
  text(" : " + outgoingPort, 836, 412);
}