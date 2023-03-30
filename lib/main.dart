import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var allWords = <WordPair>[];
  var selectedIndexInAnotherWidget = 0;
  var optionASelected = false;
  var optionBSelected = false;
  var loadingFromNetwork = false;
  void words() {
    allWords.add(current);
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void removed() {
    print('removed');
    notifyListeners();
  }

  void toggleFavorites() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratedPage();
        print("first page");
        break;
      case 1:
        page = MyFav();
        print("second page");
        break;
      default:
        throw UnimplementedError("no widget");
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class MyFav extends StatelessWidget {
  const MyFav({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pai = 0;
    return ListView(
      children: [
        Text('You have `${appState.favorites.length}` favorites:'),
        for (var pai in appState.favorites)
          GestureDetector(
            onTap: () {
              appState.favorites.remove(pai);
              appState.removed();
            },
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text(pai.asLowerCase),
              tileColor: Colors.blue,
            ),
          ),
      ],
    );
  }
}

class GeneratedPage extends StatelessWidget {
  const GeneratedPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          backgroundColor: Colors.amber,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(height: 50),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: AllWord(),
              ),
              Card(
                color: Colors.redAccent,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 26),
                  child: Text(appState.current.asLowerCase,
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        appState.toggleFavorites();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon),
                          const Text(
                            "Like",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          appState.getNext();
                          appState.words();
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class AllWord extends StatelessWidget {
  const AllWord({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Container(
      height: 300,
      width: 260,
      // height: double.maxFinite,
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var word in appState.allWords)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Center(
                        child: Row(
                      children: [
                        appState.favorites.contains(word)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_border),
                        SizedBox(width: 5),
                        Text(word.asLowerCase,
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ))),
              )
          ],
        ),
      ),
    );
  }
}
