


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pet_hub/Data/Models/locationsModel.dart';


part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(LocationsInitial());

  static LocationsCubit get(context) => BlocProvider.of(context);
  List<String>rates =["NOT Rated","Bad","Average","Good","VeryGood","Excellent"];
  List<LocationsData> clinics = [];
  List<LocationsData> shops = [];
  List<LocationsData> shelters = [];

  void getClinics()  {
    emit(GetClinicDataLoadingState());
    FirebaseFirestore.instance
        .collection('Clinics')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        clinics.add(LocationsData.fromJson(element.data()));
        // postDate="${myFormat.format(AdaptionPostData.postDate!).toString()}";
      });
      emit(GetClinicDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetClinicDataErrorState());
    });

  }

  void getShops()  {
    emit(GetShopDataLoadingState());
    FirebaseFirestore.instance
        .collection('Shops')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        shops.add(LocationsData.fromJson(element.data()));
      });
      emit(GetShopDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetShopDataErrorState());
    });

  }

  void getShelters()  {
    emit(GetShelterDataLoadingState());
    FirebaseFirestore.instance
        .collection('Shelters')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        shelters.add(LocationsData.fromJson(element.data()));
      });
      emit(GetShelterDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetShelterDataErrorState());
    });

  }
}