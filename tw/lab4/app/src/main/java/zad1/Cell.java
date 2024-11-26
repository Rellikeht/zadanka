package zad1;

class Cell {
  private int want_id;
  private String data;

  Cell(String initial_data) {
    this.want_id = 0;
    this.data = initial_data;
  }

  synchronized String getData(int id) {
    while (id != want_id) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
    return data;
  }

  synchronized void
  putData(int id, String new_data, int new_id) {
    want_id = new_id;
    data = new_data;
    notifyAll();
  }

  String debugReadData() { return this.data; }
}
