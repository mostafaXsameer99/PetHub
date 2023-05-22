import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_hub/Business_Logic/cubit_locations/locations_cubit.dart';
import 'package:pet_hub/Presentation/Widgets/Txt.dart';
import 'package:pet_hub/Presentation/Widgets/clinic_item.dart';
import 'package:pet_hub/Presentation/Widgets/shelters_item.dart';
import 'package:pet_hub/Presentation/Widgets/shop_item.dart';

import 'package:pet_hub/pets_icons_icons.dart';

import 'ChatList.dart';

class PlacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context) => LocationsCubit()..getClinics()..getShelters()..getShops(),
        child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Txt(
            txt: 'PetHub',
            size: 28,
            color: Colors.white,
            family: 'Doggies Silhouette Font',
            weight: FontWeight.bold,
          ),
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
          backgroundColor: Color(0xff23424A),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(PetsIcons.vets___copy),
                text: ("Clinics"),
              ),
              Tab(
                icon: Icon(PetsIcons.shelters_copy),
                text: ("Shelters"),
              ),
              Tab(
                icon: Icon(PetsIcons.pet_shop_2___copy),
                text: ("Shops"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //clinics
            ClinicItem(),
            //shelters
            ShelterItem(),
            //shops
            ShopItem(),
          ],
        ),
      ),
    )
    );
  }
}
