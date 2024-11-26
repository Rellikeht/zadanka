package zad2;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.SortedMap;
import utils.*;

public class Main {

  static void simulate(int M, int m, int n)
      throws InterruptedException {

    long start_elements = 100_000 * (long)M;
    Producer.elements = start_elements;
    Consumer.elements = start_elements;

    Buffer buf = new Buf(2 * M);
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

    SortedMap<Integer, List<Long>> map;

    try (
        FileWriter writer =
            new FileWriter("put_times_notfair.txt")
    ) {
      map = Producer.getTimes();
      for (int l : map.keySet()) {
        long avg = 0;
        for (long e : map.get(l)) {
          avg += e;
        }
        avg /= map.get(l).size();
        writer.write(String.format("%d %d\n", l, avg));
      }
    } catch (IOException e) {
    }

    try (
        FileWriter writer =
            new FileWriter("get_times_notfair.txt")
    ) {
      map = Consumer.getTimes();
      for (int l : map.keySet()) {
        long avg = 0;
        for (long e : map.get(l)) {
          avg += e;
        }
        avg /= map.get(l).size();
        writer.write(String.format("%d %d\n", l, avg));
      }
    } catch (IOException e) {
    }
  }

  public static void main(String[] args) {
    try {
      simulate(10000, 100, 100);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
}
