PGraphics terrain;
PGraphics clouds;
int nextX;

void setup() {
  size(800, 600);
  noiseDetail(16);
  
  terrain = createGraphics(width, height);
  generateTerrain();
  
  clouds = createGraphics(width, height);
  generateClouds();
}

void draw() {
  image(terrain, 0, 0);
  image(clouds, 0, 0);
  moveClouds();
}

void generateTerrain() {
  terrain.beginDraw();
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      color c = heightColorAt(x, y);
      terrain.stroke(c);
      terrain.point(x, y);      
    }
  }
  terrain.endDraw();
}

color heightColorAt(float x, float y) {
  float noiseSensitivity = 0.01;
  x *= noiseSensitivity;
  y *= noiseSensitivity;
  float z = dist(x, y, width*noiseSensitivity/2, height*noiseSensitivity/2);
  float n = noise(x, y, z);
  color c;
  color deepBlue = color(10, 10, 50);
  color lightBlue = color(40, 220, 160);
  color plainYellow = color(180, 240, 90);
  color highBrown = color(160, 40, 0);
  float seaCut = 0.5;
  float landCut = 0.55;
  if (n < seaCut) {
    n = map(n, 0, seaCut, 0, 1);
    c = lerpColor(deepBlue, lightBlue, n);
  } else if (n < landCut) {
    n = map(n, seaCut, landCut, 0, 1);
    c = lerpColor(lightBlue, plainYellow, n);
  } else {
    n = map(n, landCut, 1, 0, 1);
    c = lerpColor(plainYellow, highBrown, n);
  }
  return c;
}

void generateClouds() {
  clouds.beginDraw();
  clouds.clear();
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      color c = cloudColorAt(x, y);
      clouds.stroke(c);
      clouds.point(x, y);      
    }
  }
  clouds.endDraw();
  nextX = width;
}

color cloudColorAt(float x, float y) {
  float noiseSensitivity = 0.01;
  float n = noise(x*noiseSensitivity, y*noiseSensitivity, 1);
  float alpha = map(pow(n, 4), 0, 0.4, 0, 255);
  return color(255, 255, 255, alpha);
}

void moveClouds() {
  PGraphics temp = createGraphics(width, height);
  temp.beginDraw();
  temp.image(clouds, 0, 0);
  temp.endDraw();
  
  clouds.beginDraw();
  clouds.clear();
  clouds.image(temp, -1, 0);
  for (int y=0; y<height; y++) {
    color c = cloudColorAt(nextX, y);
    clouds.stroke(c);
    clouds.point(width-1, y);
  }
  clouds.endDraw();
  nextX++;
}

int seed = 1;
void keyPressed() {
  if (key == ENTER) {
    noiseSeed(seed++);
    generateTerrain();
    generateClouds(); 
  }
}
