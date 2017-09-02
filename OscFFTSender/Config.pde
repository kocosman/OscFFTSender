public void loadConfigFile() {
  try {
    JSONArray config = loadJSONArray("data/config.json");

    JSONObject soundParams = config.getJSONObject(0);
    soundFocusGUI.width = soundParams.getInt("soundFocusSize");
    soundFocusGUI.x = soundParams.getInt("soundFocusOffset");

    JSONObject oscParams = config.getJSONObject(1);
    incomingPort = oscParams.getInt("incomingPort");
    outgoingPort = oscParams.getInt("outgoingPort");
    remoteIpAddress = oscParams.getString("remoteIP");
  } 
  catch(Exception e) {
    println("Couldn't find Config file");
  }
}

public void saveConfigFile() {
  JSONArray config = new JSONArray();

  JSONObject soundParams = new JSONObject();
  soundParams.setInt("soundFocusSize", soundFocusGUI.width);
  soundParams.setInt("soundFocusOffset", soundFocusGUI.x);
  config.setJSONObject(0, soundParams);

  JSONObject oscParams = new JSONObject();
  oscParams.setInt("incomingPort", incomingPort);
  oscParams.setString("remoteIP", remoteIpAddress);
  oscParams.setInt("outgoingPort", outgoingPort);
  config.setJSONObject(1, oscParams);

  println("SAVING CONFIG FILE");
  saveJSONArray(config, "data/config.json");
}