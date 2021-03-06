/* Stephen Kaplan - September 25th, 2018 - NMD 160 Frogger Project
 This program is a recreation of Konami's classic "Frogger" game using a modular approach.
 Use the arrow keys to move frogger one "hop" at a time. Avoid colliding with vehicles.
 Contact with river water results in immediate loss of one life.
 After 5 lives, the game is over.
 
 Press D to enter debug mode. Once there, press Shift+. to switch to the next scene, or Shift+, to go back to the previous scene.
 In debug mode, press the down arrow to move frogger backward.
 
 Version 0.0.1
*/


// State Management Variables
ArrayList<Scene> scenes = new ArrayList<Scene>();

int currentScene = 0;
int sceneAmount;            // Set by getFolders()
boolean debug = false;      // Press d to toggle

// Utility Variables
String version = "0.0.1";
String divider = new String(new char[5]).replace("", "-");


// Runs once - Add start menu later, current initializes into first scene
void setup() {
  size(800, 500); // Add way to change size later
  
  // Logging for debugging purposes, see the logs subfolder to see all info
  log("\n"+divider+getExactTime()+divider+"\n");
  log("Initializing Frogger (Version "+version+")");

  // Find scenes & add to array
  log("Loading scenes.");
  sceneAmount = getFolders();
  log("Number of scenes found: "+sceneAmount+".");

  for (int i=0; i<sceneAmount; i++) {
    scenes.add(new Scene(scenes.size()));
  }

  // Load initial scene (To be changed to start menu later)
  log("Loading Data For Scene 0");
  scenes.get(0).loadData();

  log("Loading Assets For Scene 0 - "+scenes.get(0).getName());
  scenes.get(0).loadAssets();
}


// Runs ~60 times per second, add FPS monitor to debug mode later
void draw() {
  // All objects in scene are managed within scene class
  scenes.get(currentScene).update();
  scenes.get(currentScene).display();
}

void keyPressed() {
  // Toggle debug mode
  if (key == 'd') {
    if (debug) {
      log("Debug mode exited.");
    } else {
      log("Debug mode entered.");
    }

    debug = !debug;
  } else if (debug) {
    // If debug mode is on, use separate debug listener
    debugKeyPressed();
  }

  // If frog object is active, use arrow key listener
  if (scenes.get(currentScene).frogger != null) {
    Frog frog = scenes.get(currentScene).frogger;
    if (frog.alive() && frog.isNotDying()) {
      if (keyCode == UP) {
        frog.moveUp();
      } else if (keyCode == DOWN && debug) {
        // Disabe downward movement unless debug mode is on
        frog.moveDown();
      } else if (keyCode == LEFT) {
        frog.moveLeft();
      } else if (keyCode == RIGHT) {
        frog.moveRight();
      }
    }
  }
}


// Debug mode key listener
void debugKeyPressed() {
  if (debug) {
    // Move to next scene
    if (key == '>' && currentScene < sceneAmount-1) {
      // Unload unnecessary objects and images
      scenes.get(currentScene).unloadAssets();

      currentScene += 1;

      // Load next scene
      log("Loading Data For Scene "+currentScene);
      scenes.get(currentScene).loadData();

      log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
      scenes.get(currentScene).loadAssets();
    }
    
    // Move to previous scene
    else if (key == '<' && currentScene > 0) {
      // Unload unnecessary objects and images
      scenes.get(currentScene).unloadAssets();

      currentScene -= 1;

      // Load previous scene
      log("Loading Data For Scene "+currentScene);
      scenes.get(currentScene).loadData();

      log("Loading Assets For Scene "+currentScene + " - "+scenes.get(currentScene).getName());
      scenes.get(currentScene).loadAssets();
    }
  }
}


// Count folders within Scenes directory
// Technically counts all files. This method should only work on UNIX systems (including MacOS).
// Change to better method eventually, but this works for now.
int getFolders() {
  int folders = 0;

  java.io.File folder = new java.io.File(sketchPath("Scenes"));
  String[] list = folder.list();
  for (int i=0; i<list.length; i++) {
    if (!list[i].equals(".DS_Store")) {
      folders++;
      log("Found scene " + list[i] + ".");
    }
  }
  return folders;
}


// Append log messages to log file
void log(String message) {
  // Location
  String logPath = "logs/"+year()+"/"+month()+"/"+day()+".txt";
  
  // Appending data
  String[] newMessage = {message};
  String[] pastMessages = loadStrings(logPath);
  String[] logMessage;

  if (pastMessages == null) {
    logMessage = newMessage;
  } else {
    logMessage = concat(pastMessages, newMessage);
  }

  // Saving data, reporting to console
  saveStrings(logPath, logMessage);
  println(message);
}


String getExactTime(){
  return year()+"/"+month()+"/"+day()+" @ "+hour()+":"+minute()+":"+second();
}