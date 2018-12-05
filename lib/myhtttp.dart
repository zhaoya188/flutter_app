import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class HttpPage extends StatefulWidget {
  HttpPage({Key key}) : super(key: key);

  @override
  _HttpPageState createState() => new _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  bool _loading = false;
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("HTTP数据"),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return _loading
        ? Center(
            child: CircularProgressIndicator(
            semanticsLabel: "lebal",
            semanticsValue: "value",
            backgroundColor: Colors.yellow,
          ))
        : Scrollbar(
            child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: widgets.length,
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int position) {
                  return getRow(position);
                }),
          );
  }

  Widget getRow(int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          onTap: () {},
          title: Padding(
            padding: new EdgeInsets.all(10.0),
            child: Text("${widgets[i]["id"]}. ${widgets[i]["title"]}"),
          ),
        ),
        Divider()
      ],
    );
  }

  loadData() async {
    _loading = true;
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
      _loading = false;
    });
  }
}
