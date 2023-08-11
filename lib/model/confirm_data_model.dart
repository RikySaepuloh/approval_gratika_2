class ConfirmDataModel {
  final String noPooling;
  final String noPooling2;
  final String message;
  final String noPesan;

  ConfirmDataModel({
    required this.noPooling,
    required this.noPooling2,
    required this.message,
    required this.noPesan,
  });

  factory ConfirmDataModel.fromJson(Map<String, dynamic> json) {
    return ConfirmDataModel(
      noPooling: json['no_pooling'],
      noPooling2: json['no_pooling2'],
      message: json['message'],
      noPesan: json['no_pesan'],
    );
  }
}
