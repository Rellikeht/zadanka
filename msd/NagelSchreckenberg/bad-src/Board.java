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
    int j = Point.maxVel;
    for (int x = 1; x < points.length - 1; ++x) {
      int free = 0;
      int pos = x;
      for (int i = 0; i < Point.maxVel; i++) {
        pos = (pos + 1) % points.length;
      }

      Point p = points[x][1];
      if (!p.isCar())
        continue;
      p.update(free);
    }
    for (int x = 2; x < points.length - 1; ++x) {
      for (int y = 1; y < points[x].length - 1; ++y) {
      }
    }
    this.repaint();
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

    for (int x = 0; x < points.length; ++x) {
      points[x][0] = new Point(true);
      points[x][1] = new Point(true);
    }
    for (int x = 0; x < points.length; ++x)
      for (int y = 2; y < points[x].length; ++y)
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
        // if(points[x][y].type==0){
        g.setColor(
            new Color(0.0f, 0.0f, 0.0f, (points[x][y].isCar()) ? 1.0f : 0.0f));
        //	}
        /*else if (points[x][y].type==1){
                g.setColor(new Color(1.0f, 0.0f, 0.0f, 0.7f));
        }
        else if (points[x][y].type==2){
                g.setColor(new Color(0.0f, 1.0f, 0.0f, 0.7f));
        }*/
        g.fillRect((x * size) + 1, (y * size) + 1, (size - 1), (size - 1));
      }
    }
  }

  public void mouseClicked(MouseEvent e) {
    int x = e.getX() / size;
    int y = e.getY() / size;
    if ((x < points.length) && (x > 0) && (y < points[x].length) && (y > 0)) {
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
    if ((x < points.length) && (x > 0) && (y < points[x].length) && (y > 0)) {
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
