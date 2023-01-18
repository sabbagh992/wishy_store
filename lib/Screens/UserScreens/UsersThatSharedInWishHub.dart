import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wishy_store/Screens/UserScreens/WishlistsPage.dart';

class UsersThatSharedInWishHub extends StatefulWidget {
  String? userEmail;

  UsersThatSharedInWishHub({
    this.userEmail,
  });

  static String id = 'thatOneUser';

  @override
  State<UsersThatSharedInWishHub> createState() =>
      _UsersThatSharedInWishHubState(
        userEmail: userEmail,
      );
}

class _UsersThatSharedInWishHubState extends State<UsersThatSharedInWishHub> {
  String? userEmail;
  _UsersThatSharedInWishHubState({this.userEmail});

  String? userId;

  List<String> wishlistNames = [];
  List<String> wishlistTypes = [];
  List<String> wishlistDescriptions = [];

  Map wishlistData = {};
  void getWishlistsByEmail() {
    FirebaseFirestore wishlist = FirebaseFirestore.instance;
    wishlist
        .collection('wishlists')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .asStream()
        .toList()
        .then((value) {
      value.forEach((element) {
        wishlistData = element.data() as Map;

        wishlistData['sharedWishlistsFromUsers'][userEmail]
            .forEach((key, value) {
          if (key == 'userId') {
            userId = value;
          } else if (key == 'wishlistOwnerEmail') {
            print('wishlistOwnerEmail: $value');
          } else {
            wishlistNames.add(key);
            wishlistTypes.add(value['wishlistType']);
            wishlistDescriptions.add(value['wishlistDescription']);
          }
          // if (key == userEmail) {
          //   print('wishlistName: $key');
          //   print('wishlistData: $value');
          // }
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkIftheresWishlists();
    getWishlistsByEmail();
  }

  CollectionReference wlists =
      FirebaseFirestore.instance.collection('wishlists');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                EvaIcons.arrowBack,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Shared Wishlists',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: wlists.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                if (data['sharedWishlistsFromUsers'][userEmail].length == 0) {
                  return Center(
                    child: Text(
                      'No Shared Wishlists',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      ListView.builder(
                          itemCount: wishlistNames.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              tileColor: Color.fromARGB(255, 120, 114, 186),
                              title: Text(
                                wishlistNames[index],
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                wishlistTypes[index],
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              leading: Icon(
                                EvaIcons.giftOutline,
                                color: Colors.black87,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return AlertDialog(
                                  //         title: Text(
                                  //             'Are you sure you want to delete your friend wishlist?'),
                                  //         content: Row(
                                  //           children: [
                                  //             DialogButton(
                                  //               color: Color(0xFF5E57A5),
                                  //               onPressed: () {
                                  //                 setState(() {
                                  //                   FirebaseFirestore wishlist =
                                  //                       FirebaseFirestore
                                  //                           .instance;
                                  //                   final docref = wishlist
                                  //                       .collection('wishlists')
                                  //                       .doc(FirebaseAuth
                                  //                           .instance
                                  //                           .currentUser!
                                  //                           .uid);
                                  //                   docref.update({
                                  //                     'sharedWishlistsFromUsers.$userEsadsadmail.$wishlistNames[index]{':
                                  //                         FieldValue
                                  //                             .delete()
                                  //                   });
                                  //                   SetOptions(merge: true);
                                  //                   // checkIftheresWishlists();
                                  //                   // Navigator.pop(context);
                                  //                 });
                                  //               },
                                  //               child: Text(
                                  //                 "Yes",
                                  //                 style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontSize: 20),
                                  //               ),
                                  //             ),
                                  //             DialogButton(
                                  //               color: Color(0xFF5E57A5),
                                  //               onPressed: () =>
                                  //                   Navigator.pop(context),
                                  //               child: Text(
                                  //                 "Cancel",
                                  //                 style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontSize: 20),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     });
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WishlistPage(
                                      isSharedUser: true,
                                      wishlistName: wishlistNames[index],
                                      wishlistType: wishlistTypes[index],
                                      uid: userId,
                                      wishlistDescription:
                                          wishlistDescriptions[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          })),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }
              }

              return Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }
}
