part of 'set_address_bloc.dart';

/// [SetAddressState] abstract class is used SetAddress State
abstract class SetAddressState extends Equatable {
  const SetAddressState();

  @override
  List<Object> get props => [];
}

/// [SetAddressInitial] class is used SetAddress State Initial
class SetAddressInitial extends SetAddressState {}

/// [SetAddressResponse] class is used SetAddress State Response
class SetAddressResponse extends SetAddressState {
  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String placeId;

  const SetAddressResponse({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.placeId,
  });

  @override
  List<Object> get props => [
        address,
        city,
        state,
        country,
      ];
}
