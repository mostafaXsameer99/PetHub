import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pet_hub/Presentation/Screens/CreateOwnedPet.dart';
import 'package:pet_hub/pets_icons_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ChatList.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {

  var qrstr="";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qr Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            fontFamily: 'Doggies Silhouette Font',
          ),
        ),
        backgroundColor: Color(0xff23424A),
        actions: [
          IconButton(icon:Icon(Icons.chat_rounded,),onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMenu(),
                )); },
          ),
          SizedBox(width: 10,),
        ],
        elevation: 5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:screenWidth/2 ,
              width: screenWidth/2,
              child: ElevatedButton(
                style:ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Color(0xff23424A)),
                ),
                onPressed: (){
                  scanQr();
                },
                child: Image(image:AssetImage('Images/scan.png')),
              ),
            ),
            SizedBox(height:screenHeight/17 ,),
            Container(
              height: screenWidth/2,
              width: screenWidth/2,
              child: ElevatedButton(
                style:ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Color(0xff23424A)),
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateOwnedPet(),
                      ));
                },
                child: Image(image:AssetImage('Images/add new pet.png')),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future <void>scanQr()async{
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        setState(() {
          qrstr=value;
          launch(qrstr);
        });
      });
    }catch(e){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text('unable to read this'),backgroundColor: Colors.red,));
      });
    }
  }
}
