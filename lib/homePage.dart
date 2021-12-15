import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'AddVignette.dart';
import 'Controllers/AuthentificationController.dart';
import 'Controllers/VignetteController.dart';
import 'Models/Vignette.dart';
import 'Statics/FadeAnimation.dart';
import 'Statics/Statics.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  final VignetteController vignetteController = VignetteController();
  final AuthentificationController _authentificationController =
      AuthentificationController();

  bool _isScrolled = false;

  List<Vignette> allVignettes = [];
  List<Vignette> vignettes = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);

    vignetteController.getVignettes().then((list) {
      setState(() {
        allVignettes = list;
        vignettes = list;
      });
    });

    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(controller: _scrollController, slivers: [
        SliverAppBar(
          toolbarHeight: 0,
          expandedHeight: 300.0,
          elevation: 2,
          pinned: true,
          floating: false,
          stretch: true,
          backgroundColor: Colors.grey.shade50,
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.only(left: 20, right: 30, bottom: 100),
              stretchModes: [
                StretchMode.zoomBackground,
                // StretchMode.fadeTitle
              ],
              title: AnimatedOpacity(
                opacity: _isScrolled ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: FadeAnimation(
                    1,
                    Text("Scannez votre Vignette",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                        ))),
              ),
              background: Image.asset(
                "assets/background.png",
                fit: BoxFit.cover,
              )),
          bottom: AppBar(
            actions: [
              IconButton(
                icon: Icon(Iconsax.logout),
                color: Colors.black,
                onPressed: () async {
                  await _authentificationController.logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                FadeAnimation(
                  1.5,
                  Container(
                      width: 50.0,
                      height: 50.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(7)),
                      child: Image.asset('assets/avatar-2.png')),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FadeAnimation(
                      1.2,
                      Container(
                        height: 50,
                        child: TextField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            hintText: "Rechercher une vignette",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            switch (value) {
                              case "blue":
                                setState(() {
                                  vignettes = vignettes
                                      .where((v) => v.colorText == "blue")
                                      .toList();
                                });
                                break;
                              case "orange":
                                setState(() {
                                  vignettes = vignettes
                                      .where((v) => v.colorText == "orange")
                                      .toList();
                                });
                                break;
                              case "white":
                                setState(() {
                                  vignettes = vignettes
                                      .where((v) => v.colorText == "white")
                                      .toList();
                                });
                                break;
                              case "":
                                setState(() {
                                  vignettes = allVignettes;
                                });
                                break;
                              default:
                                setState(() {
                                  vignettes = allVignettes;
                                });
                                break;
                            }
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
                padding: EdgeInsets.only(top: 20, left: 20),
                height: 350,
                child: Column(children: [
                  FadeAnimation(
                      1.4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cette semaine',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            child: MaterialButton(
                              onPressed: () async {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddVignette()));
                                if (result == true) {
                                  vignetteController
                                      .getVignettes()
                                      .then((value) {
                                    setState(() {
                                      vignettes = value;
                                    });
                                  });
                                }
                              },
                              child: Text("Ajouter une vignette"),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vignettes.length,
                          itemBuilder: (context, index) {
                            if (vignettes.isNotEmpty) {
                              return vignetteCart(vignettes[index]);
                            } else {
                              return Container();
                            }
                          }))
                ])),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(children: [
                  FadeAnimation(
                      1.4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Liste des vignettes',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            child: MaterialButton(
                              onPressed: () async {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddVignette()));
                                if (result == true) {
                                  vignetteController
                                      .getVignettes()
                                      .then((value) {
                                    setState(() {
                                      vignettes = value;
                                    });
                                  });
                                }
                              },
                              child: Text("Ajouter une vignette"),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: vignettes.map((item) {
                      return listVignetteCard(item);
                    }).toList(),
                  )
                ])),
          ]),
        )
      ]),
    );
  }

  vignetteCart(Vignette vignette) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: FadeAnimation(
          1.5,
          GestureDetector(
            onTap: () {
              print("vvvvvvvvvvvvvvvvvv");
            },
            child: Container(
              margin: EdgeInsets.only(right: 20, bottom: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5, 10),
                    blurRadius: 15,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                  baseUploadsURL + vignette.imageVignette,
                                  fit: BoxFit.cover)),
                        ),
                        // Add to cart button
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: MaterialButton(
                            color: Colors.black,
                            minWidth: 45,
                            height: 45,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () {
                              print("eeeeeeeeeeeeeeeeeeee");
                            },
                            padding: EdgeInsets.all(5),
                            child: Center(
                                child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    vignette.text,
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vignette.colorText,
                        style: TextStyle(
                          color: vignette.color,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        vignette.promotion,
                        style: TextStyle(
                          color: vignette.color,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget listVignetteCard(Vignette vignette) {
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: FadeAnimation(
          1.5,
          Container(
            margin: EdgeInsets.only(right: 20, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 10),
                  blurRadius: 15,
                  color: Colors.grey.shade200,
                )
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                          baseUploadsURL + vignette.imageVignette,
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              vignette.colorText,
                              style: TextStyle(
                                color: vignette.color,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              vignette.promotion,
                              style: TextStyle(
                                color: vignette.color,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          vignette.text,
                          softWrap: false,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ]),
                )
              ],
            ),
          )),
    );
  }
}
