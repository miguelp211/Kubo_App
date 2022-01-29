import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kubo_sas_app/main.dart';
import 'package:page_transition/page_transition.dart';

class ProductOrder extends StatefulWidget {
  final String Url;
  final String Name;
  final String Desciption;
  final String Presentation;
  final String Price;
  final String Discount;
  final String Max;
  final int Likes;
  const ProductOrder(this.Url, this.Name, this.Desciption, this.Presentation,
      this.Price, this.Discount, this.Max, this.Likes);

  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  int cantidad = 1;
  int DiscountAplied = 1;

  Icon actionIcon = Icon(
    Icons.favorite_border,
    color: Colors.red,
  );
  Icon actionIconTwo = Icon(
    Icons.arrow_drop_down_circle_outlined,
    color: Colors.grey,
  );

  int? NewLike;
  String StrLike = "";
  bool Visible=false;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushReplacement(
      context,
      PageTransition(
        curve: Curves.easeInSine,
        type: PageTransitionType.fade,
        alignment: Alignment.centerLeft,
        child: MyHomePage(),
        duration: Duration(milliseconds: 850),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTitle(
      this.widget.Url,
      this.widget.Name,
      this.widget.Desciption,
      this.widget.Presentation,
      this.widget.Price,
      this.widget.Discount,
      this.widget.Max,
      this.widget.Likes,
    );
  }

  Widget _buildTitle(
      String URLPhoto,
      String Name,
      String Desciption,
      String Presentation,
      String Price,
      String Discount,
      String Max,
      int Likes) {
    DiscountAplied = int.parse(Price) - int.parse(Discount);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).padding.top,
              bottom: 0),
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.green,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: Image.network(
                              URLPhoto,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.black),
                                    backgroundColor: Colors.green,
                                    strokeWidth: 4,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 10,
                      color: Colors.grey,
                      thickness: 0.4,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(15),
                      elevation: 2,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.0),
                            padding: EdgeInsets.only(right: 20.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 1,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      Name,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          color: Colors.red,
                                          icon: actionIcon,
                                          onPressed: () {
                                            if (this.actionIcon.icon ==
                                                Icons.favorite_border) {
                                              this.actionIcon = Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              );
                                              setState(() {
                                                if (NewLike == null) {
                                                  StrLike =
                                                      (Likes + 1).toString();
                                                }
                                              });
                                            } else {
                                              this.actionIcon = Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
                                              );
                                              setState(() {
                                                if (NewLike == null) {
                                                  StrLike = (Likes).toString();
                                                }
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          StrLike,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  Desciption,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 2.0, bottom: 5, right: 15),
                                      child: Text(
                                        "\$ " + Price + " COP",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor:
                                              const Color(0xff000000),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(3.0),
                                      child: Text(
                                        "\$ " +
                                            DiscountAplied.toString() +
                                            " COP",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 24),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: Colors.grey,
                            thickness: 0.4,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            elevation: 2,
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Cantidad",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: IconButton(
                                          color: Colors.grey,
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              cantidad--;
                                              if (cantidad < 1) {
                                                cantidad = 1;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            cantidad.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          color: Colors.grey,
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              cantidad++;
                                              if (cantidad == int.parse(Max)) {
                                                cantidad = int.parse(Max);
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 20, top: 20, left: 50, right: 50),
                            child: TextButton(
                              child: Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.shopping_basket_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Añadir al carrito",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  primary: Colors.green,
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: Colors.green))),
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Detalles",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  actionIconTwo
                                ],
                              ),
                              onPressed: () {
                                if (this.actionIconTwo.icon ==
                                    Icons.arrow_drop_down_circle_outlined) {
                                  this.actionIconTwo = Icon(
                                    Icons.arrow_drop_up_outlined,
                                    color: Colors.green,
                                  );
                                  setState(() {
                                  Visible=true;
                                  });
                                } else {
                                  this.actionIconTwo = Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.green,
                                  );
                                  setState(() {
                                  Visible=false;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Colors.grey))),
                            ),
                          ),
                          Visibility(
                            visible: Visible,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(15),
                              elevation: 2,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(20.0),
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 1,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              Name,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  color: Colors.red,
                                                  icon: actionIcon,
                                                  onPressed: () {
                                                    if (this.actionIcon.icon ==
                                                        Icons.favorite_border) {
                                                      this.actionIcon = Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      );
                                                      setState(() {
                                                        if (NewLike == null) {
                                                          StrLike =
                                                              (Likes + 1).toString();
                                                        }
                                                      });
                                                    } else {
                                                      this.actionIcon = Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.red,
                                                      );
                                                      setState(() {
                                                        if (NewLike == null) {
                                                          StrLike = (Likes).toString();
                                                        }
                                                      });
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  StrLike,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          Desciption,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 2.0, bottom: 5, right: 15),
                                              child: Text(
                                                "\$ " + Price + " COP",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  decorationColor:
                                                  const Color(0xff000000),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(3.0),
                                              child: Text(
                                                "\$ " +
                                                    DiscountAplied.toString() +
                                                    " COP",
                                                style: TextStyle(
                                                    color: Colors.green, fontSize: 24),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 10,
                                    color: Colors.grey,
                                    thickness: 0.4,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }
}
