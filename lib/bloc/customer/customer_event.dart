part of 'customer_bloc.dart';

//@immutable
sealed class CustomerEvent {}

class AllCustomersEvent extends CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  Customer newCustomer;
  AddCustomerEvent({required this.newCustomer});
}

class UpdateCustomerEvent extends CustomerEvent {
  Customer newCustomer;
  UpdateCustomerEvent({required this.newCustomer});
}

class DeleteCustomerEvent extends CustomerEvent {
  String? customerId;
  DeleteCustomerEvent({this.customerId});
}

class GetCustomerEvent extends CustomerEvent {
  List<Customer>? customerList;
  GetCustomerEvent({this.customerList});
}
