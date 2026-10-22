import 'package:connectme_app/domain/entities/member.dart';
import 'package:equatable/equatable.dart';

abstract class CommunityMapState extends Equatable {
  const CommunityMapState();

  @override
  List<Object?> get props => [];
}

class CommunityMapInitial extends CommunityMapState {
  const CommunityMapInitial();
}

class CommunityMapLoading extends CommunityMapState {
  const CommunityMapLoading();
}

class CommunityMapLoaded extends CommunityMapState {
  final List<CommunityMember> members;

  const CommunityMapLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class CommunityMapError extends CommunityMapState {
  final String message;

  const CommunityMapError(this.message);

  @override
  List<Object?> get props => [message];
}
