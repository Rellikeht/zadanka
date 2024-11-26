package zad2;

import java.util.concurrent.Semaphore;

public class Buffer {
  private final Semaphore up;
  private final Semaphore down;

  Buffer(int permits) {
    up = new Semaphore(0);
    down = new Semaphore(permits);
  }

  public void acquire(int permits) throws InterruptedException {
    up.acquire(permits);
    down.release(permits);
  }

  public void release(int permits) throws InterruptedException {
    down.acquire(permits);
    up.release(permits);
  }

  public int availablePermits() {
    return up.availablePermits();
  }
}
