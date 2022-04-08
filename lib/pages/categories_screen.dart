import 'dart:convert';


import 'package:breathing_exercise_new/models/categories_modal.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/selected_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CategoriesScreen extends StatefulWidget {
  var languageID;
  CategoriesScreen(this.languageID);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Categories categories = Categories();
bool isLoading=true;
  @override
  void initState() {
    loadModal();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.GREEN_ACCENT,
        title: Text("Categories"),
        centerTitle: true,
      ),
      body: isLoading?
      Utils.loadingContainer():
      _getBody()
    );
  }
  loadModal() async {
  try{
     Response response = await HttpHelper.post(body: {
      "language_id": widget.languageID.toString()
    }, apiFile: "Categoires");
    if(response.statusCode==200)
    {
      setState(() {
        categories = Categories.fromJson(jsonDecode(response.body));
        print(categories);
        isLoading= false;
      });

    }
    else
    {
      categories.data=[];
      Utils.showToast(message: "Cannot load categories");
    }
  }
  catch(e)
    {
     print(e);
    }
  }
  Widget _getBody() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            children:  categories.data.map((category) {

              return Card(

                color: AppColors.GREEN_ACCENT,
                child: InkWell(
                  onTap: () async{
                    Utils.push(context, SelectedCategoryScreen(category.languageId, category.categoryId,category.name));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   map['icon'],
                        //   size: Utils.getScreenWidth(context) / 4,
                        //   color: Colors.white,
                        // ),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Utils.getScreenWidth(context) / 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );              // return Padding(

            }).toList(),
          ),
        ],
      ),
    );
  }

}
