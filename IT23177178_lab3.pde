int state = 0; // 0=start, 1=play, 2=end
int startTime;
int duration = 30; // seconds

// BALL (orb)
float x = 100, y = 100;
float xs = 4, ys = 3;
float r = 20;

// PLAYER 
float px = 350, py = 175;
float step = 6;
float pr = 20;

// HELPER 
float hx, hy;
float ease = 0.10;

// SCORE
int score = 0;

// TRAILS
boolean trails = false;

void setup() {
  size(700, 350);

  // helper 
  hx = px;
  hy = py;
}

void draw() {

  // TRAILS toggle
  if (!trails) {
    background(245);
  } else {
    fill(245, 40);
    rect(0, 0, width, height);
  }


  // START screen
  if (state == 0) {
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Press ENTER to Start", width/2, height/2);
  }


  // PLAY screen
  else if (state == 1) {

    // TIMER
    int elapsed = (millis() - startTime) / 1000;
    int left = duration - elapsed;

    textAlign(LEFT, TOP);
    textSize(18);
    fill(0);
    text("Time Left: " + left, 20, 20);
    text("Score: " + score, 20, 45);


    // PLAYER MOVEMENT
    if (keyPressed) {
      if (keyCode == RIGHT) px += step;
      if (keyCode == LEFT)  px -= step;
      if (keyCode == DOWN)  py += step;
      if (keyCode == UP)    py -= step;
    }

    px = constrain(px, pr, width - pr);
    py = constrain(py, pr, height - pr);


    // HELPER easing follow
    hx = hx + (px - hx) * ease;
    hy = hy + (py - hy) * ease;


    // BALL MOVEMENT
    x += xs;
    y += ys;


    // BOUNCE
    if (x > width - r || x < r) xs *= -1;
    if (y > height - r || y < r) ys *= -1;


    // COLLISION 
    float d = dist(px, py, x, y);

    if (d < pr + r) {

      score++;

      // reset orb randomly
      x = random(r, width - r);
      y = random(r, height - r);

      // increase speed slightly
      xs *= 1.1;
      ys *= 1.1;
    }


    // DRAW BALL
    fill(255, 120, 80);
    ellipse(x, y, r*2, r*2);


    // DRAW PLAYER
    fill(60, 120, 200);
    ellipse(px, py, pr*2, pr*2);


    // DRAW HELPER
    fill(80, 200, 120);
    ellipse(hx, hy, 16, 16);


    // TIME OVER
    if (left <= 0) {
      state = 2;
    }
  }


  // END screen
  else if (state == 2) {
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);

    text("Time Over!", width/2, height/2 - 30);
    text("Final Score: " + score, width/2, height/2);
    text("Press R to Restart", width/2, height/2 + 30);
  }
}


void keyPressed() {

  // START GAME
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }


  // RESET GAME
  if (state == 2 && (key == 'r' || key == 'R')) {

    state = 0;

    // reset ball
    x = 100;
    y = 100;
    xs = 4;
    ys = 3;

    // reset player
    px = 350;
    py = 175;

    // reset helper
    hx = px;
    hy = py;

    // reset score
    score = 0;
  }


  // SPEED CONTROL
  if (state == 1) {
    if (key == '+') {
      xs *= 1.2;
      ys *= 1.2;
    }
    if (key == '-') {
      xs *= 0.8;
      ys *= 0.8;
    }
  }


  // TRAILS toggle
  if (key == 't' || key == 'T') {
    trails = !trails;
  }
}
