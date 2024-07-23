import 'package:bloc/bloc.dart';
import 'package:sqflite_authentication/db_helper.dart';
import 'package:sqflite_authentication/model/customer.dart';
part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial(allCustomers: [])) {
    on<AllCustomersEvent>(_onAllCustomersEvent);
    on<AddCustomerEvent>(_onAddCustomerEvent);
    on<UpdateCustomerEvent>(_onUpdateCustomerEvent);
    on<DeleteCustomerEvent>(_onDeleteCustomerEvent);
  }

  Future<void> _onAllCustomersEvent(
      AllCustomersEvent event, Emitter<CustomerState> emit) async {
    List<Customer> allCustomers = await DBHelper.instance.getAllCustomers();
    emit(CustomerInitial(allCustomers: allCustomers));
  }

  Future<void> _onAddCustomerEvent(
      AddCustomerEvent event, Emitter<CustomerState> emit) async {
    await DBHelper.instance.createCustomer(event.newCustomer);
    List<Customer> allCustomers = await DBHelper.instance.getAllCustomers();
    emit(CustomerInitial(allCustomers: allCustomers));
  }

  Future<void> _onUpdateCustomerEvent(
      UpdateCustomerEvent event, Emitter<CustomerState> emit) async {
    await DBHelper.instance.updateCustomer(event.newCustomer);
    List<Customer> allCustomers = await DBHelper.instance.getAllCustomers();
    emit(CustomerInitial(allCustomers: allCustomers));
  }

  Future<void> _onDeleteCustomerEvent(
      DeleteCustomerEvent event, Emitter<CustomerState> emit) async {
    await DBHelper.instance.removeCustomer(event.customerId.toString());
    List<Customer> allCustomers = await DBHelper.instance.getAllCustomers();
    emit(CustomerInitial(allCustomers: allCustomers));
  }
}
