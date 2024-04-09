import javax.swing.JFrame;

public class Program extends JFrame {

  private static final long serialVersionUID = 1L;
  private GUI gof;

  public Program() {
    setTitle("Freeway Traffic simulation");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    gof = new GUI(this);
    this.setExtendedState(JFrame.MAXIMIZED_BOTH);
    gof.initialize(this.getContentPane());
    this.setSize(1440, 720);
    this.setVisible(true);
  }

  public static void main(String[] args) { new Program(); }
}
