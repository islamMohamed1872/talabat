import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/modules/cart/cubit/cart_states.dart';

class CartCubit extends Cubit<CartStates>{
  CartCubit():super(CartInitialState());
  static CartCubit get(context) => BlocProvider.of(context);

  var noteController = TextEditingController();
}