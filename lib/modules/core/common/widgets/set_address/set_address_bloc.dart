import '../../../utils/api_import.dart';

part 'set_address_event.dart';

part 'set_address_state.dart';

class SetAddressBloc extends Bloc<SetAddressEvent, SetAddressState> {
  SetAddressBloc() : super(SetAddressInitial()) {
    on<SetAddressUser>(_onSetAddressUser);
  }

  /// Notifies the [_onSetAddressUser] of a new [SetAddressUser] which triggers
  void _onSetAddressUser(
    SetAddressUser event,
    Emitter<SetAddressState> emit,
  ) async {
    emit(SetAddressResponse(
      address: event.address,
      state: event.state,
      city: event.city,
      country: event.country,
      pinCode: event.pinCode,
      placeId: event.placeId,
    ));
  }
}
