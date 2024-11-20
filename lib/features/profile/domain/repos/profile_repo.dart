// ProFile Repository

import '../entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fechUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
  Future<void> toggleFollow(String currentUid, String targetUid);
}
