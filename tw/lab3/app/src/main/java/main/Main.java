package main;

public class Main {

  public static void z1() { zad1.Main.main(new String[] {}); }

  public static void z2() { zad2.Main.main(new String[] {}); }

  public static void main(String[] args) {
    boolean done = false;

    if (args.length > 0) {
      if (args[0].equals("1")) {
        z1();
        done = true;
      } else if (args[0].equals("2")) {
        z2();
        done = true;
      }
    }

    if (!done) {
      System.out.println("Zadanie 1:");
      z1();
      System.out.println("");

      System.out.println("Zadanie 2:");
      z2();
      System.out.println("");
    }
  }
}
