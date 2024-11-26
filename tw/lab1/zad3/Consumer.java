public class Consumer implements Runnable {
  private Buffer buffer;
  private int runs;

  public Consumer(Buffer buffer, int runs) {
    this.buffer = buffer;
    this.runs = runs;
  }

  public void run() {
    for (int i = 0; i < runs; i++) {
      String message = buffer.take();
      System.out.println(message);
    }
  }
}
