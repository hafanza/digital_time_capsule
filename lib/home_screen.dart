import 'create_capsule_screen.dart';
import 'edit_capsule_screen.dart';
import 'login_screen.dart';
import 'open_capsule_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box capsuleBox;
  List<Map<String, dynamic>> allCapsules = [];

  List<Map<String, dynamic>> lockedList = [];
  List<Map<String, dynamic>> unlockedList = [];
  int _selectedLockedIndex = -1;
  int _selectedUnlockedIndex = -1;

  @override
  void initState() {
    super.initState();
    capsuleBox = Hive.box('capsuleBox');
    _loadCapsules();
  }

  void _loadCapsules() {
    // FINAL FIX: Jika akun demo, paksa rawData jadi null agar selalu reset ke default.
    // Ini mencegah reviewer melihat layar kosong jika mereka tidak sengaja menghapus kapsul di sesi sebelumnya.
    bool isDemo = widget.username.toLowerCase() == '@demoaccount';
    final rawData = isDemo ? null : capsuleBox.get(widget.username);

    if (rawData != null) {
      setState(() {
        allCapsules = List<Map<String, dynamic>>.from(
          (rawData as List).map((item) => Map<String, dynamic>.from(item)),
        );
        _organizeCapsules();
      });
    } else {
      allCapsules = [
        {
          "id": "welcome_${widget.username}",
          "message":
              "Halo ${widget.username}! Selamat datang di kapsul waktu digitalmu.",
          "image": "assets/asset5.png",
          "unlockDate": isDemo
              ? DateTime.now()
                    .subtract(const Duration(days: 1))
                    .toIso8601String()
              : DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        },
      ];
      _saveCapsules();
      _organizeCapsules();
    }
  }

  Future<void> _saveCapsules() async {
    await capsuleBox.put(widget.username, allCapsules);
    await capsuleBox.flush();
  }

  void _organizeCapsules() {
    final now = DateTime.now();

    setState(() {
      lockedList.clear();
      unlockedList.clear();

      for (var capsule in allCapsules) {
        DateTime unlockTime = DateTime.parse(capsule['unlockDate']);
        capsule['timeDisplay'] = _calculateTimeDisplay(unlockTime);

        if (unlockTime.isAfter(now)) {
          capsule['image'] = "assets/asset5.png";
          lockedList.add(capsule);
        } else {
          capsule['image'] = "assets/asset6.png";
          unlockedList.add(capsule);
        }
      }

      lockedList.sort(
        (a, b) => DateTime.parse(
          a['unlockDate'],
        ).compareTo(DateTime.parse(b['unlockDate'])),
      );
      unlockedList.sort(
        (a, b) => DateTime.parse(
          b['unlockDate'],
        ).compareTo(DateTime.parse(a['unlockDate'])),
      );
    });
  }

  String _calculateTimeDisplay(DateTime targetTime) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final targetMidnight = DateTime(
      targetTime.year,
      targetTime.month,
      targetTime.day,
    );
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Digital Time Capsule',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'VT323',
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Halo ${widget.username}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontFamily: 'VT323',
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCapsuleScreen(),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        allCapsules.add({
                          "id": result['id'],
                          "message": result['message'],
                          "image": "assets/asset5.png",
                          "unlockDate": (result['date'] as DateTime)
                              .toIso8601String(),
                        });
                        _saveCapsules();
                        _organizeCapsules();
                      });
                    }
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
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _buildCapsuleList(
                  dataList: lockedList,
                  selectedIndex: _selectedLockedIndex,
                  isLockedList: true,
                ),
                const SizedBox(height: 20),
                SizedBox(height: 300, child: _buildPreviewArea()),
                const SizedBox(height: 20),
                _buildCapsuleList(
                  dataList: unlockedList,
                  selectedIndex: _selectedUnlockedIndex,
                  isLockedList: false,
                ),

                const SizedBox(height: 10),

                // --- BAGIAN TOMBOL AKSI (LOGOUT & DELETE) ---
                Column(
                  children: [
                    TextButton(
                      onPressed: () => _showLogoutDialog(context),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'VT323',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showDeleteAccountDialog(),
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'VT323',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCapsuleList({
    required List<Map<String, dynamic>> dataList,
    required int selectedIndex,
    required bool isLockedList,
  }) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: dataList.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada capsule yang dibuka",
                style: TextStyle(color: Colors.white30, fontFamily: 'VT323'),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;
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
                      color: isSelected
                          ? const Color(0xFF444444)
                          : Colors.transparent,
                      border: isSelected
                          ? Border.all(color: Colors.white)
                          : Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(dataList[index]['image']!, width: 40),
                        const SizedBox(height: 5),
                        Text(
                          dataList[index]['timeDisplay']
                              .toString()
                              .split(' ')
                              .take(2)
                              .join(' '),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'VT323',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPreviewArea() {
    Map<String, dynamic>? activeData;
    bool isLocked = false;
    int activeIndex = -1;

    if (_selectedLockedIndex != -1 &&
        _selectedLockedIndex < lockedList.length) {
      activeData = lockedList[_selectedLockedIndex];
      isLocked = true;
      activeIndex = _selectedLockedIndex;
    } else if (_selectedUnlockedIndex != -1 &&
        _selectedUnlockedIndex < unlockedList.length) {
      activeData = unlockedList[_selectedUnlockedIndex];
      isLocked = false;
      activeIndex = _selectedUnlockedIndex;
    }

    if (activeData == null) {
      return const Center(
        child: Text(
          "Pilih capsule untuk melihat detail",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'VT323',
            fontSize: 18,
          ),
        ),
      );
    }

    Color glowColor = isLocked ? Colors.blueAccent : Colors.amber;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLocked
                ? IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _editCapsule(activeData!, activeIndex),
                  )
                : const SizedBox(width: 48),
            GestureDetector(
              onTap: () {
                if (isLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Sabar ya! Belum waktunya dibuka.",
                        style: TextStyle(fontFamily: 'VT323'),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenCapsuleScreen(
                        message: activeData!['message'],
                        dateInfo: activeData['timeDisplay'],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(activeData['image']!, width: 120),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () =>
                  _showDeleteDialog(context, activeData!, isLocked),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          isLocked ? "LOCKED" : "UNLOCKED",
          style: TextStyle(
            color: isLocked ? Colors.white : Colors.amber,
            fontSize: 32,
            fontFamily: 'VT323',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            color: Colors.black26,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            activeData['timeDisplay']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'VT323',
            ),
          ),
        ),
      ],
    );
  }

  void _editCapsule(Map<String, dynamic> capsuleData, int index) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCapsuleScreen(
          initialMessage: capsuleData['message'],
          initialDateDisplay: capsuleData['timeDisplay'],
          initialRawDate: capsuleData['unlockDate'],
        ),
      ),
    );
    if (updatedData != null) {
      setState(() {
        int masterIndex = allCapsules.indexWhere(
          (c) => c['id'] == capsuleData['id'],
        );
        if (masterIndex != -1) {
          allCapsules[masterIndex] = {
            "id": capsuleData['id'],
            "message": updatedData['message'],
            "image": capsuleData['image'],
            "unlockDate": updatedData['time'] ?? capsuleData['unlockDate'],
          };
          _saveCapsules();
          _organizeCapsules();
          _selectedLockedIndex = -1;
        }
      });
    }
  }

  void _showDeleteDialog(
    BuildContext context,
    Map<String, dynamic> itemToDelete,
    bool isLocked,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text(
          "Delete?",
          style: TextStyle(color: Colors.white, fontFamily: 'VT323'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.white, fontFamily: 'VT323'),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allCapsules.removeWhere((c) => c['id'] == itemToDelete['id']);
                _saveCapsules();
                _organizeCapsules();
                _selectedLockedIndex = -1;
                _selectedUnlockedIndex = -1;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red, fontFamily: 'VT323'),
            ),
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
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontFamily: 'VT323'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontFamily: 'VT323'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.red, fontFamily: 'VT323'),
            ),
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
        title: const Text(
          "Hapus Akun Permanen?",
          style: TextStyle(color: Colors.white, fontFamily: 'VT323'),
        ),
        content: const Text(
          "Seluruh kapsul waktu dan data pendaftaran Anda akan dihapus selamanya dari perangkat ini. Tindakan ini tidak bisa dibatalkan.",
          style: TextStyle(color: Colors.white70, fontFamily: 'VT323'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontFamily: 'VT323'),
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(this.context);

              var userBox = Hive.box('userBox');

              await capsuleBox.delete(widget.username);
              await userBox.delete(widget.username);

              if (!mounted) return;

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Hapus Permanen",
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'VT323',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
