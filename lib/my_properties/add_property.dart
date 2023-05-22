// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class House {
  final String id;
  final String whatFor;
  final String address;
  final String companyName;
  final String category;
  final String status;
  final int bedRooms;
  final int bathRoom;
  final String ownerId;

  final int area;
  final String dateAdded;
  final int likes;
  final String description;
  final String ownerName;
  final String ownerImage;
  final String ownerEmail;
  final String validationStatus;

  final int price;
  final List<dynamic> imageUrls;

  House({
    required this.validationStatus,
    required this.ownerId,
    required this.id,
    required this.area,
    required this.whatFor,
    required this.address,
    required this.price,
    required this.imageUrls,
    required this.companyName,
    required this.category,
    required this.status,
    required this.bedRooms,
    required this.bathRoom,
    required this.dateAdded,
    required this.likes,
    required this.description,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerImage,
  });

  Map<String, dynamic> toMap() {
    return {
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
      "validationStatus": validationStatus,
    };
  }
}

class AddHouseScreen extends StatefulWidget {
  // final String? id;
  // final String? whatFor;
  // final String? address;
  // final String? companyName;
  // final String? category;
  // final String? status;
  // final int? bedRooms;
  // final int? bathRoom;
  // final String? ownerId;

  // final int? area;
  // final String? dateAdded;
  // final int? likes;
  // final String? description;
  // final String? ownerName;
  // final String? ownerImage;
  // final String? ownerEmail;
  // final String? validationStatus;

  // final int? price;
  // final List<dynamic>? imageUrls;

  const AddHouseScreen({
    super.key,
    // this.id,
    // this.whatFor,
    // this.address,
    // this.companyName,
    // this.category,
    // this.status,
    // this.bedRooms,
    // this.bathRoom,
    // this.ownerId,
    // this.area,
    // this.dateAdded,
    // this.likes,
    // this.description,
    // this.ownerName,
    // this.ownerImage,
    // this.ownerEmail,
    // this.validationStatus,
    // this.price,
    // this.imageUrls
  });

  @override
  _AddHouseScreenState createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  var _addressController = "";
  var _priceController = 0;

  var _companyNameController = "";
  var _areaController = 0;
  var _statusController = "";
  var _bedRoomController = 0;
  var _bathRoomController = 0;
  var _descriptionController = "";

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<File> _selectedImages = [];
  CollectionReference housesCollection =
      FirebaseFirestore.instance.collection('houses');
  var _url;
  XFile? imgXFile;

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

  String category = "Villa";
  List<DropdownMenuItem<String>> get categories {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Villa", child: Text("Villa")),
      const DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
      const DropdownMenuItem(value: "Real estate", child: Text("Real estate")),
      const DropdownMenuItem(value: "Condominium", child: Text("Condominium")),
    ];
    return menuItems;
  }

  String whatFor = 'Rent';
  List<DropdownMenuItem<String>> get options {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Rent", child: Text("Rent")),
      const DropdownMenuItem(value: "Sell", child: Text("Sell")),
    ];
    return menuItems;
  }

  String status = 'Finished';
  List<DropdownMenuItem<String>> get statuses {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Finished", child: Text("Finished")),
      const DropdownMenuItem(
          value: "Half-finished", child: Text("Half-finished")),
      // const DropdownMenuItem(value: "Half-finished", child: Text("Half-finished")),
    ];
    return menuItems;
  }

  // TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(File(pickedImage.path));
      });
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('houses/${housesCollection.id}/$imageName');
      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<void> _uploadHouse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var uuid = const Uuid();
      String houseId = uuid.v4();
      final String address = _addressController;
      final int price = _priceController;
      final String companyName = _companyNameController;
      final int area = _areaController;
      // final String status = _statusController;

      final int bedRooms = _bedRoomController;

      final int bathRoom = _bathRoomController;
      final String description = _descriptionController;

      const int likes = 0;
      var date = DateTime.now().toString();
      var parsedDate = DateTime.parse(date);
      final String dateAdded =
          '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

      List<String> imageUrls = await _uploadImages(_selectedImages);

      House house = House(
          id: houseId,
          address: address,
          price: price,
          imageUrls: imageUrls,
          companyName: companyName,
          category: category,
          status: status,
          bedRooms: bedRooms,
          bathRoom: bathRoom,
          dateAdded: dateAdded,
          likes: likes,
          description: description,
          ownerName: _name,
          ownerEmail: _email,
          ownerImage: _image,
          area: area,
          whatFor: whatFor,
          ownerId: _uid,
          validationStatus: "posted");

      try {
        await housesCollection.add(house.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('House uploaded successfully')),
        );
        _addressController = '';
        _priceController = 0;
        _bathRoomController = 0;
        _bedRoomController = 0;
        _areaController = 0;
        _companyNameController = '';
        _statusController = '';
        _descriptionController = '';

        setState(() {
          _selectedImages.clear();
          _isLoading = false;
        });
        // Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload house')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // // backgroundColor: Colors.teal[100],
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      //   toolbarHeight: 70,
      //   title: const Text(
      //     'Upload House',
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomRight: Radius.circular(20),
      //         bottomLeft: Radius.circular(20)),
      //   ),
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // const

                  Expanded(
                    child: TextFormField(
                      // initialValue: widget.companyName,
                      decoration: const InputDecoration(
                        labelText: 'Real estate company',
                        prefixIcon: Icon(Icons.real_estate_agent_outlined,
                            color: Colors.green),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _companyNameController = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                          child: DropdownButton(
                        value: category,
                        onChanged: (String? newValue) {
                          setState(() {
                            category = newValue!;
                          });
                        },
                        items: categories,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: DropdownButton(
                        value: whatFor,
                        onChanged: (String? newValue) {
                          setState(() {
                            whatFor = newValue!;
                          });
                        },
                        items: options,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                            // initialValue: widget.address,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              prefixIcon: Icon(Icons.location_on_outlined,
                                  color: Colors.purple),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter location of property';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _addressController = value;
                              });
                            }),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                            // initialValue: widget.price.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixIcon: Icon(Icons.money, color: Colors.teal),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter property price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _priceController = int.parse(value);
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            // initialValue: widget.bedRooms.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Bed rooms',
                              prefixIcon:
                                  Icon(Icons.bed_outlined, color: Colors.black),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter how many bed rooms it has.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _bedRoomController = int.parse(value);
                              });
                            }),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                            // initialValue: widget.bathRoom.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Bath rooms',
                              prefixIcon: Icon(Icons.shower_outlined,
                                  color: Colors.blue),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter how many bath rooms it has.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _bathRoomController = int.parse(value);
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: TextFormField(
                        // initialValue: widget.description,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description_outlined,
                              color: Colors.blueGrey),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter short description about the property';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _descriptionController = value;
                          });
                        }),
                  ),
                  const SizedBox(height: 16.0),

                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: DropdownButton(
                          value: status,
                          onChanged: (String? newValue) {
                            setState(() {
                              status = newValue!;
                            });
                          },
                          items: statuses,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                            // initialValue: widget.area.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Area',
                              prefixIcon: Icon(Icons.area_chart_outlined,
                                  color: Colors.pink),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter property size';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _areaController = int.parse(value);
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // const
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    color: Colors.teal,
                    onPressed: _selectImage,
                    child: const Text(
                      'Select Images',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: _selectedImages.map((image) {
                        return Image.file(image);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  MaterialButton(
                    minWidth: 200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    color: Colors.teal,
                    onPressed: _uploadHouse,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Upload',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
