import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csc_picker/csc_picker.dart';

import '../../Business_Logic/posts_cubit/adaption_postes_cubit.dart';

List gender = ["Male", "Female"];

class CreateAdaptionPost extends StatefulWidget {
  static const routeName = 'create_adoption_post';

  @override
  State<CreateAdaptionPost> createState() => _CreateAdaptionPostState();
}

class _CreateAdaptionPostState extends State<CreateAdaptionPost> {
  var _formKeyA = GlobalKey<FormState>();
  var adoptAgeValue;
  var adoptTypeValue;
  var adoptImageFile;
  var petNameController = TextEditingController();
  var petAgeController = TextEditingController();
  var postDescriptionController = TextEditingController();

  String adoptCountryValue = "Egypt";
  String? adoptStateValue;
  String? adoptCityValue;
  String adoptGenderSelected = "";



  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: Color(0xff23424A),
          value: gender[btnValue],
          groupValue: adoptGenderSelected,
          onChanged: (value) {
            setState(() {
              adoptGenderSelected = value as String;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (BuildContext context) => AdaptionPostesCubit(),
        child: BlocConsumer<AdaptionPostesCubit, AdaptionPostesState>(
          listener: (context, state) {
            if(state is CreateAdaptionPostSuccessState)
              Navigator.of(context).pop();

          },
          builder: (context, state) {

            return Scaffold(

              appBar: AppBar(
                backgroundColor: Color(0xff23424A),
                elevation: 0,
                //back button
                leading: SizedBox(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Color.fromARGB(250, 243, 243, 243),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                //post button
                actions: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                        onPressed: () {
                          if (_formKeyA.currentState!.validate()) {

                            if(AdaptionPostesCubit.get(context).adaptionPosteImage==null){
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: new Text("Please Chose A Photo")));
                            }
                           else if(adoptStateValue==""){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: new Text("Please Chose Your State")));
                            }
                            else if(adoptCityValue==""){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: new Text("Please Chose Your City")));
                            }
                            else if(adoptGenderSelected==""){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: new Text("Please Chose Your Pet,s Gander")));
                            }
                            else{
                            var now = DateTime.now();
                            AdaptionPostesCubit.get(context)
                                .uploadAdaptionpostWithImage(
                                    petNameController.text,
                                    petAgeController.text,
                                    adoptAgeValue,
                                    adoptTypeValue,
                                    adoptStateValue!,
                                    adoptCityValue!,
                                    adoptGenderSelected,
                                    postDescriptionController.text,
                                    now.toLocal(),
                                    context);}

                          }
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(250, 243, 243, 243),
                              fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (_) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10));
                          }),
                        )),
                  ),
                ],
              ),
              body: Container(
                height: screenheight,
                width: screenwidth,
                color: Color.fromARGB(250, 243, 243, 243),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKeyA,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          if (state is CreateAdaptionPostLoadingState)
                            LinearProgressIndicator(),
                          const SizedBox(
                            height: 10,
                          ),
                          //pic
                          if (AdaptionPostesCubit.get(context).adaptionPosteImage == null)
                            InkWell(
                              child: Container(
                                width: 150,
                                height: 150,
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
                                child: Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 50.0,
                                ),
                              ),
                              onTap: () => {
                                AdaptionPostesCubit.get(context).getAdaptionPosteImage()
                              },
                            ),
                          if (AdaptionPostesCubit.get(context).adaptionPosteImage !=
                              null)

                            Stack(children: [
                              Container(
                                width: 130,
                                height: 140,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ],
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            AdaptionPostesCubit.get(context)
                                                .adaptionPosteImage!))),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 80,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        AdaptionPostesCubit.get(context)
                                            .getAdaptionPosteImage();
                                      },
                                    ),
                                  )),
                            ]),
                          const SizedBox(
                            height: 10,
                          ),
                          //pet name
                          Row(
                            children: <Widget>[
                              Text(
                                "Pet Name: ",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff23424A)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: petNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Pet Name is Required';
                                      }
                                      return null;
                                    },
                                    cursorColor: Color(0xff23424A),
                                    decoration: InputDecoration(
                                      hintText: 'Pet Name',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff23424A),
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff23424A),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //pet age
                          Row(
                            children: <Widget>[
                              Text(
                                "Pet Age: ",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff23424A)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: petAgeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Pet Age is Required';
                                      }
                                      return null;
                                    },
                                    cursorColor: Color(0xff23424A),
                                    decoration: InputDecoration(
                                      hintText: 'Pet Age',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff23424A),
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff23424A),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 120,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        color: Color(0xff23424A),
                                        style: BorderStyle.solid,
                                        width: 3.0),
                                  ),
                                  child: DropdownButtonFormField(
                                      value: adoptAgeValue,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Days"),
                                          value: "Days",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Months"),
                                          value: "Months",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Years"),
                                          value: "Years",
                                        )
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          adoptAgeValue = value;
                                        });
                                      },
                                      hint: Text(
                                        "Period",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      style: TextStyle(
                                          color: Color(0xff23424A),
                                          fontSize: 15),
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      iconEnabledColor: Color(0xff23424A),
                                      iconSize: 20,
                                      isExpanded: true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //pet type
                          Row(
                            children: <Widget>[
                              Text(
                                "Pet Type: ",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff23424A)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 200,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                        color: Color(0xff23424A),
                                        style: BorderStyle.solid,
                                        width: 3.0),
                                  ),
                                  child: DropdownButtonFormField(
                                      value: adoptTypeValue,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Dog"),
                                          value: "Dog",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Cat"),
                                          value: "Cat",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Bird"),
                                          value: "Bird",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Fish"),
                                          value: "Fish",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Other"),
                                          value: "Other",
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          adoptTypeValue = value;
                                        });
                                      },
                                      hint: Text("Type"),
                                      style: TextStyle(
                                          color: Color(0xff23424A),
                                          fontSize: 15),
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      iconEnabledColor: Color(0xff23424A),
                                      iconSize: 20,
                                      isExpanded: true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //location
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Location: ",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff23424A))),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //City and state field
                          CSCPicker(
                            showStates: true,
                            showCities: true,
                            flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                            dropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color.fromARGB(250, 243, 243, 243),
                                border: Border.all(
                                    color: Color(0xff23424A), width: 3)),

                            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color.fromARGB(250, 243, 243, 243),
                                border: Border.all(
                                    color: Color(0xff23424A), width: 3)),

                            ///placeholders for dropdown search field
                            countrySearchPlaceholder: "Country",
                            stateSearchPlaceholder: "State",
                            citySearchPlaceholder: "City",

                            ///labels for dropdown
                            countryDropdownLabel: "*Country",
                            stateDropdownLabel: "*State",
                            cityDropdownLabel: "*City",

                            ///Default Country
                            defaultCountry: DefaultCountry.Egypt,

                            ///Disable country dropdown (Note: use it with default country)
                            disableCountry: true,

                            ///selected item style [OPTIONAL PARAMETER]
                            selectedItemStyle: TextStyle(
                              color: Color(0xff23424A),
                              fontSize: 15,
                            ),

                            ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                            dropdownHeadingStyle: TextStyle(
                                color: Color(0xff23424A),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),

                            ///DropdownDialog Item style [OPTIONAL PARAMETER]
                            dropdownItemStyle: TextStyle(
                              color: Color(0xff23424A),
                              fontSize: 15,
                            ),

                            ///Dialog box radius [OPTIONAL PARAMETER]
                            dropdownDialogRadius: 10.0,

                            ///Search bar radius [OPTIONAL PARAMETER]
                            searchBarRadius: 10.0,
                            onCountryChanged: (value) {
                              setState(() {
                                ///store value in country variable
                                adoptCountryValue = value;
                              });
                            },

                            ///triggers once state selected in dropdown
                            onStateChanged: (value) {
                              setState(() {
                                ///store value in state variable
                                adoptStateValue = value;
                              });
                            },

                            ///triggers once city selected in dropdown
                            onCityChanged: (value) {
                              setState(() {
                                ///store value in city variable
                                adoptCityValue = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //gender
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              addRadioButton(0, "Male"),
                              addRadioButton(1, "Female"),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //description
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              controller: postDescriptionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Description is Required';
                                }
                                return null;
                              },
                              maxLines: null,
                              cursorColor: Color(0xff23424A),
                              decoration: InputDecoration(
                                hintText: 'Description....',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff23424A),
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Color(0xff23424A),
                                    width: 3.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
