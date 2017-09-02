SoundAnalyzer s;


Rectangle soundWavePanel;
float soundFocusSize;
float soundFocusOffset;


void settings() {
  size(1000, 500);
  soundWavePanel = new Rectangle(30, 20, width-60, height/2-10);
}

void setup() {
  s = new SoundAnalyzer(this);
  initializeGUI();
  loadConfigFile();
  background(mainBackground);
}

void draw() {
  surface.setTitle((int)frameRate + " fps");
  background(mainBackground);
  mainDecorations();

  s.setGain(soundGain);
  s.setDecay(soundDecay);
  s.analyze();
  noStroke();
  fill(mainBlue);
  s.drawFFTRaw(soundWavePanel.x, soundWavePanel.y, soundWavePanel.width, soundWavePanel.height);
  fill(dimYellow);
  s.drawFFTSmooth(soundWavePanel.x, soundWavePanel.y, soundWavePanel.width, soundWavePanel.height);

  if (osc.isConnected) {
    osc.sendArray("/fftFocusSmooth", s.soundFocusSpectrumLPF);
  }
  
  soundFocusSize = (int)map(soundFocusGUI.width, 0, soundWavePanel.width, 0, s.spectrumSize);
  soundFocusOffset = (int)map(soundFocusGUI.x, soundWavePanel.x, soundWavePanel.x+soundWavePanel.width-soundFocusGUI.width, 0, s.spectrumSize);
  s.setSoundFocus((int)soundFocusOffset, (int)soundFocusSize);  
  drawSoundFocus(soundWavePanel.x, soundWavePanel.y, soundWavePanel.width, soundWavePanel.height);

  if (oscConfigUpdate) {
    saveConfigFile();
    oscConfigUpdate = false;
  }
}

void mousePressed() {
  println(mouseX + " - " + mouseY);
  Rectangle incomingPortRect = new Rectangle((int)cp5.get(Textfield.class, "incomingPortText").getPosition()[0], (int)cp5.get(Textfield.class, "incomingPortText").getPosition()[1], (int)cp5.get(Textfield.class, "incomingPortText").getWidth(), (int)cp5.get(Textfield.class, "incomingPortText").getHeight());
  if (incomingPortRect.contains(mouseX, mouseY)) {
    cp5.get(Textfield.class, "incomingPortText").show();
    cp5.get(Textfield.class, "incomingPortText").setText("");
    cp5.get(Textfield.class, "incomingPortText").setFocus(true);
  }

  Rectangle outgoingPortRect = new Rectangle((int)cp5.get(Textfield.class, "outgoingPortText").getPosition()[0], (int)cp5.get(Textfield.class, "outgoingPortText").getPosition()[1], (int)cp5.get(Textfield.class, "outgoingPortText").getWidth(), (int)cp5.get(Textfield.class, "outgoingPortText").getHeight());
  if (outgoingPortRect.contains(mouseX, mouseY)) {
    cp5.get(Textfield.class, "outgoingPortText").show();
    cp5.get(Textfield.class, "outgoingPortText").setText("");
    cp5.get(Textfield.class, "outgoingPortText").setFocus(true);
  }

  Rectangle remoteIpRect = new Rectangle((int)cp5.get(Textfield.class, "remoteIpText").getPosition()[0], (int)cp5.get(Textfield.class, "remoteIpText").getPosition()[1], (int)cp5.get(Textfield.class, "remoteIpText").getWidth(), (int)cp5.get(Textfield.class, "remoteIpText").getHeight());
  if (remoteIpRect.contains(mouseX, mouseY)) {
    cp5.get(Textfield.class, "remoteIpText").show();
    cp5.get(Textfield.class, "remoteIpText").setText("");
    cp5.get(Textfield.class, "remoteIpText").setFocus(true);
  }
}

public void mouseWheel(processing.event.MouseEvent event) {
  if (soundWavePanel.contains(mouseX, mouseY)) {
    soundFocusGUI.x -= event.getCount();
    soundFocusGUI.width += event.getCount()*2;

    soundFocusGUI.width = constrain(soundFocusGUI.width, 4, soundWavePanel.width-4);
    soundFocusGUI.x = constrain(soundFocusGUI.x, soundWavePanel.x, soundWavePanel.x+soundWavePanel.width-soundFocusGUI.width);
  }
}

public void stop() {
  saveConfigFile();
}
