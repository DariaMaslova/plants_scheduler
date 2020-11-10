class CataloguePlant {
  final int id;
  final String name;
  final String preview;

  CataloguePlant({
    this.id,
    this.name,
    this.preview,
  });
}

class CataloguePage {
  final List<CataloguePlant> plants;
  final String nextPage;

  CataloguePage({
    this.plants,
    this.nextPage,
  });
}
