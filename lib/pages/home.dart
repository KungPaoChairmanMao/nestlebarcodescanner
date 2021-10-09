import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  Map<String, String> listCharacteristics = {};
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.cyan,
          Colors.lightGreen,
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text("3. Scan your barcode",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                    )),
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text("3. Scan your barcode",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                    )),
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text("3. Scan your barcode",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                    )),
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
