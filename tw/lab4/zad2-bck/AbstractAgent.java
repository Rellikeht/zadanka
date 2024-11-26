package zad2;

import java.util.concurrent.ThreadLocalRandom;

abstract class AbstractAgent extends Thread {
  protected final Buffer buffer;
  protected final int M;
  protected final ThreadLocalRandom random =
      ThreadLocalRandom.current();
  protected long access_time;
  protected int accesses;

  public int getAccesses() { return accesses; }
  public long getAccessTime() { return access_time; }

  protected synchronized static long
  elementsCount(long elements, int max) {
    if (elements == 0) {
      return 0;
    }
    return Math.min(elements, (long)max);
  }

  protected synchronized void updateTime(long time) {
    this.access_time += System.nanoTime() - time;
    this.accesses += 1;
  }

  AbstractAgent(Buffer buffer, int M) {
    this.buffer = buffer;
    this.M = M;
  }
}
