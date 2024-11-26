public class Producer implements Runnable {
  private Buffer buffer;
  private int runs;

  public Producer(Buffer buffer, int runs) {
    this.buffer = buffer;
    this.runs = runs;
  }

  public void run() {
    for (int i = 0; i < runs; i++) {
      buffer.put("message " + i);
    }
  }
}
