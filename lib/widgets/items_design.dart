import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodrush_selling_app/mainScreens/item_detail_screen.dart';
import '../model/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({
    this.model,
    this.context
  });

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: Colors.grey.shade200),
                //boxShadow:  const [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
              ),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child:Image.network(
                      widget.model!.thumbnailURL!,
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ) ,
                  ),
                  Expanded(
                      child: Text(
                        widget.model!.title!,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontFamily: "Train",
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),

                  /*Expanded(
                      child:Text(
                        widget.model!.shortInfo!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),*/

                  const SizedBox(height: 10,),
                  Expanded(
                      child: Text(
                        widget.model!.longDescription!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontFamily: "Train",
                        ),
                        textAlign: TextAlign.start,
                      ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
