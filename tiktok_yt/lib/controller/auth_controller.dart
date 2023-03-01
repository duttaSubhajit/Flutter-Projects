import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_yt/model/user.dart';
import 'package:tiktok_yt/view/screens/Home.dart';
import 'package:tiktok_yt/view/screens/auth/login_screen.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  // image select in global
  File? proimg;


  pickImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image==null) return;
    final img = File(image.path);
    this.proimg = img;
  }
  // Function for if the user is already loggin then after sign out the user don't need to sign up again

  late Rx<User?> _user;
  User get user => _user.value!;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    // Rx is a observable keyword - contunuesly checking variable is changing or not
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);
  }

  _setInitialView(User? user){
    if(user==null){
      Get.offAll(()=>LoginScreen());
    }
    else{
      Get.offAll(()=>HomeScreen());
    }
  }

  void SignUp(
      String username,
      String email,
      String password,
      File? image
      )async{

    try{
      print("Image here");
      print(image.toString()=='');
      print("Image here");

      if(
      username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image!=null
      ){
        UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadProPic(image);

        myUser user = myUser(name: username, email: email, uid: credential.user!.uid, profilePhoto: downloadUrl);

        //User data upload
        await FirebaseFirestore.instance.collection('user').doc(credential.user!.uid).set(user.toJson());
      }
      else{
        Get.snackbar("Error, creating account", "Please enter all the fields required");
      }

    }catch(e){
      print(e);
      Get.snackbar("Error Occured", e.toString());
    }
  }

  Future<String> _uploadProPic(File image)async{
    Reference ref = FirebaseStorage.instance.ref().child('profilePics').child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageDwnUrl = await snapshot.ref.getDownloadURL();
    return imageDwnUrl;
  }

  void login(String email,String password) async{
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        Get.snackbar("Error Logging In", "Please Enter the field");
      }
    }catch(e){
      Get.snackbar("Error Loggin In", e.toString());
    }
  }
  signOut(){
    FirebaseAuth.instance.signOut();
    Get.offAll(LoginScreen());
  }

}