import 'dart:convert';

import 'package:breathing_exercise_new/models/posts_modal.dart';
import 'package:breathing_exercise_new/other/app_colors.dart';
import 'package:breathing_exercise_new/other/http_helper.dart';
import 'package:breathing_exercise_new/other/utils.dart';
import 'package:breathing_exercise_new/pages/view_document_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'audio_player_screen.dart';
import 'yt_video_player_screen.dart';

class SelectedCategoryScreen extends StatefulWidget {
  String categoryID;
  String languageID;
  String categoryName;
  SelectedCategoryScreen(this.languageID,this.categoryID,this.categoryName);
  @override
  _SelectedCategoryScreenState createState() => _SelectedCategoryScreenState();
}

class _SelectedCategoryScreenState extends State<SelectedCategoryScreen> {
  Posts posts = Posts();
  bool isLoading=true;
  String dropdownValue = 'All';
  List modalList;
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
          actions: [
            DropdownButton(

              underline: Container(
                color: Colors.transparent,
              ),

              iconEnabledColor: Colors.white,
              icon: Icon(Icons.filter_alt_outlined),
              onChanged: (newvalue){
                setState(() {
                  dropdownValue = newvalue;
                });
                filter(newvalue);
              },
                // value: dropdownValue,
                items: <String>['All', 'Video', 'Audio', 'Document']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
            ),
            SizedBox(width: 8,)// IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt_outlined))
          ],
          title: Text(widget.categoryName),
          centerTitle: true,
        ),
        body: isLoading?
        Utils.loadingContainer():
        ListView(
          children: modalList.map((post) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:ListTile(
                onTap: (){
                  categoryOnTap(post);
                },
                // minLeadingWidth: 80,
                isThreeLine: true,
                selectedTileColor:AppColors.GREEN_ACCENT,
                selected: true,
                title: Text(post.title,
                  style: TextStyle(
                  color: Colors.white
                ),),
                subtitle:  Text(post.type=="document"?"":post.duration,
                  style: TextStyle(
                      color: Colors.white
                  ),),
                leading: IconButton(icon:Icon(
                    post.type=="mp4"?Icons.play_circle_filled_rounded:
                    post.type=="mp3"?Icons.music_video:
                    Icons.insert_drive_file_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                ),
              )
            );
          }).toList(),
        )
    );
  }

  categoryOnTap(var post){

      if(post.type=="document")
      {
        // Utils.push(context, ViewDocumentScreen(post));
      }
      else if(post.type=="mp3")
      {
        // Utils.push(context, AudioPlayerScreen(post));
      }
      else if(post.type=="mp4")
      {
        Utils.push(context, YTPlayerScreen(post));
      }
    }


  filter(String value){
    if(modalList.isNotEmpty)
      {
        if(value == "All")
          {
            modalList = posts.data;
          }
        else if(value == "Audio")
        {
         setState(() {
           modalList = posts.data.where((element) => element.type=="mp3").toList();
         });
        }

        else if(value == "Document")
        {
          setState(() {
            modalList = posts.data.where((element) => element.type=="document").toList();
          });
        }

        else if(value == "Video")
        {
          setState(() {
            modalList = posts.data.where((element) => element.type=="mp4").toList();
          });
        }

      }
  }

  loadModal() async {
    try{
      Response response = await HttpHelper.post(body: {
        "language_id": widget.languageID,
        "category_id" : widget.categoryID
      }, apiFile: "posts");
      if(response.statusCode==200)
      {
        setState(() {
          posts = Posts.fromJson(jsonDecode(response.body));
          modalList = posts.data;
          print(modalList);
          isLoading= false;
        });

      }
      else
      {
        posts.data=[];
        Utils.showToast(message: "Cannot load details");
      }
    }
    catch(e)
    {
      print(e);
    }
  }
}
