import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_project/Model/favourite.dart';
import 'package:news_project/screens/web.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String tes = 'Belum Masuk';
  List<dynamic> listdata = [];
  List<dynamic> listFavourite = [];
  var box = Hive.box<Favourite>('myBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmbilData();
  }

  Future<void> AmbilData() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=keyword&apiKey=d5646c6a41fc455abb7a6de16525eb52'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      var data = json.decode(response.body);
      setState(() {
        listdata = data['articles'];
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void SimpanFavourite(String judul, String url){
    Favourite favourite = Favourite('$judul', '$url');
    box.add(favourite);
    setState(() {
      listFavourite = box.values.toList();
    });
}

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text('News BSI'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Home Page'),
                Tab(text: 'Favourites'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content of Tab 1
              Center(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.network(
                                  listdata[index]['urlToImage'],
                                  width: 200.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 20.0,
                                    right: 16.0,
                                    child: IconButton(onPressed: (){
                                      SimpanFavourite(listdata[index]['url'], listdata[index]['title']);
                                    },
                                    icon: Icon(Icons.favorite),
                                    )
                                )
                              ],
                            ),
                            Text('${listdata[index]['title']}')
                          ],
                        ),
                      );
                    }),
              ),
              // Content of Tab 2
              Center(
                child: ListView.builder(
                    itemCount: listFavourite.length,
                    itemBuilder: (BuildContext context, int index) {
                      Favourite data = listFavourite[index];
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: ListTile(
                          title: Text('${data.title}'),
                          trailing: IconButton(
                            onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebPage(data.link)));
                            },
                            icon: Icon(Icons.arrow_circle_right),
                          ),
                        ),
                      );
                    }),
              ),
              // Content of Tab 3
            ],
          ),
        ),
      ),
    );
  }
}
