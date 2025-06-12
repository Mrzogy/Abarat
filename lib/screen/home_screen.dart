import 'package:abarat_app/component/search_trip_component/search_trips.dart';
import 'package:abarat_app/provider/auth_provider.dart';
import 'package:abarat_app/screen/booking_screen.dart';
import 'package:abarat_app/screen/trips_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<AuthProvider>(context);

    // الصفحات اللي راح تتغير حسب الضغط
    final List<Widget> pages = [
      const HomeScreenDesign(), // نفس تصميمك السابق
      SearchTrips(),
      TripsResultsScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          gap: 8,
          selectedIndex: navProvider.currentIndex,
          onTabChange: (value) {
            navProvider.changeIndex(value);
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.person, text: "Booking"),
            GButton(icon: Icons.settings, text: "Trips"),
          ],
        ),
      ),
      appBar: AppBar(elevation: 0),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    "N A Q L",
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text("Page 1", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchTrips()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: pages[navProvider.currentIndex], // 👈 التبديل هنا
    );
  }
}


class HomeScreenDesign extends StatelessWidget {
  const HomeScreenDesign({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ), // 👈 التباعد من اليمين واليسار
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome To Nagle",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5), // مسافة بين العناصر
            Text(
              "Come With Us To Discuver The Buty OF Farasan Island",
              style: TextStyle(fontWeight: FontWeight.w100),
            ),
            SizedBox(height: 50),
            Searchome(),
            SizedBox(height: 50),
            Text("Vesit Farasan"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    width: 140,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Box $index',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Searchome extends StatelessWidget {
  const Searchome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.amber,
          width: 170,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              children: [
                Text("From"),
                Text("FAS", style: TextStyle(fontSize: 20)),
                Text("Arrive City"),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.red,
          width: 170,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              children: [
                Text("To"),
                Text("JEZ", style: TextStyle(fontSize: 20)),
                Text("Depature City"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

