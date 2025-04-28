import com.zeroc.Ice.*;

public class SharedServantLocator implements ServantLocator {
  private SharedServant sharedServant;

  public SharedServantLocator(SharedServant servant) {
    this.sharedServant = servant;
  }

  @Override
  public LocateResult locate(Current current) {
    System.out.println(
        "[SharedServantLocator] Locating shared servant for: " +
        current.id
    );
    return new LocateResult(sharedServant, null);
  }

  @Override
  public void finished(
      Current current,
      com.zeroc.Ice.Object servant,
      java.lang.Object cookie
  ) {
    System.out.println(
        "[SharedServantLocator] Finished request for: " +
        current.id
    );
  }

  @Override
  public void deactivate(String category) {
    System.out.println(
        "[SharedServantLocator] Deactivating shared servant"
    );
  }
}
