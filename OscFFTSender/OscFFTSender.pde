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
  Textfield incomingPort = cp5.get(Textfield.class, "incomingPortText");
  Rectangle incomingPortRect = new Rectangle((int)incomingPort.getPosition()[0], (int)incomingPort.getPosition()[1], (int)incomingPort.getWidth(), (int)incomingPort.getHeight());
  if (incomingPortRect.contains(mouseX, mouseY)) {
    incomingPort.show();
    incomingPort.setText("");
    incomingPort.setFocus(true);
  }

  Textfield outgoingPort = cp5.get(Textfield.class, "outgoingPortText");
  Rectangle outgoingPortRect = new Rectangle((int)outgoingPort.getPosition()[0], (int)outgoingPort.getPosition()[1], (int)outgoingPort.getWidth(), (int)outgoingPort.getHeight());
  if (outgoingPortRect.contains(mouseX, mouseY)) {
    outgoingPort.show();
    outgoingPort.setText("");
    outgoingPort.setFocus(true);
  }

  Textfield remoteIp = cp5.get(Textfield.class, "remoteIpText");
  Rectangle remoteIpRect = new Rectangle((int)remoteIp.getPosition()[0], (int)remoteIp.getPosition()[1], (int)remoteIp.getWidth(), (int)remoteIp.getHeight());
  if (remoteIpRect.contains(mouseX, mouseY)) {
    remoteIp.show();
    remoteIp.setText("");
    remoteIp.setFocus(true);
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
