package utils;

public interface Buffer {
  public void acquire(int permits) throws InterruptedException;
  public void release(int permits) throws InterruptedException;
}
