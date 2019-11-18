import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';
import 'package:timezone/standalone.dart';

List locationList = [];
final myController = TextEditingController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var byteData = await rootBundle
      .load('packages/timezone/data/$tzDataDefaultFilename'); //load database
  initializeDatabase(byteData.buffer.asUint8List());
  runApp(TimeZoneApp());
}

class TimeZoneApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "time zone app",
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.cyan[600],

          // Define the default font family.
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String location;

  MyHomePage({this.location = 'Asia/Kolkata'});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    timeZoneDatabase.locations.keys.forEach((e) => locationList.add(e));
    super.initState();
  }

  String getTimeZone(String location) {
    String sign =
    TZDateTime.now(getLocation(location)).timeZoneOffset.isNegative
        ? '-'
        : '+';
    int hours =
    TZDateTime.now(getLocation(location)).timeZoneOffset.inHours.abs();
    int minutes =
        TZDateTime.now(getLocation(location)).timeZoneOffset.inMinutes;
    return '$sign' + ' ' + '$hours' + ':' + '${minutes % 60}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          primary: false,
          title: Text(' Abhishek Time Zone App'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[

              Ink(
                color: Colors.white12,
                child: ListTile(
                  title: Text(
                    'Region',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                      '${widget.location}  ${getTimeZone(widget.location)}',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    dynamic newLocation = await showSearch(
                      context: context,
                      delegate: LocationsSearch(locationList),
                    );
                    if (newLocation != null) {
                      widget.location = newLocation;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationsSearch extends SearchDelegate<String> {
  final List<dynamic> cities;

  LocationsSearch(this.cities);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List results = locationList
        .where((cityName) => cityName.toLowerCase().contains(query))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            query = results[index];
          },
          dense: true,
          title: Center(
            child: Text(
              results[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
    // return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List results = locationList
        .where((cityName) => cityName.toLowerCase().contains(query))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            close(context, results[index]);
          },
          dense: true,
          title: Text(results[index]),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme

    return ThemeData.dark();
  }



}

class SelectLocation extends StatefulWidget {
  final List locationList;

  SelectLocation(this.locationList);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,

        ),
        body: ListView.builder(
          itemCount: widget.locationList
              .where((e) => e.contains(myController.text))
              .toList()
              .length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              dense: true,
              title: Center(
                child: Text(widget.locationList
                    .where((e) => e.contains(myController.text))
                    .toList()[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
