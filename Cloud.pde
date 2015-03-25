public class Cloud {
	protected class Ellipse {
		
		public int width;
		public int height;
		public int x;
		public int y;
		public int scl;

		public Ellipse (int w, int h) {
			width = w;
			height = h;
		}

		public Ellipse (int rad, int x, int y) {
			width = rad + int(random(10, 20));
			height = rad + int(random(5, 12));
			this.x = x;
			this.y = y;
		}
		
		public void display(int offsetX, int offsetY) {
			ellipse(offsetX + x, offsetY - y, width, height);
		}

	}

	protected class Stem {
		
		ArrayList<Ellipse> ellipsisList;

		public Stem (int count) {
			ellipsisList = new ArrayList<Ellipse>();
			println(count);
			for (int i = 0; i < count; ++i) {
				ellipsisList.add( new Ellipse( ((i + 2) * 3) + 10, int(random(i*1.5, i*4)), ((i * 20) + 100) + int(random(-10, 0) ) ));
			}
		}

		public void display(int baseX, int baseY) {
			int i = 1;
			for (Ellipse el : ellipsisList) {
				el.display(baseX, baseY);
			}
		}

		public Ellipse getLastChain() {
			return ellipsisList.get(ellipsisList.size() - 1);
		}
	
	}

	Stem stem;
	int cloud_width;
	int cloud_height;
	int x;
	int y;

	int scl;

	String msg;

	// Sprite img;
	PImage[] cloud_anim;
	int curFrame;

	public Cloud (String str, int scale, PImage[] cloud_anim) {
		stem = new Stem(int(random(2)) + 2);
		cloud_width = 350;//150/scale;
		cloud_height = 350;//90/ scale;
		Ellipse lastEl = stem.getLastChain();
		x = lastEl.x;
		y = lastEl.y + 50;

		msg = str;
		scl = scale;

		this.cloud_anim = cloud_anim;
		curFrame = 0;

		// img = new Sprite(papp, "Oblako.png", 5, 8, 0);
		// img.setDomain(-100, -60, width + 100, height - 100, Sprite.REBOUND);
		// img.setFrameSequence(0, 39, 0.3f, 1);
	}

	public void display(int baseX, int baseY) {
		// fill(255);
		// stem.display(baseX, baseY);
		// ellipse(baseX + x, baseY - y, cloud_width, cloud_height);
		// drawCloud(baseX, baseY);
		// int curFrame = frameCount % cloud_anim.length;
		if (curFrame < LAST_FRAME)
			image(cloud_anim[curFrame++], baseX + x, baseY - y);
		else {
			image(cloud_anim[LAST_FRAME], baseX + x, baseY - y);
			fill(255, 0, 0);
			rectMode(CENTER);
			text(msg, baseX + cloud_width/2 + 45, baseY + 5, cloud_width*2/3 - 50, cloud_height*2/3 - 50);
		}
	}

	public void drawCloud(int baseX, int baseY) {
		int step = 15; 
		int r = 100 / scl;
		for(int theta = 0;  theta < 360;  theta += step) {
			int x_tmp = int(x + 0.8 * r*cos(theta));
			int y_tmp = int(y - 0.4 * r*sin(theta)); 
			// println("theta: "+theta); 
			// println("x: " + (cos(theta)) + " y: " + (sin(theta)));  
			ellipse(baseX + x_tmp, baseY - y_tmp, 30, 30);
		}
	}

}