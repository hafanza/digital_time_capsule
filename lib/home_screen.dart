import 'create_capsule_screen.dart';
import 'edit_capsule_screen.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- DATA DUMMY ---
  // List Locked (Masa Depan) - Mulai kosong, nanti diisi via Add
  final List<Map<String, String>> lockedCapsules = [];

  // List Unlocked (Masa Lalu) - Data dummy sesuai request
  final List<Map<String, String>> unlockedHistory = [
    {"time": "1 day ago", "image": "assets/asset6.png", "status": "Unlocked"},
    {"time": "2 days ago", "image": "assets/asset6.png", "status": "Unlocked"},
    {"time": "3 days ago", "image": "assets/asset6.png", "status": "Unlocked"},
    {"time": "4 days ago", "image": "assets/asset6.png", "status": "Unlocked"},
  ];

  // --- STATE SELECTION ---
  // -1 artinya tidak ada yang dipilih
  int _selectedLockedIndex = -1;
  int _selectedUnlockedIndex = -1;

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
                // 1. Header Title
                const Text(
                  'Digital Time Capsule',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'VT323',
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Tombol Add (+) Besar
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateCapsuleScreen()),
                    );
                    if (result != null) {
                      setState(() {
                        lockedCapsules.add(result);
                        // Otomatis pilih item yang baru dibuat
                        _selectedLockedIndex = lockedCapsules.length - 1;
                        _selectedUnlockedIndex = -1; // Reset pilihan bawah
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
                      child: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. List Atas: LOCKED CAPSULES
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: lockedCapsules.isEmpty
                      ? const Center(child: Text("Empty Slot", style: TextStyle(color: Colors.grey, fontFamily: 'VT323')))
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lockedCapsules.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedLockedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLockedIndex = index;
                            _selectedUnlockedIndex = -1; // Matikan seleksi bawah
                          });
                        },
                        child: _buildSmallCapsuleItem(
                            lockedCapsules[index],
                            isSelected,
                            "Locked"
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // 4. PREVIEW AREA (TENGAH)
                SizedBox(
                  height: 280, // Tinggi area preview
                  child: _buildPreviewArea(),
                ),

                const SizedBox(height: 20),

                // 5. List Bawah: UNLOCKED HISTORY
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: unlockedHistory.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedUnlockedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedUnlockedIndex = index;
                            _selectedLockedIndex = -1; // Matikan seleksi atas
                          });
                        },
                        child: _buildSmallCapsuleItem(
                            unlockedHistory[index],
                            isSelected,
                            "Unlocked" // Label bawah item
                        ),
                      );
                    },
                  ),
                ),

                // Tombol Logout Kecil di bawah (Opsional)
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showLogoutDialog(context),
                  child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontFamily: 'VT323')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Item Kecil di List Atas/Bawah ---
  Widget _buildSmallCapsuleItem(Map<String, String> data, bool isSelected, String type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF444444) : Colors.transparent, // Highlight selection
        border: isSelected ? Border.all(color: Colors.white) : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data['image'] ?? 'assets/asset6.png', width: 40),
          const SizedBox(height: 5),
          Text(
            data['time'] ?? '?',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'VT323'),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Area Preview Tengah ---
  Widget _buildPreviewArea() {
    // 1. Tentukan data mana yang mau ditampilkan
    Map<String, String>? activeData;
    bool isLocked = false;
    int activeIndex = -1;

    if (_selectedLockedIndex != -1 && lockedCapsules.isNotEmpty) {
      activeData = lockedCapsules[_selectedLockedIndex];
      isLocked = true;
      activeIndex = _selectedLockedIndex;
    } else if (_selectedUnlockedIndex != -1 && unlockedHistory.isNotEmpty) {
      activeData = unlockedHistory[_selectedUnlockedIndex];
      isLocked = false;
      activeIndex = _selectedUnlockedIndex;
    }

    // 2. Jika belum ada yang dipilih
    if (activeData == null) {
      return const Center(
        child: Text(
          "Pilih capsule dari list\nuntuk melihat detail",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 18),
        ),
      );
    }

    // 3. Tampilkan Preview
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Baris Icon Edit & Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Edit (Hanya muncul jika Locked)
            isLocked
                ? IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editCapsule(activeIndex),
            )
                : const SizedBox(width: 48), // Spacer dummy agar layout seimbang

            // Gambar Besar Tengah
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                  ]
              ),
              child: Image.asset(activeData['image']!, width: 120),
            ),

            // Icon Delete
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteDialog(context, activeIndex, isLocked),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Text Status Utama
        Text(
          isLocked ? "Locked" : "Unlocked",
          style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'VT323',
              fontWeight: FontWeight.bold
          ),
        ),

        const SizedBox(height: 15),

        // Kotak Status Waktu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4), // Kotak tegas pixel art style
          ),
          child: Text(
            isLocked
                ? "${activeData['time']} Remaining" // Misal: "2 Days Remaining"
                : "Opened ${activeData['time']}",   // Misal: "Opened 1 day ago"
            style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'VT323'),
          ),
        ),
      ],
    );
  }

  // --- LOGIC: Edit Capsule ---
  void _editCapsule(int index) async {
    final capsule = lockedCapsules[index];
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCapsuleScreen(
          initialMessage: capsule['message'] ?? "",
          initialDate: capsule['time'] ?? "",
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        lockedCapsules[index] = {
          "status": "Locked",
          "time": updatedData['time'],
          "message": updatedData['message'],
          "image": capsule['image']!, // Pertahankan gambar lama
        };
      });
    }
  }

  // --- LOGIC: Delete Dialog ---
  void _showDeleteDialog(BuildContext context, int index, bool isLockedList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( // Menggunakan AlertDialog bawaan biar simple, bisa diganti custom
          backgroundColor: const Color(0xFF333333),
          shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(8)),
          title: const Text("Delete?", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
          content: const Text("Hapus capsule ini selamanya?", style: TextStyle(color: Colors.grey, fontFamily: 'VT323')),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
              onPressed: () {
                setState(() {
                  if (isLockedList) {
                    lockedCapsules.removeAt(index);
                    _selectedLockedIndex = -1; // Reset selection
                  } else {
                    unlockedHistory.removeAt(index); // Opsional: jika history bisa dihapus
                    _selectedUnlockedIndex = -1;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // --- LOGIC: Logout ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(8)),
        content: const Text("Yakin ingin logout?", style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey, fontFamily: 'VT323')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }
}