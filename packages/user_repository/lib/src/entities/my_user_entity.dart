import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  String? picture;

  MyUserEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.picture});

  Map<String, dynamic> toDocument() {
    return {'id': id, 'firstName': firstName,'lastName':lastName, 'email': email, 'picture': picture};
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        id: doc['id'] as String,
        firstName: doc['firstName'] as String,
        lastName: doc['lastName']as String,
        email: doc['email'] as String,
        picture: doc['picture'] as String);
  }

  @override
  List<Object?> get props => [id, firstName,lastName, email, picture];
}
