import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/pages/scan_history.dart';
import 'pages/nestleinfo.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'
    as http; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as dom; // Contains DOM related classes for extracting data from elements
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../product_text.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 0;
  Map<String, String> listCharacteristics = {};
  PageController _pageController = PageController();
  void initState() {
    super.initState();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text('Nestle Barcode Scanner', style: GoogleFonts.montserrat()),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQR,
        tooltip: "Scan a barcode.",
        child: Icon(Icons.document_scanner),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Homepage(),
            NestleInfo(),
            ScanHistory(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
              activeColor: Colors.blue),
          BottomNavyBarItem(
              title: Text('Info'),
              icon: Icon(Icons.info),
              activeColor: Colors.lightGreenAccent),
          BottomNavyBarItem(
              title: Text('History'),
              icon: Icon(Icons.history),
              activeColor: Colors.redAccent),
        ],
      ),
    );
  }

  void resultWidget(Text result, String title) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: result,
                  padding: EdgeInsets.all(12.0),
                ),
                Container(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                          fontSize: 20, textStyle: TextStyle()),
                    ),
                    padding: EdgeInsets.all(12.0))
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: ListView.builder(
                itemCount: listCharacteristics.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = listCharacteristics.keys.elementAt(index);
                  return new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("$key"),
                        subtitle: new Text("${listCharacteristics[key]}"),
                      ),
                      new Divider(
                        height: 2.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    initiate(int.parse(barcodeScanRes));
  }

  Future initiate(int barcodeNumber) async {
    Text result = Text("This is not a Nestle product",
        style: GoogleFonts.montserrat(
            color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold));
    // Make API call to Hackernews homepage
    http.Response response = await http.Client()
        .get(Uri.parse('https://www.upcitemdb.com/upc/$barcodeNumber'));

    // Use html parser
    dom.Document document = parse(response.body);
    Map<String, String> innerMapCharacteristics = {};
    List tds = document
        .getElementsByClassName("detail-list")[0]
        .getElementsByTagName("td");
    String detailTitle = document
        .getElementsByClassName("detailtitle")[0]
        .getElementsByTagName("b")[0]
        .text;
    try {
      for (var i = 0; i < tds.length; i++) {
        if (i % 2 == 0) {
          innerMapCharacteristics[tds[i].text.trim().replaceAll(':', '')] =
              tds[i + 1]
                  .text
                  .trim(); // Set key to value with a bunch of string editing
        }
      }
      for (var i = 0; i < productList.length; i++) {
        if (productList[i].contains(innerMapCharacteristics["Brand"])) {
          result = Text("This is a Nestle product.",
              style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold));
        }
      }
    } on RangeError {
      result = Text("This product doesn't exist.",
          style: GoogleFonts.montserrat(
              fontSize: 30, fontWeight: FontWeight.bold));
    } on Error {
      result = Text("This product doesn't have a brand name.",
          style: GoogleFonts.montserrat(
              fontSize: 30, fontWeight: FontWeight.bold));
    } finally {
      for (var i = 0; i < productList.length; i++) {
        if (detailTitle.contains(productList[i])) {
          result = Text("This is a Nestle product.",
              style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold));
        }
      }
    }
    setState(() {
      listCharacteristics = innerMapCharacteristics;
    });
    resultWidget(result, detailTitle);
  }
}
