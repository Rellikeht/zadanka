public class Counter {
  public int data = 0;
  public synchronized void increment() { data++; }
  public synchronized void decrement() { data--; }
}
