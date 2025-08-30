class EditListingModel {
  final List<String>? itemId;
  final List<String>? title;
  final List<String>? dailyRate;
  final List<String>? weeklyRate;
  final List<String>? monthlyRate;

  EditListingModel({
    this.itemId,
    this.title,
    this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
  });

  factory EditListingModel.fromJson(Map<String, dynamic> json) {
    return EditListingModel(
      itemId: json['itemid'] != null ? List<String>.from(json['itemid']) : null,
      title: json['title'] != null ? List<String>.from(json['title']) : null,
      dailyRate: json['daily_rate'] != null
          ? List<String>.from(json['daily_rate'])
          : null,
      weeklyRate: json['weekly_rate'] != null
          ? List<String>.from(json['weekly_rate'])
          : null,
      monthlyRate: json['monthly_rate'] != null
          ? List<String>.from(json['monthly_rate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "itemid": itemId,
      "title": title,
      "daily_rate": dailyRate,
      "weekly_rate": weeklyRate,
      "monthly_rate": monthlyRate,
    };
  }
}
