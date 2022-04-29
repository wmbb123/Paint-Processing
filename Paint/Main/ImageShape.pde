////////////////////////////////////////////////////////////////////
// ImageShape Class
// this is a sub class of DrawnShape, but draws an image instead
// Each instance has its own copy of the image
// 

class ImageShape extends DrawnShape{
  
  PImage sourceImageReference;
  PImage myImage;
  
  public ImageShape(){
    // we tell the base class DrawnShape the type of shape
    super("ImageShape");
  }
  
  void setSourceImage(PImage srcImg){
    sourceImageReference = srcImg;
    myImage = sourceImageReference.copy();
  }
  
  public void drawMe() {

    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    float w = x2-x1;
    float h = y2-y1;
    
    
    
    image(myImage, x1, y1, w, h);
    
    if (this.isSelected) {
        noFill();
        stroke(255,0,0);
        strokeWeight(2);
        rect( x1, y1, w, h);
      }else{
        // don't draw anything
        
      }

  }
  
  PImage getMyImage(){
    return myImage;
  }
  
}
