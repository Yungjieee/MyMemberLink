class News {
  String? newsId;
  String? newsTitle;
  String? newsDetails;
  String? newsDate;
  bool? isFavourite;

  News({this.newsId, this.newsTitle, this.newsDetails, this.newsDate, this.isFavourite = false,});

  News.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'];
    newsTitle = json['news_title'];
    newsDetails = json['news_details'];
    newsDate = json['news_date'];
    isFavourite = json['isFavourite'] == 1;// Map to boolean
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['news_id'] = newsId;
    data['news_title'] = newsTitle;
    data['news_details'] = newsDetails;
    data['news_date'] = newsDate;
    return data;
  }
}