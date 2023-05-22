import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/cupit_app/cubit/app_cubit.dart';
import 'package:pet_hub/Data/Models/userModel.dart';
import 'package:pet_hub/Presentation/Screens/Chat.dart';

import '../../pets_icons_icons.dart';
import 'Notifications.dart';

class ChatMenu extends StatefulWidget {

  static const routeName = 'ChatMenu';
  @override
  State<ChatMenu> createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  bool isSeen=false;
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getallchatsid();
  }

  @override
  Widget build(BuildContext context) {

    Widget chatItem(UserData? model) =>  InkWell(

      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatInside(strangeuser:model),
            ));

        //print(AppCubit.get(context).nobleGases[model?.id]);
      },
      child: Column(
        children: [
          Row(
            children: [
              Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                CircleAvatar(
                  backgroundImage: model?.profileImage!=null?
                  NetworkImage('${model?.profileImage!}'):AssetImage('Images/Group 2.png') as ImageProvider,
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
              ]),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  '${model?.fullName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Center(
            child: Container(
              height: 1,
              width: 300,
              color: Colors.grey,
            ),
          ),
        ],
      ),


    );
    Widget empty()=>Column(
      children: [
         Icon(PetsIcons.vets___copy)
      ],
    );
      return BlocConsumer<AppCubit,AppState>(
        listener: (context, state) {},
        builder:(context, state) {

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'CHATS',
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
            body : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppCubit.get(context).chatUsersData.length==0?
                        empty():
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          var user=AppCubit.get(context).chatUsersData[index];
                          return chatItem(user);
                        },
                        separatorBuilder: (context,index)=>SizedBox(height: 20,),
                        itemCount:AppCubit.get(context).chatUsersData.length,
                    )
                  ],
                ),
              ),
            ),
          );
        } ,
      );
  }
}
