int imageWidth;
int imageHeight;
PImage myImage;
PImage outputImage;
String toolMode = "";
boolean useFill = false;
boolean useStroke = false;
color shapeColor = color(0, 0, 0);
String shapeType = "All";
int red, green, blue;

SimpleUI myUI;
DrawingList drawingList;
ColorPicker colorpicker;

void setup() {  
  size(1000, 700);
  myUI = new SimpleUI();
  drawingList = new DrawingList();
  myImage = loadImage("");
  frameRate( 100 );    
  colorpicker = new ColorPicker( 10, 380, 230, 230, 255 );


  //String[] shapes = {"draw circle", "draw line", "draw rect", "draw tri", "draw arc", "draw poly", "Select","move"};      //Different Filters
  //myUI.addMenu("Shapes", 300, 0, shapes); 
  String[] Files = {"load file", "save file"};                                             //Different Convolution Filters
  myUI.addMenu("File", 300, 0, Files);    
  String[] filters = {"Greyscale", "Black and White", "Dilate", "Invert", "Erode", "Poster", "Brightness"};      //Different Filters
  myUI.addMenu("Filters", 400, 0, filters);  
  String[] sizes = {"Smaller", "Normalise", "Bigger"};                                                       //Modify Size of Image
  myUI.addMenu("Sizes", 500, 0, sizes);    
  String[] convol = {"Edge", "Blur", "Sharpen", "Gaussianblur"};                                             //Different Convolution Filters
  myUI.addMenu("Convolution", 600, 0, convol);  
  
  //myUI.addPlainButton("load file", 50, 0);        //Open Image
  //myUI.addPlainButton("save file", 120, 0);       //Save Image
  
  myUI.addPlainButton("Delete Sha", 80, 250);      //Delete Selected Shapes
  myUI.addPlainButton("Reset Img", 45, 340); 
  myUI.addPlainButton("Remove Img", 115, 340);  
  //myUI.addPlainButton("Clear Canvas", 150, 340);
  //myUI.addPlainButton("NoFill", 80, 560);  
  myUI.addPlainButton("Exit", 880, 630);           //Exit Application
  //myUI.addSlider("draw scale", 80, 620);
  myUI.addSlider("Image Hue", 65, 310);              //Slide bar to edit Hue of Image
  myUI.addSlider("Set Line Weight", 65, 220);        //Edit Line Weight
  

  ButtonBaseClass rectButton =
  myUI.addRadioButton("Select", 45, 160, "group1");         //Select Shape
  myUI.addRadioButton("draw line", 10, 40, "group1");      //Draw Line
  myUI.addRadioButton("draw circle", 10, 70, "group1");    //Draw Circle
  myUI.addRadioButton("draw rect", 150, 40, "group1");     //Draw Rectangle
  myUI.addRadioButton("draw tri", 80, 40, "group1");  
  myUI.addRadioButton("draw cube", 80, 100, "group1");
  myUI.addRadioButton("draw arc", 80, 70, "group1");
  myUI.addRadioButton("draw curve", 150, 70, "group1");
  //myUI.addRadioButton("draw image", 150, 70, "group1");  /Draw Image (it works if uncommented!)
  //myUI.addRadioButton("draw poly", 80, 180, "group1");  
  myUI.addRadioButton("move", 115, 160, "group1");  
  //myUI.addRadioButton("draw rotate", 80, 210, "group1");

  myUI.addPlainButton("Set Fill", 45, 190);                 //Select Shape and Fill with a certain color
  myUI.addPlainButton("Set Line", 115, 190);                //Select Shape and color the line
  //myUI.addPlainButton("Set Rotate", 150, 500);
  
  
  rectButton.selected = true;
  toolMode = rectButton.UILabel;  
  Widget rb = myUI.getWidget("square");
  rb.setSelected(true);
  myUI.addCanvas(250, 10, 700, 600);           //Size of canvas
}

void draw() {
  background(255);
  colorpicker.render();  
  if ( myImage != null ) {    
    image(myImage, 300, 40);
  } 
  if ( outputImage != null ) {    
    image(outputImage, 300, 40);
  }
  drawingList.drawMe();  
  myUI.update();
}
void handleUIEvent(UIEventData uied) {
  uied.print(2);  
  if (uied.menuItem.equals("load file")) {
    myUI.openFileLoadDialog("load an image");
  }  
  if (uied.eventIsFromWidget("fileLoadDialog")) {
    myImage = loadImage(uied.fileSelection);
    imageWidth = myImage.width;
    imageHeight = myImage.height;
  }
  if (uied.menuItem.equals("save file")) {
    myUI.openFileSaveDialog("save an image");
  }  
  if (uied.eventIsFromWidget("fileSaveDialog")) {
    outputImage.save(uied.fileSelection);
  }    
  if (uied.menuItem.equals("Greyscale")) {        
    Greyscale();
  }
  if (uied.menuItem.equals("Dilate")) {        
    Dilate();
  }
  if (uied.menuItem.equals("Invert")) {        
    Invert();
  }
  if (uied.menuItem.equals("Black and White")) {        
    BlackandWhite();
  }
  if (uied.menuItem.equals("Poster")) {        
    Posterize();
  }
  if (uied.menuItem.equals("Erode")) {        
    Erode();
  }
  if (uied.menuItem.equals("Smaller")) {    
    Smaller();
    //outputImage = myImage.copy();  
    //image(outputImage, 0, 0);
    //outputImage.resize(myImage.width/2, myImage.height/2);
  }
  if (uied.menuItem.equals("Bigger")) {     
    Bigger();
    //outputImage = myImage.copy();  
    //image(outputImage, 0, 0);
    //outputImage.resize(myImage.width*2, myImage.height*2);
  }
  if (uied.menuItem.equals("Normalise")) {  
    Normal();
    //outputImage = myImage.copy();  
    //image(outputImage, 0, 0);
    //outputImage.resize(myImage.width, myImage.height);
  }
  if (uied.eventIsFromWidget("Image Hue")) {
    Hue(myImage);
  }
  if (uied.menuItem.equals("Brightness")) {        
    Brightness();
  } 
  if (uied.eventIsFromWidget("Delete Sha")) {        
    drawingList.Delete();
  }  
  if (uied.eventIsFromWidget("Reset Img")) {        
    Reset();
  }    
  if (uied.eventIsFromWidget("Exit")) {        
    End();
  }
  if (uied.eventIsFromWidget("Remove Img")) {     
    myImage = null;
    outputImage = null;
  }
  if (uied.eventIsFromWidget("Set Fill")) {
    drawingList.cfColor(colorpicker.currentcolor());
  }
  if ( uied.eventIsFromWidget("Set Line") ) {
    drawingList.clColor(colorpicker.currentcolor());
  }
  //if (uied.eventIsFromWidget("Set Rotate")){
  //  drawingList.Rotation();
  //}
  if ( uied.eventIsFromWidget("Set Line Weight")) {
    drawingList.clWeight(colorpicker.currentWeight += 1);
    if (colorpicker.currentWeight > 15)
    {
      colorpicker.currentWeight = 1;
    }
  }
  if ( uied.menuItem.equals("Size") ) {
    drawingList.sScale(colorpicker.currentScale += 2);
  }    
  if (uied.menuItem.equals("Gaussianblur")) {        
    Gaussianblur();
  }
  if (uied.menuItem.equals("Edge")) {        
    Edge();
  }
  if (uied.menuItem.equals("Blur")) {        
    Blur();
  }
  if (uied.menuItem.equals("Sharpen")) {        
    Sharpen();
  }  
  if (uied.uiComponentType == "RadioButton") {
    toolMode = uied.uiLabel;
    return;
  }
  if (uied.uiComponentType == "ButtonBaseClass") {
  }
  if (uied.eventIsFromWidget("canvas")==false) return; 
  PVector p =  new PVector(uied.mousex, uied.mousey);    
  if ( toolMode.contains("draw")) {  
    drawingList.handleMouseDrawEvent(toolMode, uied.mouseEventType, p);
  }    
  if ( toolMode.equals("Select")) {    
    drawingList.trySelect(uied.mouseEventType, p);
  }
  if( toolMode.equals("move") ) {
    drawingList.tryMove(uied.mouseEventType, p);
  }    
}
