class GenresList {
  List<Genres> genres;

  GenresList({this.genres});

  GenresList.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = new List<Genres>.empty(growable: true);
      json['genres'].forEach((v) {
        genres.add(new Genres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genres != null) {
      data['genres'] = this.genres.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Genres {
  int id;
  String name;
  int parentId;

  Genres({this.id, this.name, this.parentId});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    return data;
  }
}
