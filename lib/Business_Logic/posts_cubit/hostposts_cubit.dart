import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pet_hub/Business_Logic/cupit_app/cubit/app_cubit.dart';
import 'package:pet_hub/Data/Models/Likes.dart';
import 'package:pet_hub/Data/Models/comments.dart';

import '../../Data/Models/hostPostModel.dart';

part 'hostposts_state.dart';

class HostpostsCubit extends Cubit<HostpostsState> {
  HostpostsCubit() : super(HostpostsInitial());

  String? birthDate;
  static HostpostsCubit get(context) => BlocProvider.of(context);
  File? hostPosteImage;
  var hostPostImagePicker = ImagePicker();
  List<HostPostData> hostPosts = [];
  List<String> postsId = [];
  List<String> likesId = [];
  List<Likes> likesState = [];
  List<Comments> comments = [];
  var map_name = new Map();
  var map_name2 =new Map();
  Future<void> getHostPosteImage() async {
    final pickedFile =
    await hostPostImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      hostPosteImage = File(pickedFile.path);
      print(hostPosteImage);
      emit(HostPostImagePickedSuccessState());
    } else {
      print(hostPosteImage);
      print("no image selected");
      emit(HostPostImagePickedErrorState());
    }
  }

  void uploadhostpostWithImage(
      String petName,
      String petAge,
      String petAgeType,
      String petType,
      String reward,
      String state,
      String city,
      String moreDetails,
      DateTime? startDate,
      DateTime? endDate,
      String petGander,
      String postDescription,
      DateTime postDate,
      BuildContext context,
      ) {
    emit(CreateHostPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'HostPosts/${Uri.file(hostPosteImage!.path).pathSegments.last}')
        .putFile(hostPosteImage!)
        .then((value) {
      emit(HostPostImageUploadSuccessState());
      value.ref.getDownloadURL().then((value) {
        HostPostData postData = HostPostData(
          fullName:  AppCubit.get(context).loggedInUser.fullName,
          id:  AppCubit.get(context).loggedInUser.id,
          profileImage:  AppCubit.get(context).loggedInUser.profileImage,
          postImage: value,
          petName: petName,
          petAge: petAge,
          petAgeType: petAgeType,
          petType: petType,
          reward: reward,
          state: state,
          city: city,
          moreDetails: moreDetails,
          startDate: startDate,
          endDate: endDate,
          petGander: petGander,
          postDescription: postDescription,
          postDate: postDate,
        );
        FirebaseFirestore.instance
            .collection("HostPosts")
            .add(postData.toMap())
            .then((value) {
          emit(CreateHostPostSuccessState());
        }).catchError((error) {
          emit(CreateHostPostErrorState());
        });
      }).catchError((error) {
        emit(CreateHostPostErrorState());
      });
    }).catchError((error) {
      emit(HostPostImageUploadErrorState());
    });
  }

  var myFormat = DateFormat('yyyy-MM-dd');
  String? postDate;
  void getHostPosts(BuildContext context)  {
    FirebaseFirestore.instance
        .collection('HostPosts')
        .orderBy('postDate',descending: true)
        .snapshots()
        .listen((event) {
      hostPosts = [];
      postsId.clear();
      event.docs.forEach((element) {
        hostPosts.add(HostPostData.fromJson(element.data()));
        postsId.add(element.id);
      });
      getHostLikes(context);
      emit(GetHostPostSuccessState());
    });
  }
  void getHostLikes(BuildContext context){
    likesState.clear();
    likesId.clear();
    for(int i=0;i<postsId.length;i++){
      FirebaseFirestore
          .instance
          .collection('HostLikes')
          .doc(postsId[i])
          .collection('HostLikes')
          .get()
          .then((value){
        map_name[postsId[i]]= value.docs.length.toString();
        likesId.add(postsId[i]);
        value.docs.forEach((element) {
          likesState.add(Likes.fromJson(element.data()));
        });
        emit(GetHostLikesState());
      }).catchError((error){
      });
    }}

  void likeHostPosts( String? postId, BuildContext context){
    Likes likeData=Likes(
        isLiked: "true",
        userId: AppCubit.get(context).loggedInUser.id,
        postId: postId
    );
    FirebaseFirestore
        .instance
        .collection('HostLikes')
        .doc(postId)
        .collection('HostLikes')
        .doc(AppCubit.get(context).loggedInUser.id)
        .set(likeData.toMap())
        .then((value){

      emit(CreateLikePostSuccessState());
      map_name2[postId]=true;
    } )
        .catchError((error){
      emit(CreateLikePostErrorState());
    });

  }
  void dislikeHostPosts( String? postId, BuildContext context){
    FirebaseFirestore
        .instance
        .collection('HostLikes')
        .doc(postId)
        .collection('HostLikes')
        .doc(AppCubit.get(context).loggedInUser.id)
        .delete().then((value){
      map_name2[postId]=false;
      emit(CreateDisLikePostSuccessState());
    });

  }
  void addComment(String postId,String description,  DateTime commentDate, BuildContext context){
    emit(CreateHostCommentLoadingState());
    Comments commentData=Comments(
      id: AppCubit.get(context).loggedInUser.id,
      fullName:AppCubit.get(context).loggedInUser.fullName ,
      ProfileImage:AppCubit.get(context).loggedInUser.profileImage ,
      commentDescription:description ,
      commentDate: commentDate,
    );
    FirebaseFirestore
        .instance
        .collection('comments')
        .doc(postId)
        .collection('Comments')
        .add(commentData.toMap()).then((value) {
      emit(CreateHostCommentSuccessState());
    }).catchError((error){
      emit(CreateHostCommentErrorState());
    });
  }
  getComments(String postId){
    emit(GetHostCommentLoadingState());
    FirebaseFirestore
        .instance
        .collection('comments')
        .doc(postId)
        .collection('Comments')
        .snapshots()
        .listen((event){
      comments=[];
      event.docs.forEach((element) {
        comments.add(Comments.fromJson(element.data()));
      });

      emit(GetHostCommentSuccessState());
    }).onError((error){
      emit(GetHostCommentErrorState());
    });

  }
  Future <void> deletePost (HostPostData data,String postId,BuildContext context)async{
    String url=data.postImage!;

    FirebaseFirestore.instance.collection('HostLikes')
        .doc(postId)
        .collection('HostLikes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc.exists)
        {doc.reference.delete();}
      });
    });
    await FirebaseFirestore.instance.collection('HostLikes')
        .doc(postId)
        .delete()
        .then((value){print ("Likes deleted");
    emit(DeleteHostLikesSuccessState());}).catchError((error) => print('Delete likes: $error'));
    FirebaseFirestore.instance.collection('comments')
        .doc(postId)
        .collection('Comments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc.exists)
        {doc.reference.delete();}
      });
    });
    await FirebaseFirestore.instance.collection('comments')
        .doc(postId) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((value){
    emit(DeleteHostCommentsSuccessState());}).catchError((error) => print('Delete comments: $error'));
    await FirebaseFirestore.instance.collection('HostPosts')
        .doc(postId) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((value){emit(DeleteHostPostSuccessState());
    }).catchError((error) => print('Delete failed: $error'));
    await FirebaseStorage.instance.refFromURL(url).delete();

    Navigator.pop(context);
  }
}
