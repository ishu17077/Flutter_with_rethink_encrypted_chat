// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe
// @dart=2.9
import 'dart:async';

import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:chat/src/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:chat/src/models/receipt.dart';

import 'package:bloc/bloc.dart';
part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _receiptService;
  StreamSubscription _subscription;

  ReceiptBloc(this._receiptService) : super(ReceiptState.initial());

  @override
  Stream<ReceiptState> mapEventToState(ReceiptEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _receiptService
          .receipts(user: event.user)
          .listen((receipt) => add(_ReceiptReceived(receipt)));
    }

    if (event is _ReceiptReceived) {
      yield ReceiptState.received(event.receipt);
    }
    if (event is ReceiptSent) {
      await _receiptService.send(event.receipt);
      yield ReceiptState.sent(event.receipt);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}
//? super is used to call the constructor of the base class which is Bloc<... , ...> here MessageState.initial() is called to represent that it should be called to initially represent the data, see message_bloc_test.dart file
 //? Follow the if statement carefully if Receipt event is in subscribed state then event.user is asked as Subscribe state has a constructor to ask for a user
  //* if we think that a subscription has been made with a stream with different user, we can essencially just cancel that and make a new subscription with current user