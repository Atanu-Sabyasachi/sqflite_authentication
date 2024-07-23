// // ignore_for_file: library_private_types_in_public_api, avoid_print

// ignore_for_file: avoid_print, must_be_immutable, library_private_types_in_public_api

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_authentication/auth_form_field.dart';
import 'package:sqflite_authentication/bloc/customer/customer_bloc.dart';
import 'package:sqflite_authentication/customer_list.dart';
import 'package:sqflite_authentication/db_helper.dart';
import 'package:sqflite_authentication/model/customer.dart';
import 'package:uuid/uuid.dart';

class AddCustomer extends StatefulWidget {
  AddCustomer({
    Key? key,
    this.customer,
  }) : super(key: key);
  Customer? customer;

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  String? imagePath;
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      editCustomer();
    }
  }

  editCustomer() {
    setState(() {
      nameController.text = widget.customer?.name.toString() ?? '';
      mobileController.text = widget.customer?.mobile.toString() ?? '';
      emailController.text = widget.customer?.email.toString() ?? '';
      addressController.text = widget.customer?.address ?? '';
      latitudeController.text = widget.customer?.latitude.toString() ?? '';
      longitudeController.text = widget.customer?.longitude.toString() ?? '';
      imagePath = widget.customer?.imagePath ?? '';
    });
  }

  Future<void> saveImageToDatabase(
      String imageName, Uint8List imageBytes) async {
    try {
      await DBHelper.instance.saveImage(imageName, imageBytes);
      print('Image saved successfully');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        Uint8List imageBytes = await imageFile.readAsBytes();

        setState(() {
          imagePath = pickedFile.path;
          imageData = imageBytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddress(Position position) async {
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        addressController.text =
            "${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country}, ${placemark[0].postalCode}";
      });
    } catch (e) {
      print(e);
    }
    // addressController.text = placemark;
  }

  @override
  void dispose() {
    //_nameController.dispose();
    // dispose other controllers...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is AddUserState) {
          // Handle customer added state
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer added successfully!')),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Customer'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: imagePath != null || imagePath!.isNotEmpty
                            ? Image.file(
                                File(imagePath!),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : const CircleAvatar(),
                      ),
                    const SizedBox(height: 15.0),
                    SizedBox(
                      height: 50,
                      // width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.pinkAccent),
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => 0)),
                        onPressed: _pickImage,
                        child: const Icon(
                          Icons.image_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        // child: const Text(
                        //   "Select Image",
                        //   style: TextStyle(color: Colors.white, fontSize: 16),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    AuthFormField(
                      keyboardtype: TextInputType.name,
                      title: "Customer Name",
                      hintText: "Customer Name",
                      controller: nameController,
                      //keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthFormField(
                      title: "Phone No.",
                      hintText: "Phone No.",
                      controller: mobileController,
                      keyboardtype: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a valid number";
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "Please enter a valid phone number";
                        } else if (value.length != 10) {
                          return "Please enter 10 digit phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthFormField(
                      title: "Email",
                      hintText: "E-Mail",
                      controller: emailController,
                      keyboardtype: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email address";
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.pinkAccent),
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => 0)),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );

                          try {
                            Position position = await _determinePosition();
                            print(position.longitude);
                            getAddress(position);

                            latitudeController.text =
                                position.latitude.toString();
                            longitudeController.text =
                                position.longitude.toString();
                          } catch (e) {
                            print(e);
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    AuthFormField(
                      title: "Address",
                      hintText: "Address",
                      controller: addressController,
                      keyboardtype: TextInputType.streetAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthFormField(
                      title: "Longitude",
                      hintText: "Longitude",
                      controller: longitudeController,
                      keyboardtype: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter longitude";
                        } else if (!RegExp(r'^[0-9 .]+$').hasMatch(value)) {
                          return "Please enter a valid longitude";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthFormField(
                      title: "Latitude",
                      hintText: "Latitude",
                      controller: latitudeController,
                      keyboardtype: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter latitude";
                        } else if (!RegExp(r'^[0-9 .]+$').hasMatch(value)) {
                          return "Please enter a valid latitude";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.pinkAccent),
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => 0)),
                        onPressed: () {
                          if (imageData != null) {
                            if (_formKey.currentState!.validate()) {
                              Customer newCustomer = Customer(
                                customerId: const Uuid().v4(),
                                imageData: imageData,
                                imagePath: imagePath,
                                name: nameController.text,
                                email: emailController.text,
                                mobile: mobileController.text,
                                address: addressController.text,
                                longitude:
                                    double.parse(longitudeController.text),
                                latitude: double.parse(latitudeController.text),
                              );
                              if (widget.customer == null) {
                                context.read<CustomerBloc>().add(
                                    AddCustomerEvent(newCustomer: newCustomer));
                              } else {
                                context.read<CustomerBloc>().add(
                                    UpdateCustomerEvent(
                                        newCustomer: newCustomer));
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const CustomerList();
                                  },
                                ),
                              );
                            }
                          } else {
                            print("image null");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Select image !'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: Text(
                          widget.customer != null ? "Update" : "Add",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
