import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:digital_time_capsule/models/capsule.dart';
import 'package:digital_time_capsule/models/user.dart' as app_user;

class FirebaseService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengubah Firebase User menjadi User model aplikasi
  app_user.User? _userFromFirebase(auth.User? user) {
    return user != null ? app_user.User(uid: user.uid, email: user.email) : null;
  }

  // Stream untuk memantau perubahan status autentikasi
  Stream<app_user.User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Mendapatkan user yang sedang login dari model aplikasi
  app_user.User? getCurrentUser() {
    return _userFromFirebase(_auth.currentUser);
  }

  // Registrasi dengan email & password
  Future<app_user.User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(cred.user);
    } catch (e) {
      // Biarkan UI yang menangani error spesifik dari Firebase
      rethrow;
    }
  }

  // Login dengan email & password
  Future<app_user.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(cred.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
  
  // Mengambil stream data capsule milik user saat ini
  Stream<List<Capsule>> getCapsulesStream() {
    final user = getCurrentUser();
    if (user == null) {
      return Stream.value([]); // Kembalikan stream dengan list kosong
    }
    return _firestore
        .collection('capsules')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Capsule.fromFirestore(doc)).toList();
    });
  }

  // Menambah capsule baru
  Future<void> addCapsule(String message, DateTime unlockDate) async {
    final user = getCurrentUser();
    if (user == null) return;

    await _firestore.collection('capsules').add({
      'userId': user.uid,
      'message': message,
      'unlockDate': Timestamp.fromDate(unlockDate),
      'createdAt': Timestamp.now(),
    });
  }

  // Memperbarui capsule yang ada
  Future<void> updateCapsule(String docId, String message, DateTime unlockDate) async {
    await _firestore.collection('capsules').doc(docId).update({
      'message': message,
      'unlockDate': Timestamp.fromDate(unlockDate),
    });
  }

  // Menghapus capsule
  Future<void> deleteCapsule(String docId) async {
    await _firestore.collection('capsules').doc(docId).delete();
  }

  // Menghapus akun (butuh re-autentikasi demi keamanan)
  Future<void> deleteAccount() async {
    final user = _auth.currentUser; // Use auth.User for deletion
    if (user == null) return;

    try {
      // Pertama, hapus semua data capsule milik user
      QuerySnapshot userCapsules = await _firestore
          .collection('capsules')
          .where('userId', isEqualTo: user.uid)
          .get();
      for (var doc in userCapsules.docs) {
        await doc.reference.delete();
      }

      // Kemudian, hapus akun user
      await user.delete();
    } on auth.FirebaseAuthException catch (e) {
      // Jika butuh re-autentikasi, bisa di-handle di sini
      print("Error deleting account: $e");
      // Anda bisa melempar error ini ke UI untuk menampilkan dialog login ulang
      rethrow;
    } catch (e) {
      print("An unexpected error occurred: $e");
      rethrow;
    }
  }
}
