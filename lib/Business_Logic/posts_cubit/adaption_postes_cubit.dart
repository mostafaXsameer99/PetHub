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



import '../../Data/Models/adaptionPostModel.dart';
import '../../Data/Models/comments.dart';
import '../../Data/Models/hostPostModel.dart';

part 'adaption_postes_state.dart';

class AdaptionPostesCubit extends Cubit<AdaptionPostesState> {
  AdaptionPostesCubit() : super(PostesInitial());

  String? birthDate;

  static AdaptionPostesCubit get(context) => BlocProvider.of(context);

  File? adaptionPosteImage;
  var adaptionPostImagePicker = ImagePicker();

  List<AdaptionPostData> adaptionPosts = [];


  List<String> postsId = [];


  List<Comments> comments = [];
  List<String> likesId = [];
  List<int> postLikes = [];
  List<String> postLikesIds = [];
  List<Likes> likesState = [];
  var map_name = new Map();
  var map_name2 =new Map();


  Future<void> getAdaptionPosteImage() async {
    final pickedFile =
        await adaptionPostImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      adaptionPosteImage = File(pickedFile.path);
      print(adaptionPosteImage);
      emit(AdaptionPostImagePickedSuccessState());
    } else {
      print(adaptionPosteImage);
      print("no image selected");
      emit(AdaptionPostImagePickedErrorState());
    }
  }

  void uploadAdaptionpostWithImage(
    String petName,
    String petAge,
    String petAgeType,
    String petType,
    String state,
    String city,
    String petGander,
    String postDescription,
    DateTime postDate,
      BuildContext context,
  ) {
    emit(CreateAdaptionPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'AdaptionPosts/${Uri.file(adaptionPosteImage!.path).pathSegments.last}')
        .putFile(adaptionPosteImage!)
        .then((value) {
      emit(AdaptionPostImageUploadSuccessState());
      value.ref.getDownloadURL().then((value) {
        AdaptionPostData postData = AdaptionPostData(
          fullName: AppCubit.get(context).loggedInUser.fullName,
          id: AppCubit.get(context).loggedInUser.id,
          profileImage: AppCubit.get(context).loggedInUser.profileImage,
          postImage: value,
          petName: petName,
          petAge: petAge,
          petAgeType: petAgeType,
          petType: petType,
          state: state,
          city: city,
          petGander: petGander,
          postDescription: postDescription,
          postDate: postDate,
        );
        FirebaseFirestore.instance
            .collection("AdaptionPosts")
            .add(postData.toMap())
            .then((value) {
          emit(CreateAdaptionPostSuccessState());
        }).catchError((error) {
          emit(CreateAdaptionPostErrorState());
        });
      }).catchError((error) {
        emit(CreateAdaptionPostErrorState());
      });
    }).catchError((error) {
      emit(AdaptionPostImageUploadErrorState());
    });
  }

  var myFormat = DateFormat('yyyy-MM-dd');
  String? postDate;
  void getAdaptionPosts(BuildContext context)  {
      FirebaseFirestore.instance
          .collection('AdaptionPosts')
          .orderBy('postDate',descending: true)
          .snapshots()
          .listen((event) {
        adaptionPosts = [];
        postsId.clear();
        event.docs.forEach((element) {
          adaptionPosts.add(AdaptionPostData.fromJson(element.data()));
          postsId.add(element.id);
        });
        getAdaptionLikes(context);
        emit(GetAdaptionPostSuccessState());
      });
  }

  List<AdaptionPostData> adaptionPostsProfile = [];

  List<String> postsIdadaptionProfile = [];


  AdaptionPostData temp=new AdaptionPostData();
  void getPostsProfile(BuildContext context)  {
    FirebaseFirestore.instance
        .collection('AdaptionPosts')
        .orderBy('postDate',descending: true)
        .snapshots()
        .listen((event) {
      adaptionPostsProfile = [];
      event.docs.forEach((element) {
        temp=AdaptionPostData.fromJson(element.data());
        if(temp.id==AppCubit.get(context).loggedInUser.id){
          adaptionPostsProfile.add(AdaptionPostData.fromJson(element.data()));
          postsIdadaptionProfile.add(element.id);

        }
      });
      getAdaptionLikes(context);

      emit(GetAdaptionPostSuccessState());
    });


  }
  Future<void>  getAdaptionLikes(BuildContext context)async{
  likesState.clear();
  likesId.clear();
  for(int i=0;i<postsId.length;i++){
   FirebaseFirestore
      .instance
      .collection('AdaptionLikes')
      .doc(postsId[i])
      .collection('AdaptionLikes')
      .get()
      .then((value){
    map_name[postsId[i]]= value.docs.length.toString();
    likesId.add(postsId[i]);
    value.docs.forEach((element) {
      likesState.add(Likes.fromJson(element.data()));
    });
    emit(GetAdaptionLikesState());
  })
      .catchError((error){

  });
}}

  void likeAdaptionPosts( String? postId, BuildContext context){
    Likes likeData=Likes(
      isLiked: "true",
      userId: AppCubit.get(context).loggedInUser.id,
      postId: postId
    );
    FirebaseFirestore
        .instance
        .collection('AdaptionLikes')
        .doc(postId)
        .collection('AdaptionLikes')
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
  void dislikeAdaptionPosts( String? postId, BuildContext context){
    FirebaseFirestore
        .instance
        .collection('AdaptionLikes')
        .doc(postId)
        .collection('AdaptionLikes')
        .doc(AppCubit.get(context).loggedInUser.id)
        .delete().then((value){
      map_name2[postId]=false;
      emit(CreateDisLikePostSuccessState());
    });

  }

  void addComment(String postId,String description,  DateTime commentDate, BuildContext context){
    emit(CreateAdaptionCommentLoadingState());
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
      emit(CreateAdaptionCommentSuccessState());
    }).catchError((error){
      emit(CreateAdaptionCommentErrorState());
    });
  }

  getComments(String postId){
    emit(GetAdaptionCommentLoadingState());
      FirebaseFirestore
          .instance
          .collection('comments')
          .doc(postId)
          .collection('Comments')
          .orderBy('commentDate',descending: false)
          .snapshots()
          .listen((event) {
        comments=[];
            event.docs.forEach((element) {
              comments.add(Comments.fromJson(element.data()));
            });
            emit(GetAdaptionCommentSuccessState());
      }).onError((error){
        emit(GetAdaptionCommentErrorState());
      });

   }

   Future <void> deletePost (AdaptionPostData data,String postId,BuildContext context)async{
   String url=data.postImage!;

   FirebaseFirestore.instance.collection('AdaptionLikes')
       .doc(postId)
       .collection('AdaptionLikes')
       .get()
       .then((QuerySnapshot querySnapshot) {
     querySnapshot.docs.forEach((doc) {
       if(doc.exists)
       {doc.reference.delete();}
     });
   });
   await FirebaseFirestore.instance.collection('AdaptionLikes')
       .doc(postId) // <-- Doc ID to be deleted.
       .delete() // <-- Delete
       .then((value){print ("Likes deleted");
   emit(DeleteAdaptionLikesSuccessState());}).catchError((error) => print('Delete likes: $error'));

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
   emit(DeleteAdaptionCommentsSuccessState());}).catchError((error) => print('Delete comments: $error'));

   await FirebaseFirestore.instance.collection('AdaptionPosts')
        .doc(postId) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((value){emit(DeleteAdaptionPostSuccessState());
   }).catchError((error) => print('Delete failed: $error'));

   await FirebaseStorage.instance.refFromURL(url).delete();

   Navigator.pop(context);
  }

}
