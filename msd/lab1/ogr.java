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

  public static int[] optimal1 = {};
  public static int[] optimal2 = {1};

  public static void printPart(int[] part) {
    for (int e : part) {
      System.out.printf("%d ", e);
    }
    System.out.println();
  }

  public static int nextPartition(int[] part, int k) {
    if (part[part.length - 1] == 1)
      return -1;
    int p = k - 1;
    while (part[p] == 1)
      p--;

    part[p]--;
    int s = k - p;

    while (s > 0) {
      if (s >= part[p])
        part[p + 1] = part[p];
      else
        part[p + 1] = s;

      s -= part[p + 1];
      p += 1;
    }

    return p + 1;
  }

  public static boolean nextPerm(int[] perm) {
    int n = perm.length;
    int i = n - 2;

    while (i >= 0 && perm[i] > perm[i + 1])
      i--;
    if (i < 0) {
      return false;
    }

    int j = n - 1;
    while (perm[j] < perm[i])
      j--;

    int tmp = perm[i];
    perm[i] = perm[j];
    perm[j] = tmp;

    int k = i + 1;
    int l = n - 1;
    while (l > k) {
      tmp = perm[l];
      perm[l] = perm[k];
      perm[k] = tmp;

      k += 1;
      l -= 1;
    }

    return true;
  }

  public static void applyPartition(int[] base, int[] partition) {
    int n = partition.length;
    for (int i = 0; i < Math.min(n, base.length); i++) {
      base[i] += partition[n - 1 - i];
    }
  }

  public static int[] checkPerms(int[] base) {
    int[] perm = Arrays.copyOf(base, base.length);
    do {
      if (perm[0] > perm[perm.length - 1])
        continue;
      if (checkLine(perm))
        return perm;
    } while (nextPerm(perm));
    return null;
  }

  public static boolean equal(int[] p1, int[] p2, int size) {
    if (size >= p1.length)
      return false;
    for (int i = 0; i < size; i++) {
      if (p1[i] != p2[i])
        return false;
    }
    return true;
  }

  public static int[] findOptimal(int size) {
    if (size == 1)
      return optimal1;
    if (size == 2)
      return optimal2;
    size--;

    int[] base = new int[size];
    int[] perm, partition;
    for (int i = 0; i < size; i++)
      base[i] = i + 1;
    int numberToPart = 0, k;

    while (true) {
      perm = Arrays.copyOf(base, base.length);
      do {
        if (perm[0] > perm[perm.length - 1])
          continue;
        if (checkLine(perm))
          return perm;
      } while (nextPerm(perm));

      numberToPart += 1;
      partition = new int[numberToPart];
      partition[0] = numberToPart;
      k = 1;

      do {
        perm = Arrays.copyOf(base, base.length);
        do {
          int[] applied = Arrays.copyOf(perm, perm.length);
          if (applied[0] > applied[applied.length - 1])
            continue;
          applyPartition(applied, partition);
          if (checkLine(applied))
            return applied;
        } while (nextPerm(perm));

        int[] prevPart;
        do {
          prevPart = Arrays.copyOf(partition, partition.length);
          k = nextPartition(partition, k);
        } while (k > 0 && equal(partition, prevPart, size));
        // System.out.printf("%d: ", k);
        // printPart(partition);
      } while (k > 0);
    }
  }

  public static void main(String[] args) {
    int size = 5;
    if (args.length > 0) {
      try {
        size = Integer.parseInt(args[0]);
      } finally {
      }
    }

    //     int[] perm = new int[size];
    //     for (int i = 0; i < size; i++)
    //       perm[i] = i + 1;
    //     do {
    //       for (int e : perm) {
    //         System.out.printf("%d ", e);
    //       }
    //       System.out.println();
    //     } while (nextPerm(perm));
    //     return;

    //     int[] part = new int[size];
    //     part[0] = size;
    //     int k = 1;

    //     do {
    //       System.out.printf("%d: ", k);
    //       for (int e : part) {
    //         System.out.printf("%d ", e);
    //       }
    //       System.out.println();
    //       k = nextPartition(part, k);
    //     } while (k > 0);
    //     return;

    // TODO time ?
    int i = 0;
    int[] optimal = findOptimal(size);
    System.out.printf("%d ", i);
    for (int m : optimal) {
      i += m;
      System.out.printf("%d ", i);
    }
    System.out.println();
  }
}
