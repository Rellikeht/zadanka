import java.util.ArrayList;
import java.util.Random;

public class Point {
  private final Random RNG = new Random();
  private ArrayList<Point> neighbors;
  private int currentState;
  private int nextState;
  private int numStates = 6;

  public Point() {
    currentState = 0;
    nextState = 0;
    neighbors = new ArrayList<Point>();
  }

  public void clicked() { currentState = (++currentState) % numStates; }

  public int getState() { return currentState; }

  public void setState(int s) { currentState = s; }

  public void calculateNewState() {
    if (this.currentState > 0)
      nextState = currentState - 1;
    if (this.neighbors.size() > 0 && this.neighbors.get(0).getState() == 0 &&
        this.getState() > 0)
      this.neighbors.get(0).nextState = 6;
  }

  public void changeState() { currentState = nextState; }

  public void addNeighbor(Point nei) { neighbors.add(nei); }

  public int aliveNeighbours() {
    int numberOfAlive = 0;
    for (int i = 0; i < neighbors.size(); i++) {
      if (neighbors.get(i).getState() == 1)
        numberOfAlive++;
    }
    return numberOfAlive;
  }
  public boolean drop() {
    if (RNG.nextInt(100) < 5) {
      nextState = 6;
      return true;
    } else
      return false;
  }
}
