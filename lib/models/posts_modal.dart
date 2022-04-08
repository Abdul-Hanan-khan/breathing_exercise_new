class Posts {
  List<Data> data;
  int status;

  Posts({this.data, this.status});

  Posts.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String id;
  String postId;
  String languageId;
  String title;
  String description;
  String picture;
  String type;
  String createdAt;
  String status;
  String path;
  String duration;

  Data(
      {this.id,
        this.postId,
        this.languageId,
        this.title,
        this.description,
        this.picture,
        this.type,
        this.createdAt,
        this.status,
        this.path,
        this.duration});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    languageId = json['language_id'];
    title = json['title'];
    description = json['description'];
    picture = json['picture'];
    type = json['type'];
    createdAt = json['created_at'];
    status = json['status'];
    path = json['path'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['language_id'] = this.languageId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['picture'] = this.picture;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['path'] = this.path;
    data['duration'] = this.duration;
    return data;
  }
}
