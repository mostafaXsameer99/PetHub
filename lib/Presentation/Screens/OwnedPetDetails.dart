import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pet_hub/Data/Models/pets_data.dart';

class OwnedPetDetails extends StatefulWidget {
  static const routeName = 'owned_pet_details';
  PetsOwned petsOwned = new PetsOwned();
  String link = "";
  OwnedPetDetails(PetsOwned petsOwned, String link) {
    this.link = link;
    this.petsOwned = petsOwned;
  }
  @override
  State<OwnedPetDetails> createState() => _OwnedPetDetailsState();
}

class _OwnedPetDetailsState extends State<OwnedPetDetails> {
  var _formkeyOD = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff23424A),
          elevation: 0,
        ),
        body: Container(
          height: screenheight,
          width: screenwidth,
          alignment: Alignment.center,
          color: Color(0xff23424A),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formkeyOD,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: screenheight/2,
                      width: screenheight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 7,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.6),
                                offset: Offset(0, 10))
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:  widget.petsOwned.petImage != null
                          ? NetworkImage('${widget.petsOwned.petImage}')
                              : AssetImage('Images/Group 2.png') as ImageProvider,
                      ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Owner Details",
                        style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold, color:Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:screenwidth/2.5 ,
                      width: screenwidth-5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context)
                                .scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 7,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.6),
                                offset: Offset(0, 10))
                          ],
                         ),
                      child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Name: ${widget.petsOwned.ownerName}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          ),
                          SizedBox(height: 10)
                          ,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Address: ${widget.petsOwned.country}   ${widget.petsOwned.state}   ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Contact:  ${widget.petsOwned.ownerContact}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pet Details",
                        style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold, color:Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:screenheight/4 ,
                      width: screenwidth-5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context)
                              .scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 7,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(0, 10))
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: (screenheight/3.5)/14,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Name:  ${widget.petsOwned.petName}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          ),
                          SizedBox(height: (screenheight/5)/14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:  Text(
                              " Age:  ${widget.petsOwned.petAge}  ${widget.petsOwned.petAgeType}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          ),
                          SizedBox(height:  (screenheight/5)/14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:   Text(
                              " Type:  ${widget.petsOwned.petType}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          ),
                          SizedBox(height:  (screenheight/5)/14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:   Text(
                              " Gender:  ${widget.petsOwned.petGander}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(250, 243, 243, 243)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Qr Code",
                        style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color:Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //qr code
                    Container(
                      height: screenwidth - 100,
                      width: screenwidth - 100,
                      decoration: BoxDecoration(
                        //DecorationImage
                        border: Border.all(
                          color: Color(0xff23424A).withOpacity(0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(
                              0.5,
                              0.5,
                            ), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(250, 243, 243, 243),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: BarcodeWidget(
                            data: widget.link,
                            barcode: Barcode.qrCode(),
                            color: Color(0xff23424A),
                            height: double.infinity,
                            width: double.infinity,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
