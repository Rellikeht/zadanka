package utils;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Config {
  private final int THREADS_AMOUNT, TASKS_AMOUNT, RUNS, PX;
  private final long[] run_data;
  private static final long NANOS = 1_000;
  private List<Integer> pixels;
  private final Mandelbrot MANDELBROT;

  public Config(
      int threads_amount,
      int tasks_amount,
      int runs,
      Mandelbrot mandelbrot
  ) {
    this.THREADS_AMOUNT = threads_amount;
    this.TASKS_AMOUNT = tasks_amount;
    this.RUNS = runs;
    this.run_data = new long[runs];
    this.MANDELBROT = mandelbrot;
    this.PX = MANDELBROT.getPixelsAmount();
  }

  public List<Integer> getPixels() { return pixels; }

  public double getAvg() {
    double avg = 0;
    for (long e : run_data)
      avg += e;
    return avg / RUNS;
  }

  public double getSTDev() {
    double avg = getAvg();
    double stdev = 0;
    for (long e : run_data) {
      stdev += (e - avg) * (e - avg);
    }
    return stdev / (RUNS - 1);
  }

  private Callable<Integer[]> pixels(int task) {
    return () -> {
      int start, end;
      if (PX == TASKS_AMOUNT) {
        start = task;
        end = task + 1;
      } else {
        end = (task + 1) * PX / TASKS_AMOUNT;
        start = task * PX / TASKS_AMOUNT;
      }
      Integer[] result = new Integer[end - start];
      int j = 0;
      for (int i = start; i < end; i++) {
        int y = i / MANDELBROT.getWidth();
        int x = i - y * MANDELBROT.getWidth();
        result[j] = MANDELBROT.pixel(x, y);
        j += 1;
      }
      return result;
    };
  }

  public void calculate() {
    // rozgrzewka bo jit
    // mandelbrot.backup();
    // mandelbrot.backup();

    ExecutorService pool =
        Executors.newFixedThreadPool(THREADS_AMOUNT);
    Queue<Future<Integer[]>> tasks =
        new ArrayDeque<Future<Integer[]>>(TASKS_AMOUNT);

    for (int r = 0; r < RUNS; r++) {
      pixels = new ArrayList<>(MANDELBROT.getPixelsAmount());
      long start = System.nanoTime();
      for (int t = 0; t < TASKS_AMOUNT; t++) {
        tasks.add(pool.submit(pixels(t)));
      }

      for (int t = 0; t < TASKS_AMOUNT; t++) {
        try {
          pixels.addAll(Arrays.asList(tasks.poll().get()));
        } catch (InterruptedException e) {
          e.printStackTrace();
        } catch (ExecutionException e) {
          e.printStackTrace();
        }
      }

      run_data[r] = System.nanoTime() - start;
      run_data[r] /= NANOS;
    }
    pool.shutdownNow();
  }
}
