class Feedback {
  final int week;
  final String? by;
  final String message;
  List<Map<String,dynamic>> files;

  Feedback(this.week, this.by, this.message, {this.files =const []});

  Map<String, dynamic> toMap() {
    return {'week': week, 'by': by, 'message': message, 'files': files};
  }

  static Feedback fromJson(Map<String, dynamic> json) {
    List<Map<String,dynamic>> files = List.from(json['files']);
    return Feedback(json['week'], json['by'], json['message'],
        files: files);
  }

  int compare(Feedback f) {
    if (this.week > f.week) return -1;
    if (this.week < f.week) return 1;
    return 0;
  }
}
