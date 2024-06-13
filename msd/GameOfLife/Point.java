import java.util.ArrayList;

public class Point {
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
    int numberOfAlive = this.aliveNeighbours();
    if ((numberOfAlive == 3) && currentState == 0)
      this.nextState = 1;
    else if ((numberOfAlive == 2 || numberOfAlive == 3) && currentState == 1)
      this.nextState = 1;
    else
      nextState = 0;
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
}
