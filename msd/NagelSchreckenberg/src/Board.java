import java.awt.Color;
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import java.awt.event.MouseEvent;
import javax.swing.JComponent;
import javax.swing.event.MouseInputListener;

public class Board
    extends JComponent implements MouseInputListener, ComponentListener {
  private static final long serialVersionUID = 1L;
  private Point[][] points;
  private int size = 10;
  public int editType = 0;

  public Board(int length, int height) {
    initialize(length, height);
    addMouseListener(this);
    addComponentListener(this);
    addMouseMotionListener(this);
    setBackground(Color.WHITE);
    setOpaque(true);
  }

  public void iteration() {
    int y = 0;
    Point tmp;

    copyRowsOneDown();

    for (int x = 0; x < points.length; ++x) {
      tmp = points[x][y];
      tmp.accelerate();
      tmp.slowDown(getDistanceToNextCar(tmp, x, y));
      tmp.randomSlowDown();
      tmp.hasMoved = false;
    }

    for (int x = 0; x < points.length; ++x) {
      tmp = points[x][y];
      tmp.moveCar(points[(x + tmp.getVelocity()) % points.length][y],
                  x + tmp.getVelocity() >= points.length);
    }

    points[0][0].randomAppearance();

    this.repaint();
  }

  private int getDistanceToNextCar(Point tmp, int x, int y) {
    if (!tmp.isCar())
      return 0;
    for (int i = 1; i <= Point.maxVelocity; i++) {
      if (points[(x + i) % points.length][y].isCar())
        return i - 1;
    }
    return Point.maxVelocity;
  }

  private void copyRowsOneDown() {
    for (int y = points[0].length - 1; y > 0; y--) {
      for (int x = 0; x < points.length; x++) {
        if (points[x][y - 1].isCar())
          points[x][y].clicked();
        else
          points[x][y].clear();
      }
    }
  }

  public void clear() {
    for (int x = 0; x < points.length; ++x)
      for (int y = 0; y < points[x].length; ++y) {
        points[x][y].clear();
      }
    this.repaint();
  }

  private void initialize(int length, int height) {
    points = new Point[length][height];

    for (int x = 0; x < points.length; ++x)
      for (int y = 0; y < points[x].length; ++y)
        points[x][y] = new Point();
  }

  protected void paintComponent(Graphics g) {
    if (isOpaque()) {
      g.setColor(getBackground());
      g.fillRect(0, 0, this.getWidth(), this.getHeight());
    }
    g.setColor(Color.GRAY);
    drawNetting(g, size);
  }

  private void drawNetting(Graphics g, int gridSpace) {
    Insets insets = getInsets();
    int firstX = insets.left;
    int firstY = insets.top;
    int lastX = this.getWidth() - insets.right;
    int lastY = this.getHeight() - insets.bottom;

    int x = firstX;
    while (x < lastX) {
      g.drawLine(x, firstY, x, lastY);
      x += gridSpace;
    }

    int y = firstY;
    while (y < lastY) {
      g.drawLine(firstX, y, lastX, y);
      y += gridSpace;
    }

    for (x = 0; x < points.length; ++x) {
      for (y = 0; y < points[x].length; ++y) {
        float a = 1.0F;
        if (points[x][y].isCar())
          g.setColor(new Color(0, 0, 0));
        else
          g.setColor(new Color(a, a, a, 0.5f));
        g.fillRect((x * size) + 1, (y * size) + 1, (size - 1), (size - 1));
      }
    }
  }

  public void mouseClicked(MouseEvent e) {
    int x = e.getX() / size;
    int y = e.getY() / size;
    if ((x < points.length) && (x >= 0) && y == 0) {
      if (editType == 0) {
        points[x][y].clicked();
      } else {
        //		points[x][y].type= editType;
      }
      this.repaint();
    }
  }

  public void componentResized(ComponentEvent e) {
    int dlugosc = (this.getWidth() / size) + 1;
    int wysokosc = (this.getHeight() / size) + 1;
    initialize(dlugosc, wysokosc);
  }

  public void mouseDragged(MouseEvent e) {
    int x = e.getX() / size;
    int y = e.getY() / size;
    if ((x < points.length) && (x >= 0) && y == 0) {
      if (editType == 0) {
        points[x][y].clicked();
      } else {
        //	points[x][y].type= editType;
      }
      this.repaint();
    }
  }

  public void mouseExited(MouseEvent e) {}

  public void mouseEntered(MouseEvent e) {}

  public void componentShown(ComponentEvent e) {}

  public void componentMoved(ComponentEvent e) {}

  public void mouseReleased(MouseEvent e) {}

  public void mouseMoved(MouseEvent e) {}

  public void componentHidden(ComponentEvent e) {}

  public void mousePressed(MouseEvent e) {}
}
