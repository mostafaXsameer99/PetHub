import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Business_Logic/cupit_app/cubit/app_cubit.dart';
import '../../Business_Logic/posts_cubit/adaption_postes_cubit.dart';
import '../../Constants/timeAgo.dart';
import '../../Data/Models/adaptionPostModel.dart';
import '../../pets_icons_icons.dart';
import '../Screens/AdaptionPost.dart';
import '../Screens/StrangeUserProfile.dart';
import '../Screens/profilePage.dart';

class ProfilePosts extends StatefulWidget {
  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  bool adaptionHeart = true;

  final bool lostHeart = true;

  final bool hostHeart = true;

  Widget profilePost(AdaptionPostData postData, context,int index) => postData.id==AppCubit.get(context).loggedInUser.id?SingleChildScrollView(

    child:BlocConsumer<AdaptionPostesCubit, AdaptionPostesState>(
      listener: (context, state) {

        // TODO: implement listener
      },
      builder: (context, state) {
        String postid=AdaptionPostesCubit.get(context).postsIdadaptionProfile[index];


        var contain = AdaptionPostesCubit.get(context).likesState.where((element) => element.postId == postid && element.userId==AppCubit.get(context).loggedInUser.id) ;
        Timestamp myTimeStamp = Timestamp.fromDate(postData.postDate!);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: Colors.grey),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(postData.id==AppCubit.get(context).loggedInUser.id){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>Profile()
                                ,
                              ));
                        }
                        else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>UserProfile(userId: postData.id)
                                ,
                              ));
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: postData.profileImage!=null?
                        NetworkImage('${postData.profileImage}'):AssetImage('Images/Group 2.png') as ImageProvider,
                        backgroundColor: Colors.white,
                        radius: 25,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(postData.id==AppCubit.get(context).loggedInUser.id){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>Profile()
                                    ,
                                  ));
                            }
                            else{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>UserProfile(userId: postData.id)
                                    ,
                                  ));
                            }

                          },
                          child: Text(
                            '${postData.fullName}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '${TimeAgo.timeago(myTimeStamp.millisecondsSinceEpoch)}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap:(){
                    String postid=AdaptionPostesCubit.get(context).postsIdadaptionProfile[index];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdaptionPost(postdetails: postData,index: index,postId:postid ),
                        ));
                  } ,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    height: 300,
                    //width: ,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                image: NetworkImage('${postData.postImage}'),
                                fit: BoxFit.fill,
                              )),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          height: 40,
                          alignment: AlignmentDirectional.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(postData.petGander=="Male")
                                Icon(
                                  Icons.male_rounded,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              if(postData.petGander=="Female")
                                Icon(
                                  Icons.female_rounded,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              Text(
                                '${postData.petName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            if(contain.isNotEmpty)
                              IconButton(
                                icon: Icon(
                                    PetsIcons.heart__2_,

                                    color: Colors.red),

                                onPressed: () {
                                  AdaptionPostesCubit.get(context).dislikeAdaptionPosts(AdaptionPostesCubit.get(context).postsIdadaptionProfile[index],context);
                                  setState(() {

                                    AdaptionPostesCubit.get(context).getAdaptionLikes(context);
                                    // AdaptionPostesCubit.get(context).map_name2[postid]=true;

                                  });
                                },
                              ),
                            if(contain.isEmpty)
                              IconButton(
                                icon: Icon(

                                    PetsIcons.heart ,

                                    color: Colors.red),

                                onPressed: () {
                                  AdaptionPostesCubit.get(context).likeAdaptionPosts(AdaptionPostesCubit.get(context).postsIdadaptionProfile[index],context);
                                  setState(() {

                                    AdaptionPostesCubit.get(context).getAdaptionLikes(context);


                                  });
                                },
                              ),
                            if(AdaptionPostesCubit.get(context).map_name[postid]!=null)
                              Text(
                                  '${AdaptionPostesCubit.get(context).map_name[postid]}'
                              ),
                            IconButton(
                                onPressed: () {
                                  String postid=AdaptionPostesCubit.get(context).postsIdadaptionProfile[index];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdaptionPost(postdetails: postData,index: index,postId:postid ),
                                      ));
                                },
                                icon: Icon(PetsIcons.comment)),
                          ],
                        )),
                    Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  print('Map Clicked');
                                },
                                icon: Icon(PetsIcons.location)),
                            Expanded(child: Text('${postData.state}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),))
                          ],
                        )),


                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),

  ):Container(
    child: Center(
      child: Text(
        'there is no posts'
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdaptionPostesCubit()..getPostsProfile(context)..getAdaptionLikes(context),
      child: BlocConsumer<AdaptionPostesCubit, AdaptionPostesState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return AdaptionPostesCubit.get(context).adaptionPostsProfile.length > 0
              ? Container(
            color: Colors.grey,
            child: ListView.separated(
              itemBuilder: (context, index) => profilePost(
                  AdaptionPostesCubit.get(context).adaptionPostsProfile[index], context,index),
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemCount: AdaptionPostesCubit.get(context).adaptionPostsProfile.length,
            ),
          )
              : Transform.scale(scale: 0.1, child: CircularProgressIndicator(strokeWidth: 30,));
        },
      ),
    );
  }
}