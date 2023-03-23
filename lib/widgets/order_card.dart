import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/mainScreens/order_detials_screen.dart';
import 'package:foodrush_selling_app/model/items.dart';

class OrderCard extends StatelessWidget {

  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;

  OrderCard({
    this.data,
    this.itemCount,
    this.orderID,
    this.separateQuantitiesList
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailsScreen(orderID: orderID)));
      },
      child: Container(
        decoration: const BoxDecoration(

            borderRadius: BorderRadius.all(
                Radius.circular(15.0)), // Set rounded corner radius
            //boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
            color: Colors.white,
            
            /*gradient: LinearGradient(
              /*begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.01,
                0.04,
                0.5,
                0.9,
              ],
              colors: [
                Colors.red,
                Colors.redAccent,
                Colors.amber,
                Colors.teal,
              ],*/
              colors: Colors.white,


              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )*/
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        //height: MediaQuery.of(context).size.height,

        //height: 400,
        child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Items model = Items.fromJson(data![index].data()! as Map<String, dynamic>);
            return placedOrderDesignWidget(model, context, separateQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(Items model, BuildContext context, separateQuantitiesList){
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Colors.grey[380],
    child: Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
          ),
          child:
          ClipRRect(
            borderRadius:  BorderRadius.circular(15.0),
             child:Image.network(model.thumbnailURL!, width: 100,),
          )
        ),

        const SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Text(
                        model.title!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontFamily: "Acme",
                        ),
                      ),
                  ),
                 const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "GH₵ ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    )
                  ),
                  Text(
                    model.price.toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                 const Text(
                    "X",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14
                    ),
                  ),
                  Expanded(
                      child: Text(
                        separateQuantitiesList,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontFamily: "Acme",
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}