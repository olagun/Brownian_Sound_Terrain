/**
 <h1>Stocastic Behavior with a Fractal Landscape</h1>
 <p>Uses the processing sound library to map out a terrain. Insipred by @shiffman.</p>
 
 @author  Sam Olaogun
 @since   0.0.1
 */
import processing.sound.AudioIn;
import processing.sound.Amplitude;

/** Setup variables */
int cols = 0;
int rows = 0;
int s = 20;
int w, h;

float last = 0;
float z[][];
float n = 0;

/** Audio in object and audio object from processing sound library */
Amplitude amp;
AudioIn in;

void setup() {
  /** Full Screen, and uses P3D Render mode */
  fullScreen(P3D);
  
  w = width * 2;
  h = height * 2;
  cols = w / s;
  rows = h / s;
  z = new float[cols][rows];
  
  /** Smooth rendering */
  smooth();
  frameRate(60);

  /** Creates a new AudioIn object using "Built In Microphone" and listens */
  in = new AudioIn(this, 0);
  in.start();
  
  /** Creates new Amplitude object that returns the amplitude of the given AudioIn object */
  amp = new Amplitude(this);
  amp.input(in);
}

void draw() {
  /** Maps the sound in the room to a z position */
  last -= map(amp.analyze() * 60, 0, 1.2, 0.1, 0.8);

  /**
   * Uses perlin {@code noise} algorithm to map out a set of values,
   * each similar to the last for each vertex   
   */
  float yoff = last;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      z[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      xoff += 0.1;
    }
    yoff += 0.1;
  }

  /** Black background */
  background(0);

  /** Center */
  translate(width/2, height/2);
  rotateX(PI / 3);
  translate(-w/2, -h/2);

  /**
   * Creates triangle strip in the form of a jagged edge, following the pattern
   * in the processing reference. The strip starts one point, 
   * goes down and to the right by 1 (x + 1, y + 1),
   * and then goes back up one point to normal (x, y).
   *
   * @param  TRIANGLE_STRIP
   *         Specifies for the shape to follow the Triangle strip pattern        
   */
  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      /** Specifies white color, and no fill, maps color to terrain height for "shadow" effect */
      stroke(map(z[x][y], -15, 15, 45, 255));
      println(z[x][y]);
      noFill();
      vertex(x * s, y * s, z[x][y]);
      vertex(x * s, (y + 1) * s, z[x][y + 1]);
    }
    endShape();
  }
}

/*
float clamp(float s, float a, float b) {
  float val = s;
  if (s < a)
    val = a;
  else if (s > b) 
    val = b;
  return val;
}
*/