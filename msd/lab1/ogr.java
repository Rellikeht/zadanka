import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ogr {
  public static boolean isPrime(int number) {
    if (number < 3)
      return false;
    int i = 3;
    while (i < Math.sqrt(number) + 1) {
      if (number % i == 0)
        return false;
      i += 2;
    }
    return true;
  }

  public static List<Integer> primesTo(int n) {
    List<Integer> nums = new ArrayList<>((int)Math.sqrt(n));
    int i = 3;
    while (i < n) {
      if (isPrime(i))
        nums.add(i);
      i += 2;
    }
    return nums;
  }

  public static Integer[] primes =
      primesTo(100).stream().toArray(Integer[] ::new);

  public static List<Integer> erdosTuran(int p) {
    List<Integer> marks = new ArrayList<>(p);
    for (int i = 0; i < p; i++) {
      marks.add(2 * p * i + (i * i % p));
    }
    marks.sort(Integer::compare);
    return marks;
  }

  public static boolean checkLine(List<Integer> marks) {
    Set<Integer> lengths = new HashSet<>(marks.size() * marks.size());
    for (int i = 0; i < marks.size(); i++) {
      for (int j = i + 1; j < marks.size(); j++) {
        int dist = marks.get(j) - marks.get(i);
        if (lengths.contains(dist))
          return false;
        lengths.add(dist);
      }
    }
    return true;
  }

  public static List<Integer> findOptimal(int size) {
    // TODO
    return new ArrayList<>(size);
  }

  public static void main(String[] args) {
    int size = 5;
    if (args.length > 1) {
      try {
        size = Integer.parseInt(args[1]);
      } finally {
      }
    }
    for (int m : findOptimal(size)) {
      System.out.printf("%d ", m);
    }
    System.out.println();
  }
}
