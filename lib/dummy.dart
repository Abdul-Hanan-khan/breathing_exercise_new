import 'package:flutter/material.dart';

class YourPage extends StatefulWidget {
  @override
  State createState() => YourPageState();
}

class YourPageState extends State<YourPage> {
  List<String> countries = ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'];
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    //fill countries with objects
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Scaffold(
        body: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                    child: TextField(
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            controller.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                        hintText: "Search...",
                      ),
                      controller: controller,
                    )),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: _buildListView()),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          if (filter == null || filter == "") {
            // return _buildRow(countries[index]);
          } else {
            if (countries[index].toLowerCase().contains(filter.toLowerCase())) {
              return _buildRow(countries[index]);
            } else {
              return new Container();
            }
          }
        });
  }

  Widget _buildRow(String c) {
    return GestureDetector(
     onTap: (){
       print(c);
     },
      child: ListTile(
        tileColor: Colors.green,
        title: Text(
          c,
        ),
        subtitle: Text(
          c,
        ),
      ),
    );
  }
}
