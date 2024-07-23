// ignore_for_file: library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_authentication/add_customer.dart';
import 'package:sqflite_authentication/bloc/customer/customer_bloc.dart';
import 'package:sqflite_authentication/db_helper.dart';
import 'package:sqflite_authentication/map_with_distance.dart';
import 'package:sqflite_authentication/model/customer.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key, this.userName}) : super(key: key);

  final String? userName;

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Customer> allCustomers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer List"),
        leading: const SizedBox(),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CustomerInitial) {
            return SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: state.allCustomers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        tileColor: const Color.fromARGB(255, 255, 232, 240),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: state.allCustomers[index].imageData != null
                              ? Image.memory(
                                  state.allCustomers[index].imageData!,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                )
                              : const CircleAvatar(),
                        ),
                        trailing: PopupMenuButton<int>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.pinkAccent,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<int>(
                              value: 2,
                              child: Text('Location'),
                            ),
                            const PopupMenuItem<int>(
                              value: 3,
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (int value) {
                            if (value == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddCustomer(
                                    customer: state.allCustomers[index],
                                  ),
                                ),
                              );
                            } else if (value == 2) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CustomerMap(
                                    destLat:
                                        state.allCustomers[index].latitude ?? 0,
                                    destLong:
                                        state.allCustomers[index].longitude ??
                                            0,
                                  ),
                                ),
                              );
                            } else if (value == 3) {
                              context.read<CustomerBloc>().add(
                                  DeleteCustomerEvent(
                                      customerId: state
                                          .allCustomers[index].customerId));
                            }
                          },
                        ),
                        title: Text(
                          "${state.allCustomers[index].name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${state.allCustomers[index].mobile}"),
                            Text("${state.allCustomers[index].email}"),
                            Text("${state.allCustomers[index].address}"),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddCustomer(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
