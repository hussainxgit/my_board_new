import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_board_new/views/AllLectuesView.dart';
import 'package:my_board_new/views/lectureView.dart';
import 'package:my_board_new/views/AllResidentsView.dart';
import 'package:my_board_new/services/utilities.dart';
import 'package:my_board_new/views/settings.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyDynamicThemeWidget(
    child: MainApp(),
  ),);
}

class MainApp extends StatelessWidget {
  Color parseColor(String color) {
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
      '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  var lightThemeData = new ThemeData(
      primaryColor: Colors.blue,
      textTheme: new TextTheme(button: TextStyle(color: Colors.white70)),
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      accentColor: Colors.blue);

  var darkThemeData = ThemeData(
      primaryColor: Colors.blue,
      textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
      brightness: Brightness.dark,
      accentColor: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Board',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Utilities _utilities = Utilities();
  PageController _pageController;
  int _page = 0;
  List<Widget> appbarTitles = [
    Text("Today's lecture"),
    Text('All residents'),
    Text('All lectures'),
    Text('Settings'),
  ];

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // _utilities.createExcel();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appbarTitles[_page],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'My Board',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text("Today's lecture"),
              autofocus: _page == 0 ? true : false,
              onTap: () {
                _pageController.jumpToPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text('All residents'),
              autofocus: _page == 1 ? true : false,
              onTap: () {
                _pageController.jumpToPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text('All lectures'),
              autofocus: _page == 2 ? true : false,
              onTap: () {
                _pageController.jumpToPage(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              autofocus: _page == 3 ? true : false,
              onTap: () {
                _pageController.jumpToPage(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.help), title: Text('Help and Feedback'))
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          LectureView(),
          ResidentsView(),
          AllLecturesView(),
          Settings()
        ],
      ),
    );
  }
}
