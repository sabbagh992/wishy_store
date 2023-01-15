import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishy_store/StoreOwner/addNewCategory.dart';
import 'package:wishy_store/StoreOwner/addNewItemToStore.dart';
import 'package:wishy_store/StoreOwner/UploadToStorage.dart';

class StoreOwnerPage extends StatefulWidget {
  static String id = 'StoreOwnerPage';

  @override
  State<StoreOwnerPage> createState() => _StoreOwnerPage();
}

class _StoreOwnerPage extends State<StoreOwnerPage> {
  String? storename;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String imageUrl = '';

  Future getstorename() async {
    await FirebaseFirestore.instance
        .collection('StoreOwners')
        .doc(userId)
        .get()
        .then((value) {
      storename = value.data()!['storeName'];
    });
  }

  @override
  void initState() {
    getstorename();
    // TODO: implement initState
    super.initState();
  }

  File? filevar;
  String? imageURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            //  Menu
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Store',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Column(children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 13,
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card(
                      //   child: SizedBox(
                      //     height: 200,
                      //     child: Image.asset(
                      //       'images/asd.jpeg',
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('StoreOwners')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              Text(
                                snapshot.data!['storeName'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data!['storeType'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        } else {
                          return Text('Loading');
                        }
                      },
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddNewCategory.id);
                      },
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          "Add new category",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddNewItemToStore.id);
                      },
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            "add new item",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        filevar = await Storage.getGalleryImage(image: filevar);
                        imageURL =
                            await Storage.uploadUserImage(image: filevar);

                        await FirebaseFirestore.instance
                            .collection('StoreOwners')
                            .doc(userId)
                            .update({'storeLogo': imageURL});
                        SetOptions(merge: true);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AddLogoForStore()));
                      },
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          "upload store logo",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        filevar = await Storage.getGalleryImage(image: filevar);
                        imageURL =
                            await Storage.uploadUserImage(image: filevar);

                        await FirebaseFirestore.instance
                            .collection('StoreOwners')
                            .doc(userId)
                            .update({'storeCover': imageURL});
                        SetOptions(merge: true);
                      },
                      child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          "upload store cover",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ]),
          ]),
        ],
      ),
    );
  }
}
