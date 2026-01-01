import 'package:cloud_firestore/cloud_firestore.dart';

class Capsule {
  final String id;
  final String userId;
  final String message;
  final DateTime unlockDate;
  final DateTime createdAt;

  Capsule({
    required this.id,
    required this.userId,
    required this.message,
    required this.unlockDate,
    required this.createdAt,
  });

  // Factory constructor to create a Capsule from a Firestore document
  factory Capsule.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Capsule(
      id: doc.id,
      userId: data['userId'] ?? '',
      message: data['message'] ?? '',
      unlockDate: (data['unlockDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
