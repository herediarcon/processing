void setup() {
  size(640, 360);
  frame.setResizable(true);
  noStroke();
  colorMode(HSB);
}

void draw() {
  int rectSize = width/200;
  for (int x = 0; x < width; x += rectSize) {
    for (int y = 0; y < height; y += rectSize) {
      color c = colorAt(x, y);
      fill(c);
      rect(x, y, rectSize, rectSize);
    }
  }
  updateZ();
}

color colorAt(int x, int y) {
  float h = map(x, 0, width, -50, 50) + noiseAt(x, y);
  h = h < 0 ? h + 255 : h;
  float s = 255;
  float b = 255;
  return color(h, s, b);
}

float noiseZ = 0;
boolean doubleNoise = true; 

float noiseAt(int x, int y) {
  float noiseSensitivity = 0.01;
  float noiseX = x * noiseSensitivity; 
  float noiseY = y * noiseSensitivity;
  float hueNoise = noise(noiseX + noiseZ, noiseY, noiseZ);
  float zOffset = 1;
  if (doubleNoise) {
    hueNoise += noise(noiseX + noiseZ, noiseY, noiseZ+zOffset);
  }
  return map(hueNoise, 0, 2, -60, 60);
}

void updateZ() {
  float step = 0.03;
  noiseZ += step;
}
