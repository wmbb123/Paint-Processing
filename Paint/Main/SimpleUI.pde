public class SimpleUI{
  
    UIRect canvasRect;
    
    ArrayList<Widget> widgetList = new ArrayList<Widget>();
    
    String UIManagerName;
    
    UIRect backgroundRect = null;
    color backgroundRectColor; 

    // these are for capturing user events
    boolean pmousePressed = false;
    boolean pkeyPressed = false;
    String fileDialogPrompt = "";

    public SimpleUI(){
          UIManagerName = "";
          
      }
      
    public SimpleUI(String uiname){
          UIManagerName = uiname;
          
      }
      
   
   ////////////////////////////////////////////////////////////////////////////
   // file dialogue
   //
   
    public void openFileLoadDialog(String prompt) {
      fileDialogPrompt = prompt;
      selectInput(prompt, "fileLoadCallback", null, this);
    }
     
    void fileLoadCallback(File selection) {
      
      // cancelled
      if(selection == null){
      return;
      }
      
     
      // is directory not file
      if (selection.isDirectory()){
      return;
      }

      UIEventData uied = new UIEventData(UIManagerName, "fileLoadDialog" , "fileLoadDialog", "mouseReleased", mouseX, mouseY);
      uied.fileSelection = selection.getPath();
      uied.fileDialogPrompt = this.fileDialogPrompt;
      handleUIEvent( uied);
    }
    
    
    public void openFileSaveDialog(String prompt) {
      fileDialogPrompt = prompt;
      selectOutput(prompt, "fileSaveCallback", null, this);
    }
     
    void fileSaveCallback(File selection) {
      
      // cancelled
      if(selection == null){
      return;
      }
      
      String path = selection.getPath();
      println(path);

      UIEventData uied = new UIEventData(UIManagerName, "fileSaveDialog" , "fileSaveDialog", "mouseReleased", mouseX, mouseY);
      uied.fileSelection = selection.getPath();
      uied.fileDialogPrompt = this.fileDialogPrompt;
      handleUIEvent(uied);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // canvas creation
    //
    public void addCanvas(int x, int y, int w, int h){
      
      canvasRect = new UIRect(x,y,x+w,y+h);
    }
    
    public void checkForCanvasEvent(String mouseEventType, int x, int y){
       if(canvasRect==null) return;
       if(   canvasRect.isPointInside(x,y)) {
         UIEventData uied = new UIEventData(UIManagerName, "canvas" , "canvas", mouseEventType,x,y);
         handleUIEvent(uied);
       }

    }
    
    public void drawCanvas(){
      if(canvasRect==null) return;
      pushStyle();
      noFill();
      stroke(0,0,0);
      strokeWeight(1);
      rect(canvasRect.left, canvasRect.top, canvasRect.getWidth(), canvasRect.getHeight());
      popStyle();
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // widget creation
    //
    
    // button creation
    public ButtonBaseClass addPlainButton(String label, int x, int y){
      ButtonBaseClass b = new ButtonBaseClass(UIManagerName,x,y,label);
      widgetList.add(b);
      return b;
    }
    
    public ButtonBaseClass addToggleButton(String label, int x, int y){
      ButtonBaseClass b = new ToggleButton(UIManagerName,x,y,label);
      widgetList.add(b);
      return b;
    }
    
    public ButtonBaseClass addToggleButton(String label, int x, int y, boolean initialState){
      ButtonBaseClass b = new ToggleButton(UIManagerName,x,y,label);
      b.selected = initialState;
      widgetList.add(b);
      return b;
    }
    
    public ButtonBaseClass addRadioButton(String label, int x, int y, String groupID){
      ButtonBaseClass b = new RadioButton(UIManagerName,x,y,label,groupID, this);
      widgetList.add(b);
      return b;
    }
    
    // label creation
    public SimpleLabel addLabel(String label, int x, int y,String txt){
      SimpleLabel sl = new SimpleLabel(UIManagerName,label,x,y,txt);
      widgetList.add(sl);
      return sl;
    }
  
    // menu creation
    public Menu addMenu(String label, int x, int y, String[] menuItems){
      Menu m = new Menu(UIManagerName,label,x,y,menuItems, this);
      widgetList.add(m);
      return m;
      }
    
    // slider creation
    public Slider addSlider(String label, int x, int y){
      Slider s = new Slider(UIManagerName,label,x,y);
      widgetList.add(s);
      return s;
    }
    

    // text input box creation
    public TextInputBox addTextInputBox(String label, int x, int y){
      int maxNumChars = 14;
      TextInputBox tib = new TextInputBox(UIManagerName,label,x,y,maxNumChars);
      widgetList.add(tib);
      return tib;
    }
    
    public TextInputBox addTextInputBox(String label, int x, int y, String content){
      TextInputBox tib = addTextInputBox( label,  x,  y);
      tib.setText(content);
      return tib;
    }
    


    void removeWidget(String uilabel){
      Widget w = getWidget(uilabel);
      widgetList.remove(w);
    }
    


    // getting widget data by lable
    //
    Widget getWidget(String uilabel){
      for(Widget w: widgetList){
       if(w.UILabel.equals(uilabel)) return w;
      }
      println(" getWidgetByLabel: cannot find widget with label ",uilabel);
      return new Widget(UIManagerName);
    }
    
    
    // get toggle state
    public boolean getToggleButtonState(String uilabel){
      Widget w = getWidget(uilabel);
      if( w.UIComponentType.equals("ToggleButton") ) return w.selected;
      println(" getToggleButtonState: cannot find widget with label ",uilabel);
      return false;
    }
   
    // get selected radio button in a group - returns the label name
    public String getRadioGroupSelected(String groupName){
       for(Widget w: widgetList){
        if( w.UIComponentType.equals("RadioButton")){
          if( ((RadioButton)w).radioGroupName.equals(groupName) && w.selected) return w.UILabel;
        }
    }
    return "";
    }
    
    
    
    public float getSliderValue(String uilabel){
      Widget w = getWidget(uilabel);
      if( w.UIComponentType.equals("Slider") ) return ((Slider)w).getSliderValue();
      return 0;
    }
    
    public void setSliderValue(String uilabel, float v){
      Widget w = getWidget(uilabel);
      if( w.UIComponentType.equals("Slider") )  ((Slider)w).setSliderValue(v);
      
    }
    
    
    
    
    
    
    public String getText(String uilabel){
      Widget w = getWidget(uilabel);
     
      if(w.UIComponentType.equals("TextInputBox")){
         return ((TextInputBox)w).getText();
      }
      
      if(w.UIComponentType.equals("SimpleLabel")){
         return ((SimpleLabel)w).getText();
      }
      return "";
    }
  
    public void setText(String uilabel, String content){
      Widget w = getWidget(uilabel);
      if(w.UIComponentType.equals("TextInputBox")){
            ((TextInputBox)w).setText(content); }
      if(w.UIComponentType.equals("SimpleLabel")){
            ((SimpleLabel)w).setText(content); }
      
    }
    
    
    
    // setting a background Color region for the UI. This is drawn first.
    // to do: this should also set an offset for subsequent placement of the buttons
    
    void setBackgroundRect(int left, int top, int right, int bottom, int r, int g, int b){
      backgroundRect = new UIRect(left,top,right,bottom);
      backgroundRectColor = color(r,g,b);
    }
    
    void setRadioButtonOff(String groupName){
      for(Widget w: widgetList){
        if( w.UIComponentType.equals("RadioButton")){
           if( ((RadioButton)w).radioGroupName.equals(groupName))  w.selected = false;
        }
      }
    }
    
    void setMenusOff(){
      for(Widget w: widgetList){
        if( w.UIComponentType.equals("Menu")){
          ((Menu)w).visible = false;
        }
      }
      
    }
    
    
    // this is an alternative to using the seperate event handlers provided by Processing
    // It therefor easier to use, but more sluggish in response
    void checkForUserInputEvents(){
      // this gets called in the drawMe() method, instead of having to link up
      // to the native mousePressed() etc. methods
      
       if( pmousePressed == false  && mousePressed){
          handleMouseEvent("mousePressed", mouseX, mouseY);
        }
 
      if( pmousePressed == true  && mousePressed == false){
         handleMouseEvent("mouseReleased", mouseX, mouseY);
        }
 
       if( (pmouseX != mouseX || pmouseY != mouseY) && mousePressed ==false){
         handleMouseEvent("mouseMoved", mouseX, mouseY);
       }
       if( (pmouseX != mouseX || pmouseY != mouseY) && mousePressed){
         handleMouseEvent("mouseDragged", mouseX, mouseY);
       }
       
       
       if( pkeyPressed == false && keyPressed == true){
         handleKeyEvent(key, keyCode, "pressed");
       }
       
       if( pkeyPressed == true && keyPressed == false){
        handleKeyEvent(key, keyCode, "released");
       }
       
      pmousePressed = mousePressed;
      pkeyPressed = keyPressed;
    }
      
      

    
    
    void handleMouseEvent(String mouseEventType, int x, int y){
      checkForCanvasEvent(mouseEventType,x,y);
      for(Widget w: widgetList){
        w.handleMouseEvent(mouseEventType,x,y);
      }
      
    }
    
    void handleKeyEvent(char k, int kcode, String keyEventType){
      for(Widget w: widgetList){
         w.handleKeyEvent( k,  kcode,  keyEventType);
      }
    }
    
    
    void update(){
      checkForUserInputEvents();
      
      if( backgroundRect != null ){
        pushStyle();
        fill(backgroundRectColor);
        rect(backgroundRect.left,backgroundRect.top,backgroundRect.getWidth(), backgroundRect.getHeight());
        popStyle();
      }
      
      drawCanvas();
      for(Widget w: widgetList){
         w.drawMe();
      }
      
    }
    
    void clearAll(){
      widgetList = new ArrayList<Widget>();
    }
    
   

  }// end of SimpleUIManager
  
  
  
//////////////////////////////////////////////////////////////////
// UIEventData
// when a UI component calls the simpleUICallback() function, it passes this object back
// which contains EVERY CONCEIVABLE bit of extra information about the event that you could imagine
//
public class UIEventData{
  // set by the constructor
  public String callingUIManager; // this is the name of the UIManager, because you might have more than one
  public String uiComponentType; // this is the type of widet e.g. ButtonBaseClass, ToggleButton, Slider - it is identical to the class name
  public String uiLabel; // this is the unique shown label for each widget, and is used to idetify the calling widget
  public String mouseEventType;
  public int mousex; // this is the x location of the recieved mouse event, in window space
  public int mousey;
  
  // extra stuff, which is specific to particular widgets
  public boolean toggleSelectState = false;
  public String radioGroupName = "";
  public String menuItem = "";
  public float sliderValue = 0.0;
  public String fileDialogPrompt = "";
  public String fileSelection = "";
  
  // key press and text content information for text widgets
  public char keyPress;
  public String textContent;
  
   public UIEventData(){
   }
   
   
   
   public UIEventData(String uiname, String thingType, String label, String mouseEvent, int x, int y){
     initialise(uiname, thingType, label, mouseEvent, x,y);
     
   }
   
   void initialise(String uiname, String thingType, String label, String mouseEvent, int x, int y){
     
     callingUIManager = uiname;
     uiComponentType = thingType;
     uiLabel = label;
     mouseEventType = mouseEvent;
     mousex = x;
     mousey = y;
     
   }
   
   boolean eventIsFromWidget(String lab){
     if( uiLabel.equals( lab )) return true;
     return false;
     
   }
   
   void print(int verbosity){
     if(verbosity != 3 && this.mouseEventType.equals("mouseMoved")) return;
     
     
     if(verbosity == 0) return;
     
     if(verbosity >= 1){
       println("UIEventData:" + this.uiComponentType + " " + this.uiLabel);
       
       if( this.uiComponentType.equals("canvas")){
         println("mouse event:" + this.mouseEventType + " at (" + this.mousex +"," + this.mousey + ")");
       }
       
     }
     
     if(verbosity >= 2){
         println("toggleSelectState " + this.toggleSelectState);
         println("radioGroupName " + this.radioGroupName);
         println("sliderValue " + this.sliderValue);
         println("menuItem " + this.menuItem);
         println("keyPress " + keyPress);
         println("textContent " + textContent);
         println("fileDialogPrompt " + this.fileDialogPrompt);
         println("fileSelection " + this.fileSelection);
     }
     
     if(verbosity == 3 ){
         if(this.mouseEventType.equals("mouseMoved")) {
         println("mouseMove at (" + this.mousex +"," + this.mousey + ")");
         }
     }
     
     println(" ");
   }
  
}





//////////////////////////////////////////////////////////////////
// Everything below here is stuff wrapped up by the UImanager class
// so you don't need to to look at it, or use it directly. But you can if you
// want to!
// 





//////////////////////////////////////////////////////////////////
// Base class to all components
class Widget{
  
  // Color for overall application
  color SimpleUIAppBackgroundColor = color(240,240,240);// the light neutralgrey of the overall application surrounds
  
  // Color for UI components
  color SimpleUIBackgroundRectColor = color(230,230,240); // slightly purpley background rect Color for alternative UI's
  color SimpleUIWidgetFillColor = color(200,200,200);// darker grey for butttons
  color SimpleUIWidgetRolloverColor = color(215,215,215);// slightly lighter rollover Color
  color SimpleUITextColor = color(0,0,0);


  // should any widgets need to "talk" to other widgets (RadioButtons, Menus)
  SimpleUI parentManager = null; 
  
  // Because you can have more than one UIManager in a system, 
  // e.g. a seperate one for popups, or tool modes
  String UIManagerName;
  
  // this should be the best way to identify a widget, so make sure
  // that all UILabels are unique
  String UILabel;
  
  // type of component e.g. "UIButton", should be absolutely same as class name
  public String UIComponentType = "WidgetBaseClass";
  
  // location and size of widget
  int widgetWidth, widgetHeight;
  int locX, locY;
  public UIRect bounds;
  
  // needed by most, but not all widgets
  boolean rollover = false;
  
  // needed by some widgets but not all
  boolean selected = false;
  
  public Widget(String uiname){
    
    UIManagerName = uiname;
  }
  
  public Widget(String uiname, String uilabel, int x, int y, int w, int h){
    
    UIManagerName = uiname;
    UILabel = uilabel;
    setBounds(x, y, w, h);
  }
  
  // virtual functions
  // 
  public void setBounds(int x, int y, int w, int h){
    locX = x;
    locY = y;
    widgetWidth = w;
    widgetHeight = h;
    bounds = new UIRect(x,y,x+w,y+h);
  }
  
  public boolean isInMe(int x, int y){
    if(   bounds.isPointInside(x,y)) return true;
   return false;
  }
  
  public void setParentManager(SimpleUI manager){
    parentManager = manager;
  }
  
  public void setWidgetDims(int w, int h){
    setBounds(locX,locY,w, h);
  }
  
  // "virtual" functions here
  //
  public void drawMe(){}
  
  public void handleMouseEvent(String mouseEventType, int x, int y){}
  
  void handleKeyEvent(char k, int kcode, String keyEventType){}
  
  void setSelected(boolean s){
    selected = s;
  }

}


//////////////////////////////////////////////////////////////////
// Simple Label widget - uneditable text
// It displays label:text, where text is changeable in the widget's lifetime, but label is not

class SimpleLabel extends Widget{
  
  int textPad = 5;
  String text;
  int textSize = 12;
  boolean displayLabel  = true;
  
  public SimpleLabel(String uiname, String uilable, int x, int y,  String txt){
    super(uiname, uilable,x,y,100,30);
    UIComponentType = "SimpleLabel";
    this.text = txt;
    
  }
  
  public void drawMe(){
    pushStyle();
    stroke(100,100,100);
    strokeWeight(1);
    fill(SimpleUIBackgroundRectColor);
    rect(locX, locY, widgetWidth, widgetHeight);
   
    String seperator = ":";
    if(this.text.equals("")) seperator = " ";
    String displayString;
    
    if(displayLabel) { 
      
      displayString = this.UILabel + seperator + this.text;
    
    } else {
      
      displayString = this.text;
    }
    
    
        
    if( displayString.length() < 20) {
      textSize = 12;} 
      else { textSize = 9; }
    fill(SimpleUITextColor);  
    textSize(textSize);
    text(displayString, locX+textPad, locY+textPad, widgetWidth, widgetHeight);
    popStyle();
  }
  
  void setText(String txt){
    this.text = txt;
  }
  
  String getText(){
    return this.text;
  }
  
  
}


//////////////////////////////////////////////////////////////////
// Base button class, functions as a simple button, and is the base class for
// toggle and radio buttons
class ButtonBaseClass extends Widget{

  int textPad = 12;
  int textSize = 10;

  

  public ButtonBaseClass(String uiname, int x, int y, String uilable){
    super(uiname, uilable,x,y,70,30);

    UIComponentType = "ButtonBaseClass";
  }
  
  
  public void setButtonDims(int w, int h){
    setBounds(locX,locY,w, h);
  }
  
  public void handleMouseEvent(String mouseEventType, int x, int y){
    if( isInMe(x,y) && (mouseEventType.equals("mouseMoved") || mouseEventType.equals("mousePressed"))){
      rollover = true;
    } else { rollover = false; }
    
    if( isInMe(x,y) && mouseEventType.equals("mouseReleased")){
      UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, mouseEventType, x,y);
      handleUIEvent(uied);
    }
    
  }
  
  public void drawMe(){
    pushStyle();
    stroke(0,0,0);
    strokeWeight(1);
    if(rollover){
      fill(SimpleUIWidgetRolloverColor);}
    else{
      fill(SimpleUIWidgetFillColor);
    }
    
    rect(locX, locY, widgetWidth, widgetHeight);
    fill(SimpleUITextColor);
    if( this.UILabel.length() < 10) {
      textSize = 10;} 
      else { textSize = 10; }
      
    textSize(textSize);
    text(this.UILabel, locX+textPad, locY+textPad, widgetWidth, widgetHeight);
    popStyle();
  }
  
  

}

//////////////////////////////////////////////////////////////////
// ToggleButton

class ToggleButton extends ButtonBaseClass{
  
  
  
  public ToggleButton(String uiname, int x, int y, String labelString){
    super(uiname,x,y,labelString);
    
    UIComponentType = "ToggleButton";
  }
  
  public void handleMouseEvent(String mouseEventType, int x, int y){
    if( isInMe(x,y) && (mouseEventType.equals("mouseMoved") || mouseEventType.equals("mousePressed"))){
      rollover = true;
    } else { rollover = false; }
    
    if( isInMe(x,y) && mouseEventType.equals("mouseReleased")){
      swapSelectedState();
      UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, mouseEventType, x,y);
      uied.toggleSelectState = selected;
      handleUIEvent(uied);
    }
    
  }
  
  public void swapSelectedState(){
    selected = !selected;
  }
  
  public void drawMe(){
    pushStyle();
    stroke(0,0,0);
    if(rollover){
      fill(SimpleUIWidgetRolloverColor);}
    else{
      fill(SimpleUIWidgetFillColor);   
    }
    
    if(selected){
     strokeWeight(2);
     rect(locX+1, locY+1, widgetWidth-2, widgetHeight-2);
     } else {
     strokeWeight(1);
     rect(locX, locY, widgetWidth, widgetHeight);  
     }
   
      
      
    
    
    stroke(0,0,0);
    strokeWeight(1);
    fill(SimpleUITextColor);
    textSize(textSize);
    text(this.UILabel, locX+textPad, locY+textPad, widgetWidth, widgetHeight);
    popStyle();
  }
  
  
  
}

//////////////////////////////////////////////////////////////////
// RadioButton

class RadioButton extends ToggleButton{
  
  
  // these have to be part of the base class as is accessed by manager
  public String radioGroupName = "";
  
  public RadioButton(String uiname,int x, int y, String labelString, String groupName,SimpleUI manager){
    super(uiname,x,y,labelString);
    radioGroupName = groupName;
    UIComponentType = "RadioButton";
    parentManager = manager;
  }
  
  
  public void handleMouseEvent(String mouseEventType, int x, int y){
    if( isInMe(x,y) && (mouseEventType.equals("mouseMoved") || mouseEventType.equals("mousePressed"))){
      rollover = true;
    } else { rollover = false; }
    
    if( isInMe(x,y) && mouseEventType.equals("mouseReleased")){
      
      
      parentManager.setRadioButtonOff(this.radioGroupName);
      selected = true;
      UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, mouseEventType, x,y);
      uied.toggleSelectState = selected;
      uied.radioGroupName  = this.radioGroupName;
      handleUIEvent(uied);
    }
    
  }
  
  
  
  
  public void turnOff(String groupName){
    if(groupName.equals(radioGroupName)){
      selected = false;
    }
    
  }
  
}



/////////////////////////////////////////////////////////////////////////////
// menu stuff
//
//

/////////////////////////////////////////////////////////////////////////////
// the menu class
//
class Menu extends Widget{
  
  
  int textPad = 12;
  int textSize = 10;

  int numItems = 0;
  SimpleUI parentManager;
  public boolean visible = false;
  
  
  ArrayList<String> itemList = new ArrayList<String>();
  
  
  
  public Menu(String uiname, String uilabel, int x, int y, String[] menuItems, SimpleUI manager)
    {
    super(uiname,uilabel,x,y,100,20);
    parentManager = manager;
    UIComponentType = "Menu";
    
    for(String s: menuItems){
      itemList.add(s);
      numItems++;
    }
    }
    
  

  public void drawMe(){
    //println("drawing menu " + title);
    drawTitle();
    if( visible ){
     drawItems();
    } 
    
  }
  
  void drawTitle(){
    pushStyle();
    stroke(0,0,0);
    if(rollover){
      fill(SimpleUIWidgetRolloverColor);}
    else{
      fill(SimpleUIWidgetFillColor);
    }
     
    rect(locX, locY, widgetWidth,widgetHeight);
    fill(SimpleUITextColor);
    textSize(textSize);
    text(this.UILabel, locX+textPad, locY+3, widgetWidth,widgetHeight);
    popStyle();
  }
  
  
  void drawItems(){
    pushStyle();
    if(rollover){
      fill(SimpleUIWidgetRolloverColor);}
    else{
      fill(SimpleUIWidgetFillColor);
    }
    
    
    
    int thisY = locY + widgetHeight;
    rect(locX, thisY, widgetWidth, (widgetHeight*numItems));
    
    if(isInItems(mouseX,mouseY)){
      hiliteItem(mouseY);
    }
    
    fill(SimpleUITextColor);
    
    textSize(textSize);
    
    for(String s : itemList){
      
      if(s.length() > 14)
        {textSize(textSize-1);}
      else {textSize(textSize);}
      
      
      text(s, locX+textPad, thisY, widgetWidth, widgetHeight);
      thisY += widgetHeight;
    }
   popStyle();
  }
  
  
 void hiliteItem(int y){
   pushStyle();
   int topOfItems =this.locY + widgetHeight;
   float distDown = y - topOfItems;
   int itemNum = (int) distDown/widgetHeight;
   fill(230,210,210);
   rect(locX, topOfItems + itemNum*widgetHeight, widgetWidth, widgetHeight);
   popStyle();
 }
  
 public void handleMouseEvent(String mouseEventType, int x, int y){
    rollover = false;
    
    //println("here1 " + mouseEventType);
    if(isInMe(x,y)==false) {
      visible = false;
      return;
    }
    if( isInMe(x,y)){
      rollover = true;
    }
    
    //println("here2 " + mouseEventType);
    if(mouseEventType.equals("mousePressed") && visible == false){
      //println("mouseclick in title of " + title);
      parentManager.setMenusOff();
      visible = true;
      rollover = true;
      return;
    }
    if(mouseEventType.equals("mousePressed") && isInItems(x,y)){
      String pickedItem = getItem(y);
      
      UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, mouseEventType, x,y);
      uied.menuItem = pickedItem;
      handleUIEvent(uied);
      
      parentManager.setMenusOff();
      
      return;
    }
  }
  
 String getItem(int y){
   int topOfItems =this.locY + widgetHeight;
   float distDown = y - topOfItems;
   int itemNum = (int) distDown/widgetHeight;
   //println("picked item number " + itemNum);
   return itemList.get(itemNum);
 }
  
 boolean isInMe(int x, int y){
   if(isInTitle(x,y)){
     //println("mouse in title of " + title);
     return true;
   }
   if(isInItems(x,y)){
     return true;
   }
   return false;
 }
 
 boolean isInTitle(int x, int y){
   if(x >= this.locX   && x < this.locX+this.widgetWidth &&
      y >= this.locY && y < this.locY+this.widgetHeight) return true;
   return false;
   
 }
 
 
 boolean isInItems(int x, int y){
   if(visible == false) return false;
   if(x >= this.locX   && x < this.locX+this.widgetWidth &&
      y >= this.locY+this.widgetHeight && y < this.locY+(this.widgetHeight*(this.numItems+1))) return true;
      
   
   return false;
 }
  
  
  
  
}// end of menu class

/////////////////////////////////////////////////////////////////////////////
// Slider class stuff

/////////////////////////////////////////////////////////////////////////////
// Slider Class
//
// calls back with value on  both release and drag

class Slider extends Widget{

  
  public float currentValue  = 0.0;
  boolean mouseEntered = false;
  int textPad = 5;
  int textSize = 10;
  boolean rollover = false;
  
  public String HANDLETYPE = "ROUND";
  
  public Slider(String uiname, String label, int x, int y){
    super(uiname,label,x,y,102,30); 
    UIComponentType = "Slider";
  }
  
  public void handleMouseEvent(String mouseEventType, int x, int y){
    PVector p = new PVector(x,y);
    
    if( mouseLeave(p) ){
      UIEventData uied = new UIEventData(UIManagerName,UIComponentType, UILabel, mouseEventType , x,y);
      uied.sliderValue = currentValue;
      handleUIEvent(uied);
      //println("mouse left sider");
    }
    
    if( bounds.isPointInside(p) == false){
      mouseEntered = false;
      return; }
    
    
    
    if( (mouseEventType.equals("mouseMoved") || mouseEventType.equals("mousePressed"))){
      rollover = true;
    } else { rollover = false; }
    
    if(  mouseEventType.equals("mousePressed") || mouseEventType.equals("mouseReleased") || mouseEventType.equals("mouseDragged") ){
      mouseEntered = true;
      float val = getSliderValueAtMousePos(x);
      //println("slider val",val);
      setSliderValue(val);
      UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, mouseEventType, x,y);
      uied.sliderValue = val;
      handleUIEvent(uied);
    }
    
  }
  
  float getSliderValueAtMousePos(int pos){
    float val = map(pos, bounds.left, bounds.right, 0,1);
    return val;
  }
  
  float getSliderValue(){
    return currentValue;
  }
  
  void setSliderValue(float val){
   currentValue =  constrain(val,0,1);
  }
  
  boolean mouseLeave(PVector p){
     // is only true, if the mouse has been in the widget, has been depressed
    if( mouseEntered && bounds.isPointInside(p)== false) {
      mouseEntered = false;
      return true; }
      
    return false;
  }
  
  public void drawMe(){
    pushStyle();
    stroke(0,0,0);
    strokeWeight(1);
    if(rollover){
      fill(SimpleUIWidgetRolloverColor);}
    else{
      fill(SimpleUIWidgetFillColor);
    }
    rect(bounds.left, bounds.top,  bounds.getWidth(), bounds.getHeight());
    fill(SimpleUITextColor);
    textSize(textSize);
    text(this.UILabel, bounds.left+textPad, bounds.top+26);
    int sliderHandleLocX = (int) map(currentValue,0,1,bounds.left, bounds.right);
    sliderHandleLocX = (int)constrain(sliderHandleLocX, bounds.left+10, bounds.right-10 );
    stroke(127);
    float lineHeight = bounds.top+ (bounds.getHeight()/2.0) - 5;
    line(bounds.left+5, lineHeight,  bounds.left+bounds.getWidth()-5, lineHeight);
    stroke(0);
    drawSliderHandle(sliderHandleLocX);
    popStyle();
  }
  
  void drawSliderHandle(int loc){
    pushStyle();
    stroke(0,0,0);
    fill(255,255,255,100);
    if(HANDLETYPE.equals("ROUND")) {
      //if(this.label =="tone"){
      //  println("drawing slider" + this.label, loc, bounds.top + 10);
      //  
      //}
      
     ellipse(loc, bounds.top + 10, 10,10);
    }
    if(HANDLETYPE.equals("UPARROW")) {
      triangle(loc-4, bounds.top + 15, loc,bounds.top - 2, loc+4, bounds.top + 15);
    }
    if(HANDLETYPE.equals("DOWNARROW")){
      triangle(loc-4, bounds.top + 5, loc,bounds.bottom + 2, loc+4, bounds.top + 5);
    }
    popStyle();
  }
  
}

////////////////////////////////////////////////////////////////////////////////
// self contained simple txt ox input
// simpleUICallback is called after every character insertion/deletion, enabling immediate udate of the system
//
class TextInputBox extends Widget{
  String contents = "";
  int maxNumChars = 14;
  
  boolean rollover;
  
  color textBoxBackground = color(235,235,255);
  
  public TextInputBox(String uiname, String uilabel, int x, int y,  int maxNumChars){
    super(uiname,uilabel,x,y,100,30);
    UIComponentType = "TextInputBox";
    this.maxNumChars = maxNumChars;
    
    rollover = false;
    
  }

  
  public void handleMouseEvent(String mouseEventType, int x, int y){
    // can only type into an input box if the mouse is hovering over
    // this way we avoid sending text input to multiple widgets
    PVector mousePos = new PVector (x,y);
    rollover = bounds.isPointInside(mousePos);
      
  }
  
  void handleKeyEvent(char k, int kcode, String keyEventType){
    if(keyEventType.equals("released")) return;
    if(rollover == false) return;

    UIEventData uied = new UIEventData(UIManagerName, UIComponentType, UILabel, "textInputEvent", 0,0);
    uied.keyPress = k;
   


    
        
    if( isValidCharacter(k) ){
        addCharacter(k);   
    }
    
    if(k == BACKSPACE){
        deleteCharacter();
    }
    
     handleUIEvent(uied);
  }
  
  void addCharacter(char k){
    if( contents.length() < this.maxNumChars){
      contents=contents+k;
      
    }
    
  }
  
  void deleteCharacter(){
    int l = contents.length();
    if(l == 0) return; // string already empty
    if(l == 1) {contents = ""; }// delete the final character
    String cpy  = contents.substring(0, l-1);
    contents = cpy;
    
  }
  
  boolean isValidCharacter(char k){
    if(k == BACKSPACE) return false;
    return true;
    
  }

  String getText(){
    return contents;
  }
  
  void setText(String s){
    contents = s;
  }

  public void drawMe(){
    pushStyle();
      stroke(0,0,0);
      fill(textBoxBackground);
      strokeWeight(1);
      
      if(rollover){stroke(255,0,0);fill(SimpleUIWidgetRolloverColor);}
      

      rect(locX, locY, widgetWidth, widgetHeight);
      stroke(0,0,0);
      fill(SimpleUITextColor);
      
      int textPadX = 5;
      int textPadY = 20;
      text(contents, locX + textPadX, locY + textPadY);
      text(UILabel, locX + widgetWidth + textPadX, locY + textPadY);
    popStyle();
  }
}  



/////////////////////////////////////////////////////////////////
// simple rectangle class especially for this UI stuff
//

class UIRect{
  
  float left,top,right,bottom;
  public UIRect(){
    
  }

  public UIRect(PVector upperleft, PVector lowerright){
    setRect(upperleft.x,upperleft.y,lowerright.x,lowerright.y);
  }
  
  public UIRect(float x1, float y1, float x2, float y2){
    setRect(x1,y1,x2,y2);
  }
  
  void setRect(UIRect other){
    setRect(other.left, other.top, other.right, other.bottom);
  }
  
  UIRect copy(){
    return new UIRect(left, top, right, bottom);
  }
  
  void setRect(float x1, float y1, float x2, float y2){
    this.left = min(x1,x2);
    this.top = min(y1,y2);
    this.right = max(x1,x2);
    this.bottom = max(y1,y2);
  }
  
  
  boolean equals(UIRect other){
    if(left == other.left && top == other.top && 
       right == other.right && bottom == other.bottom) return true;
    return false;
  }
  
  PVector getCentre(){
    float cx = this.left + (this.right - this.left)/2.0;
    float cy = this.top + (this.bottom - this.top)/2.0;
    return new PVector(cx,cy);
  }
  
  boolean isPointInside(PVector p){
    // inclusive of the boundries
    if(   isBetweenInc(p.x, this.left, this.right) && isBetweenInc(p.y, this.top, this.bottom) ) return true;
    return false;
  }
  
  boolean isPointInside(float x, float y){
    PVector v = new PVector(x,y);
    return isPointInside(v);
  }
  
  float getWidth(){
    return (this.right - this.left);
  }
  
  float getHeight(){
    return (this.bottom - this.top);
  }
  
  PVector getTopLeft(){
    return new PVector(left,top);
  }
  
  PVector getBottomRight(){
    return new PVector(right,bottom);
  }

}// end UIRect class



boolean isBetweenInc(float v, float lo, float hi){
  if(v >= lo && v <= hi) return true;
  return false;
  }
  
  void BlackandWhite(){
  outputImage = myImage.copy();
  outputImage.filter(THRESHOLD, 0.8);
}

void Dilate(){
  outputImage = myImage.copy();
  outputImage.filter(DILATE);
}

void Invert(){
  outputImage = myImage.copy();  
  outputImage.filter(INVERT);
}

void Posterize(){
  outputImage = myImage.copy();  
  outputImage.filter(POSTERIZE, 4);
}

void Erode(){
  outputImage = myImage.copy();  
  outputImage.filter(ERODE);
}

void End(){
  exit();
}

void Smaller(){
  outputImage = myImage.copy();  
  image(outputImage, 0, 0);
  outputImage.resize(250, 250);
  image(outputImage, 0, 0);
}

void Normal(){
  outputImage = myImage.copy();  
  image(outputImage, 0, 0);
  outputImage.resize(500, 500);
  image(outputImage, 0, 0);
}

void Bigger(){
  outputImage = myImage.copy();  
  image(outputImage, 0, 0);
  outputImage.resize(750, 750);
  image(outputImage, 0, 0);
}

void Reset() {
  outputImage = myImage;
};

void Lut(){
  Lut();
}
void Greyscale(){
   outputImage = myImage.copy();
   for(int y =0; y < myImage.height; y++){
      for(int x =0; x < myImage.width; x++){
        color thisPix = myImage.get(x,y);
        int r = (int) red(thisPix);
        int g = (int) green(thisPix);
        int b = (int) blue(thisPix);
        int greyscale = (int) ((r+g+b)/3);
        color newColour = color(greyscale);
        outputImage.set(x,y, newColour);
      }
   }
}

public void Hue(PImage img){
    outputImage = myImage.copy(); 
    for (int y = 0; y < img.height; y++) {
    
      for (int x = 0; x < img.width; x++){
        
        color thisPix = myImage.get(x,y);
        int r = (int) (red(thisPix));
        int g = (int) (green(thisPix));
        int b = (int) (blue(thisPix));
        
        float[] hsv = RGBtoHSV(r,g,b);
        float hue = hsv[0];
        float sat = hsv[1];
        float val = hsv[2];

        hue += 30;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
        
        color newRGB =   HSVtoRGB(hue,  sat,  val);
        myImage.set(x,y, newRGB);
        }    
     } 
   }

float[] RGBtoHSV(float r, float g, float b){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
    
    
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
     saturation = delta / maxRGB; }
   else {
       return returnVals;
       }
       
   if(delta == 0){ 
         hue = 0;
        }
   else {
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   
      if( r == maxRGB ) hue = ( g - b ) / delta;
    }
   hue = hue * 60;
   if( hue < 0 ) hue += 360;   
   returnVals[0] = hue;
   returnVals[1] = saturation;
   returnVals[2] = value;   
   return returnVals;
}

color HSVtoRGB(float hue, float sat, float val)
{  
    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);
    float r,g,b;

    switch (h) {
      case 0: r = val; g = t; b = p; break;
      case 1: r = q; g = val; b = p; break;
      case 2: r = p; g = val; b = t; break;
      case 3: r = p; g = q; b = val; break;
      case 4: r = t; g = p; b = val; break;
      case 5: r = val; g = p; b = q; break;
      default: r = val; g = t; b = p;
    }    
    return color(r*255,g*255,b*255);
}

float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 

void Edge() {
  outputImage = createImage(myImage.width,myImage.height,RGB);
  myImage.loadPixels();  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
     for(int x = 0; x < imageWidth; x++){    
        color c = convolution(x, y, edge_matrix, matrixSize, myImage);    
        outputImage.set(x,y,c);
     }
  }
}
                          
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

void Blur() {
  outputImage = createImage(myImage.width,myImage.height,RGB);
  myImage.loadPixels();  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){    
       color c = convolution(x, y, blur_matrix, matrixSize, myImage);    
       outputImage.set(x,y,c);
    }
  }
}

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  

void Sharpen() {
  outputImage = createImage(myImage.width,myImage.height,RGB);
  myImage.loadPixels();  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){    
      color c = convolution(x, y, sharpen_matrix, matrixSize, myImage);    
      outputImage.set(x,y,c);
    }
  }
}
                         
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };                                  
                                  

void Gaussianblur() {
  outputImage = createImage(myImage.width,myImage.height,RGB);
  myImage.loadPixels();  
  int matrixSize = 7;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){    
      color c = convolution(x, y, gaussianblur_matrix, matrixSize, myImage);    
      outputImage.set(x,y,c);
    }
  }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

void Brightness() {
  float startTime = getSeconds();
  
  int[] lut = makeSigmoidLUT();
  //int[] lut = makeFunctionLUT("invert",2,0);
  
  outputImage = applyPointProcessing(lut,lut,lut, myImage);
  
  float finishTime = getSeconds();
  
  println("That took ", finishTime-startTime, " seconds");
}

int[] makeSigmoidLUT(){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/255.0f;  // p ranges between 0...1
    float val = sigmoidCurve(p);
    lut[n] = (int)(val*255);
  }
  return lut;
}


// makeFunctionLUT
// this function returns a LUT from the range of functions listed
// in the second TAB above
// The parameters are functionName: a string to specify the function used
// parameter1 and parameter2 are optional, some functions do not require
// any parameters, some require one, some two

int[] makeFunctionLUT(String functionName, float parameter1, float parameter2){
  
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/256.0f;  // ranges between 0...1
    float val = 0;
    
    switch(functionName) {
      // add in the list of functions here
      // and set the val accordingly
      //
      //
      }// end of switch statement

   
    lut[n] = (int)(val*255);
  }
  
  return lut;
}


PImage applyPointProcessing(int[] redLUT, int[] greenLUT, int[] blueLUT, PImage inputImage){
PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  
  inputImage.loadPixels();
  outputImage.loadPixels();
  int numPixels = inputImage.width*inputImage.height;
  for(int n = 0; n < numPixels; n++){
    
    color c = inputImage.pixels[n];
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    r = redLUT[r];
    g = greenLUT[g];
    b = blueLUT[b];
    
    outputImage.pixels[n] = color(r,g,b);        
  }  
  return outputImage;
}

float getSeconds(){
  float t = millis()/1000.0;
  return t;
}

void Size(){
  pushMatrix();
  scale(2.0);
  popMatrix();
}
