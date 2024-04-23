import java.awt.Color;
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import java.awt.event.MouseEvent;
import java.util.*;
import javax.swing.JComponent;
import javax.swing.event.MouseInputListener;

public class Board extends JComponent
    implements MouseInputListener, ComponentListener {
    private static final long serialVersionUID = 1L;
    private Point[][] points;
    private int size = 10;
    public int editType = 0;
    // private int neighborhood = 1;
    private int iteration_counter = 0;
    Queue<Point> toCheckField = new ArrayDeque<Point>();

    private static final int SFMAX = 100000;
    private static final int DFMAX = 100000;
    private static final int WALLRF = 30;

    // Different rate of exit overcrowding
    private static final int EXIT2RATIO = 3;
    private static final int EXIT4RATIO = 5;

    public Board(int length, int height) {
        addMouseListener(this);
        addComponentListener(this);
        addMouseMotionListener(this);
        setBackground(Color.WHITE);
        setOpaque(true);
        initialize(length, height);
    }

    public void iteration() {

        for (int x = 1; x < points.length - 1; ++x)
            for (int y = 1; y < points[x].length - 1; ++y)
                points[x][y].blocked = false;

        // Random order of pedestrians movement
        Collections.shuffle(Point.pedestrians);
        for (Point pedestrian :
             List.copyOf(Point.pedestrians)) {
            pedestrian.move();
        }

        // Pedestrians exit decision process
        if (iteration_counter % 25 == 0) {
            calcDynamicField();
        }
        iteration_counter++;
        this.repaint();
    }

    // Calculating a field that indicates the exit's congestion
    // level
    public void calcDynamicField() {
        int min_exit_counter = iteration_counter + 100;

        for (int x = 0; x < points.length; ++x)
            for (int y = 0; y < points[x].length; ++y) {
                points[x][y].dynamicField = DFMAX;
                if (points[x][y].type == 2 ||
                    points[x][y].type == 4) {
                    min_exit_counter = Math.min(
                        min_exit_counter,
                        points[x][y].exit_pedestrians_counter
                    );
                }
            }

        System.out.println(
            "Min exit counter: " + min_exit_counter
        );

        for (int x = 1; x < points.length - 1; ++x) {
            for (int y = 1; y < points[x].length - 1; ++y) {
                if (points[x][y].type == 2) {
                    points[x][y].dynamicField =
                        EXIT2RATIO *
                        (points[x][y].exit_pedestrians_counter -
                         min_exit_counter);
                    System.out.println(
                        "Dynamic field at (" + x + ", " + y +
                        "): " + points[x][y].dynamicField
                    );
                    toCheckField.addAll(points[x][y].neighbors);
                }
                if (points[x][y].type == 4) {
                    points[x][y].dynamicField =
                        EXIT4RATIO *
                        (points[x][y].exit_pedestrians_counter -
                         min_exit_counter);
                    System.out.println(
                        "Dynamic field at (" + x + ", " + y +
                        "): " + points[x][y].dynamicField
                    );
                    toCheckField.addAll(points[x][y].neighbors);
                }
            }
        }

        while (!toCheckField.isEmpty()) {
            Point currPoint = toCheckField.poll();
            if (currPoint.calcDynamicField()) {
                toCheckField.addAll(currPoint.neighbors);
            }
        }

        this.repaint();
    }

    public void clear() {
        for (int x = 0; x < points.length; ++x)
            for (int y = 0; y < points[x].length; ++y) {
                points[x][y].clear();
            }
        calculateField();
        calcDynamicField();
        this.repaint();
    }

    private void initialize(int length, int height) {
        boolean MooreNH = true; // Using a Moore Neighbourhood

        points = new Point[length][height];

        for (int x = 0; x < points.length; ++x)
            for (int y = 0; y < points[x].length; ++y) {
                points[x][y] = new Point();
                if (x == 0 || y == 0 ||
                    x == points.length - 1 ||
                    y == points[x].length - 1) {
                    points[x][y].type = 1;
                }
            }

        for (int x = 1; x < points.length - 1; ++x) {
            for (int y = 1; y < points[x].length - 1; ++y) {
                if (MooreNH) {
                    points[x][y].addNeighbor(
                        points[x - 1][y - 1]
                    ); // NW
                    points[x][y].addNeighbor(
                        points[x + 1][y - 1]
                    ); // NE
                    points[x][y].addNeighbor(
                        points[x + 1][y + 1]
                    ); // SE
                    points[x][y].addNeighbor(
                        points[x - 1][y + 1]
                    ); // SW
                }
                points[x][y].addNeighbor(points[x][y - 1]); // N
                points[x][y].addNeighbor(points[x + 1][y]); // E
                points[x][y].addNeighbor(points[x][y + 1]); // S
                points[x][y].addNeighbor(points[x - 1][y]); // W
            }
        }
    }

    public void calculateField() {
        Queue<Point> toCheckField = new ArrayDeque<Point>();
        Queue<Point> toCheckForce = new ArrayDeque<Point>();
        for (int x = 1; x < points.length - 1; ++x) {
            for (int y = 1; y < points[x].length - 1; ++y) {
                if (points[x][y].type == 2) {
                    points[x][y].staticField = 0;
                    toCheckField.addAll(points[x][y].neighbors);
                }
                if (points[x][y].type == 1) {
                    points[x][y].wallRepulsionForce = WALLRF;
                    toCheckForce.addAll(points[x][y].neighbors);
                }
                if (points[x][y].type == 4) {
                    points[x][y].staticField = 0;
                    toCheckField.addAll(points[x][y].neighbors);
                }
            }
        }
        // calc wall repulsion force
        while (!toCheckForce.isEmpty()) {
            Point currPoint = toCheckForce.poll();
            if (currPoint.calcRepulsionForce()) {
                toCheckForce.addAll(currPoint.neighbors);
            }
        }

        // adding repulsive force to static field
        for (int x = 0; x < points.length; ++x)
            for (int y = 0; y < points[x].length; ++y) {
                points[x][y].staticField +=
                    points[x][y].wallRepulsionForce;
            }

        // calc static field along with repulsion force
        while (!toCheckField.isEmpty()) {
            Point currPoint = toCheckField.poll();
            if (currPoint.calcStaticField()) {
                toCheckField.addAll(currPoint.neighbors);
            }
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

        for (x = 1; x < points.length - 1; ++x) {
            for (y = 1; y < points[x].length - 1; ++y) {
                if (points[x][y].type == 0) {
                    float staticField =
                        points[x][y].staticField;
                    float dynamicField =
                        points[x][y].dynamicField;
                    float intensity =
                        (staticField + dynamicField) / 2000;
                    if (intensity > 1.0) {
                        intensity = 1.0f;
                    }
                    g.setColor(new Color(
                        intensity, intensity, intensity
                    ));
                } else if (points[x][y].type == 1) {
                    g.setColor(new Color(1.0f, 0.0f, 0.0f, 0.7f)
                    );
                } else if (points[x][y].type == 2) {
                    g.setColor(new Color(0.0f, 1.0f, 0.0f, 0.7f)
                    );
                } else if (points[x][y].type == 4) {
                    g.setColor(new Color(1.0f, 0.8f, 0.0f, 0.7f)
                    );
                }
                if (points[x][y].isPedestrian) {
                    g.setColor(new Color(0.0f, 0.0f, 1.0f, 0.7f)
                    );
                }
                g.fillRect(
                    (x * size) + 1,
                    (y * size) + 1,
                    (size - 1),
                    (size - 1)
                );
            }
        }
    }

    public void mouseClicked(MouseEvent e) {
        int x = e.getX() / size;
        int y = e.getY() / size;
        if ((x < points.length) && (x > 0) &&
            (y < points[x].length) && (y > 0)) {
            if (editType == 3) {
                points[x][y].makePedestrian();
                points[x][y].type = editType;
            } else {
                points[x][y].type = editType;
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
        if ((x < points.length) && (x > 0) &&
            (y < points[x].length) && (y > 0)) {
            if (editType == 3) {
                points[x][y].makePedestrian();
                points[x][y].type = editType;
            } else {
                points[x][y].type = editType;
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
