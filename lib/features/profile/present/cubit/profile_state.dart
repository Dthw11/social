// PROFILE STATES

import '../../domain/entities/profile_user.dart';

abstract class ProfileState {}

// initial
class ProfileInitial extends ProfileState {}

// loading
class ProfileLoading extends ProfileState {}

// loaded
class ProflieLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProflieLoaded(this.profileUser);
}

//error
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
