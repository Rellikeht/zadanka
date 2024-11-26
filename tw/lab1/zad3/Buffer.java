public class Buffer {
  private String data = "";
  private boolean empty = true;

  // https://www.youtube.com/watch?v=UOr9kMCCa5g
  // https://www.youtube.com/watch?v=A1tnVMpWHh8

  public Buffer() {}

  public synchronized void put(String value) {
    while (!empty) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    data = value;
    empty = false;
    notify();
  }

  public synchronized String take() {
    while (empty) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    empty = true;
    notify();
    return data;
  }
}
