import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/cupit_app/cubit/app_cubit.dart';
import 'package:pet_hub/Constants/strings.dart';
import 'package:pet_hub/Data/Models/userModel.dart';
import 'package:pet_hub/Presentation/Widgets/Txt.dart';
import 'package:pet_hub/Presentation/Widgets/owned_pets_tab.dart';
import 'package:pet_hub/Presentation/Widgets/profile_image.dart';
import 'package:skeleton_text/skeleton_text.dart';
import '../../Presentation/Screens/editProfile.dart';
import '../Widgets/ProfilePosts.dart';
import 'ChatList.dart';

class Profile extends StatefulWidget {
  static const routeName = 'Profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  UserData loggedInUser = UserData();
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  List<BoxShadow> shadowList = [
    BoxShadow(color: Colors.grey, blurRadius: 30, offset: Offset(0, 10))
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (context, state) {},
       builder: (context,state){
        loggedInUser=AppCubit.get(context).loggedInUser;
        return  Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                elevation: 40,
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.choice.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            backgroundColor: Color(0xff23424A),
          ),
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                //profile image
                ProfileImage(userData: loggedInUser),
                SizedBox(
                  height: 20,
                ),
                //profile Name
               Text(
                  "${loggedInUser.fullName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff23424A),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Container(
                          width: double.maxFinite,
                          height: 100,
                          child: Align(
                            alignment: Alignment.center,
                            child: TabBar(
                              isScrollable: true,
                              labelColor: Color(0xff23424A),
                              indicatorColor: Color(0xff23424A),
                              labelPadding:
                              EdgeInsets.only(left: 35, right: 35),
                              controller: _tabController,
                              tabs: [
                                Tab(text: "Pets"),
                                Tab(text: "About"),
                                Tab(text: "Posts"),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                OwnedPetsTab(user:loggedInUser),
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      //country city state
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 20),
                                        child: Text(
                                          "${loggedInUser.state} , ${loggedInUser.city} , Egypt",
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                            color: Color(0xff23424A),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //Gender
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 20),
                                        child: Txt(txt: "Gender : ${loggedInUser.gender}",size: 17,weight: FontWeight.normal,color: Color(0xff23424A),)
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // BirthDate
                                       Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 20),
                                      child: Txt(txt: AppCubit.get(context).birthDate!,size: 17,weight: FontWeight.normal,color: Color(0xff23424A),)
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: IconButton(
                                                  onPressed: () {
                                                   AppCubit.get(context).openWhatsUp(context,loggedInUser.phoneNumber!);
                                                  },
                                                  icon: Icon(
                                                    Icons.phone,
                                                    color: Colors.green,
                                                    size: 50.0,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 120,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: IconButton(
                                                icon:Icon(Icons.mail,
                                                color: Colors.redAccent,
                                                size: 50.0,),
                                                onPressed: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ChatMenu(),
                                                    )); },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ProfilePosts(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
       });

  }

  Padding loadingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 20),
      child: SkeletonAnimation(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 20,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[200]),
        ),
      ),
    );
  }



  void choiceAction(String choice) {
    if (choice == Constants.logout) {
      AppCubit.get(context).logout(context);
    }
    if (choice == Constants.editProfile) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfilePage(loggedInUser: AppCubit.get(context).loggedInUser),
          ));
    }
  }
}
