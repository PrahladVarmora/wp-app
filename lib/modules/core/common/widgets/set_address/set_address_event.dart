part of 'set_address_bloc.dart';

/// [SetAddressEvent] abstract class is used Event of bloc.
abstract class SetAddressEvent extends Equatable {
  const SetAddressEvent();

  @override
  List<Object> get props => [];
}

/// [SetAddressUser] abstract class is used SetAddress Event
class SetAddressUser extends SetAddressEvent {
  const SetAddressUser({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.placeId,
  });

  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String placeId;

  @override
  List<Object> get props => [address, city, state, country];
}
