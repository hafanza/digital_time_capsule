import 'package:digital_time_capsule/models/user.dart' as app_user;
import 'package:flutter/material.dart';
import 'package:digital_time_capsule/models/capsule.dart';
import 'package:digital_time_capsule/services/firebase_service.dart';
import 'create_capsule_screen.dart';
import 'edit_capsule_screen.dart';
import 'login_screen.dart';
import 'open_capsule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  app_user.User? _currentUser;
  
  int _selectedLockedIndex = -1;
  int _selectedUnlockedIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseService.getCurrentUser();
  }

  String _calculateTimeDisplay(DateTime targetTime) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final targetMidnight = DateTime(targetTime.year, targetTime.month, targetTime.day);
    final difference = targetMidnight.difference(todayMidnight);

    if (difference.isNegative) {
      final daysAgo = difference.abs().inDays;
      if (daysAgo == 0) return "Opened Today";
      return "Opened $daysAgo days ago";
    } else {
      final daysLeft = difference.inDays;
      if (daysLeft == 0) {
        final hoursLeft = targetTime.difference(now).inHours;
        if (hoursLeft <= 0) return "Ready to Open!";
        return "$hoursLeft Hours Remaining";
      }
      return "$daysLeft Days Remaining";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: StreamBuilder<List<Capsule>>(
        stream: _firebaseService.getCapsulesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Tampilan jika tidak ada data sama sekali
            return _buildEmptyState();
          }

          final allCapsules = snapshot.data!;
          final now = DateTime.now();

          final lockedList = allCapsules.where((c) => c.unlockDate.isAfter(now)).toList();
          final unlockedList = allCapsules.where((c) => !c.unlockDate.isAfter(now)).toList();

          lockedList.sort((a, b) => a.unlockDate.compareTo(b.unlockDate));
          unlockedList.sort((a, b) => b.unlockDate.compareTo(a.unlockDate));
          
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildCapsuleList(
                        dataList: lockedList,
                        selectedIndex: _selectedLockedIndex,
                        isLockedList: true),
                    const SizedBox(height: 20),
                    SizedBox(height: 300, child: _buildPreviewArea(lockedList, unlockedList)),
                    const SizedBox(height: 20),
                    _buildCapsuleList(
                        dataList: unlockedList,
                        selectedIndex: _selectedUnlockedIndex,
                        isLockedList: false),
                    const SizedBox(height: 10),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Digital Time Capsule',
          style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'VT323', letterSpacing: 1.5),
        ),
        Text(
          'Account: ${_currentUser?.email ?? "Guest"}',
          style: const TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'VT323'),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateCapsuleScreen()),
            );
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeader(),
            const Expanded(
              child: Center(
                child: Text(
                  "Anda belum punya kapsul waktu.\nTekan tombol '+' untuk membuat yang baru!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: 'VT323'),
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleList({required List<Capsule> dataList, required int selectedIndex, required bool isLockedList}) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(8)),
      child: dataList.isEmpty
          ? const Center(child: Text("Kosong...", style: TextStyle(color: Colors.white30, fontFamily: 'VT323')))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final capsule = dataList[index];
          bool isSelected = selectedIndex == index;
          String timeDisplay = _calculateTimeDisplay(capsule.unlockDate);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isLockedList) {
                  _selectedLockedIndex = index;
                  _selectedUnlockedIndex = -1;
                } else {
                  _selectedUnlockedIndex = index;
                  _selectedLockedIndex = -1;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF444444) : Colors.transparent,
                border: isSelected ? Border.all(color: Colors.white) : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(isLockedList ? "assets/asset5.png" : "assets/asset6.png", width: 40),
                  const SizedBox(height: 5),
                  Text(
                    timeDisplay.split(' ').take(2).join(' '),
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'VT323'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewArea(List<Capsule> lockedList, List<Capsule> unlockedList) {
    Capsule? activeCapsule;
    bool isLocked = false;

    if (_selectedLockedIndex != -1 && _selectedLockedIndex < lockedList.length) {
      activeCapsule = lockedList[_selectedLockedIndex];
      isLocked = true;
    } else if (_selectedUnlockedIndex != -1 && _selectedUnlockedIndex < unlockedList.length) {
      activeCapsule = unlockedList[_selectedUnlockedIndex];
      isLocked = false;
    }

    if (activeCapsule == null) {
      return const Center(child: Text("Pilih capsule untuk melihat detail", style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 18)));
    }

    Color glowColor = isLocked ? Colors.blueAccent : Colors.amber;
    String timeDisplay = _calculateTimeDisplay(activeCapsule.unlockDate);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLocked
                ? IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCapsuleScreen(capsule: activeCapsule!),
                  ),
                );
              },
            )
                : const SizedBox(width: 48),
            GestureDetector(
              onTap: () {
                if (isLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sabar ya! Belum waktunya dibuka.", style: TextStyle(fontFamily: 'VT323')), backgroundColor: Colors.redAccent));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OpenCapsuleScreen(message: activeCapsule!.message, dateInfo: timeDisplay)));
                }
              },
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: glowColor.withAlpha(75), blurRadius: 30, spreadRadius: 5)]),
                child: Image.asset(isLocked ? "assets/asset5.png" : "assets/asset6.png", width: 120),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _showDeleteDialog(context, activeCapsule!.id)),
          ],
        ),
        const SizedBox(height: 20),
        Text(isLocked ? "LOCKED" : "UNLOCKED", style: TextStyle(color: isLocked ? Colors.white : Colors.amber, fontSize: 32, fontFamily: 'VT323', fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.white30), color: Colors.black26, borderRadius: BorderRadius.circular(4)),
          child: Text(timeDisplay, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'VT323')),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () => _showLogoutDialog(context),
          child: const Text("Logout", style: TextStyle(color: Colors.white70, fontFamily: 'VT323')),
        ),
        TextButton(
          onPressed: () => _showDeleteAccountDialog(),
          child: const Text("Delete Account", style: TextStyle(color: Colors.redAccent, fontFamily: 'VT323', fontSize: 14, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Delete?", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.white, fontFamily: 'VT323'))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first
              await _firebaseService.deleteCapsule(docId);
              if (mounted) {
                setState(() {
                  _selectedLockedIndex = -1;
                  _selectedUnlockedIndex = -1;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kapsul dihapus."), backgroundColor: Colors.green));
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Logout", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.grey, fontFamily: 'VT323'))),
          TextButton(
            onPressed: () async {
              await _firebaseService.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              }
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Hapus Akun Permanen?", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        content: const Text("Tindakan ini tidak bisa dibatalkan.", style: TextStyle(color: Colors.white70, fontFamily: 'VT323')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.grey, fontFamily: 'VT323'))),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context); // Close dialog
                await _firebaseService.deleteAccount();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Akun berhasil dihapus."), backgroundColor: Colors.green,));
                }
              } catch (e) {
                if(mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus akun. Silakan coba login ulang dan ulangi lagi."), backgroundColor: Colors.red,));
                }
              }
            },
            child: const Text("Hapus Permanen", style: TextStyle(color: Colors.red, fontFamily: 'VT323', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}