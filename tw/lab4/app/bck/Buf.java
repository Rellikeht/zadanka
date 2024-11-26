package zad2;

import java.util.concurrent.Semaphore;
import utils.Buffer;

public class Buf implements Buffer {
  private final Semaphore up;
  private final Semaphore down;

  Buf(int permits) {
    up = new Semaphore(0, false);
    down = new Semaphore(permits, false);
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
