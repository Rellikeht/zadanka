public class Point {
  private int velocity;
  private boolean isCar = false;
  public boolean hasMoved = false;
  public final static int maxVelocity = 5;
  final static double slowDownChance = 0.35;
  final static double appearChance = 0.0;
  final static double disappearChance = 0.5;

  public Point() { clear(); }

  public boolean isCar() { return isCar; }

  public int getVelocity() { return velocity; }

  public void clicked() {
    if (!isCar) {
      this.isCar = true;
    }
  }

  public void randomAppearance() {
    if (!isCar && Math.random() <= appearChance) {
      isCar = true;
    }
  }

  public void clear() {
    velocity = 0;
    isCar = false;
  }

  public void accelerate() {
    if (isCar && velocity < maxVelocity) {
      velocity++;
    }
  }

  public void slowDown(int distanceToNextCar) {
    if (isCar && distanceToNextCar < velocity) {
      velocity = distanceToNextCar;
    }
  }

  public void randomSlowDown() {
    if (isCar && Math.random() <= slowDownChance && velocity > 0) {
      velocity--;
    }
  }

  public void moveCar(Point newPoint, boolean exceededPeriodicBoundaries) {
    if (isCar) { // && !hasMoved && velocity > 0) {
      if (Math.random() > disappearChance) {
        newPoint.isCar = true;
        newPoint.velocity = velocity;
        newPoint.hasMoved = true;
      }
      clear();
    }
  }
}
