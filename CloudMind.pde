import SimpleOpenNI.*;
import java.util.HashMap;
import java.util.Map.Entry;

SimpleOpenNI kinect;
boolean kinectIsOn = false;

HashMap<Integer, Cloud> cloud_users = new HashMap<Integer, Cloud>();

PFont font = createFont("Arial Bold", 25, true); 

void setup() {
	size(640, 360);
	background(0);
	noStroke();

	kinect = new SimpleOpenNI(this);
	kinect.setMirror(true);
	kinect.enableDepth();
	kinect.enableRGB();
	kinect.enableUser();

	textFont(font);
	fill(255, 0, 0);
	textAlign(CENTER, CENTER);
}

void draw() {
	// if (!kinectIsOn)
	// 	return;
	kinect.update();
	image(kinect.rgbImage(), 0, 0);

	for (Entry<Integer, Cloud> cloud_user : cloud_users.entrySet())
	{
	    PVector headPos = new PVector();
		kinect.getJointPositionSkeleton(cloud_user.getKey(), SimpleOpenNI.SKEL_HEAD, headPos);	
		kinect.convertRealWorldToProjective(headPos, headPos);	
		cloud_user.getValue().display((int)headPos.x + 50, (int)headPos.y + 50);
	}
}

void onNewUser(SimpleOpenNI kin, int userId) {
    println("onNewUser - userId: " + userId);
    kin.startTrackingSkeleton(userId);
    cloud_users.put(userId, new Cloud("Hello, world!"));
}

void onLostUser(SimpleOpenNI kin, int userId) {
  println("onLostUser - userId: " + userId);
  cloud_users.remove(userId);
}