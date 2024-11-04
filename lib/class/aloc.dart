class Aloc {
  final int userId;
  final int bookId;
  final DateTime alocDate;
  final DateTime? returnDate;
  final String status;

  Aloc({
    required this.userId,
    required this.bookId,
    required this.alocDate,
    this.returnDate,
    required this.status,
  });

  factory Aloc.fromJson(Map<String, dynamic> json) {
    return Aloc(
      userId: json['userId'],
      bookId: json['bookId'],
      alocDate: DateTime.parse(json['alocDate']),
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bookId': bookId,
      'alocDate': alocDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'status': status,
    };
  }
}