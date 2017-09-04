public void loadConfigFile() {
  try {
    JSONObject config = loadJSONObject("data/config.json");

    JSONObject soundParams = config.getJSONObject("sound");
    soundFocusGUI.width = soundParams.getInt("soundFocusSize");
    soundFocusGUI.x = soundParams.getInt("soundFocusOffset");

    JSONObject oscParams = config.getJSONObject("osc");
    incomingPort = oscParams.getInt("incomingPort");
    outgoingPort = oscParams.getInt("outgoingPort");
    remoteIpAddress = oscParams.getString("remoteIP");
  } 
  catch(Exception e) {
    println("Couldn't find Config file");
  }
}

public void saveConfigFile() {
  JSONObject config = new JSONObject();

  JSONObject soundParams = new JSONObject();
  soundParams.setInt("soundFocusSize", soundFocusGUI.width);
  soundParams.setInt("soundFocusOffset", soundFocusGUI.x);
  config.setJSONObject("sound", soundParams);

  JSONObject oscParams = new JSONObject();
  oscParams.setInt("incomingPort", incomingPort);
  oscParams.setString("remoteIP", remoteIpAddress);
  oscParams.setInt("outgoingPort", outgoingPort);
  config.setJSONObject("osc", oscParams);

  println("SAVING CONFIG FILE");
  saveJSONObject(config, "data/config.json");
}