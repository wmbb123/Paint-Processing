float simpleScale(float v, float scl){
  
  float scaledV =  v*scl;
  return constrain(scaledV,0,1);
  
}

// interpolates the input value between the low and hi values
float ramp(float v, float low, float hi){
  
  float rampedV = lerp(low, hi, v);
  return constrain(rampedV,0,1);
}

// negates the input value
float invert(float v){
  
  return 1-v;
}


// raises the input value by a power
float gammaCurve(float v, float gamma){
  
  return pow(v,gamma);
  
}

// creates a "flipped" gamma curve
float inverseGammaCurve(float v, float gamma){
  
  return 1.0 - pow(1.0-v,gamma);
  
}

// creates a nice S-shaped curve, useful for contrast functions
float sigmoidCurve(float v){
  // contrast: generate a sigmoid function
  
  float f =  (1.0 / (1 + exp(-12 * (v  - 0.5))));
  
 
  return f;
}


// creates a stepped output. useful for posterising
float step(float v, int numSteps){
  float thisStep = (int) (v*numSteps);
  return thisStep/numSteps;
  
}
