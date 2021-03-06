class PodcastsFromGenre {
  int id;
  String name;
  int parentId;
  List<Podcasts> podcasts;
  int total;
  bool hasNext;
  bool hasPrevious;
  int pageNumber;
  int previousPageNumber;
  int nextPageNumber;
  String listennotesUrl;

  PodcastsFromGenre(
      {this.id,
        this.name,
        this.parentId,
        this.podcasts,
        this.total,
        this.hasNext,
        this.hasPrevious,
        this.pageNumber,
        this.previousPageNumber,
        this.nextPageNumber,
        this.listennotesUrl});

  PodcastsFromGenre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    if (json['podcasts'] != null) {
      podcasts = new List<Podcasts>.empty(growable: true);
      json['podcasts'].forEach((v) {
        podcasts.add(new Podcasts.fromJson(v));
      });
    }
    total = json['total'];
    hasNext = json['has_next'];
    hasPrevious = json['has_previous'];
    pageNumber = json['page_number'];
    previousPageNumber = json['previous_page_number'];
    nextPageNumber = json['next_page_number'];
    listennotesUrl = json['listennotes_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    if (this.podcasts != null) {
      data['podcasts'] = this.podcasts.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['has_next'] = this.hasNext;
    data['has_previous'] = this.hasPrevious;
    data['page_number'] = this.pageNumber;
    data['previous_page_number'] = this.previousPageNumber;
    data['next_page_number'] = this.nextPageNumber;
    data['listennotes_url'] = this.listennotesUrl;
    return data;
  }
}

class Podcasts {
  String id;
  String title;
  String publisher;
  String image;
  String thumbnail;
  String listennotesUrl;
  int totalEpisodes;
  bool explicitContent;
  String description;
  int itunesId;
  String rss;
  int latestPubDateMs;
  int earliestPubDateMs;
  String language;
  String country;
  String website;
  Extra extra;
  bool isClaimed;
  String email;
  String type;
  LookingFor lookingFor;
  List<int> genreIds;

  Podcasts(
      {this.id,
        this.title,
        this.publisher,
        this.image,
        this.thumbnail,
        this.listennotesUrl,
        this.totalEpisodes,
        this.explicitContent,
        this.description,
        this.itunesId,
        this.rss,
        this.latestPubDateMs,
        this.earliestPubDateMs,
        this.language,
        this.country,
        this.website,
        this.extra,
        this.isClaimed,
        this.email,
        this.type,
        this.lookingFor,
        this.genreIds});

  Podcasts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    publisher = json['publisher'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    listennotesUrl = json['listennotes_url'];
    totalEpisodes = json['total_episodes'];
    explicitContent = json['explicit_content'];
    description = json['description'];
    itunesId = json['itunes_id'];
    rss = json['rss'];
    latestPubDateMs = json['latest_pub_date_ms'];
    earliestPubDateMs = json['earliest_pub_date_ms'];
    language = json['language'];
    country = json['country'];
    website = json['website'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    isClaimed = json['is_claimed'];
    email = json['email'];
    type = json['type'];
    lookingFor = json['looking_for'] != null
        ? new LookingFor.fromJson(json['looking_for'])
        : null;
    genreIds = json['genre_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['publisher'] = this.publisher;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['listennotes_url'] = this.listennotesUrl;
    data['total_episodes'] = this.totalEpisodes;
    data['explicit_content'] = this.explicitContent;
    data['description'] = this.description;
    data['itunes_id'] = this.itunesId;
    data['rss'] = this.rss;
    data['latest_pub_date_ms'] = this.latestPubDateMs;
    data['earliest_pub_date_ms'] = this.earliestPubDateMs;
    data['language'] = this.language;
    data['country'] = this.country;
    data['website'] = this.website;
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    data['is_claimed'] = this.isClaimed;
    data['email'] = this.email;
    data['type'] = this.type;
    if (this.lookingFor != null) {
      data['looking_for'] = this.lookingFor.toJson();
    }
    data['genre_ids'] = this.genreIds;
    return data;
  }
}

class Extra {
  String twitterHandle;
  String facebookHandle;
  String instagramHandle;
  String wechatHandle;
  String patreonHandle;
  String youtubeUrl;
  String linkedinUrl;
  String spotifyUrl;
  String googleUrl;
  String url1;
  String url2;
  String url3;

  Extra(
      {this.twitterHandle,
        this.facebookHandle,
        this.instagramHandle,
        this.wechatHandle,
        this.patreonHandle,
        this.youtubeUrl,
        this.linkedinUrl,
        this.spotifyUrl,
        this.googleUrl,
        this.url1,
        this.url2,
        this.url3});

  Extra.fromJson(Map<String, dynamic> json) {
    twitterHandle = json['twitter_handle'];
    facebookHandle = json['facebook_handle'];
    instagramHandle = json['instagram_handle'];
    wechatHandle = json['wechat_handle'];
    patreonHandle = json['patreon_handle'];
    youtubeUrl = json['youtube_url'];
    linkedinUrl = json['linkedin_url'];
    spotifyUrl = json['spotify_url'];
    googleUrl = json['google_url'];
    url1 = json['url1'];
    url2 = json['url2'];
    url3 = json['url3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['twitter_handle'] = this.twitterHandle;
    data['facebook_handle'] = this.facebookHandle;
    data['instagram_handle'] = this.instagramHandle;
    data['wechat_handle'] = this.wechatHandle;
    data['patreon_handle'] = this.patreonHandle;
    data['youtube_url'] = this.youtubeUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['spotify_url'] = this.spotifyUrl;
    data['google_url'] = this.googleUrl;
    data['url1'] = this.url1;
    data['url2'] = this.url2;
    data['url3'] = this.url3;
    return data;
  }
}

class LookingFor {
  bool sponsors;
  bool guests;
  bool cohosts;
  bool crossPromotion;

  LookingFor({this.sponsors, this.guests, this.cohosts, this.crossPromotion});

  LookingFor.fromJson(Map<String, dynamic> json) {
    sponsors = json['sponsors'];
    guests = json['guests'];
    cohosts = json['cohosts'];
    crossPromotion = json['cross_promotion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sponsors'] = this.sponsors;
    data['guests'] = this.guests;
    data['cohosts'] = this.cohosts;
    data['cross_promotion'] = this.crossPromotion;
    return data;
  }
}
