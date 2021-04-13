// generic methods
public <T> List<T> fromArrayToList(T[] a) {
  return Arrays.stream(a).collect(Collectors.toList());
}

public static <T, G> List<G> fromArrayToList(T[] a, Function<T, G> mapperFunction) {
  return Arrays.stream(a)
    .map(mapperFunction)
    .collect(Collectors.toList());
}

// bounded generics
public <T extends Number> List<T> fromArrayToList(T[] a) {
    ...
}

//multiple bounds
<T extends Number & Comparable>

// upper bound wildcards
public static void paintAllBuildings(List<? extends Building> buildings) {
    ...
}

// lower bound wildcard
<? super T>

