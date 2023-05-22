import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/cupit_app/cubit/app_cubit.dart';
import 'package:pet_hub/Presentation/Screens/ChatList.dart';
import 'package:pet_hub/Presentation/Screens/CreateHostPost.dart';
import 'package:pet_hub/Presentation/Screens/CreateLostPost.dart';
import 'package:pet_hub/Presentation/Screens/Notifications.dart';

import 'package:pet_hub/Presentation/Screens/Sign_Up.dart';
import 'package:pet_hub/Presentation/Screens/Sign_in.dart';
import 'package:pet_hub/Presentation/Screens/Sign_in_out.dart';
import 'package:pet_hub/Presentation/Screens/bottomTabScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_hub/Presentation/Screens/homePage.dart';
import 'package:pet_hub/Presentation/Screens/profilePage.dart';

import 'Constants/strings.dart';
import 'Presentation/Screens/CreateAdoptionPost.dart';
import 'Presentation/Screens/forgotPassword.dart';
import 'Presentation/Screens/verficationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown],);
  var token =await FirebaseMessaging.instance.getToken();
  print ('Token =>>> ${token}');
  // on foreground
  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
  });
  // when click to notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on Message Opened App');
    print(event.data.toString());
  });
  // on background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  Widget? widget;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  uId = prefs.getString('uId');
  print(uId);
  if (uId == null) {
    widget = SignInOut(initialLink: initialLink,);
  } else {
    widget = Verification(initialLink:initialLink);
  }
  runApp(MyApp(widget));
}
class MyApp extends StatelessWidget {
  final Widget? startWidget;
  MyApp(this.startWidget);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserData(),
      child: BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'PetHup',
              theme: ThemeData(
                primarySwatch: Colors.teal,
                //primaryColor: Color(0xff23424A),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              routes: {
                '/': (context) => startWidget!,
                HomePage.routeName: (context) => HomePage(),
                SignInOut.routeName: (context) => SignInOut(),
                SignIn.routeName: (context) => SignIn(),
                SignUp.routeName: (context) => SignUp(),
                TabScreen.routeName: (context) => TabScreen(),
                Profile.routeName: (context) => Profile(),
                Verification.routeName: (context) => Verification(),
                ForgotPassword.routeName: (context) => ForgotPassword(),
                CreateAdaptionPost.routeName: (context) => CreateAdaptionPost(),
                CreateLostPost.routeName: (context) => CreateLostPost(),
                CreateHostPost.routeName: (context) => CreateHostPost(),
                NotificationScreen.routeName:(context)=>NotificationScreen(),
                ChatMenu.routeName: (context) => ChatMenu(),
              },
            );
          }),
    );
  }
}