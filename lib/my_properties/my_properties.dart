// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upload_property/my_properties/edit_property.dart';

class MyProperties extends StatefulWidget {
  const MyProperties({super.key});

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  @override
  void initState() {
    super.initState();
    // _getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: CustomScrollView(slivers: [
            const SliverAppBar(
              backgroundColor: Colors.teal,
              centerTitle: true,
              toolbarHeight: 80,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "My Properties",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TabBar(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      isScrollable: true,
                      labelColor: Colors.teal,
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      indicatorColor: Colors.teal,
                      tabs: [
                        // Tab(
                        //   text: "Pending",
                        // ),
                        Tab(
                          text: "Posted",
                        ),
                        Tab(
                          text: "Closed",
                        ),
                        Tab(
                          text: "Inactive",
                        ),
                      ],
                    ),
                    SizedBox(
                      // color: Colors.amber,
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          // TabViewWidget(
                          //   validationStatus: "pending",
                          //   collection: "pending houses",
                          // ),
                          TabViewWidget(
                            validationStatus: "posted",
                            collection: "houses",
                          ),
                          TabViewWidget(
                            validationStatus: "closed",
                            collection: "closed houses",
                          ),
                          TabViewWidget(
                            validationStatus: "inactive",
                            collection: "inactive houses",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

class TabViewWidget extends StatelessWidget {
  TabViewWidget({
    required this.validationStatus,
    required this.collection,
    super.key,
  });
  String validationStatus;
  String collection;
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;
    return SizedBox(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(collection)
              .where("validationStatus", isEqualTo: validationStatus)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var doc = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ((doc[index]['ownerId'].toString())
                                .compareTo(_uid) ==
                            0)
                        ? Card(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      width: 150,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 5,
                                              offset: Offset(0, 3)),
                                          BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-5, 0)),
                                          BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(5, 0)),
                                        ],
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                doc[index]["imageUrls"][0]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    validationStatus != "posted"
                                        ? const Text("")
                                        : TextButton.icon(
                                            onPressed: () {
                                              closed(
                                                  id: doc[index]['id'],
                                                  address: doc[index]
                                                      ['address'],
                                                  price: doc[index]['price'],
                                                  imageUrls: doc[index]
                                                      ['imageUrls'],
                                                  companyName: doc[index]
                                                      ['companyName'],
                                                  category: doc[index]
                                                      ['category'],
                                                  status: doc[index]['status'],
                                                  bedRooms: doc[index]
                                                      ['bedRoom'],
                                                  bathRoom: doc[index]
                                                      ['bathRoom'],
                                                  dateAdded: doc[index]
                                                      ['dateAdded'],
                                                  likes: doc[index]['likes'],
                                                  description: doc[index]
                                                      ['description'],
                                                  ownerName: doc[index]
                                                      ['ownerName'],
                                                  ownerEmail: doc[index]
                                                      ['ownerEmail'],
                                                  ownerImage: doc[index]
                                                      ['ownerImage'],
                                                  area: doc[index]['area'],
                                                  whatFor: doc[index]
                                                      ['whatFor'],
                                                  ownerId: doc[index]
                                                      ['ownerId'],
                                                  validationStatus: "posted");
                                            },
                                            icon: const Icon(
                                              Icons.done_outline,
                                              color: Colors.green,
                                              size: 30,
                                            ),
                                            label: const Text(
                                              "Closed",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Category:  ${doc[index]["category"]}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Area: ${doc[index]['area']} sq ft.",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "For: ${doc[index]['whatFor']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "Price: Birr ${doc[index]['price']}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Status: ${doc[index]['status']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "Location: ${doc[index]['address']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          validationStatus != "posted"
                                              ? const Text("")
                                              : TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EditProperty(
                                                                id: doc[index]
                                                                    ['id'],
                                                                address: doc[index]
                                                                    ['address'],
                                                                price: doc[index]
                                                                    ['price'],
                                                                imageUrls: doc[index][
                                                                    'imageUrls'],
                                                                companyName: doc[index][
                                                                    'companyName'],
                                                                category: doc[index][
                                                                    'category'],
                                                                status: doc[index]
                                                                    ['status'],
                                                                bedRooms: doc[index]
                                                                    ['bedRoom'],
                                                                bathRoom: doc[index]
                                                                    ['bathRoom'],
                                                                dateAdded: doc[index]['dateAdded'],
                                                                likes: doc[index]['likes'],
                                                                description: doc[index]['description'],
                                                                ownerName: doc[index]['ownerName'],
                                                                ownerEmail: doc[index]['ownerEmail'],
                                                                ownerImage: doc[index]['ownerImage'],
                                                                area: doc[index]['area'],
                                                                whatFor: doc[index]['whatFor'],
                                                                ownerId: doc[index]['ownerId'],
                                                                validationStatus: "posted")));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ),
                                                  label: const Text(
                                                    "Edit Post",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                          validationStatus == "closed"
                                              ? const Text("")
                                              : TextButton.icon(
                                                  onPressed: validationStatus !=
                                                          "inactive"
                                                      ? () {
                                                          inActive(
                                                              id: doc[index]
                                                                  ['id'],
                                                              address: doc[index]
                                                                  ['address'],
                                                              price: doc[index]
                                                                  ['price'],
                                                              imageUrls: doc[index]
                                                                  ['imageUrls'],
                                                              companyName:
                                                                  doc[index][
                                                                      'companyName'],
                                                              category: doc[index]
                                                                  ['category'],
                                                              status: doc[index]
                                                                  ['status'],
                                                              bedRooms: doc[index]
                                                                  ['bedRoom'],
                                                              bathRoom: doc[index]
                                                                  ['bathRoom'],
                                                              dateAdded: doc[index]
                                                                  ['dateAdded'],
                                                              likes: doc[index]
                                                                  ['likes'],
                                                              description:
                                                                  doc[index][
                                                                      'description'],
                                                              ownerName: doc[index]
                                                                  ['ownerName'],
                                                              ownerEmail: doc[index]
                                                                  ['ownerEmail'],
                                                              ownerImage: doc[index]['ownerImage'],
                                                              area: doc[index]['area'],
                                                              whatFor: doc[index]['whatFor'],
                                                              ownerId: doc[index]['ownerId'],
                                                              validationStatus: "posted");
                                                        }
                                                      : () {
                                                          activate(
                                                              id: doc[index]
                                                                  ['id'],
                                                              address: doc[index]
                                                                  ['address'],
                                                              price: doc[index]
                                                                  ['price'],
                                                              imageUrls: doc[index]
                                                                  ['imageUrls'],
                                                              companyName:
                                                                  doc[index][
                                                                      'companyName'],
                                                              category: doc[index]
                                                                  ['category'],
                                                              status: doc[index]
                                                                  ['status'],
                                                              bedRooms: doc[index]
                                                                  ['bedRoom'],
                                                              bathRoom: doc[index]
                                                                  ['bathRoom'],
                                                              dateAdded: doc[index]
                                                                  ['dateAdded'],
                                                              likes: doc[index]
                                                                  ['likes'],
                                                              description:
                                                                  doc[index][
                                                                      'description'],
                                                              ownerName: doc[index]
                                                                  ['ownerName'],
                                                              ownerEmail: doc[index]
                                                                  ['ownerEmail'],
                                                              ownerImage: doc[index]['ownerImage'],
                                                              area: doc[index]['area'],
                                                              whatFor: doc[index]['whatFor'],
                                                              ownerId: doc[index]['ownerId'],
                                                              validationStatus: "posted");
                                                        },
                                                  icon: validationStatus !=
                                                          "inactive"
                                                      ? const Icon(
                                                          Icons.block,
                                                          color: Colors.red,
                                                        )
                                                      : const Icon(
                                                          Icons.block,
                                                          color: Colors.orange,
                                                        ),
                                                  label: validationStatus !=
                                                          "inactive"
                                                      ? const Text(
                                                          "Inactive",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : const Text(
                                                          "Activate",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .orange),
                                                        ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : const Center(
                            child: Text(""),
                          );
                  });
            }
            return const Text("something went wrong");
          }),
    );
  }

  void inActive(
      {required id,
      required address,
      required price,
      required imageUrls,
      required companyName,
      required category,
      required status,
      required bedRooms,
      required bathRoom,
      required dateAdded,
      required likes,
      required description,
      required ownerName,
      required ownerEmail,
      required ownerImage,
      required area,
      required whatFor,
      required ownerId,
      required String validationStatus}) async {
    try {
      print(id);
      await FirebaseFirestore.instance
          .collection('inactive houses')
          .doc(id)
          .set({
        'id': id,
        'address': address,
        'price': price,
        'imageUrls': imageUrls,
        'companyName': companyName,
        'category': category,
        'status': status,
        'bedRoom': bedRooms,
        'bathRoom': bathRoom,
        'dateAdded': dateAdded,
        'likes': likes,
        'description': description,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'ownerImage': ownerImage,
        "whatFor": whatFor,
        "area": area,
        "ownerId": ownerId,
        "validationStatus": "inactive",
      });
      // print("inactive sucess");
      await FirebaseFirestore.instance.collection("houses").doc(id).delete();
      print("successss");

      // _globalMethods.showDialogues(context, "Product inactived successfully.");
    } catch (e) {
      print(e);
    }
  }

  void activate(
      {required id,
      required address,
      required price,
      required imageUrls,
      required companyName,
      required category,
      required status,
      required bedRooms,
      required bathRoom,
      required dateAdded,
      required likes,
      required description,
      required ownerName,
      required ownerEmail,
      required ownerImage,
      required area,
      required whatFor,
      required ownerId,
      required String validationStatus}) async {
    try {
      print(id);
      await FirebaseFirestore.instance.collection('houses').doc(id).set({
        'id': id,
        'address': address,
        'price': price,
        'imageUrls': imageUrls,
        'companyName': companyName,
        'category': category,
        'status': status,
        'bedRoom': bedRooms,
        'bathRoom': bathRoom,
        'dateAdded': dateAdded,
        'likes': likes,
        'description': description,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'ownerImage': ownerImage,
        "whatFor": whatFor,
        "area": area,
        "ownerId": ownerId,
        "validationStatus": "posted",
      });
      // print("inactive sucess");
      await FirebaseFirestore.instance
          .collection("inactive houses")
          .doc(id)
          .delete();
      print("successss");

      // _globalMethods.showDialogues(context, "Product inactived successfully.");
    } catch (e) {
      print(e);
    }
  }

  void closed(
      {required id,
      required address,
      required price,
      required imageUrls,
      required companyName,
      required category,
      required status,
      required bedRooms,
      required bathRoom,
      required dateAdded,
      required likes,
      required description,
      required ownerName,
      required ownerEmail,
      required ownerImage,
      required area,
      required whatFor,
      required ownerId,
      required String validationStatus}) async {
    try {
      print(id);
      await FirebaseFirestore.instance.collection('closed houses').doc(id).set({
        'id': id,
        'address': address,
        'price': price,
        'imageUrls': imageUrls,
        'companyName': companyName,
        'category': category,
        'status': status,
        'bedRoom': bedRooms,
        'bathRoom': bathRoom,
        'dateAdded': dateAdded,
        'likes': likes,
        'description': description,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'ownerImage': ownerImage,
        "whatFor": whatFor,
        "area": area,
        "ownerId": ownerId,
        "validationStatus": "closed",
      });
      // print("inactive sucess");
      await FirebaseFirestore.instance.collection("houses").doc(id).delete();
      print("successss");

      // _globalMethods.showDialogues(context, "Product inactived successfully.");
    } catch (e) {
      print(e);
    }
  }
}
