import 'dart:async';

import 'package:connectme_app/Presentation/blocs/map_state.dart';
import 'package:connectme_app/domain/entities/member.dart';
import 'package:connectme_app/domain/usecases/members.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class CommunityMapCubit extends Cubit<CommunityMapState> {
  final GetCommunityMembers _getCommunityMembers;

  StreamSubscription<List<CommunityMember>>? _membersSubscription;

  CommunityMapCubit(this._getCommunityMembers)
    : super(const CommunityMapInitial());

  void loadMembers() {
    emit(const CommunityMapLoading());

    _membersSubscription?.cancel();

    _membersSubscription = _getCommunityMembers().listen(
      (members) {
        if (!isClosed) {
          emit(CommunityMapLoaded(members));
        }
      },
      onError: (error) {
        if (!isClosed) {
          emit(const CommunityMapError('Failed to load community members.'));
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _membersSubscription?.cancel();
    return super.close();
  }
}
