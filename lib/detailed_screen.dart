import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PhoneDetailScreen extends StatefulWidget {
  final String documentId;

  PhoneDetailScreen({required this.documentId});

  @override
  _PhoneDetailScreenState createState() => _PhoneDetailScreenState();
}

class _PhoneDetailScreenState extends State<PhoneDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('items').doc(widget.documentId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!;
          String title = data['title'] ?? 'No Title';
          String brand = data['brand'] ?? 'Unknown Brand';
          String ram = data['ram'] ?? 'N/A';
          String storage = data['storage'] ?? 'N/A';
          String processor = data['processor'] ?? 'N/A';
          List<dynamic> imageUrls = data['imageUrls'] ?? [];
          List<dynamic> colors = data['colors'] ?? [];
          String description = data['description'] ?? 'No description available.';

          return Scaffold(
            appBar: AppBar(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  if (imageUrls.isNotEmpty)
                    CarouselSlider.builder(
                      itemCount: imageUrls.length,
                      options: CarouselOptions(
                        height: 450,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        enableInfiniteScroll: true,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(imageUrls[index], fit: BoxFit.cover, width: double.infinity),
                        );
                      },
                    ),

                  SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),

                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildSpecRow("Brand", brand),
                              _buildSpecRow("RAM", ram),
                              _buildSpecRow("Storage", storage),
                              _buildSpecRow("Processor", processor),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // 🔥 Available Colors
                        Text("Available Colors ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: ListView.builder(
                              itemCount: colors.length,
                              itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(colors[index]),
                              );
                            },),
                          ),
                        ),
                         SizedBox(height: 10,),
                        // 🔥 Description Section
                        Text("Features: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        SizedBox(height: 30,)
                      ],
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

  /// 🔥 Widget for Spec Row
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue.shade700)),
        ],
      ),
    );
  }
}
