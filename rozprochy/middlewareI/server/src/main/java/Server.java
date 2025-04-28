import com.zeroc.Ice.*;
import java.util.Scanner;

public class Server {
  public static void main(String[] args) {
    try (Communicator communicator = Util.initialize(args)) {
      ObjectAdapter adapter =
          communicator.createObjectAdapterWithEndpoints(
              "SimpleServiceAdapter",
              "default -h localhost -p 10000"
          );

      DedicatedServantLocator dedicatedLocator =
          new DedicatedServantLocator();
      adapter.addServantLocator(dedicatedLocator, "dedicated");

      SharedServant sharedServant = new SharedServant();
      adapter.addServantLocator(
          new SharedServantLocator(sharedServant), "shared"
      );

      adapter.activate();
      System.out.println("Server started. Press Enter to exit");

      Scanner scanner = new Scanner(System.in);
      while (true) {
        String line = scanner.nextLine();
        if (line.equals("quit") || line.equals("q")) {
          break;
        }
      }
      scanner.close();
    } catch (java.lang.Exception e) {
      e.printStackTrace();
    }
  }
}
