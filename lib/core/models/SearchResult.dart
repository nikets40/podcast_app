class SearchResult {
  int count;
  int nextOffset;
  int total;
  double took;
  List<Results> results;

  SearchResult(
      {this.count, this.nextOffset, this.total, this.took, this.results});

  SearchResult.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    nextOffset = json['next_offset'];
    total = json['total'];
    took = json['took'];
    if (json['results'] != null) {
      results = new List<Results>.empty(growable: true);
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next_offset'] = this.nextOffset;
    data['total'] = this.total;
    data['took'] = this.took;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String rss;
  String descriptionHighlighted;
  String descriptionOriginal;
  String titleHighlighted;
  String titleOriginal;
  String publisherHighlighted;
  String publisherOriginal;
  String image;
  String thumbnail;
  int itunesId;
  int latestPubDateMs;
  int earliestPubDateMs;
  String id;
  List<int> genreIds;
  String listennotesUrl;
  int totalEpisodes;
  String email;
  bool explicitContent;
  String website;
  String listenScore;
  String listenScoreGlobalRank;

  Results(
      {this.rss,
        this.descriptionHighlighted,
        this.descriptionOriginal,
        this.titleHighlighted,
        this.titleOriginal,
        this.publisherHighlighted,
        this.publisherOriginal,
        this.image,
        this.thumbnail,
        this.itunesId,
        this.latestPubDateMs,
        this.earliestPubDateMs,
        this.id,
        this.genreIds,
        this.listennotesUrl,
        this.totalEpisodes,
        this.email,
        this.explicitContent,
        this.website,
        this.listenScore,
        this.listenScoreGlobalRank});

  Results.fromJson(Map<String, dynamic> json) {
    rss = json['rss'];
    descriptionHighlighted = json['description_highlighted'];
    descriptionOriginal = json['description_original'];
    titleHighlighted = json['title_highlighted'];
    titleOriginal = json['title_original'];
    publisherHighlighted = json['publisher_highlighted'];
    publisherOriginal = json['publisher_original'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    itunesId = json['itunes_id'];
    latestPubDateMs = json['latest_pub_date_ms'];
    earliestPubDateMs = json['earliest_pub_date_ms'];
    id = json['id'];
    genreIds = json['genre_ids'].cast<int>();
    listennotesUrl = json['listennotes_url'];
    totalEpisodes = json['total_episodes'];
    email = json['email'];
    explicitContent = json['explicit_content'];
    website = json['website'];
    listenScore = json['listen_score'];
    listenScoreGlobalRank = json['listen_score_global_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rss'] = this.rss;
    data['description_highlighted'] = this.descriptionHighlighted;
    data['description_original'] = this.descriptionOriginal;
    data['title_highlighted'] = this.titleHighlighted;
    data['title_original'] = this.titleOriginal;
    data['publisher_highlighted'] = this.publisherHighlighted;
    data['publisher_original'] = this.publisherOriginal;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['itunes_id'] = this.itunesId;
    data['latest_pub_date_ms'] = this.latestPubDateMs;
    data['earliest_pub_date_ms'] = this.earliestPubDateMs;
    data['id'] = this.id;
    data['genre_ids'] = this.genreIds;
    data['listennotes_url'] = this.listennotesUrl;
    data['total_episodes'] = this.totalEpisodes;
    data['email'] = this.email;
    data['explicit_content'] = this.explicitContent;
    data['website'] = this.website;
    data['listen_score'] = this.listenScore;
    data['listen_score_global_rank'] = this.listenScoreGlobalRank;
    return data;
  }
}
