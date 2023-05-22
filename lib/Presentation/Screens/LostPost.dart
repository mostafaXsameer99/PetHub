import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/posts_cubit/lost_postes_cubit.dart';
import 'package:pet_hub/Data/Models/lostPostsModel.dart';
import 'package:pet_hub/Presentation/Screens/profilePage.dart';
import '../../Business_Logic/cupit_app/cubit/app_cubit.dart';
import '../../Constants/strings.dart';
import '../../Constants/timeAgo.dart';
import '../../Data/Models/comments.dart';
import '../../pets_icons_icons.dart';
import 'StrangeUserProfile.dart';

class LostPost extends StatefulWidget {
  static const routeName = 'LostPost';
  final LostPostData postdetails;
  final int index;
  final String postId;
  const LostPost({Key? key, required this.postdetails ,required this.index, required this.postId}) : super(key: key);
  @override
  _LostPostState createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  var heartclicked = true;
  bool isReadMore = false;
  var userComment = TextEditingController();
  //var formKey=GlobalKey<FormState>();
  Widget buildText(String text) {
    final lines = isReadMore ? null : 6;
    return Text(
      text,
      maxLines: lines,
      overflow: isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
      style: TextStyle(
        color: Color(0xff23424a),
        fontSize: 15,
      ),
    );
  }

  Widget comment(Comments comment, BuildContext context) => BlocConsumer<LostPostesCubit, LostPostesState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    double screenWidth = MediaQuery.of(context).size.width;
    Timestamp myTimeStamp = Timestamp.fromDate(comment.commentDate!);
    return Container(
    decoration: BoxDecoration(
      border: Border.all(
        width: 1,
        color: Colors.grey,
      ),
      //color: Colors.grey,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              if(comment.id==uId){
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
                      builder: (context) =>UserProfile(userId: comment.id)
                      ,
                    ));
              }
            },
            child: CircleAvatar(
              backgroundImage: comment.ProfileImage!=null?
              NetworkImage('${comment.ProfileImage}'):AssetImage('Images/Group 2.png') as ImageProvider,
              backgroundColor: Colors.white,
              radius: 20,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(comment.id==uId){
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
                                builder: (context) =>UserProfile(userId: comment.id)
                                ,
                              ));
                        }
                      },
                      child: Text(
                        '${comment.fullName}',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth/4,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${TimeAgo.timeago(myTimeStamp.millisecondsSinceEpoch)}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    Text(
                      '${comment.commentDescription}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  },
);

  @override
  Widget build(BuildContext context) {

     return BlocProvider(
  create: (context) => LostPostesCubit()..getlostPosts(context)..getComments(widget.postId)..getLostLikes(context),
  child: BlocConsumer<LostPostesCubit, LostPostesState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    String postid=widget.postId;
    var contain = LostPostesCubit.get(context).likesState.where((element) => element.postId == postid && element.userId==AppCubit.get(context).loggedInUser.id) ;
    Timestamp myTimeStamp = Timestamp.fromDate(widget.postdetails.postDate!);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Lost',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
              fontFamily: 'Doggies Silhouette Font',
            ),
          ),

          centerTitle: true,
          backgroundColor: Color(0xff23424A),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2
                      ,child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>UserProfile(userId: widget.postdetails.id)
                                  ,
                                ));
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage('${widget.postdetails.profileImage }'),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>UserProfile(userId: widget.postdetails.id)
                                      ,
                                    ));
                              },
                              child: Text(
                                '${widget.postdetails.fullName }',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${TimeAgo.timeago(myTimeStamp.millisecondsSinceEpoch)}',
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic
                              ),

                            )
                          ],
                        ),
                      ],
                    ),
                    ),
                    Flexible(
                      flex: 1
                      ,child: Row(
                      children: [
                        if(contain.isNotEmpty)
                          IconButton(
                            icon: Icon(
                                PetsIcons.heart__2_,

                                color: Colors.red),

                            onPressed: () {
                              LostPostesCubit.get(context).dislikeLostPosts(widget.postId,context);
                              setState(() {

                                LostPostesCubit.get(context).getLostLikes(context);
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
                              LostPostesCubit.get(context).likeLostPosts(widget.postId,context);
                              setState(() {

                                LostPostesCubit.get(context).getLostLikes(context);


                              });
                            },
                          ),
                        if(LostPostesCubit.get(context).map_name[postid]!=null)
                          Text(
                              '${LostPostesCubit.get(context).map_name[postid]}'
                          ),
                        if(uId==widget.postdetails.id)
                          IconButton(onPressed: (){
                            LostPostesCubit.get(context).deletePost(widget.postdetails, widget.postId,context);
                          }, icon: Icon(Icons.delete_forever,color: Colors.red,size: 30,))
                      ],
                    ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Image(
                  image: NetworkImage('${widget.postdetails.postImage }'),
                  //fit: BoxFit.fill,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: Color(0xff65a9a6),
                ),
                height: 50,
                alignment: AlignmentDirectional.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.postdetails.petName }',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Table(
                columnWidths: {0: FixedColumnWidth(120), 1: FlexColumnWidth(1)},
                border: TableBorder(
                    horizontalInside: BorderSide(width: 1, color: Colors.grey)),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Pet Type',
                          style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${widget.postdetails.petType}',
                        style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Gender',
                          style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${widget.postdetails.petGander }',
                        style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Age',
                          style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${widget.postdetails.petAge }'+'  ${widget.postdetails.petAgeType}',
                        style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Last Location',
                          style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                          '${widget.postdetails.city }',
                        style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Prize',
                          style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${widget.postdetails.prize }',
                        style: TextStyle(
                            color: Color(0xff23424A),
                            fontSize: 20.0,
                            ),
                      ),
                    )
                  ]),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    buildText(
                      '${widget.postdetails.postDescription }',
                    ),
                    !isReadMore && (widget.postdetails.postDescription!.length > 100)
                        ? Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isReadMore = !isReadMore;
                          });
                        },
                        child: Text(
                          (isReadMore ? 'Read Less' : 'Read More'),
                          style: TextStyle(
                              color: Color(0xff23424a),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: isReadMore
                              ? Colors.grey.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          padding: isReadMore
                              ? const EdgeInsets.symmetric(vertical: 50)
                              : const EdgeInsets.symmetric(vertical: -20),
                        ),
                      ),
                    )
                        : SizedBox(
                      width: 0,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 120,
                ),
                child: ListView.separated(
                    itemBuilder: (context, index) => comment(
                        LostPostesCubit.get(context).comments[index],context
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 1,
                        ),
                    itemCount: LostPostesCubit.get(context).comments.length),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: userComment,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Type Comment ......',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          /*border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.grey,width: 1)
                          )*/
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          var now = DateTime.now();
                          LostPostesCubit.get(context).addComment(
                              widget.postId,
                              userComment.text,
                              now.toLocal(),
                              context);
                          userComment.clear();
                        },
                        child: Icon(Icons.arrow_forward_ios_rounded),
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  },
),
);
  }
}
