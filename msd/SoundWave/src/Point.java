public class Point {

	public Point nNeighbor;
	public Point wNeighbor;
	public Point eNeighbor;
	public Point sNeighbor;

	public float nVel;
	public float eVel;
	public float wVel;
	public float sVel;

	public float pressure = 0;
	public float sinput = 0;
	public static Integer[] types = {0, 1, 2};
	int type = 0;

	public Point() {
		clear();
	}

	public void clicked() {
		pressure = 1;
	}
	
	public void clear() {
		nVel = 0;
		eVel = 0;
		sVel = 0;
		wVel = 0;
		pressure = 0;
	}

	public void updateVelocity() {
		if (type == 0) {
			nVel = nVel - nNeighbor.pressure + pressure;
			sVel = sVel - sNeighbor.pressure + pressure;
			eVel = eVel - eNeighbor.pressure + pressure;
			wVel = wVel - wNeighbor.pressure + pressure;
		}
	}

	public void updatePresure() {
		float c = (float) 1 /2;
		if (type == 0)
			pressure = pressure - (c * (nVel + sVel + eVel + wVel));
		else if (type == 2) {
			sinput += 12;
			double radians = Math.toRadians(sinput);
			pressure = (float) (Math.sin(radians));
			//pressure = (float) Math.sin(sinput/3);
		}
	}

	public float getPressure() {
		return pressure;
	}
}