import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/cubit_locations/locations_cubit.dart';
import 'package:pet_hub/Data/Models/locationsModel.dart';

import '../../pets_icons_icons.dart';

class ShopItem extends StatelessWidget {
  Widget shopsWidget(LocationsData shopData, context) =>
      SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Color.fromARGB(250, 243, 243, 243),
              elevation: 0,
              //shadowColor: Colors.black,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        PetsIcons.pet_shop_2___copy,
                        size: 20,
                        color: Color(0xff23424A),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          '${shopData.placeName}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff23424A),
                              fontWeight: FontWeight.bold),
                          //textAlign: TextAlign.left,


                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: 20,
                        color: Color(0xff23424A),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          '${shopData.address}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff23424A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.call_rounded,
                        size: 20,
                        color: Color(0xff23424A),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${shopData.phoneNumber}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff23424A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate,
                        size: 20,
                        color: Color(0xff23424A),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${LocationsCubit.get(context).rates[shopData.rating!]}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff23424A),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationsCubit, LocationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return LocationsCubit.get(context).shops.length > 0
            ? Container(
          color: Color.fromARGB(250, 243, 243, 243),
          child: ListView.separated(
            itemBuilder: (context, index) => shopsWidget(
                LocationsCubit.get(context).shops[index], context),
            separatorBuilder: (context, index) => Divider(
              thickness: 2.0,
            ),
            itemCount: LocationsCubit.get(context).shops.length,
          ),
        )
            : Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(
              strokeWidth: 30,
            ));
      },
    );
  }
}
