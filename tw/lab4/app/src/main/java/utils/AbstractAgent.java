package utils;

import java.util.concurrent.ThreadLocalRandom;

public abstract class AbstractAgent extends Thread {
  protected final Buffer buffer;
  protected final int M;
  protected final ThreadLocalRandom random =
      ThreadLocalRandom.current();

  protected synchronized static long
  elementsCount(long elements, int max) {
    if (elements == 0) {
      return 0;
    }
    return Math.min(elements, (long)max);
  }

  public AbstractAgent(Buffer buffer, int M) {
    this.buffer = buffer;
    this.M = M;
  }
}
