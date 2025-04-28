import com.zeroc.Ice.Current;

public class SharedServant implements Demo.SimpleService {
  public SharedServant() {
    System.out.println(
        "[SharedServant] Created new shared servant"
    );
  }

  @Override
  public String getIdentity(Current current) {
    String identity = current.id.name;
    System.out.println(
        "[SharedServant] getIdentity called on behalf of: " +
        identity
    );
    return identity;
  }

  @Override
  public String getServantType(Current current) {
    String identity = current.id.name;
    System.out.println(
        "[SharedServant] getServantType called on behalf of: " +
        identity
    );
    return "shared";
  }

  @Override
  public String process(String input, Current current) {
    String identity = current.id.name;
    System.out.println(
        "[SharedServant] process called on behalf of: " +
        identity + " with input: " + input
    );
    return "Shared servant handling " + identity +
        " processed: " + input;
  }
}
