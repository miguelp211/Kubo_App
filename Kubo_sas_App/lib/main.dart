import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kubo_sas_app/Product.dart';
import 'package:kubo_sas_app/Services/sharedPreferences.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF1F1F1F), // navigation bar color
      statusBarColor: Colors.black, // status bar
      //statusBarBrightness: Brightness.light,// color
      //statusBarBrightness: Brightness.dark,//status bar brigtness
      //statusBarIconBrightness:Brightness.dark , //status barIcon Brightness
      systemNavigationBarDividerColor:
          Color(0xFF1F1F1F), //Navigation bar divider color
      //systemNavigationBarIconBrightness: Brightness.dark,
      //navigation bar icon
    ),

    //SystemUiOverlayStyle.light
    //SystemUiOverlayStyle.light
  );

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

  Icon favIcon = Icon(
    Icons.favorite_border,
    color: Colors.red,
  );
  Widget appBarTitle = Text(
    "Kudo SAS App",
    style: TextStyle(color: Colors.black),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.green,
  );
  Icon historyIcon = Icon(
    Icons.history,
    color: Colors.green,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<Model> _list = [];
  List<Model> _searchList = [];
  List<String> _searchHistory = [];
  bool VisibleHistory = false;

  bool _IsSearching = false;
  double DiscountAplied = 1;
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
      } else {}
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: key,
        appBar: AppBar(
            centerTitle: true,
            title: appBarTitle,
            iconTheme: IconThemeData(color: Colors.green),
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                  icon: historyIcon,
                  onPressed: () {
                    if (_searchHistory.length >= 1) {
                      if (this.historyIcon.icon == Icons.history) {
                        this.historyIcon = Icon(
                          Icons.close,
                          color: Colors.red,
                        );
                        setState(() {
                          setState(() {
                            VisibleHistory = true;
                          });
                        });
                      } else {
                        this.historyIcon = Icon(
                          Icons.history,
                          color: Colors.green,
                        );
                        setState(() {
                          VisibleHistory = false;
                        });
                      }
                    } else {
                      this.historyIcon = Icon(
                        Icons.history,
                        color: Colors.green,
                      );
                      setState(() {
                        VisibleHistory = false;
                      });
                    }
                  }),
              IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = Icon(
                        Icons.close,
                        color: Colors.green,
                      );
                      this.appBarTitle = TextField(
                        controller: _searchQuery,
                        onEditingComplete: () {
                          if (_searchHistory.contains(_searchQuery.text)) {
                            _searchHistory.remove(_searchQuery.text);
                          } else {
                            _searchHistory.add(_searchQuery.text);
                            Map<String, dynamic> map = {
                              'name': _searchQuery.text,
                            };
                            StorageUtil.putList("Historial", _searchHistory);
                          }
                          print("______________");
                          print(StorageUtil.getList("Historial"));
                          print("______________");
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: "Busque aqu??",
                            hintStyle: TextStyle(color: Colors.black)),
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
            Visibility(
                visible: VisibleHistory,
                child: Text("Deslice para eliminar del historial ")),
            Visibility(
              visible: VisibleHistory,
              child: Expanded(
                flex: 1,
                child: Container(
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.green,
                      child: ListView.builder(
                          itemCount: _searchHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> SaveHis=[];
                            if(StorageUtil.getList("Historial").length>=1){
                              SaveHis=StorageUtil.getList("Historial");
                            }else{
                              SaveHis=_searchHistory;
                            }
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                if (SaveHis.length < 1) {
                                  setState(() {
                                    VisibleHistory = false;
                                  });
                                }
                                setState(() {
                                  SaveHis.removeAt(index);
                                });
                              },
                              child: ListTile(
                                title: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(SaveHis[index],
                                      style: TextStyle(
                                        color: Colors.green[10],
                                        fontSize: 17,
                                      )),
                                ),
                                subtitle: Divider(
                                  height: 10,
                                  color: Colors.grey,
                                  thickness: 0.4,
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder<dynamic>(
                future: _getListado(),
                builder: (context, snapshot) {
                  _list = [];
                  if (snapshot.hasData) {
                    try {
                      snapshot.data["data"].forEach((e) {
                        _list.add(Model(Link: e["imagen"], name: e["nombre"]));
                      });
                      _searchList = _list;
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                              backgroundColor: Colors.green,
                              strokeWidth: 4,
                            )),
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height -
                          kBottomNavigationBarHeight * 2,
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
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.5),
                                itemBuilder: (context, index) {
                                  return decideGridTileview(
                                    index + 1,
                                    _searchList[index].name.toString(),
                                    _searchList[index].Link.toString(),
                                    snapshot.data["data"][index]["descripcion"]
                                        .toString(),
                                    snapshot.data["data"][index]["Presentaci??n"]
                                        .toString(),
                                    snapshot.data["data"][index]["precio"]
                                        .toString(),
                                    snapshot.data["data"][index]["valor_promo"]
                                        .toString(),
                                    snapshot.data["data"][index]["disponible"]
                                        .toString(),
                                    snapshot.data["data"][index]["likes"]
                                        .toString(),
                                    snapshot.data["data"][index]
                                            ["fecha_creacion"]
                                        .toString(),
                                    snapshot.data["data"][index]["fecha_promo"]
                                        .toString(),
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
        color: Colors.green,
      );
      this.appBarTitle = Text(
        "Kudo SAS App",
        style: TextStyle(color: Colors.black),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  Widget decideGridTileview(
      int index,
      String name,
      String keyImage,
      String Desciption,
      String Presentation,
      String Price,
      String Discount,
      String Max,
      String Likes,
      String Fecha_creation,
      String Fecha_promo) {
    DiscountAplied = int.parse(Price)-(int.parse(Price) *int.parse(Discount)*0.01);
    return Card( shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 4,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(

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
                        child: ProductOrder(
                            keyImage,
                            name,
                            Desciption,
                            Presentation,
                            Price,
                            Discount,
                            Max,
                            int.parse(Likes),
                            Fecha_creation,
                            Fecha_promo),
                        duration: Duration(milliseconds: 850),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 30,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(300.0),
                                  child: Image.network(
                                    keyImage,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin:const EdgeInsets.all(10.0) ,
                                padding: const EdgeInsets.all(3.0), // borde width
                                decoration: new BoxDecoration(
                                    color: Colors.green, // border color
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  ((1-(DiscountAplied/int.parse(Price)))*100).abs().round().toString().substring(0,2)+"%",
                                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                                )),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(

                                    padding: const EdgeInsets.all(3.0), // borde width
                                    decoration: new BoxDecoration(
                                        color: Colors.white, // border color
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      name,
                                      style: TextStyle(fontSize: 20, color: Colors.grey,fontWeight: FontWeight.bold),
                                    ))),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(top: 2.0, bottom: 5, right: 15,left: 10),
                              child: Text(
                                "\$ " + Price + " COP",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: const Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: Text(
                                "\$ " + DiscountAplied.toString() + " COP",
                                style: TextStyle(color: Colors.black, fontSize: 24),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),

                        ]),
                  )
                  //),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
