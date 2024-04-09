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
  private final static int size = 24;
  public int editType = 0;
  private final static int LANES = 3;
  private final static int GAP = 2; // black lanes gap height

  public Board(int length, int height) {
    initialize(length, height);
    addMouseListener(this);
    addComponentListener(this);
    addMouseMotionListener(this);
    setBackground(Color.WHITE);
    setOpaque(true);
  }

  public void iteration() {

    // clear hasChangedLine status
    for (int lane = 0; lane < LANES; lane++) {
      for (int x = 0; x < points.length; ++x) {
        points[x][lane].hasChangedLine = false;
        points[x][lane + LANES + GAP].hasChangedLine = false;
      }
    }

    for (int lane = 0; lane < LANES; lane++) {
      handleForwardLaneChanges(lane);
      handleBackwardLaneChanges(lane + GAP + LANES);

      handleDriveForward(lane);
      handleDriveBackwards(lane + GAP + LANES);

      points[0][lane].randomAppearance();
      points[points.length - 1][lane + GAP + LANES].randomAppearance();
    }
    this.repaint();
  }

  private void handleBackwardLaneChanges(int lane) {
    Point point;
    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      if (!point.isCar() && !point.hasChangedLine)
        continue;
      boolean T1 = getDistanceToPreviousCar(point, x, lane) < Point.l_gap;
      if (T1) {
        if (lane > LANES + GAP) {
          boolean T2 = getDistanceToPreviousCarOnSideLine(
                           x, lane - 1, Point.l_lead) > Point.l_lead;
          boolean T3 = getDistanceToNextCarOnSideLine(
                           x, lane - 1, Point.l_back) > Point.l_back;
          if (T2 && T3) {
            point.changeLane(points[x][lane - 1]);
            point.hasChangedLine = true;
            continue;
          }
        }
        if (lane < GAP + 2 * LANES - 1) {
          boolean T2 = getDistanceToPreviousCarOnSideLine(
                           x, lane + 1, Point.l_lead) > Point.l_lead;
          boolean T3 = getDistanceToNextCarOnSideLine(
                           x, lane + 1, Point.l_back) > Point.l_back;
          if (T2 && T3) {
            point.changeLane(points[x][lane + 1]);
            point.hasChangedLine = true;
          }
        }
      }
    }
  }

  private void handleForwardLaneChanges(int lane) {
    Point point;
    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      if (!point.isCar() && !point.hasChangedLine)
        continue;
      boolean T1 = getDistanceToNextCar(point, x, lane) < Point.l_gap;
      if (T1) {
        if (lane > 0) {
          boolean T2 =
              getDistanceToNextCarOnSideLine(x, lane - 1) > Point.l_lead;
          boolean T3 =
              getDistanceToPreviousCarOnSideLine(x, lane - 1) > Point.l_back;
          if (T2 && T3) {
            point.changeLane(points[x][lane - 1]);
            continue;
          }
        }
        if (lane < LANES - 1) {
          boolean T2 =
              getDistanceToNextCarOnSideLine(x, lane + 1) > Point.l_lead;
          boolean T3 =
              getDistanceToPreviousCarOnSideLine(x, lane + 1) > Point.l_back;
          if (T2 && T3) {
            point.changeLane(points[x][lane + 1]);
            point.hasChangedLine = true;
          }
        }
      }
    }
  }

  private void handleDriveForward(int lane) {
    Point point;
    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      point.accelerate();
      point.slowDown(getDistanceToNextCar(point, x, lane));
      point.randomSlowDown();
      point.hasMoved = false;
    }

    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      point.moveCar(points[(x + point.getVelocity()) % points.length][lane],
                    x + point.getVelocity() >= points.length);
    }
  }

  private void handleDriveBackwards(int lane) {
    Point point;
    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      point.accelerate();
      point.slowDown(getDistanceToPreviousCar(point, x, lane));
      point.randomSlowDown();
      point.hasMoved = false;
    }

    for (int x = 0; x < points.length; ++x) {
      point = points[x][lane];
      point.moveCar(
          points[Math.floorMod(x - point.getVelocity(), points.length)][lane],
          x - point.getVelocity() < 0);
    }
  }

  private int getDistanceToNextCar(Point tmp, int x, int y) {
    if (!tmp.isCar())
      return 0;
    for (int i = 1; i <= Math.max(Point.maxVelocity, Point.l_gap); i++) {
      if (points[(x + i) % points.length][y].isCar())
        return i - 1;
    }
    return Math.max(Point.maxVelocity, Point.l_gap);
  }

  private int getDistanceToPreviousCar(Point tmp, int x, int y) {
    if (!tmp.isCar())
      return 0;
    for (int i = 1; i <= Math.max(Point.maxVelocity, Point.l_gap); i++) {
      if (points[Math.floorMod(x - i, points.length)][y].isCar())
        return i;
    }
    return Math.max(Point.maxVelocity, Point.l_gap);
  }

  private int getDistanceToNextCarOnSideLine(int x, int line) {
    return getDistanceToNextCarOnSideLine(x, line, Point.l_lead);
  }

  private int getDistanceToNextCarOnSideLine(int x, int line,
                                             int default_return) {
    for (int i = 0; i <= Point.l_lead + 1; i++) {
      if (points[(x + i) % points.length][line].isCar())
        return i - 1;
    }
    return default_return + 1;
  }

  private int getDistanceToPreviousCarOnSideLine(int x, int y) {
    return getDistanceToPreviousCarOnSideLine(x, y, Point.l_back);
  }

  private int getDistanceToPreviousCarOnSideLine(int x, int y,
                                                 int default_return) {
    for (int i = 0; i <= Point.l_back + 1; i++) {
      if (points[Math.floorMod(x - i, points.length)][y].isCar())
        return i - 1;
    }
    return default_return + 1;
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
      for (int lane = 0; lane < points[x].length; ++lane) {
        int l = lane;
        if (l == 4) {
          l = 3;
        } else if (l > 4) {
          l = (l - 4) % LANES;
        }

        points[x][lane] = new Point(l);
      }
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

    int y = firstY;
    while (y < lastY) {
      g.drawLine(firstX, y, lastX, y);
      y += gridSpace;
    }

    g.setColor(new Color(0, 0, 0, 0.8f));
    int x = firstX;
    while (x < lastX) {
      g.drawLine(x, firstY, x, lastY);
      x += gridSpace;
    }

    for (x = 0; x < points.length; ++x) {
      for (y = 0; y < points[x].length; ++y) {
        float a = 1.0F;
        if (points[x][y].isCar())
          switch (points[x][y].currentColorID) {
                        case 0 -> g.setColor(new Color(0, 255, 255));
                        case 1 -> g.setColor(new Color(255, 0, 255));
                        case 2 -> g.setColor(new Color(255, 255, 0));
                    }
                else if (points[x][y].defaultColorID == 3) {
                    g.setColor(new Color(0, 0, 0));
                } else {
                    g.setColor(new Color(0, 0, 0, 0.8f));
                }
                g.fillRect((x * size) + 1, (y * size) + 1, (size - 1), (size - 1));
            }
        }
    }

    public void mouseClicked(MouseEvent e) {
        int x = e.getX() / size;
        int y = e.getY() / size;
        boolean firstRoad = y >= 0 && y < 3;
        boolean secondRoad = y >= 5 && y < 8;
        if (((x < points.length) && (x >= 0)) && (firstRoad || secondRoad)) {
            if (editType == 0) {
                points[x][y].clicked();
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
        boolean firstRoad = y >= 0 && y < 3;
        boolean secondRoad = y >= 5 && y < 8;
        if (((x < points.length) && (x >= 0)) && (firstRoad || secondRoad)) {
            if (editType == 0) {
                points[x][y].clicked();
            }

            this.repaint();
        }
    }

    public void mouseExited(MouseEvent e) {
    }

    public void mouseEntered(MouseEvent e) {
    }

    public void componentShown(ComponentEvent e) {
    }

    public void componentMoved(ComponentEvent e) {
    }

    public void mouseReleased(MouseEvent e) {
    }

    public void mouseMoved(MouseEvent e) {
    }

    public void componentHidden(ComponentEvent e) {
    }

    public void mousePressed(MouseEvent e) {
    }

}
