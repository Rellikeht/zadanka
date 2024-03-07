// vim: set sw=2 ts=2:
import java.util.*;
import java.util.stream.Collectors;

public class ogr {
  public static boolean checkLine(int[] spaces) {
    int[] marks = new int[spaces.length + 1];
    for (int j = 1; j < marks.length; j++) {
      marks[j] = marks[j - 1] + spaces[j - 1];
    }

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

    k = p + 1;
    return k;
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

  public static void applyPartition(int[] base, int[] partition, int k) {
    int n = partition.length;
    for (int i = 0; i < k; i++) {
      base[i] += partition[n - 1 - i];
    }
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
    int numberToPart = 0;

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
      int k = 1;

      do {
        perm = Arrays.copyOf(base, base.length);
        do {
          int[] applied = Arrays.copyOf(perm, perm.length);
          applyPartition(applied, partition, k);
          if (applied[0] >= applied[applied.length - 1])
            continue;
          if (checkLine(applied))
            return applied;
        } while (nextPerm(perm));

        do {
          k = nextPartition(partition, k);
        } while (k > size);
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

    int i = 0;
    long start = System.currentTimeMillis();
    int[] optimal = findOptimal(size);
    long finish = System.currentTimeMillis();

    System.out.printf("Czas: %d ms\nLinijka: %d ", finish - start, i);
    for (int m : optimal) {
      i += m;
      System.out.printf("%d ", i);
    }
    System.out.println();
  }
}
