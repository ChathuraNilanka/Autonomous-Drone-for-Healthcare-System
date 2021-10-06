class UploadResult {
  String message;
  String name;
  int success;

  UploadResult({this.message, this.name, this.success});

  UploadResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['name'] = this.name;
    data['success'] = this.success;
    return data;
  }
}
