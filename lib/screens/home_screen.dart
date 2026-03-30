import 'package:flutter/material.dart';
import '../widgets/common/Headerhomescreen.dart';
import 'QR_code_screen.dart';
import 'scan_qr_code_screen.dart';
import 'relation_screen.dart';
import '../models/pairing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Relation> relations = [];

  @override
  void initState() {
    super.initState();
    _loadRelations();
  }

  Future<void> _loadRelations() async {
    final loaded = await Relation.listFromStorage();
    setState(() {
      relations = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Headerhomescreen(),
          Expanded(
            child: relations.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Aucune connexion établie\nCliquez pour ajouter une relation",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadRelations,
                    child: ListView.builder(
                      itemCount: relations.length,
                      itemBuilder: (context, index) {
                        final rel = relations[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text(rel.displayName)),
                          title: Text(rel.displayName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RelationScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text("Initier pairing (mon QR)"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRCodeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scanner QR (pairing)"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanQRCodeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
