// DedicatedServant.java - Implementation for dedicated servants
import com.zeroc.Ice.Current;

public class DedicatedServant implements Demo.SimpleService {
  private String identity;

  public DedicatedServant(String identity) {
    this.identity = identity;
    System.out.println(
        "[DedicatedServant] Created new dedicated servant " +
        "with identity: " +
        identity
    );
  }

  @Override
  public String getIdentity(Current current) {
    System.out.println(
        "[DedicatedServant] getIdentity called on: " + identity
    );
    return identity;
  }

  @Override
  public String getServantType(Current current) {
    System.out.println(
        "[DedicatedServant] getServantType called on: " +
        identity
    );
    return "dedicated";
  }

  @Override
  public String process(String input, Current current) {
    System.out.println(
        "[DedicatedServant] process called on: " + identity +
        " with input: " + input
    );
    return "Dedicated servant " + identity +
        " processed: " + input;
  }
}
