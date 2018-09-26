// A class that manages and displays a safezone row in the game Frogger.
class Safezone{
  // Position Attributes
  int ypos;
  
  // Images
  PImage grassImage;
  
  
  // Constructor
  Safezone(int ypos_){
    ypos = ypos_;
  }
  
  
  // Currently unused, but kept for easy access later
  void update(){
  }
  
  
  // Displays this row
  void display(){
    noStroke();
    
    if (grassImage == null) {
      // If no grass image is provided, resort to green rectangles
      fill(100,200,0);
      rect(0, ypos, width, height/10);
    } else {
      // Otherwise, use math to provide optimal tiling of image along the row
      float ratio = grassImage.height/(height/10);
      for (int x=0; x<width; x += grassImage.width/ratio) {
        image(grassImage, x, ypos, grassImage.width/ratio, height/10);
      }
    }
  }
  
  
  // Add background image to row (Can be used to have different design for each level)
  void setImage(PImage grassImage_) {
    grassImage = grassImage_;
  }
}