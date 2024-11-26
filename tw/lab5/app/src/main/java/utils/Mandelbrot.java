package utils;

import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.util.Collection;
import javax.swing.JFrame;

public class Mandelbrot extends JFrame {
  public static final int DEFAULT_MAX_ITER = 570;

  private final int MAX_ITER;
  private final double ZOOM = 250;
  // private final double ZOOM = 150;
  private BufferedImage I;
  private double zx, zy, cX, cY, tmp;
  public final int W = 800, H = 600;

  public final int getPixelsAmount() {
    return getWidth() * getHeight();
  }

  public Mandelbrot() { this(DEFAULT_MAX_ITER); }

  public Mandelbrot(int max_iter) {
    super("Mandelbrot Set");
    MAX_ITER = max_iter;
    setBounds(100, 100, W, H);
    setResizable(false);
    setDefaultCloseOperation(EXIT_ON_CLOSE);
    I = new BufferedImage(
        getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB
    );
  }

  public void backup() {
    for (int y = 0; y < getHeight(); y++) {
      for (int x = 0; x < getWidth(); x++) {
        I.setRGB(x, y, pixel(x, y));
      }
    }
  }

  public int pixel(int x, int y) {
    zx = zy = 0;
    cX = (x - 2 * W / 3) / ZOOM;
    cY = (y - H / 2) / ZOOM;
    int iter = MAX_ITER;
    while (zx * zx + zy * zy < 4 && iter > 0) {
      tmp = zx * zx - zy * zy + cX;
      zy = 2.0 * zx * zy + cY;
      zx = tmp;
      iter--;
    }
    return iter | (iter << 8);
  }

  public void draw(int[][] pixels) {
    int[] newpix = new int[pixels.length * pixels[0].length];
    for (int i = 0; i < pixels.length; i++) {
      for (int j = 0; j < pixels[0].length; j++) {
        newpix[i * pixels[0].length + j] = pixels[i][j];
      }
    }
    draw(newpix);
  }

  public void draw(int[] pixels) {
    I.setRGB(
        0, 0, getWidth(), getHeight(), pixels, 0, getWidth()
    );
  }

  public void draw(Collection<Integer> pixels) {
    int[] a = pixels.stream().mapToInt(i -> i).toArray();
    draw(a);
  }

  @Override
  public void paint(Graphics g) {
    g.drawImage(I, 0, 0, this);
  }
}
