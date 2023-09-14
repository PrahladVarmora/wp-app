import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/model/model_job_tag_notes.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../core/utils/api_import.dart';
import '../../core/utils/validation_string.dart';

part 'tag_notes_event.dart';

part 'tag_notes_state.dart';

/// Notifies the [TagNotesBloc] of a new [TagNotesEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class TagNotesBloc extends Bloc<TagNotesEvent, TagNotesState> {
  TagNotesBloc({
    required RepositoryJob repositoryTagNotes,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryTagNotes = repositoryTagNotes,
        mApiProvider = apiProvider,
        mClient = client,
        super(TagNotesInitial()) {
    on<TagNotesList>(_onJobReject);
  }

  final RepositoryJob mRepositoryTagNotes;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobReject] of a new [TagNotesTagNotes] which triggers
  void _onJobReject(
    TagNotesList event,
    Emitter<TagNotesState> emit,
  ) async {
    emit(TagNotesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelJobTagNotes, ModelCommonAuthorised> response =
          await mRepositoryTagNotes.callGetTagNotesApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          emit(TagNotesResponse(tagsNotes: success.tagsNotes!));
        },
        (error) {
          emit(TagNotesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const TagNotesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const TagNotesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const TagNotesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
