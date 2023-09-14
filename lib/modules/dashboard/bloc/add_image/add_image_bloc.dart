import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'add_image_event.dart';

part 'add_image_state.dart';

/// Notifies the [AddImageBloc] of a new [AddImageEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddImageBloc extends Bloc<AddImageEvent, AddImageState> {
  AddImageBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddImage = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddImageInitial()) {
    on<AddImage>(_onAddImage);
  }

  final RepositoryJob mRepositoryAddImage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAddImage] of a new [AddImage] which triggers
  void _onAddImage(
    AddImage event,
    Emitter<AddImageState> emit,
  ) async {
    emit(AddImageLoading());
    try {
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryAddImage.callPostAddImageApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient,
              event.mFileList);
      response.fold(
        (success) {
          // ToastController.showToast(
          //     success.message ?? '', getNavigatorKeyContext(), true);
          if ((event.mJobData.invoice ?? []).isEmpty ||
              !(event.mJobData.invoice
                      ?.every((element) => element.status == 'Paid') ??
                  false)) {
            Navigator.pushNamed(
                getNavigatorKeyContext(), AppRoutes.routesCollectPayment,
                arguments: event.mJobData);
          } else {
            Navigator.pushNamed(
                getNavigatorKeyContext(), AppRoutes.routesCloseJob,
                arguments: event.mJobData);
          }
          emit(AddImageResponse(mModelAddImage: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddImageFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const AddImageFailure(
          mError: ValidationString.validationNoInternetFound));
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddImageFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddImageFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
