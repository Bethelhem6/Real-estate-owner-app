import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProperties extends StatefulWidget {
  const MyProperties({super.key});

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  String _uid = "";
  String _name = "";
  String _email = "";
  String _image = "";

  void _getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    setState(() {
      _name = userDocs.get('name');
      _email = userDocs.get('email');
      _image = userDocs.get('image');
    });
  }

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
                      height: 700,
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
                            collection: "colsed houses",
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
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
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
                                          TextButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.edit),
                                            label: const Text("Edit Post"),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.block,
                                              color: Colors.orange,
                                            ),
                                            label: const Text(
                                              "Inactive",
                                              style: TextStyle(
                                                  color: Colors.orange),
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
}
