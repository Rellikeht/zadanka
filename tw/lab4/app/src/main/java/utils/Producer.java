package utils;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

public class Producer extends AbstractAgent {
  public static long elements;

  public Producer(Buffer buffer, int M) {
    super(buffer, M);
    if (sM != M) {
      sM = M;
      times = new TreeMap<Integer, List<Long>>();
    }
  }

  private static long sM = 0;
  private static SortedMap<Integer, List<Long>> times;
  private static synchronized void
  updateTime(int amount, long time) {
    List<Long> l = times.get(amount);
    if (l == null) {
      l = new ArrayList<Long>(5);
      times.put(amount, l);
    }
    l.add(time);
  }

  public static SortedMap<Integer, List<Long>> getTimes() {
    return times;
  }

  private synchronized static int elementsCount(int max) {
    long result = elementsCount(elements, max);
    elements -= result;
    return (int)result;
  }

  public void run() {
    while (true) {
      try {
        int amount = elementsCount(random.nextInt(M - 1) + 1);
        if (elements <= 0)
          break;
        long time = System.nanoTime();
        buffer.release(amount);
        updateTime(amount, System.nanoTime() - time);
      } catch (InterruptedException e) {
        e.printStackTrace();
        break;
      }
      // System.out.println(buffer.availablePermits());
    }
  }
}
