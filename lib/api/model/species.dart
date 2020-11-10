class SpeciesResponse {
  final List<SpeciesPreview> data;
  final PageLinks links;
  final PageMeta meta;

  SpeciesResponse({
    this.data,
    this.links,
    this.meta,
  });

  factory SpeciesResponse.fromJSON(Map<String, dynamic> json) {
    return SpeciesResponse(
      data: (json["data"] as List).map((e) => SpeciesPreview.fromJson(e)).toList(),
      links: PageLinks.fromJson(json["links"]),
      meta: PageMeta.fromJson(json["meta"]),
    );
  }

  bool hasNext() {
    return links.hasNext();
  }
}

class SpeciesPreview {
  final int id; // Not null
  final String commonName;
  final String slug; // Not null
  final String scientificName; // Non null
  final String imageUrl;
  final String name;

  SpeciesPreview({
    this.id,
    this.commonName,
    this.slug,
    this.scientificName,
    this.imageUrl,
  }) : name = commonName ?? scientificName;

  factory SpeciesPreview.fromJson(Map<String, dynamic> json) {
    return SpeciesPreview(
      id: json["id"],
      commonName: json["common_name"],
      slug: json["slug"],
      scientificName: json["scientific_name"],
      imageUrl: json["image_url"],
    );
  }
}

class PageLinks {
  final String self;
  final String first;
  final String next;
  final String prev;
  final String last;

  PageLinks({
    this.self,
    this.first,
    this.next,
    this.prev,
    this.last,
  });

  factory PageLinks.fromJson(Map<String, dynamic> json) {
    return PageLinks(
      self: json["self"],
      first: json["first"],
      next: json["next"],
      prev: json["prev"],
      last: json["last"],
    );
  }

  bool hasNext() {
    return next != null;
  }
}

class PageMeta {
  final int total;

  PageMeta({
    this.total,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      total: json["total"],
    );
  }
}
