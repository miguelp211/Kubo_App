import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kubo_sas_app/Product.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class Model {
  String Link;
  String name;

  Model({this.Link = "", this.name = ""});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget appBarTitle = Text(
    "Kudo SAS App",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.orange,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<Model> _list = [];
  List<Model> _searchList = [];

  bool _IsSearching = false;
  String _searchText = "";

  Widget TittleApp = const Text('Kudo App');
  Icon AppIcon = const Icon(Icons.search);

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    init();
  }

  void init() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  List<Model> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _list;
    } else {
      _searchList = _list
          .where((element) =>
              element.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();

      return _searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    String url =
        "https://api.bazzaio.com/v5/listados/listar_productos_tienda/590/0/";
    Future<dynamic> _getListado() async {
      final respuesta = await http.get(Uri.parse(url));
      final userdata =
          new Map<String, dynamic>.from(jsonDecode(respuesta.body));
      if (respuesta.statusCode == 200) {
        return userdata;
      } else {
        print("Error con la respuesta");
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset:false,
        key: key,
        appBar: AppBar(
            centerTitle: true,
            title: appBarTitle,
            iconTheme: IconThemeData(color: Colors.orange),
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = Icon(
                        Icons.close,
                        color: Colors.orange,
                      );
                      this.appBarTitle = TextField(
                        controller: _searchQuery,
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                        decoration: InputDecoration(
                            hintText: "Search here..",
                            hintStyle: TextStyle(color: Colors.white)),
                      );
                      _handleSearchStart();
                    } else {
                      _handleSearchEnd();
                    }
                  });
                },
              ),
            ]),
        body: Column(
          children: [
            FutureBuilder<dynamic>(
              future: _getListado(),
              builder: (context, snapshot) {
                _list = [];
                if (snapshot.hasData) {
                  try {
                    snapshot.data["data"].forEach((e) {
                      _list.add(Model(Link: e["imagen"], name: e["nombre"]));
                    });
                    _searchList = _list;
                    print(snapshot.data["data"]);
                    print("***********");
                  } catch (e) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Cargando por favor espere un momento."),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.black),
                            backgroundColor: Colors.green,
                            strokeWidth: 4,
                          )),
                        ],
                      ),
                    );
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height-kBottomNavigationBarHeight*2,
                      width: MediaQuery.of(context).size.width,
                      child: ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: Colors.green,
                            child: GridView.builder(
                                itemCount: _searchList.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 1.2),
                                itemBuilder: (context, index) {
                                  print(
                                    snapshot.data["data"]);
                                  return decideGridTileview(
                                      index + 1,
                                      _searchList[index].name.toString(),
                                      _searchList[index].Link.toString(),
                                      snapshot.data["data"][index]["descripcion"].toString(),
                                      snapshot.data["data"][index]["Presentación"].toString(),
                                      snapshot.data["data"][index]["precio"].toString(),
                                      snapshot.data["data"][index]["valor_promo"].toString(),
                                      snapshot.data["data"][index]["disponible"].toString(),
                                      snapshot.data["data"][index]["likes"].toString(),



                                  );
                                }),
                          )),
                    );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Cargando por favor espere un momento."),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                            child: CircularProgressIndicator(
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
                              backgroundColor: Colors.green,
                              strokeWidth: 4,
                            )),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.orange,
      );
      this.appBarTitle = Text(
        "Search Demo",
        style: TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  Widget decideGridTileview(int index, String name, String keyImage,String Desciption,String Presentation,String Price,String Discount,String Max,String Likes) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0, 0.0), // 10% of the width, so there are ten blinds.
          colors: <Color>[Colors.green.shade50, Colors.grey], // red to yellow
          tileMode: TileMode.mirror, // repeats the gradient over the canvas
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
          onTap: () {

            Navigator.pushReplacement(
              context,
              PageTransition(
                curve: Curves.easeInSine,
                type: PageTransitionType.fade,
                alignment: Alignment.centerLeft,
                child: ProductOrder(keyImage,name,Desciption,Presentation,Price,Discount,Max,int.parse(Likes)),
                duration: Duration(milliseconds: 850),
              ),
            );

          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 10,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: Image.network(
                          keyImage,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black),
                                backgroundColor: Colors.green,
                                strokeWidth: 4,
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    padding: const EdgeInsets.all(3.0), // borde width
                    decoration: new BoxDecoration(
                        color: Color(0x656F00C1), // border color
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ])
          //),
          ),
    );
  }
}
