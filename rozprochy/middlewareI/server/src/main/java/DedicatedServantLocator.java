// DedicatedServantLocator.java - Locator for dedicated servants
import com.zeroc.Ice.*;
import java.util.HashMap;
import java.util.Map;

public class DedicatedServantLocator implements ServantLocator {
  private Map<String, DedicatedServant> servants =
      new HashMap<>();

  @Override
  public LocateResult locate(Current current) {
    System.out.println(
        "[DedicatedServantLocator] Locating servant for: " +
        current.id
    );

    String objectId = current.id.name;

    if (!servants.containsKey(objectId)) {
      System.out.println(
          "[DedicatedServantLocator] Instantiating new "
          + "dedicated servant for: " + objectId
      );
      DedicatedServant servant = new DedicatedServant(objectId);
      servants.put(objectId, servant);
      return new LocateResult(servant, null);
    } else {
      System.out.println(
          "[DedicatedServantLocator] Using existing servant "
          + "for: " + objectId
      );
      return new LocateResult(servants.get(objectId), null);
    }
  }

  @Override
  public void finished(
      Current current,
      com.zeroc.Ice.Object servant,
      java.lang.Object cookie
  ) {
    System.out.println(
        "[DedicatedServantLocator] Finished request for: " +
        current.id
    );
  }

  @Override
  public void deactivate(String category) {
    System.out.println(
        "[DedicatedServantLocator] "
        + "Deactivating all dedicated servants"
    );
    servants.clear();
  }
}
