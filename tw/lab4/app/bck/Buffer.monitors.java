package zad2;

class Buffer {
  private final int max_permits;
  private int permits = 0;

  Buffer(int permits) { max_permits = permits; }

  synchronized void acquire(int permits)
      throws InterruptedException {
    while (this.permits < permits) {
      wait();
    }
    this.permits -= permits;
    notifyAll();
  }

  synchronized void release(int permits)
      throws InterruptedException {
    while (this.permits + permits > max_permits) {
      wait();
    }
    this.permits += permits;
    notifyAll();
  }

  int availablePermits() { return permits; }
}
