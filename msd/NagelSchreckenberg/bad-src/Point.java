public class Point {
  public static final float p = (float)0.4;
  public static final int maxVel = 5;
  public final boolean canclick;
  public boolean iscar = false;
  public int velocity = 0;

  public Point(boolean canClick) {
    canclick = canClick;
    clear();
  }
  public Point() { this(false); }

  public void clicked() {
    if (canclick)
      iscar = !iscar;
  }

  public void clear() { iscar = false; }

  public void update(int free) {
    if (velocity < maxVel)
      velocity += 1;
    if (free < velocity)
      velocity = free;
    if (Math.random() <= p && velocity > 0)
      velocity -= 1;
  }

  public void setCar(boolean isCar) { iscar = isCar; }
  public boolean isCar() { return iscar; }
}
