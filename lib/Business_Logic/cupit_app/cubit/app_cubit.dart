import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_hub/Constants/strings.dart';
import 'package:pet_hub/Data/Models/MessageModel.dart';
import 'package:pet_hub/Data/Models/hostPostModel.dart';
import 'package:pet_hub/Data/Models/pets_data.dart';
import 'package:pet_hub/Data/Models/userModel.dart';
import 'package:pet_hub/Presentation/Screens/OwnedPetDetails.dart';
import 'package:pet_hub/Presentation/Screens/Sign_in.dart';
import 'package:pet_hub/Presentation/Screens/homePage.dart';
import 'package:pet_hub/Presentation/Screens/placesPage.dart';
import 'package:pet_hub/Presentation/Screens/profilePage.dart';
import 'package:pet_hub/Presentation/Screens/qrCodePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as Path;

import '../../../Data/Models/adaptionPostModel.dart';
import '../../../Data/Models/comments.dart';
import '../../../Data/Models/lostPostsModel.dart';
import '../../posts_cubit/adaption_postes_cubit.dart';
import '../../posts_cubit/hostposts_cubit.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  var myFormat = DateFormat('yyyy-MM-dd');
  UserData loggedInUser = UserData();
  UserData? strangeUser;
  UserData? chatUser;

  String? birthDate;
  String? birthDateStranger;

  bool linkOpened = false;
bool isSeen=false;

  Future<void> getUserData() async {
    if (uId != null) {
      print(uId);
      emit(AppGetUserLoadingState());
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uId)
          .get()
          .then((value) {
        this.loggedInUser = UserData.fromMap(value.data());
        birthDate = "${myFormat.format(loggedInUser.birthDay!).toString()}";
        print("ana keda tmam");
        print(loggedInUser.fullName);
        emit(AppGetUserSuccessState());
      }).catchError((e) {
        emit(AppGetUserErrorState());
      });
    }
  }

  Future<void> getStrangeUserData(String? userId) async {
    strangeUser = new UserData();
    emit(AppGetUserLoadingState());
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .get()
        .then((value) {
      this.strangeUser = UserData.fromMap(value.data());
      birthDateStranger = "${myFormat.format(strangeUser!.birthDay!).toString()}";
      print("-----------------------------------------------------------ana keda tmam");
      print(strangeUser!.fullName);
      emit(AppGetUserSuccessState());
    }).catchError((e) {
      emit(AppGetUserErrorState());
    });
  }


  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uId');
    loggedInUser = UserData();
    currentIndex = 0;
    Navigator.of(context).pushReplacementNamed(SignIn.routeName);
  }


  int currentIndex = 0;
  List<Widget>screens = [HomePage(), PlacesPage(), QrCode(), Profile()];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }


  File? profileImage;
  var profileImagePicker = ImagePicker();
  String? profileImageUrl;

  Future<void> getProfileImage() async {
    final pickedFile = await profileImagePicker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppImagePickedSuccessState());
      //isPicUploaded=true;
    } else {
      emit(AppImagePickedErrorState());
    }
  }


  void uploadProfileImage(
      {@required String? fullName, @required String? phoneNumber,required BuildContext context}) {
    emit(AppUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance.ref().child('uers/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        updateUser(fullName: fullName, phoneNumber: phoneNumber,context:context );
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((erorr) {
      emit(AppUploadProfileImageErrorState());
    });
  }


  Future<void> updateUser({@required String? fullName, @required String? phoneNumber,required BuildContext context}) async {
    UserData userData = UserData();
    // writing all the values
    userData.email = loggedInUser.email;
    userData.id = loggedInUser.id;
    userData.fullName = fullName == "" ? loggedInUser.fullName : fullName;
    userData.phoneNumber =
    phoneNumber == "" ? loggedInUser.phoneNumber : phoneNumber;
    userData.birthDay = loggedInUser.birthDay;
    userData.city = loggedInUser.city;
    userData.state = loggedInUser.state;
    userData.gender = loggedInUser.gender;
    userData.profileImage =
    profileImage == null ? loggedInUser.profileImage : profileImageUrl;
    var copy=loggedInUser.profileImage;

    FirebaseFirestore.instance.collection("Users").doc(loggedInUser.id).update(
        userData.toMap()).then((value) async {
      getAdaptionPostsAfterUpdate(context,fullName);
      getHostPostsAfterUpdate(context,fullName);
      getLostPostsAfterUpdate(context,fullName);
      getUserData();
      var fileUrl = Uri.decodeFull(Path.basename(copy!)).replaceAll(new RegExp(r'(\?alt).*'), '');
      final  firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
      // final refpic= firebase_storage.FirebaseStorage.instance.ref().child(copy! );
      // refpic.delete();
      profileImage = null;
    }).catchError((error) {});
  }
  List<AdaptionPostData> adaptionPostsProfile = [];
  List<String> postsIdadaptionProfile = [];
  AdaptionPostData temp=new AdaptionPostData();


  void getAdaptionPostsAfterUpdate(BuildContext context,String? fullName)  {

    FirebaseFirestore.instance
        .collection('AdaptionPosts')
        .orderBy('postDate',descending: true)
        .snapshots()
        .listen((event) {
      adaptionPostsProfile = [];
      event.docs.forEach((element) {
        temp=AdaptionPostData.fromJson(element.data());
        if(temp.id==AppCubit.get(context).loggedInUser.id){
          temp=AdaptionPostData.fromJson(element.data());
          temp.profileImage=profileImageUrl;
          temp.fullName=fullName;
          FirebaseFirestore.instance.collection("AdaptionPosts").doc(element.id).update(
              temp.toMap()).then((value) {
          }).catchError((e){});


          adaptionPostsProfile.add(AdaptionPostData.fromJson(element.data()));

          postsIdadaptionProfile.add(element.id);

        }
        getCommentsAfterUpdate(element.id,context,fullName);
      });


    });


  }
  List<HostPostData> hostPostsProfile = [];
  List<String> postsIdHostProfile = [];
  HostPostData temp2=new HostPostData();
  void getHostPostsAfterUpdate(BuildContext context,String? fullName)  {

    FirebaseFirestore.instance
        .collection('HostPosts')
        .orderBy('postDate',descending: true)
        .snapshots()
        .listen((event) {
      hostPostsProfile = [];
      event.docs.forEach((element) {
        temp2=HostPostData.fromJson(element.data());
        if(temp2.id==AppCubit.get(context).loggedInUser.id){
          temp2=HostPostData.fromJson(element.data());
          temp2.profileImage=profileImageUrl;
          temp2.fullName=fullName;
          FirebaseFirestore.instance.collection("HostPosts").doc(element.id).update(
              temp2.toMap()).then((value) {
          }).catchError((e){});

          hostPostsProfile.add(HostPostData.fromJson(element.data()));

          postsIdHostProfile.add(element.id);

        }
        getCommentsAfterUpdate(element.id,context,fullName);
      });


    });


  }
  List<LostPostData> lostPostsProfile = [];
  List<String> postsIdLostProfile = [];
  LostPostData temp3=new LostPostData();
  void getLostPostsAfterUpdate(BuildContext context,String? fullName)  {

    FirebaseFirestore.instance
        .collection('LostPosts')
        .orderBy('postDate',descending: true)
        .snapshots()
        .listen((event) {
      lostPostsProfile = [];
      event.docs.forEach((element) {
        temp3=LostPostData.fromJson(element.data());
        if(temp3.id==AppCubit.get(context).loggedInUser.id){
          temp3=LostPostData.fromJson(element.data());
          temp3.profileImage=profileImageUrl;
          temp3.fullName=fullName;

          FirebaseFirestore.instance.collection("LostPosts").doc(element.id).update(
              temp3.toMap()).then((value) {
          }).catchError((e){});

          lostPostsProfile.add(LostPostData.fromJson(element.data()));

          postsIdLostProfile.add(element.id);

        }
        getCommentsAfterUpdate(element.id,context,fullName);
      });


    });


  }
  List<Comments>comments= [];
  Comments temp4=new Comments();
  getCommentsAfterUpdate(String postId,BuildContext context,String? fullName){
    FirebaseFirestore
        .instance
        .collection('comments')
        .doc(postId)
        .collection('Comments')
        .snapshots()
        .listen((event){
      comments=[];

      event.docs.forEach((element) {

          temp4=Comments.fromJson(element.data());
          temp4.ProfileImage=profileImageUrl;
          temp4.fullName=fullName;

          FirebaseFirestore.instance.collection("comments").doc(postId).collection("Comments").doc(element.id).update(
              temp4.toMap()).then((value) {
          }).catchError((e){});
          comments.add(Comments.fromJson(element.data()));


      });


    }).onError((error){
    });

  }
  openWhatsUp(BuildContext context,String phoneNumber) async {
    var whatsApp = "+2${phoneNumber}";
    var whatsAppUrlAndroid = "whatsapp://send?phone=" + whatsApp;
    if (Platform.isAndroid) {
      if (await canLaunch(whatsAppUrlAndroid)) {
        await launch(whatsAppUrlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("WhatsApp Not Installed")));
      }
    } else {}
  }

  void handleLinkRunning(BuildContext context) async
  {
    emit(AppRunningOpenWithLinkInitialState());

    if (!linkOpened) {
      linkOpened = true;
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
        if (uId != null) {
          print("I love U");
          String link = dynamicLinkData.link.toString();
          var arr = link.split('/');
          String userId = arr[arr.length - 3];
          String petOwnedId = arr[arr.length - 2];
          navigateToPetScreen(context, userId, petOwnedId, link);
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text(
              "Please Sign in or Sign up to Reach the required page"),
            backgroundColor: Colors.lightGreen,
            duration: Duration(seconds: 3),));
        }
      }).onError((error) {
        emit(AppRunningOpenWithLinkErrorState());
        print(error.toString());
      });
    }
  }

  void navigateToPetScreen(BuildContext context, String userId,
      String petOwnedId, String link) async
  {
    PetsOwned petsOwned = new PetsOwned();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection("PetsOwned")
        .doc(petOwnedId)
        .get()
        .then((value) {
      petsOwned = PetsOwned.fromJson(value.data()!);
      emit(AppRunningOpenWithLinkOpenedState());
    }
    ).catchError((e) {
      emit(AppRunningOpenWithLinkErrorState());
      print(e.toString());
    });

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => OwnedPetDetails(petsOwned, link),));
  }

  Future <void> handleLink(PendingDynamicLinkData? initialLink,
      BuildContext context) async
  {
    print("I Hate U");
    String link = initialLink!.link.toString();
    print(link);
    var arr = link.split('/');
    String userId = arr[arr.length - 3];
    String petOwnedId = arr[arr.length - 2];
    PetsOwned petsOwned = new PetsOwned();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection("PetsOwned")
        .doc(petOwnedId)
        .get()
        .then((value) {
      petsOwned = PetsOwned.fromJson(value.data()!);
    }
    ).catchError((e) {
      print(e.toString());
    });

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => OwnedPetDetails(petsOwned, link),));
  }


  Future<String> createDynamicLink(PetsOwned petOwned, String? petId) async {
    String _linkMessage;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse(
          'https://www.pethub.page.link.com/${petOwned.ownerId}/${petId!}/'),
      uriPrefix: 'https://pethub.page.link',
      androidParameters: const AndroidParameters(
          packageName: "com.example.pet_hub"),
    );
    Uri url;
    url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    _linkMessage = url.toString();
    return _linkMessage;
  }


  // CHAT
  var nobleGases = new Map<String, bool>();
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
   }) {
    MessageModel model = MessageModel(
      senderId: loggedInUser.id,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,

    );

    FirebaseFirestore.instance
        .collection('Users')
        .doc(loggedInUser.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(AppSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('chats')
        .doc(loggedInUser.id)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(AppSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(loggedInUser.id)
        .collection('chats')
        .doc(receiverId)
        .set({
         'isSeen': true
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('chats')
        .doc(loggedInUser.id)
        .set({
          'isSeen': false
    });
    nobleGases[receiverId]=false;
  }
  List<bool> massagelist=[];
  List<String> strangeIds=[];


  List <MessageModel> messages = [];
  void getMessages({required String receiverId,}) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(loggedInUser.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(AppGetMessagesSuccessState());
    });
  }


  List <String> chatUsersId=[];
  void getallchatsid(){
    FirebaseFirestore.instance
        .collection('Users/${loggedInUser.id}/chats')
        .get()
        .then((value)
    {
      chatUsersId=[];
       value.docs.forEach((element)
       {
         chatUsersId.add(element.reference.id);
       });
      getchatuserdata();
       emit(AppGetAllChatUsersSuccessState());
    }).catchError((error){
      emit(AppGetAllChatUsersErrorState());
    });
  }
  List<UserData> chatUsersData=[];
  Future<void> getchatuserdata() async {
    chatUsersData=[];
    for (int i = 0; i < chatUsersId.length; i++)
    {
      UserData chatUser = new UserData();
      emit(AppGetUserLoadingState());
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(chatUsersId[i])
          .get()
          .then((value) {
        chatUser = UserData.fromMap(value.data());
        chatUsersData.add(chatUser);
        //print("ana ${chatUser.fullName}");
        emit(AppGetUserSuccessState());
      }).catchError((e) {
        emit(AppGetUserErrorState());
      });
    }
  }

}