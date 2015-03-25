/**
 * Which Face Is Which
 * Daniel Shiffman
 * http://shiffman.net/2011/04/26/opencv-matching-faces-over-time/
 *
 * Modified by Jordi Tost (call the constructor specifying an ID)
 * @updated: 01/10/2014
 */

class Face {
  
  // A Rectangle
  Rectangle r;
  
  // Am I available to be matched?
  boolean available;
  
  // Should I be deleted?
  boolean delete;
  
  // How long should I live if I have disappeared?
  int timer = 5;
  
  // Assign a number to each face
  int id;
  
  Cloud cloud;
  // Make me
  Face(int newID, int x, int y, int w, int h, String str, PImage[] cloud_anim) {
    r = new Rectangle(x,y,w,h);
    available = true;
    delete = false;
    id = newID;

    cloud = new Cloud(str, cloud_anim);
  }

  // Show me
  void display(int baseX, int baseY) {
    // fill(0,0,255,timer);
    // stroke(0,0,255);
    // rect(r.x,r.y,r.width, r.height);
    //rect(r.x*scl,r.y*scl,r.width*scl, r.height*scl);
    // fill(255,timer*2);
    // text(""+id,r.x+10,r.y+30);
    //text(""+id,r.x*scl+10,r.y*scl+30);
    //text(""+id,r.x*scl+10,r.y*scl+30);
    cloud.display(baseX, baseY, r.width, r.height);
  }

  // Give me a new location / size
  // Oooh, it would be nice to lerp here!
  void update(Rectangle newR) {
    r = (Rectangle) newR.clone();
  }

  // Count me down, I am gone
  void countDown() {
    timer--;
  }

  // I am deed, delete me
  boolean dead() {
    if (timer < 0) return true;
    return false;
  }



  protected class Cloud {

    int cloud_width;
    int cloud_height;

    String msg;

    // Sprite img;
    PImage[] cloud_anim;
    int curFrame;

    public Cloud (String str, PImage[] cloud_anim) {
      cloud_width = 350;//150/scale;
      cloud_height = 350;//90/ scale;

      msg = str;

      this.cloud_anim = cloud_anim;
      curFrame = 0;
    }

    public void display(int baseX, int baseY, int w, int h) {
      // w = 350;
      // h = 350;
      if (curFrame < START_TEXT) {
        image(cloud_anim[curFrame++], baseX + w/5, baseY - 3*h/4);
      }
      else {
        image(cloud_anim[curFrame], baseX + w/5, baseY - 3*h/4);
        // fill(255, 0, 0);
        // rectMode(CENTER);
        fill(255, 0, 0);
        text(msg, baseX, baseY, w, h);
        noFill();
        rect(baseX, baseY, w, h);
        // rect(baseX + w, baseY, 350, 350);
        if (curFrame != LAST_FRAME)
          curFrame++;
      }
    }

  }
}