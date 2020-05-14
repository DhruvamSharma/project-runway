import 'package:project_runway/features/login/data/models/user_model.dart';
import 'package:project_runway/features/login/domain/entities/user_entity.dart';

UserModel convertEntityToModel(UserEntity userEntity) {
  return UserModel(
    userId: userEntity.userId,
    userName: userEntity.userName,
    phoneNumber: userEntity.phoneNumber,
    age: userEntity.age,
    gender: userEntity.gender,
    createdAt: userEntity.createdAt,
    score: userEntity.score,
    isVerified: userEntity.isVerified,
    isDeleted: userEntity.isDeleted,
    isLoggedIn: userEntity.isLoggedIn,
    googleId: userEntity.googleId,
    userPhotoUrl: userEntity.userPhotoUrl,
    emailId: userEntity.emailId,
  );
}