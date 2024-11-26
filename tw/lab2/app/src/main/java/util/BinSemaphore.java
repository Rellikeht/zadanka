package util;

public class BinSemaphore {
  private boolean is_up = true;
  public final int number;

  public BinSemaphore(int number) { this.number = number; }

  public synchronized void up() {
    // while (is_up) {
    //   try {
    //     wait();
    //   } catch (InterruptedException e) {
    //     e.printStackTrace();
    //   }
    // }
    is_up = true;
    notify();
    // notifyAll();
    System.out.printf("Semaphore %d is up\n", number);
  }

  public synchronized void down() {
    while (!is_up) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    is_up = false;
    // notify();
    // notifyAll();
    System.out.printf("Semaphore %d is down\n", number);
  }
}
