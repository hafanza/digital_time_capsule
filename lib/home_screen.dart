import 'create_capsule_screen.dart';
import 'edit_capsule_screen.dart';
import 'login_screen.dart'; // Import login untuk logout
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> myCapsules = [];

  final List<Map<String, String>> unlockedHistory = [
    {"time": "1 day ago", "image": "assets/asset6.png"},
    {"time": "3 days ago", "image": "assets/asset6.png"},
    {"time": "1 week ago", "image": "assets/asset6.png"},
    {"time": "2 weeks ago", "image": "assets/asset6.png"},
  ];

  @override
  Widget build(BuildContext context) {
    String cleanName = widget.username.replaceAll('@', '');

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- TOMBOL LOGOUT ---
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 30),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),
              const Text(
                'Digital Time Capsule',
                style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'VT323'),
              ),
              const SizedBox(height: 5),
              Text(
                "Halo $cleanName, Ayo Buat Surat untuk Masa Depan",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'VT323'),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateCapsuleScreen()),
                  );
                  if (result != null) {
                    setState(() { myCapsules.add(result); });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add_circle_outline, color: Colors.white, size: 30),
                ),
              ),

              const SizedBox(height: 40),

              if (myCapsules.length > 2)
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Geser untuk melihat koleksi",
                    style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 14),
                  ),
                )
              else
                const SizedBox(height: 15),

              SizedBox(
                height: 250,
                child: myCapsules.isEmpty
                    ? Center(
                  child: Text(
                    "Belum ada capsule locked.\nKlik (+) untuk membuat!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 18),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: myCapsules.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return _buildMainCapsuleCard(index);
                  },
                ),
              ),

              const SizedBox(height: 50),
              _buildUnlockedHistoryList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- FUNGSI LOGOUT DIALOG ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10)),
        title: const Text("Logout", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        content: const Text("Apakah kamu yakin ingin keluar?", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
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

  Widget _buildMainCapsuleCard(int index) {
    var capsule = myCapsules[index];
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
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
                      myCapsules[index] = {
                        "status": "Locked",
                        "time": updatedData['time'],
                        "message": updatedData['message'],
                        "image": "assets/asset5.png",
                      };
                    });
                  }
                },
                child: Image.asset('assets/asset3.png', width: 35),
              ),
              Image.asset(capsule['image']!, width: 90),
              GestureDetector(
                onTap: () => _showDeleteDialog(context, index),
                child: Image.asset('assets/asset4.png', width: 35),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text("Locked", style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'VT323')),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.white54)),
            child: Text(capsule['time']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 8),
          child: Text("Unlocked Capsules", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
        ),
        Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: unlockedHistory.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Image.asset(unlockedHistory[index]['image']!, width: 45),
                    const SizedBox(height: 5),
                    Text(unlockedHistory[index]['time']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'VT323')),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Hapus Capsule Ini ??", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'VT323', decoration: TextDecoration.underline)),
                const SizedBox(height: 20),
                Image.asset('assets/asset5.png', width: 80),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF555555)),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setState(() { myCapsules.removeAt(index); });
                        Navigator.pop(context);
                      },
                      child: const Text("Hapus", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
