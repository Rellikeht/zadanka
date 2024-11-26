package zad2;

class Producer extends AbstractAgent {
  Producer(Buffer buffer, int M) { super(buffer, M); }
  static long elements;

  private synchronized static int elementsCount(int max) {
    long result = elementsCount(elements, max);
    elements -= result;
    return (int)result;
  }

  public void run() {
    while (elements > 0) {
      try {
        long time = System.nanoTime();
        int amount = elementsCount(random.nextInt(M - 1) + 1);
        buffer.release(amount);
        updateTime(time);
      } catch (InterruptedException e) {
        e.printStackTrace();
        break;
      }
      // System.out.println(buffer.availablePermits());
    }
  }
}
