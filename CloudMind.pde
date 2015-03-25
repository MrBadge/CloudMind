import java.util.HashMap;
import java.util.Map.Entry;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

import sprites.*;
import sprites.utils.*;

import java.util.Random;

// Scaling down the video
int scl = 1;
int w = 1280;
int h = 800;

int fps = 5;

// SimpleOpenNI kinect;
// boolean kinectIsOn = false;

// HashMap<Integer, Cloud> cloud_users = new HashMap<Integer, Cloud>();

PFont font = createFont("PFDinTextCompPro-Medium", 23 / scl, true); 

Capture video;
OpenCV opencv;

// List of my Face objects (persistent)
ArrayList<Face> faceList;

// List of detected faces (every frame)
Rectangle[] faces;

// Number of faces detected over all time. Used to set IDs.
int faceCount = 0;

PImage border_image;

StopWatch sw = new StopWatch();

PImage spritesheet;
int DIM_X = 5;
int DIM_Y = 8;
int LAST_FRAME = 30;
PImage[] cloud_anim = new PImage[DIM_X*DIM_Y];

Random r = new Random();

// int test_frame = 0;

void setup() {
	spritesheet = loadImage("Oblako.png");
	int W = 352; /*spritesheet.width/DIM_X;*/
	int H = 352; /*spritesheet.height/DIM_Y;*/
	// println("cloud_anim.length: " + cloud_anim.length);
	int k = 0;
	for (int i = 0; i < DIM_Y; ++i) {
		// println("Row: " + i);
		for (int j = 0; j < DIM_X; ++j) {
			int x = j*W;
			// println("x: "+x);
			int y = i*H;
			// println("y: "+y);
			cloud_anim[k++] = spritesheet.get(x, y, W, H);
		}
	}
	// for (int i=0; i<cloud_anim.length; i++) {
	// 	int x = i%DIM_X*W;
	// 	println("x: "+x);
	// 	int y = i/DIM_Y*H;
	// 	println("y: "+y);
	// 	cloud_anim[i] = spritesheet.get(x, y, W, H);
	// }

	frameRate(5);

	size(w, h);
	background(0);
	// noStroke();
	noFill();

	faceList = new ArrayList<Face>();
  	// String[] cameras = Capture.list();

  	border_image  = loadImage("Plenka2.png");

  	// frameRate(fps);

	// if (cameras.length == 0) {
 //    println("There are no cameras available for capture.");
 //    exit();
 //  } else {
 //    println("Available cameras:");
 //    for (int i = 0; i < cameras.length; i++) {
 //      println(cameras[i]);
 //    }
 //  }

	video = new Capture(this, w/scl, h/scl, "HD Pro Webcam C920", fps);
  	opencv = new OpenCV(this, w/scl, h/scl);
  	opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  	video.start();

	textFont(font);
	textAlign(CENTER, CENTER);

	// registerMethod("pre", this);
}

// public void pre() {
//   float elapsedTime = (float) sw.getElapsedTime();
//   S4P.updateSprites(elapsedTime);
// }

void draw() {
	// scale(scl);
	opencv.loadImage(video);
	image(video, 0, 0);
	image(border_image, 0, 0);
	// stroke(255,0,0);
	// rect(300, 300, 350, 350);
	// image(cloud_anim[frameCount%cloud_anim.length], 300, 300);
	// if (frameCount % 10 == 0)
	// 	image(cloud_anim[test_frame % cloud_anim.length], width / 2, height / 2);
	// try {
	// 	S4P.drawSprites();
	// } catch (Exception e) {
		
	// }
	

	// if (frameCount % 2 == 0) {
	detectFaces();		
	// }

	// Draw all the faces
	// if (faces != null)
	// 	for (int i = 0; i < faces.length; i++) {
	// 		noFill();
	// 		// strokeWeight(5);
	// 		stroke(255,0,0);
	// 		// noStroke();
	// 		//rect(faces[i].x*scl,faces[i].y*scl,faces[i].width*scl,faces[i].height*scl);
	// 		rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
	// 		// cloud_users.get(i).display(faces[i].x, faces[i].y - faces[i].height);
	// 	}

	for (Face f : faceList) {
		strokeWeight(2);
		f.display(f.r.x - f.r.width, f.r.y - f.r.height * 2);
	}
}

void detectFaces() {
  
  // Faces detected in this frame
  faces = opencv.detect();
  
  // Check if the detected faces already exist are new or some has disappeared. 
  
  // SCENARIO 1 
  // faceList is empty
  if (faceList.isEmpty()) {
    // Just make a Face object for every face Rectangle
    for (int i = 0; i < faces.length; i++) {
      println("+++ New face detected with ID: " + faceCount);
      faceList.add(new Face(faceCount, faces[i].x,faces[i].y,faces[i].width,faces[i].height, phrases[r.nextInt(phrases.length)], cloud_anim));
      // cloud_users.put(faceCount, new Cloud(phrases[r.nextInt(phrases.length)], scl, cloud_anim));
      faceCount++;
    }
  
  // SCENARIO 2 
  // We have fewer Face objects than face Rectangles found from OPENCV
  } else if (faceList.size() <= faces.length) {
    boolean[] used = new boolean[faces.length];
    // Match existing Face objects with a Rectangle
    for (Face f : faceList) {
       // Find faces[index] that is closest to face f
       // set used[index] to true so that it can't be used twice
       float record = 50000;
       int index = -1;
       for (int i = 0; i < faces.length; i++) {
         float d = dist(faces[i].x,faces[i].y,f.r.x,f.r.y);
         if (d < record && !used[i]) {
           record = d;
           index = i;
         } 
       }
       // Update Face object location
       used[index] = true;
       f.update(faces[index]);
    }
    // Add any unused faces
    for (int i = 0; i < faces.length; i++) {
      if (!used[i]) {
        println("+++ New face detected with ID: " + faceCount);
        faceList.add(new Face(faceCount, faces[i].x,faces[i].y,faces[i].width,faces[i].height, phrases[r.nextInt(phrases.length)], cloud_anim));
        // cloud_users.put(faceCount, new Cloud(phrases[r.nextInt(phrases.length)], scl, cloud_anim));
        faceCount++;
      }
    }
  
  // SCENARIO 3 
  // We have more Face objects than face Rectangles found
  } else {
    // All Face objects start out as available
    for (Face f : faceList) {
      f.available = true;
    } 
    // Match Rectangle with a Face object
    for (int i = 0; i < faces.length; i++) {
      // Find face object closest to faces[i] Rectangle
      // set available to false
       float record = 50000;
       int index = -1;
       for (int j = 0; j < faceList.size(); j++) {
         Face f = faceList.get(j);
         float d = dist(faces[i].x,faces[i].y,f.r.x,f.r.y);
         if (d < record && f.available) {
           record = d;
           index = j;
         } 
       }
       // Update Face object location
       Face f = faceList.get(index);
       f.available = false;
       f.update(faces[i]);
    } 
    // Start to kill any left over Face objects
    for (Face f : faceList) {
      if (f.available) {
        f.countDown();
        if (f.dead()) {
          f.delete = true;
        } 
      }
    } 
  }
  
  // Delete any that should be deleted
  for (int i = faceList.size()-1; i >= 0; i--) {
    Face f = faceList.get(i);
    if (f.delete) {
      faceList.remove(i);
      println("--- Face removed, ID: " + i);
      // cloud_users.remove(i);
    } 
  }
}

// void onNewUser(SimpleOpenNI kin, int userId) {
//     println("onNewUser - userId: " + userId);
//     kin.startTrackingSkeleton(userId);
//     cloud_users.put(userId, new Cloud("Hello, world!"));
// }

// void onLostUser(SimpleOpenNI kin, int userId) {
//   println("onLostUser - userId: " + userId);
//   cloud_users.remove(userId);
// }

void captureEvent(Capture c) {
  c.read();
}

String[] phrases = {
	// "Я гуру программатика", 
	// "Я играю на аукционах", 
	// "Я знаю, чем ты занимаешься в Интернете",
	// "Я знаю, что ты любишь",
	// "Ай лав пис дата!",
	// "Зацени мои KPI",
	// "Я слежу за тобой",
	// "Люблю отборные сегменты",
	// "Ты в моем white list’е",
	// "Таргетируюсь на женщин",
	// "Умею управлять трафиком",
	// "Обычный диджитал уже не торт",
	// "Моя аффинитивность зашкаливает",
	// "Мои роботы уже ищут тебя",
	// "В моем сегменте есть место для тебя",
	// "Знаю о тебе больше твоей мамы",
	"DMP, SSP, CTR, DSP…WTF is programmatic??!!"
};

