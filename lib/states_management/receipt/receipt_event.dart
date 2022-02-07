// @dart=2.9
// ignore: import_of_legacy_library_into_null_safe, implementation_imports
// ignore: import_of_legacy_library_into_null_safe, implementation_imports
// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports, duplicate_ignore

part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  factory ReceiptEvent.onSubscribed(User user) => Subscribed(user);
  factory ReceiptEvent.onReceiptSent(Receipt receipt) => ReceiptSent(receipt);
  @override
  List<Object> get props => [];
}

class Subscribed extends ReceiptEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final Receipt receipt;
  const ReceiptSent(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class _ReceiptReceived extends ReceiptEvent {
  const _ReceiptReceived(this.receipt);

  final Receipt receipt;

  @override
  List<Object> get props => [receipt];
}
