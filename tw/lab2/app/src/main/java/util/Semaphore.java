package util;

public class Semaphore {
  private final int max;
  private int resource;

  public Semaphore(int max) {
    this.max = max;
    this.resource = this.max;
  }

  public synchronized void up() {
    resource++;
    notifyAll();
  }

  public synchronized void down() {
    while (resource <= 0) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    resource--;
  }
}
