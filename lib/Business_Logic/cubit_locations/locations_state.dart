
part of 'locations_cubit.dart';

@immutable

abstract class LocationsState {}

class LocationsInitial extends LocationsState {}

class GetClinicDataLoadingState extends LocationsState {}

class GetClinicDataErrorState extends LocationsState {}

class GetClinicDataSuccessState extends LocationsState {}

class GetShopDataLoadingState extends LocationsState {}

class GetShopDataErrorState extends LocationsState {}

class GetShopDataSuccessState extends LocationsState {}

class GetShelterDataLoadingState extends LocationsState {}

class GetShelterDataErrorState extends LocationsState {}

class GetShelterDataSuccessState extends LocationsState {}