import 'package:flutter/material.dart';

class NewSerchScreen extends StatelessWidget {
  const NewSerchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> myData = [
      {'dayNumber': 22, 'dayName': "SUN"},
      {'dayNumber': 23, 'dayName': "MON"},
      {'dayNumber': 24, 'dayName': "TUE"},
      {'dayNumber': 25, 'dayName': "WED"},
      {'dayNumber': 26, 'dayName': "THU"},
      {'dayNumber': 27, 'dayName': "FRI"},
      {'dayNumber': 28, 'dayName': "SAT"},
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(Icons.ac_unit_outlined, size: 30)),
          ),
        ),
        title: Center(
          child: Column(
            children: [
              Text(
                "Hello Mrzogy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                "data",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 30)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 400,
              height: 190,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Trips",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text("Do Your Trips Before Saturday Night."),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myData.length,
                itemBuilder: (context, index) {
                  final item = myData[index];
                  return Container(
                    width: 60,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
