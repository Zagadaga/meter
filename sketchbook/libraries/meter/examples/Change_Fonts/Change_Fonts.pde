/* //<>//
 Meter as a partial circle.
 Change a font and it's size.
 Note that the circle starts at 90 degrees (6:00 OClock) and
 moves clockwise. The scale labels have to be in this order.
 
 Non-Hardware example.
 
 created April 19, 2017
 by Bill (Papa) Kujawa.
 
 This example code is in the public domain.
 */

import meter.*;

Meter m;

void setup() {
  size(700, 600);
  background(255, 255, 200);

  // Display a list of available fonts from your computer.
  String[] fontList = PFont.list();
  printArray(fontList);

  // Display a full circle meter frame.
  m = new Meter(this, 125, 25, true); // Instantiate a full circle meter class.

  m.setMeterTitleFontSize(34);
  m.setMeterTitleFontName("Arial Bold Italic");
  m.setMeterTitleFontColor(color(0, 200, 0));
  // Move title down
  m.setMeterTitleYOffset(24);  // default is 12 pixels

  // Define where the scale labele will appear
  m.setArcMinDegrees(90.0); // (start)
  m.setArcMaxDegrees(360.0); // ( end)

  String[] scaleLabels = {"0", "10", "20", "30", "40", "50", "60", "70", "80"};
  m.setScaleLabels(scaleLabels);

  // Change the title from the default "Voltage" to a more meaningful label.
  m.setMeterTitle("Rainbow");

  // Display the digital meter value.
  m.setDisplayDigitalMeterValue(true);
}

void draw() {

  // Simulate sensor data.
  int newSensorReading;
  newSensorReading = (int)random(0, 255);

  // Display the new sensor value.
  m.updateMeter(newSensorReading);
  delay(1000); // Allow time to see the change.
}