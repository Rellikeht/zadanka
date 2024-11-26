public class Main {
  // public static final int runs = 100000000;
  // public static final int runs = 100;
  public static final int runs = 10;

  public static void main(String[] args) {
    Buffer buffer = new Buffer();

    Producer prod = new Producer(buffer, runs);
    Consumer cons = new Consumer(buffer, runs);
    Thread t1 = new Thread(prod);
    Thread t2 = new Thread(cons);

    t1.start();
    t2.start();

    try {
      t1.join();
      t2.join();
    } catch (Exception e) {
    }
  }
}
