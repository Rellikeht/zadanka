package zad2;

class Table {
  private boolean used = false;

  Table() {}

  synchronized void acquire() {
    while (used) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    used = true;
    notify();
  }

  synchronized void free() {
    while (!used) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    used = false;
    notify();
  }
}
