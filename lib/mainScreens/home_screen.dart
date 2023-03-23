import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodrush_selling_app/global/global.dart';
import 'package:foodrush_selling_app/model/menus.dart';
import 'package:foodrush_selling_app/uploadScreens/menu_upload_screen.dart';
import 'package:foodrush_selling_app/widgets/sellers_design.dart';
import 'package:foodrush_selling_app/widgets/my_drawer.dart';
import 'package:foodrush_selling_app/widgets/progress_bar.dart';
import 'package:foodrush_selling_app/widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.amberAccent,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
            sharedPreferences!.getString("name")!,
          style: const TextStyle(
              fontSize: 25,
              fontFamily: "Lobster",
              color: Colors.black54,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add, color: Colors.black54,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => MenuUploadScreen()));
            },
          )
        ],
      ),

      body: CustomScrollView(
        slivers: [
          //Text(data),
         SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid")!)
                .collection("menus").orderBy("publishedDate", descending: true).snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Menus model = Menus.fromjson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return SellersDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          )
        ],
      ),
    );
  }
}
