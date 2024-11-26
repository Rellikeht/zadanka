package zad2;

public class Main {

  static void simulate(int M, int m, int n)
      throws InterruptedException {

    long start_elements = 100_000 * (long)M;
    Producer.elements = start_elements;
    Consumer.elements = start_elements;

    Buffer buf = new Buffer(2 * M);
    Producer[] prods = new Producer[m];
    Consumer[] cons = new Consumer[n];

    for (int i = 0; i < m; i++) {
      prods[i] = new Producer(buf, M);
    }
    for (int i = 0; i < n; i++) {
      cons[i] = new Consumer(buf, M);
    }

    for (int i = 0; i < m; i++) {
      prods[i].start();
    }
    for (int i = 0; i < n; i++) {
      cons[i].start();
    }

    for (int i = 0; i < m; i++) {
      prods[i].join();
    }
    for (int i = 0; i < n; i++) {
      cons[i].join();
    }

    long avgAtime = 0;
    for (Producer p : prods) {
      if (p.getAccesses() > 0) {
        avgAtime += p.getAccessTime() / p.getAccesses();
      }
    }

    long avgRtime = 0;
    for (Consumer c : cons) {
      if (c.getAccesses() > 0) {
        avgRtime += c.getAccessTime() / c.getAccesses();
      }
    }

    long ns = 1_000;
    System.out.printf(
        "%d %d %d %d\n", M, n, avgAtime / ns, avgRtime / ns
    );
    // System.out.printf(
    //     "%d %d %d %d %d\n",
    //     M,
    //     m,
    //     n,
    //     avgAtime / ns,
    //     avgRtime / ns
    // );
  }

  public static void main(String[] args) {
    // System.out.println("M m n acquire release");
    System.out.println("M n acquire release");
    try {
      simulate(1000, 10, 10);
      simulate(1000, 100, 100);
      simulate(1000, 1000, 1000);

      simulate(10000, 10, 10);
      simulate(10000, 100, 100);
      simulate(10000, 1000, 1000);

      simulate(100000, 10, 10);
      simulate(100000, 100, 100);
      simulate(100000, 1000, 1000);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
}
