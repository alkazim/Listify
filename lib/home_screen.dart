import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lisifyy/detailed_screen.dart';
import 'package:lisifyy/login_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference items = FirebaseFirestore.instance.collection("items");

  List<DocumentSnapshot> _itemList = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _limit = 5;
  DocumentSnapshot? _lastDoc;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    Query query = items.orderBy('title').limit(_limit);
    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    QuerySnapshot querySnapshot = await query.get();
    List<DocumentSnapshot> newItems = querySnapshot.docs;

    setState(() {
      if (newItems.length < _limit) {
        _hasMore = false;
      }
      _lastDoc = newItems.isNotEmpty ? newItems.last : null;
      _itemList.addAll(newItems);
      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _itemList.clear();
      _lastDoc = null;
      _hasMore = true;
    });
    await _fetchItems();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Home Screen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _itemList.length,
                  itemBuilder: (context, index) {
                    var item = _itemList[index];
                    var title = item['title'] ?? 'No Title';
                    var description = item['description'] ?? 'No Description';
                    var brand = item['brand'] ?? 'Unknown Brand';
                    var price = item['price'] ?? 'N/A';
                    var imageUrl = item['imageUrl'] ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAAja6c9Ip37JMYpOmIIe9JGv16LvccS2OoCpr2Evz5Gv2-ImNwePvBoxNWctyWlJwYmA&usqp=CAU";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneDetailScreen(documentId: item.id),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "$brand - $description",
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Rs $price",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_hasMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _fetchItems,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Load More", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
