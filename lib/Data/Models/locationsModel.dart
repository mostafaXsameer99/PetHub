class LocationsData {
  String? placeName;
  String? address;
  String? phoneNumber;
  int? rating;


  LocationsData({
    this.placeName,
    this.address,
    this.phoneNumber,
    this.rating,

  });

  LocationsData.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'];
    address=json['address'];
    phoneNumber=json['phoneNumber'];
    rating=json['rating'];
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'placeName':placeName,
      'address': address,
      'phoneNumber':phoneNumber,
      'rating':rating,
    };
  }
}