import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/profile/bloc/get_companies/get_companies_bloc.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'add_companies_event.dart';

part 'add_companies_state.dart';

/// Notifies the [AddCompaniesBloc] of a new [AddCompaniesEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddCompaniesBloc extends Bloc<AddCompaniesEvent, AddCompaniesState> {
  AddCompaniesBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddCompanies = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddCompaniesInitial()) {
    on<AddCompaniesUser>(_onAddCompaniesUser);
  }

  final RepositoryProfile mRepositoryAddCompanies;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAddCompaniesUser] of a new [AddCompaniesUser] which triggers
  void _onAddCompaniesUser(
    AddCompaniesUser event,
    Emitter<AddCompaniesState> emit,
  ) async {
    emit(AddCompaniesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryAddCompanies.callAddCompaniesAPI(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);
          BlocProvider.of<GetCompaniesBloc>(getNavigatorKeyContext())
              .add(GetCompaniesUser(url: AppUrls.apiGetCompanies));
          emit(AddCompaniesResponse(
              mAddCompanies: success, mCompany: event.mCompany));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddCompaniesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(AddCompaniesFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const AddCompaniesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('AddCompaniesFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const AddCompaniesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
