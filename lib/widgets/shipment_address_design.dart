import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/model/address.dart';
import 'package:foodrush_selling_app/splashScreen/splash_screen.dart';


class ShipmentAddressDesign extends StatelessWidget {

  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByuser;

  ShipmentAddressDesign({
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByuser
  });

  confirmParcelShipment(BuildContext context, String getOrderID, String sellerId, String purchaserId){
    //send rider to shipment screen

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Padding(
         padding: EdgeInsets.all(10.0),
         child: Text(
            "Shipping Details:",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
       ),
       const SizedBox(
          height: 6,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 0.5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                   const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                      model!.name!
                  ),
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                      "Phone",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                        model!.phoneNumber!
                    ),
                  ]
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amberAccent,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
