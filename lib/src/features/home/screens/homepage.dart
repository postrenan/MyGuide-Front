import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/home/screens/carousel.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _locationEnabled = false;

  void _toggleLocation() {
    setState(() {
      _locationEnabled = !_locationEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: thirdColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Favorites',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 250.0),
            TextButton(
              onPressed: () {},
              child: Text(
                'Rated',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 250.0),
            TextButton(
              onPressed: () {},
              child: Text(                              //listar melhor avaliados
                'Shops',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: thirdColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 8.0),
                    child: Image.asset(
                      'assets/images/home/my.png',
                      height: 150,
                      width: 160,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: IconButton(
                      icon: Icon(Icons.person, color: primaryColor, size: 40),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Text(
                'Where are you going?',
                style: GoogleFonts.italianno(
                  fontSize: 72,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: _toggleLocation,
                icon: Icon(
                  _locationEnabled ? Icons.location_off : Icons.location_on,
                  color: Colors.white,
                ),
                label: Text(
                  _locationEnabled ? 'Disable location' : 'Use your location',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              if (_locationEnabled) ...[
                MyCarousel(),
                const SizedBox(height: 15.0),
                MyCarousel(),
                const SizedBox(height: 15.0),
                MyCarousel(),
                const SizedBox(height: 15.0),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Location blocked',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
