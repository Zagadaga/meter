// Display mouse direction, velocity, and acceleration.

/*
  The meter turns clockwise while the Polar coordinates 
 are counter clockwise. You will notice the changes to the
 Meter to accomodate this. Just do not expect to 
 display the digitalMeterValue correctly.
 The dot in the center of the window and the horizontal
 and vertical line passing through it are for the
 Direction meter.
 
 Move the mouse pointer about the center of the display
 to have the meters resister the movement.
 
 Please excuse any physics mistakes as this is just an
 example of non-microprocessor Meter use, 
 and it is just for fun.
 
 * Mover class and PVector ideas borrowed from
 * Daniel Shiffman.  
 */

import meter.*;
Meter m, av, aa;

// A Mover object
Mover mover;
float heading;

// Set main loop limit and array sizes.
int iMax = 500;
PVector[] pts = new PVector[iMax];
int[] times = new int[iMax];
float[] tdiff = new float[iMax];
float[] dist = new float[iMax];
int[] avgVelocity = new int[iMax];
int velocity = 0;
int avgAcceleration = 0;
int i = 0;
int maxVelocity = 0;
int maxAcceleration = 0;
float dotsPerCM = 255;

void setup() {
  size(1000, 1000);
  // With the window size at 1000 by 1000, measure your processing window
  // with a ruller. This will tell you the approximate DotsPerCM.
  // Mine turned out to be approximately 255, which is used for
  // the calculations.

  m = new Meter(this, 10, 10, true);
  m.setMeterWidth(280);
  int mx = m.getMeterX();
  int my = m.getMeterY();
  int mw = m.getMeterWidth();
  m.setMeterTitle("Direction");
  m.setMinScaleValue(0.0f);
  m.setMaxScaleValue(360.0f);
  m.setMaxInputSignal(360);
  m.setDisplayWarningMessagesToOutput(false);
  m.setArcMaxDegrees(360);
  m.setArcMinDegrees(0);
  m.setDisplayLastScaleLabel(false);
  String[] scaleLabels = {"0", "330", "300", "270", "240", "210", 
    "180", "150", "120", "90", "60", "30", "360"};
  m.setScaleLabels(scaleLabels);
  int ticMarkPosition = m.getMeterScaleOffsetFromPivotPoint();
  m.setTicMarkOffsetFromPivotPoint(20);
  m.setLongTicMarkLength(ticMarkPosition);
  m.setShortTicsBetweenLongTics(0);
  m.setNeedleLength(180);

  fill(color(255, 0, 0));
  ellipse(width/2, height/2, 8, 8);
  line(width/2, 5, width/2, height - 5);
  line(5, height/2, width - 5, height/2);

  av = new Meter(this, width/2 + 20, 10);
  av.setMeterWidth(280);
  av.setMaxInputSignal(1000);
  av.setShortTicsBetweenLongTics(0);
  av.setMeterTitle("Average Velocity - CM / Sec");
  String[] scaleLabelsAV = {"0", "0.5", "1.0", 
    "1.5", "2.0", "2.5", "3.0"};
  av.setScaleLabels(scaleLabelsAV);
  av.setMaxScaleValue(3.0);
  av.setDisplayMaximumMeterValue(true);
  av.setMaximumMeterValue(0);
  int avx = av.getMeterX();
  int avy = av.getMeterY();
  int avh = av.getMeterHeight();

  aa = new Meter(this, avx, avy + avh + 20);
  aa.setMeterWidth(280);
  aa.setMinInputSignal(-200);
  aa.setMaxInputSignal(200);
  //  aa.setShortTicsBetweenLongTics(0);
  aa.setMeterTitle("Average Acceleration CM / Sec / Sec");
  String[] scaleLabelsAA = {"-3.0", "-2.0", "-1.0", 
    "0.0", "1.0", "2.2", "3.0"};
  aa.setScaleLabels(scaleLabelsAA);
  aa.setMinScaleValue(-3.0);
  aa.setMaxScaleValue(3.0);
  aa.setDisplayMaximumMeterValue(true);
  aa.setMaximumMeterValue(0);

  mover = new Mover();
}

void draw() {
  // background(0);

  // Update the location
  mover.update();
  // Display the Mover
  mover.display();
}

class Mover {

  // The Mover tracks location, velocity, and acceleration 
  PVector center;
  PVector mouse;
  PVector previous;

  Mover() {
    // Start in the center
    center = new PVector(width/2, height/2);
  }

  void update() {
    // Compute a vector that points from center to mouse
    PVector mouse = new PVector(mouseX, mouseY);
    pts[i] = new PVector();
    pts[i] = mouse.copy();
    times[i] = millis();

    if (i > 0) {
      // Change milliseconds to seconds
      tdiff[i] = (times[i] - times[i-1]) * .001;
      // Change pixels to CM
      dist[i] = PVector.dist(pts[i], pts[i-1]) / dotsPerCM;
      // Change float to int for meter input
      avgVelocity[i] = (int)((dist[i] / tdiff[i]) * 10);
      velocity = avgVelocity[i];
      if (avgVelocity[i] > maxVelocity) {
        maxVelocity = avgVelocity[i];
      }
      if (i > 1) {
        avgAcceleration = (int)((avgVelocity[i] - avgVelocity[i-1]) * 10) / (times[i] - times[i-1]);
        if (avgAcceleration > maxAcceleration) {
          maxAcceleration = avgAcceleration;
        }
      }
      // If you wish to see the calculation values.
//      System.out.println("i: " + i + "  tdiff[i]: " + tdiff[i] + "  dist[i]: " + dist[i] + 
//        "  avgVelocity: " + avgVelocity[i] + "  max: " + maxVelocity + 
//        "  avgAcceleleration: " + avgAcceleration + "  maxAcceleration: " + maxAcceleration);

      // Ignore any data when the mouse is not moving by not incrementing the counter.
      if (dist[i] > 0.0) {
        i++;
      }
    }
    // Ensure there are at least two values before calculating values.
    if (i == 0) {
      i++;
    }

    // Set mouse position relative to the center.
    // Compensate for the difference in coordinate systems.
    mouse.x = mouse.x - center.x;
    mouse.y = center.y - mouse.y;
    heading = degrees(mouse.heading());
    if (heading < 0) {
      heading += 360.0;
    }
  }

  void display() {
    // Compensate for Meter and Polar graphs in different directions.
    m.updateMeter(360 - (int)heading);
    av.updateMeter(velocity);
    aa.updateMeter(avgAcceleration);
    // Reset the counter and reset the maximum values for the Meters.
    if (i >= iMax) {
      i = 0;
      av.setMaximumMeterValue(0);
      aa.setMaximumMeterValue(0);
    }
  }
}