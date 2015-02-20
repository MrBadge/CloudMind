public class Cloud {
	protected class Ellipse {
		
		public int width;
		public int height;
		public int x;
		public int y;

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
				ellipsisList.add(new Ellipse(((i + 2) * 3) + 10, int(random(i*1.5, i*4)), ((i * 20) + 100) + int(random(-10, 0))));
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

	String msg;

	public Cloud (String str) {
		stem = new Stem(int(random(2)) + 2);
		cloud_width = 150;
		cloud_height = 90;
		Ellipse lastEl = stem.getLastChain();
		x = lastEl.x;
		y = lastEl.y + 50;

		msg = str;
	}

	public void display(int baseX, int baseY) {
		fill(255);
		stem.display(baseX, baseY);
		ellipse(baseX + x, baseY - y, cloud_width, cloud_height);
		drawCloud(baseX, baseY);

		fill(255, 0, 0);
		rectMode(CENTER);
		text(msg, baseX + x, baseY - y, cloud_width, cloud_height);
	}

	public void drawCloud(int baseX, int baseY) {
		int step = 15; 
		int r = 100;
		for(int theta = 0;  theta < 360;  theta += step) {
			int x_tmp = int(x + 0.8 * r*cos(theta));
			int y_tmp = int(y - 0.4 * r*sin(theta)); 
			// println("theta: "+theta); 
			// println("x: " + (cos(theta)) + " y: " + (sin(theta)));  
			ellipse(baseX + x_tmp, baseY - y_tmp, 30, 30);
		}
	}

}