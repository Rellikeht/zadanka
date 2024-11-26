package zad1;

class Process implements Runnable {
  private final int id, wait_time, max;
  private final String name;
  private final Cell[] buffer;
  private final int runs = 3;

  Process(
      int id, int wait_time, String name, Cell[] buffer, int max
  ) {
    this.id = id;
    this.wait_time = wait_time;
    this.name = name;
    this.buffer = buffer;
    this.max = max;
  }

  private String process(String data) {
    try {
      Thread.sleep(wait_time);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    if (id == -1) {
      return name;
    }
    return data + name;
  }

  public void run() {
    for (int run = 0; run < runs; run++) {
      for (int i = 0; i < buffer.length; i++) {
        String data = buffer[i].getData(id);
        int new_id = id + 1;
        if (new_id == max) {
          new_id = -1;
        }
        data = process(data);
        buffer[i].putData(id, data, new_id);

        for (int j = 0; j < buffer.length; j++) {
          System.out.println(buffer[j].debugReadData());
        }
        System.out.println();
      }
    }
  }
}
