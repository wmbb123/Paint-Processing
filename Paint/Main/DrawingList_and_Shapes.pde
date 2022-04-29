public class ColorPicker 
{
  int x, y, w, h, c;
  PImage cpImage; 
  
  public ColorPicker ( int x, int y, int w, int h, int c )
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;    
    cpImage = new PImage( w, h );
    init();
  }
  
  private void init ()
  {
    // draw color.
    int cw = w - 60;
    for( int i=0; i<cw; i++ ) 
    {
      float nColorPercent = i / (float)cw;
      float rad = (-360 * nColorPercent) * (PI / 180);
      int nR = (int)(cos(rad) * 127 + 128) << 16;
      int nG = (int)(cos(rad + 2 * PI / 3) * 127 + 128) << 8;
      int nB = (int)(Math.cos(rad + 4 * PI / 3) * 127 + 128);
      int nColor = nR | nG | nB;
      
      setGradient( i, 0, 1, h/2, 0xFFFFFF, nColor );
      setGradient( i, (h/2), 1, h/2, nColor, 0x000000 );
    }
    
    // draw black/white.
    drawRect( cw, 0,   30, h/2, 0xFFFFFF );
    drawRect( cw, h/2, 30, h/2, 0 );
    
    // draw grey scale.
    for( int j=0; j<h; j++ )
    {
      int g = 255 - (int)(j/(float)(h-1) * 255 );
      drawRect( w-30, j, 30, 1, color( g, g, g ) );
    }
  }

  private void setGradient(int x, int y, float w, float h, int c1, int c2 )
  {
    float deltaR = red(c2) - red(c1);
    float deltaG = green(c2) - green(c1);
    float deltaB = blue(c2) - blue(c1);

    for (int j = y; j<(y+h); j++)
    {
      int c = color( red(c1)+(j-y)*(deltaR/h), green(c1)+(j-y)*(deltaG/h), blue(c1)+(j-y)*(deltaB/h) );
      cpImage.set( x, j, c );
    }
  }
   
  private void drawRect( int rx, int ry, int rw, int rh, int rc )
  {
    for(int i=rx; i<rx+rw; i++) 
    {
      for(int j=ry; j<ry+rh; j++) 
      {
        cpImage.set( i, j, rc );
      }
    }
  }
  
  public void render ()
  {
    image( cpImage, x, y );
    if( mousePressed &&
  mouseX >= x && 
  mouseX < x + w &&
  mouseY >= y &&
  mouseY < y + h )
    {
      c = get( mouseX, mouseY );
    }
    fill( c );
    rect( x, y+h+10, 20, 20 );
  }
  public color currentcolor()
  {
    return c;
  }
  //  public color currentweight()
  //{
  //  return 10;
  //}
  public int currentWeight = 1;
  public int currentScale = 1;
}

class DrawnShape { 
  boolean useFill = false;
  boolean useStroke = false;
  color shapeColor = color(0,0,0);
  String shapeType = "sqaure";
  
  public color fillColor = color(127,127,127);
  public color lineColor = color(127,127,127);
  public int lineSize;
  public int lineWeight;
  public int shapeSize;
  public int Rotation;
  PVector shapeStartPoint, shapeEndPoint;

  boolean isSelected = false;
  boolean isBeingDrawn = false;
  
  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }
  
  public void startMouseDrawing(PVector startPoint) {
    this.isBeingDrawn = true;
    this.shapeStartPoint = startPoint;
    this.shapeEndPoint = startPoint;
  }

  public void duringMouseDrawing(PVector dragPoint) {
    if (this.isBeingDrawn) this.shapeEndPoint = dragPoint;
  }

  public void endMouseDrawing(PVector endPoint) {
    this.shapeEndPoint = endPoint;
    
    this.isBeingDrawn = false;
  }

  public boolean tryToggleSelect(PVector p) {
    
    UIRect boundingBox = new UIRect(shapeStartPoint, shapeEndPoint);
   
    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
  }
  
  public void changeFillColor(color newColor){
    fillColor = newColor;
  }
  public void changeLineColor(color Colour){
    lineColor = Colour;
  }
  public void changeLineWeight(int Size){
    lineSize = Size;
  }
  public void scaleSize(int Scale){
    shapeSize = Scale;
  }
  //public void Rotate(){
  //  rotate(PI/3.0);
  //}
  
  public void translate(float newx, float newy){
 
    shapeStartPoint.x += newx;
    shapeStartPoint.y += newy;

    shapeEndPoint.x += newx;
    shapeEndPoint.y += newy;
    
  }

  public void rotate(float newx, float newy){
 
    shapeStartPoint.x += newx;
    shapeStartPoint.y += newy;

    shapeEndPoint.x += newx;
    shapeEndPoint.y += newy;
    
  }
  
  public void drawMe() {

    if (this.isSelected) {
        setSelectedDrawingStyle();
      }else{
        setDefaultDrawingStyle();       
      }
    
    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    float w = x2-x1;
    float h = y2-y1;
    
    //float Y = HALF_PI; 
    //float Y2 = PI;
    //float Y3 = TWO_PI;
    
    if ( shapeType.equals("draw rect")) rect(x1, y1, w, h);
    if ( shapeType.equals("draw circle")) ellipse(x1+ w/2, y1 + h/2, w, h);
    if ( shapeType.equals("draw line")) line(x1, y1, x2, y2);
    if ( shapeType.equals("draw tri"))triangle(x1, y1, x2, y2, x1, y2);    
    if ( shapeType.equals("draw arc"))arc(x1, y1, x2, y2, PI, TWO_PI);    
    //if ( shapeType.equals("draw scale"))
    //{
    //    pushMatrix();
    //    scale(2.0);
    //    popMatrix();
    //};
    //if( shapeType.equals("draw rotate"))rotate(PI/3.0); 
    if ( shapeType.equals("draw poly"))
    {       
        ArrayList<PVector> points = new ArrayList<PVector>();
        points.add( new PVector(x1,y1));
        points.add( new PVector(mouseX,mouseY));        
        polygon(points);  
    };    
    if ( shapeType.equals("draw curve"))
    {  
        PVector p1 = new PVector(x1,y1);
        PVector controlPoint1 = new PVector(150,75);
        PVector p2 = new PVector(x2,y2);
        PVector controlPVector = new PVector(450,20);
        bezierWithControlPoints(p1,controlPoint1, p2, controlPVector);
    };
    if ( shapeType.equals("draw cube")) 
    {
       beginShape();
       noFill();
       vertex(x1,y1);
       vertex(x2, y1);
       vertex((4*x2)/3,(4*y1)/3);
       vertex(x2, y1);
       vertex(x2, y2);
       vertex(x2, y1);
       vertex(x1,y1);
       vertex((4*x1)/3,(4*y1)/3);
       vertex((4*x2)/3,(4*y1)/3);
       vertex((4*x2)/3,(4*y2)/3);
       vertex(x2,y2);
       vertex(x1,y2);
       vertex(x1,y1);
       vertex((4*x1)/3,(4*y1)/3);
       vertex((4*x1)/3,(4*y2)/3);
       vertex(x1,y2);
       vertex((4*x1)/3,(4*y2)/3);
       vertex((4*x2)/3,(4*y2)/3);
       endShape();
    };
}

  void setSelectedDrawingStyle() {
    strokeWeight(2);
    stroke(0, 0, 0);
    fill(255, 100, 100);
  }
 
  void setDefaultDrawingStyle() {  
    strokeWeight(lineSize);
    stroke(lineColor);
    fill(fillColor);
    //scale(shapeSize);
    //rotate(PI/3.0);
  }
}
void polygon(ArrayList<PVector> points) {
  
  beginShape();
  for (PVector p: points) {
    float sx = p.x;
    float sy = p.y;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();

  public DrawnShape currentlyDrawnShape = null;

  public DrawingList() {
  }
  
  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }
  
  public void Delete() {
    for (DrawnShape s : shapeList) {
      if(s.isSelected) {
        shapeList.remove(s);
        break;
      }
    }
  }
  
  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc) {

    
    
    if ( mouseEventType.equals("mousePressed")) {
      DrawnShape newShape;
      if( shapeType.equals("draw image") ) {
        newShape = new ImageShape();
        ((ImageShape)newShape).setSourceImage(myImage);
      } else {
        newShape = new DrawnShape( shapeType );
      }
      
      newShape.startMouseDrawing(mouseLoc);
      shapeList.add(newShape);
      currentlyDrawnShape = newShape;
    }
    if ( mouseEventType.equals("mouseDragged")) {
      currentlyDrawnShape.duringMouseDrawing(mouseLoc);
    }
    if ( mouseEventType.equals("mouseReleased")) {
      currentlyDrawnShape.endMouseDrawing(mouseLoc);
    }
  }

  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed")){
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound) break;
      }
    }    
  }
  
  public void cfColor(color newColor){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeFillColor(newColor);
      }
    }
  }  
  public void clColor(color Colour){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeLineColor(Colour);
      }
    }
  }
  public void clWeight(int Size){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeLineWeight(Size);
      }
    }
  }
    public void sScale(int Scale){
      for (DrawnShape s: shapeList){
        if (s.isSelected == true){
          s.scaleSize(Scale);
        }
      }
    }  
    //public void Rotation(){
    //  for (DrawnShape s: shapeList){
    //    if (s.isSelected == true){
    //       s.Rotate();
    //    }
    //  }
    //}  
    
    public void tryMove(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed") || mouseEventType.equals("mouseDragged")){
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound)
        //s.translate(mouseX -s.shapeStartPoint.x, mouseY -s.shapeStartPoint.y);
        s.translate(10, 10);
        //s.translate(10, -10);
        //s.translate(-10, -10);
        //s.translate(-10, 10); 
        s.drawMe();
      }
    }
  }
}

void bezierWithControlPoints(PVector p1, PVector cp1, PVector p2,PVector cp2 ){ 
  fill(255, 0, 0);
  ellipse(p1.x, p1.y, 5, 5); // start of curve
  ellipse(p2.x, p2.y, 5, 5); // end of curve  
  ellipse(cp1.x, cp1.y, 5, 5);  // control point 1
  ellipse(cp2.x, cp2.y, 5, 5);  // control point 2 
  noFill();
  stroke(0);
  bezier(p1.x, p1.y,cp1.x, cp1.y, cp2.x, cp2.y, p2.x, p2.y);
}
  
//void romcatmullCurve(ArrayList<PVector> points){
//  // draws a rom-catmull curve using the list of points.
//  // Note that it draws the first and last point twice, as each point needs a 
//  // preceeding control point of the previous point
//   noFill();
//   stroke(0);
//   beginShape();
//   PVector startPoint = points.get(0);
//   curveVertex(startPoint.x, startPoint.y);  
//   for (PVector p: points) {      
//      curveVertex(p.x, p.y);
//    }    
//   PVector endPoint = points.get(points.size()-1);
//   curveVertex(endPoint.x, endPoint.y);     
//   endShape();  
//}
