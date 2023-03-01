import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tiktok_yt/constructors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_yt/view/screens/addcaption_screen.dart';

class addVideoScreen extends StatelessWidget {
  const addVideoScreen({Key? key}) : super(key: key);

  videoPic(ImageSource src, BuildContext context) async{
    final video = await ImagePicker().pickVideo(source: src);
    if(video!=null){
      Get.snackbar("video selected", video.path);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> addCaption_Screen(videoFile: File(video.path), videoPath: video.path)));
    }else{
      Get.snackbar("Error in Selecting Videp", "Please choose a different video");
    }
  }

  showDialogOpt(BuildContext context){
    return showDialog(context: context, builder: (context)=>
    SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: ()=>videoPic(ImageSource.gallery, context),
          child: Text("Gallery"),
        ),
        SimpleDialogOption(
          onPressed: ()=>videoPic(ImageSource.camera, context),
          child: Text("Camera"),
        ),
        SimpleDialogOption(
          onPressed: (){
            Navigator.pop(context);         //For close the dialog box
          },
          child: Text("Close"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showDialogOpt(context),
          child: Container(
            width: 190,
            height:50,
            decoration: BoxDecoration(
              color: buttonColor
            ),
            child: Center(
              child: Text("Upload video", style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
