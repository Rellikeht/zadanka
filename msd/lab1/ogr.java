// vim: set sw=2 ts=2:
import java.util.*;
import java.util.stream.Collectors;

public class ogr {
  public static boolean checkLine(int[] marks) {
    Set<Integer> lengths = new HashSet<>(marks.length * marks.length);
    for (int i = 0; i < marks.length; i++) {
      for (int j = i + 1; j < marks.length; j++) {
        int dist = marks[j] - marks[i];
        if (lengths.contains(dist))
          return false;
        lengths.add(dist);
      }
    }
    return true;
  }

  public static int[] optimal1 = {0};
  public static int[] optimal2 = {0, 1};

  public static int[] nextPartition(int[] curPartition) {
    if (curPartition[curPartition.length - 1] == 1)
      return null;
    int[] part = Arrays.copyOf(curPartition, curPartition.length);
    int i = part.length - 1;
    while (i >= 0 && part[i] > 1)
      i++;
    // TODO

    return part;
  }

  public static void applyPartition(int[] base, int[] partition) {
    for (int i = 0; i < base.length; i++) {
      base[i] += partition[i];
    }
  }

  public static void nextPerm(int[] perm) {
    // TODO
  }

  public static int[] findOptimal(int size) {
    if (size == 1)
      return optimal1;
    if (size == 2)
      return optimal2;

    int[] base = new int[size];
    for (int i = 0; i < size; i++)
      base[i] = i + 1;
    int[] perm;
    int[] partition = new int[size];
    int numberToPart = -1;

    while (true) {
      numberToPart += 1;
      for (int i = 0; i < size - 1; i++)
        partition[i] = 0;
      partition[size - 1] = numberToPart;
      while (partition != null) {
        perm = Arrays.copyOf(base, base.length);
        applyPartition(perm, partition);
        while (perm != null) {
          // TODO filter permutations that have first element greater
          // than last, no idea if that will be if here or in while
          if (checkLine(perm))
            return perm;
          nextPerm(perm);
        }
        partition = nextPartition(partition);
      }
    }
  }

  public static void main(String[] args) {
    int size = 5;
    if (args.length > 1) {
      try {
        size = Integer.parseInt(args[1]);
      } finally {
      }
    }
    // TODO time ?
    for (int m : findOptimal(size)) {
      System.out.printf("%d ", m);
    }
    System.out.println();
  }
}
