import 'package:equatable/equatable.dart';
import 'package:first_class_canine_demo/Modal/ProductModal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBLOC extends Bloc<ProductEvents, ProductBlocState> {
  ProductBLOC() : super(ProductNotLoadedYet());

  @override
  Stream<ProductBlocState> mapEventToState(ProductEvents event) async* {
    if (event is UiLoadedEvent) {
      yield ProductNotLoadedYet();
      var data = await ProductData().getData();
      var servicedata = await ProductData().getServiceData();
      yield DataLoaded(data, servicedata);
    }
  }
}

//Events
class ProductEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class UiLoadedEvent extends ProductEvents {
  @override
  List<Object?> get props => [];
}

//States
class ProductBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductNotLoadedYet extends ProductBlocState {
// waiting for data and showing progress
}

class DataLoaded extends ProductBlocState {
  final List<ServiceModal> servicedata;
  final List<ProductModal> data;

  DataLoaded(this.data, this.servicedata);
}

class ProductFoundErrors extends ProductBlocState {
// render the ui with errors
}
