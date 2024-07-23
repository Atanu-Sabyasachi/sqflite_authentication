part of 'customer_bloc.dart';

//@immutable
sealed class CustomerState {}

class CustomerInitial extends CustomerState {
  List<Customer> allCustomers = [];
  CustomerInitial({required this.allCustomers});
}

class AllCustomersState extends CustomerEvent {
  List<Customer>? allCustomers;
  AllCustomersState({this.allCustomers});
}

class AddUserState extends CustomerState {
  List<Customer>? allCustomers;
  AddUserState({this.allCustomers});
}

class DeleteuserState extends CustomerState {
  Customer? customer;
  DeleteuserState({this.customer});
}
