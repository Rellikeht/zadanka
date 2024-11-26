package main;

import utils.*;

public class Main {
  private static final int ITERATIONS = 500;
  private static final int RUNS = 10;
  private static final Mandelbrot MANDELBROT =
      new Mandelbrot(ITERATIONS);

  private static final int CORES =
      Runtime.getRuntime().availableProcessors() / 2;
  private static final int[] THREADS = {1, CORES, CORES * 4};
  private static final int[] TASKS = {
      THREADS[0],
      10 * THREADS[0],
      MANDELBROT.getPixelsAmount(),
      THREADS[1],
      10 * THREADS[1],
      MANDELBROT.getPixelsAmount(),
      THREADS[2],
      10 * THREADS[2],
      MANDELBROT.getPixelsAmount(),
  };

  private static Config[] configs = new Config[TASKS.length];

  public static void main(String[] args) {
    // rozgrzewka bo jit
    // Config config = new Config(1, 1, 5);
    // config.run(MANDELBROT);
    System.out.println("threads\ttasks\taverage\t\tstdev");

    for (int t = 0; t < configs.length; t++) {

      configs[t] = new Config(
          THREADS[t / THREADS.length],
          TASKS[t],
          RUNS,
          MANDELBROT
      );
      configs[t].calculate();

      System.out.printf(
          "%d\t%d\t%f\t%f\n",
          THREADS[t / THREADS.length],
          TASKS[t],
          configs[t].getAvg(),
          configs[t].getSTDev()
      );
    }

    // int t = 0;
    // configs[t] = new Config(
    //     THREADS[t % THREADS.length], TASKS[t], 1, MANDELBROT
    // );
    // configs[t].calculate();
    // MANDELBROT.draw(configs[t].getPixels());
    // MANDELBROT.setVisible(true);
  }
}
