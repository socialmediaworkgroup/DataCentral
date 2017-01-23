void t_setup() {

  //Set up drawing space for dumpable pixel list
  secondCanvas = new PImage(STRIPLENGTH, STRIPNUM);
  
//  secondCanvas = createImage(STRIPLENGTH, STRIPNUM, RGB);

  //Scrub through serial list, grab candidates (/dev/ttyACM*)
  String[] list = Serial.list();
  delay(20);
  ArrayList<String> matches = new ArrayList<String>();
  Pattern p = Pattern.compile("\\/dev\\/ttyACM[0-9]");
  for (int x = 0; x < list.length; x++) {
    if (p.matcher(list[x]).matches()) {
      matches.add(list[x]);
    }
  }

  

  for (int x = 0; x < matches.size (); x++) {
    println("Configuring " + matches.get(x));
    serialConfigure(matches.get(x));
  }

//  serialConfigure("/dev/ttyACM0");

  //Set up UDP listener
  //println("listening to port 5005");
  //udp = new UDP( this, 5005 );
  //udp.listen( true );
  
  //Compute gamma lookup table
  for (int i=0; i < 256; i++) {
    gammatable[i] = (int)(pow((float)i / 255.0, gamma) * 255.0 + 0.5);
  }
}

void t_draw() {
  //Dump main canvas pixels to hidden PImage and then out to serial
  loadPixels();  
  secondCanvas.loadPixels();

  arraycopy(pixels, secondCanvas.pixels);

  secondCanvas.updatePixels();
//  updatePixels();


  writeToLEDs(secondCanvas);
  //updatePixels();  
}