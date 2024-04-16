public class Point {
  private int velocity;
  private boolean isCar = false;
  public boolean hasMoved = false;
  public final static int maxVelocity = 3;
  public final static double slowDownChance = 0.5;
  // final static double appearChance = 0.0;
  // final static double disappearChance = 0.0;
  // final static double appearChance = 0.03;
  // final static double disappearChance = 0.15;
  final static double appearChance = 0;
  final static double disappearChance = 0.00;

  final static int l_gap = 3;
  final static int l_lead = 3;
  final static int l_back = 2;
  final static double prob_c = 0.75;
  public boolean hasChangedLine = false;

  public int currentColorID;
  public final int defaultColorID;
  private int numOfMovesOnNewLane = 0;
  private final static int numOfMovesBeforeColorReset = 50;

  public Point(int defaultColorID) {
    clear();
    this.defaultColorID = defaultColorID;
    currentColorID = defaultColorID;
  }

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
    currentColorID = defaultColorID;
    numOfMovesOnNewLane = 0;
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
    if (numOfMovesOnNewLane == numOfMovesBeforeColorReset) {
      currentColorID = defaultColorID;
    }
    if (isCar && !hasMoved && velocity > 0) {
      if (!exceededPeriodicBoundaries || Math.random() > disappearChance) {
        newPoint.isCar = true;
        newPoint.velocity = velocity;
        newPoint.hasMoved = true;
        newPoint.currentColorID = currentColorID;
        newPoint.numOfMovesOnNewLane = numOfMovesOnNewLane + 1;
      }
      clear();
    }
  }

  public void changeLane(Point newPoint) {
    if (isCar && !hasChangedLine) {
      if (Math.random() <= prob_c) {
        newPoint.isCar = true;
        newPoint.velocity = velocity;
        newPoint.hasChangedLine = true;
        newPoint.currentColorID = currentColorID;
      }
      clear();
    }
  }
}
