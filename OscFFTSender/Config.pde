public static final String CONFIG_FILE = "data/config.json";

public void loadConfigFile() {
  JSONObject config;
  try {
    config = loadJSONObject(CONFIG_FILE);
  } catch(NullPointerException e) {
    println("Couldn't find config file " + CONFIG_FILE);
    return;
  }

  JSONObject soundParams = config.getJSONObject("sound");
  soundFocusGUI.width = soundParams.getInt("soundFocusSize");
  soundFocusGUI.x = soundParams.getInt("soundFocusOffset");

  JSONObject oscParams = config.getJSONObject("osc");
  incomingPort = oscParams.getInt("incomingPort");
  outgoingPort = oscParams.getInt("outgoingPort");
  remoteIpAddress = oscParams.getString("remoteIP");
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

  println("SAVING CONFIG FILE " + CONFIG_FILE);
  saveJSONObject(config, CONFIG_FILE);
}