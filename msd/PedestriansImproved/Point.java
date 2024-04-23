import java.util.*;

public class Point {

    private static final int SFMAX = 100000;
    private static final int DFMAX = 100000;

    public ArrayList<Point> neighbors;
    public static Integer[] types = {0, 1, 2, 3, 4};
    public int type;
    public int staticField;
    public boolean isPedestrian;
    boolean blocked = false;
    public int wallRepulsionForce;
    public int exit_pedestrians_counter;
    public int dynamicField; // exits congestion level

    public static List<Point> pedestrians = new ArrayList<>();

    public Point() {
        type = 0;
        staticField = SFMAX;
        wallRepulsionForce = 0;
        exit_pedestrians_counter = 0;
        dynamicField = 0;
        neighbors = new ArrayList<Point>();
    }

    public void clear() {
        staticField = SFMAX;
        wallRepulsionForce = 0;
        exit_pedestrians_counter = 0;
        dynamicField = 0;
    }

    public boolean calcRepulsionForce() {
        int maxRepulsionForce = 0;
        if (!neighbors.isEmpty()) {
            maxRepulsionForce =
                neighbors.stream()
                    .map(p -> p.wallRepulsionForce)
                    .max(Integer::compare)
                    .get();
        }
        if (wallRepulsionForce < maxRepulsionForce - 10) {
            wallRepulsionForce = maxRepulsionForce - 10;
            return true;
        }
        return false;
    }

    public boolean calcDynamicField() {
        int minDynamicField = DFMAX;
        int field_increase = 10;

        if (!neighbors.isEmpty()) {
            Point minDynamicFieldPoint =
                neighbors.stream()
                    .min(
                        (p,
                         q) -> p.dynamicField - q.dynamicField
                    )
                    .get();
            if (this.neighbors.lastIndexOf(minDynamicFieldPoint
                ) < 4)
                field_increase = 14;

            minDynamicField = minDynamicFieldPoint.dynamicField;
        }

        if (dynamicField > minDynamicField + field_increase +
                               wallRepulsionForce) {
            dynamicField = minDynamicField + field_increase +
                           wallRepulsionForce;
            return true;
        }
        return false;
    }

    public boolean calcStaticField() {
        int minStaticField = SFMAX;
        int field_increase = 10;

        if (!neighbors.isEmpty()) {
            Point minStaticFieldPoint =
                neighbors.stream()
                    .min(
                        (p, q) -> p.staticField - q.staticField
                    )
                    .get();
            if (this.neighbors.lastIndexOf(minStaticFieldPoint
                ) < 4)
                field_increase = 14;

            minStaticField = minStaticFieldPoint.staticField;
        }

        if (staticField > minStaticField + field_increase +
                              wallRepulsionForce) {
            staticField = minStaticField + field_increase +
                          wallRepulsionForce;
            return true;
        }
        return false;
    }

    // Old move method:
    //	public void move(){
    //		if (isPedestrian && !neighbors.isEmpty() &&
    //!blocked){
    //
    //			Optional<Point> optionalMinSFNNeighbor =
    //neighbors.stream().filter( 					a -> !a.isPedestrian && a.type
    //!= 1 && !a.blocked
    //			).min((a, b) -> a.staticField - b.staticField);
    //
    //			if (!optionalMinSFNNeighbor.isPresent()) {
    //				this.blocked = true;
    //				return;
    //			}
    //
    //			Point minSFNNeighbor =
    //optionalMinSFNNeighbor.get(); 			System.out.println("Minimal
    //static field: "+minSFNNeighbor.staticField); 			if
    //(minSFNNeighbor.type == 0) {
    //				minSFNNeighbor.makePedestrian();
    //				minSFNNeighbor.type = 3;
    //				minSFNNeighbor.blocked = true;
    //				this.removePedestrian();
    //				type = 0;
    //			} else if (minSFNNeighbor.type == 2 ||
    //minSFNNeighbor.type == 4) { 				isPedestrian = false; 				type =
    //0;
    //			}
    //		}
    //	}

    public void move() {
        if (isPedestrian && !neighbors.isEmpty() && !blocked) {

            Optional<Point> optionalMinSFNNeighbor =
                neighbors.stream()
                    .filter(
                        a
                        -> !a.isPedestrian && a.type != 1 &&
                               !a.blocked
                    )
                    .min(
                        (a, b)
                            -> a.staticField - b.staticField +
                                   a.dynamicField -
                                   b.dynamicField
                    );

            if (!optionalMinSFNNeighbor.isPresent()) {
                this.blocked = true;
                return;
            }

            Point minSFNNeighbor = optionalMinSFNNeighbor.get();
            if (minSFNNeighbor.type == 0) {
                minSFNNeighbor.makePedestrian();
                minSFNNeighbor.type = 3;
                minSFNNeighbor.blocked = true;
                this.removePedestrian();
                type = 0;
            } else if (minSFNNeighbor.type == 2 || minSFNNeighbor.type == 4) {
                isPedestrian = false;
                type = 0;
                minSFNNeighbor.exit_pedestrians_counter++;
            }
        }
    }

    public void addNeighbor(Point nei) { neighbors.add(nei); }

    public void makePedestrian() {
        if (!this.isPedestrian) {
            this.isPedestrian = true;
            pedestrians.add(this);
        }
    }

    public void removePedestrian() {
        if (this.isPedestrian) {
            this.isPedestrian = false;
            pedestrians.remove(this);
        }
    }
}
