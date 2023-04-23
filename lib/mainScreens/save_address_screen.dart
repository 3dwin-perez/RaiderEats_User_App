import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:raidereats_users_app/global/global.dart';
import 'package:raidereats_users_app/models/address.dart';
import 'package:raidereats_users_app/widgets/simple_app_bar.dart';
import 'package:raidereats_users_app/widgets/text_field.dart';


class SaveAddressScreen extends StatelessWidget

{
  final _name  = TextEditingController();
  final _phoneNumber  = TextEditingController();
  final _flatNumber  = TextEditingController();
  final _city  = TextEditingController();
  final _state  = TextEditingController();
  final _completeAddress  = TextEditingController();
  final _locationController  = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;


  getUserLocationAddress() async
  {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    position = newPosition;

    placemarks = await placemarkFromCoordinates(
        position!.latitude, position!.longitude
    );
    Placemark pMark = placemarks![0];

    String fullAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "RaiderEats",),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save Now"),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.save, color: Colors.white,),
        onPressed: ()
        {
          // save address info
          if(formKey.currentState!.validate())
          {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();
            
            FirebaseFirestore.instance.collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model).then((value)
            {
              Fluttertoast.showToast(msg: "New Address has been saved. ");
              formKey.currentState!.reset();
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(height: 6,),
             Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save New Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            ListTile(
              leading:  Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style:  TextStyle(
                    color: Colors.black
                  ),
                  controller: _locationController,
                    decoration:  InputDecoration(
                      hintText: "Whats your address?",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      )
                    ),
                ),
              ),
            ),

             SizedBox(height: 10,),

            ElevatedButton.icon(
              label:  Text(

                  "Get my Location",

                style: TextStyle(color: Colors.white,)
              ),
              icon: const Icon(Icons.location_on, color: Colors.white,),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.red),

                  ),
                ),
              ),
              onPressed: ()
              {

                  //getCuurentLocationWithAddress
                getUserLocationAddress();

              },



            ),

            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: 'Phone Number',
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: 'City',
                    controller: _city,
                  ),
                  MyTextField(
                    hint: 'State / Country',
                    controller: _state,
                  ),
                  MyTextField(
                    hint: 'Address Line',
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: 'Complete Address',
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
