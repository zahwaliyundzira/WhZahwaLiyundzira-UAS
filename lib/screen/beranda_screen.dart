import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/models/dosen_model.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<DosenModel> listDosen = [];

  @override
  void initState() {
    super.initState();
    loadDosenJson();
  }

  Future<void> loadDosenJson() async {
    final String response =
        await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final data = json.decode(response) as List;
    setState(() {
      listDosen = data.map((e) => DosenModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhZahwaLiyundzira'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari dosen dan mulai chat',
                filled: true,
                fillColor: const Color.fromARGB(255, 110, 110, 110),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: listDosen.length,
        itemBuilder: (context, index) {
          final dosen = listDosen[index];
          final lastMessage = dosen.messages.isNotEmpty
              ? dosen.messages.last.message
              : 'Belum ada pesan';

          // Hitung unread count pesan yang belum dibaca
          int unreadCount =
              dosen.messages.where((msg) => msg.isRead == false && msg.from == 0).length;

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PesanScreen(dosen: dosen),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(dosen.avatar),
            ),
            title: Text(
              dosen.fullName,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              lastMessage,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 7),
                    ),
                  ),
                const Text(
                  '6 menit lalu',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
