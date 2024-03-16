import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  String? picture;

  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.picture,
  });

  // Empty user which represents an unathentificated user
  static MyUser empty = MyUser(id: '', firstName: '',lastName: '', email: '', picture: '');

  // Modify myuser parameters
  MyUser copyWith({String? id, String? firstName,String? lastName, String? email, String? picture}) {
    return MyUser(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        picture: picture ?? this.picture);
  }

  // getter to determine whether the current user is empty
  bool get isEmpty => this == MyUser.empty;

  //getter to determine whether the current user is not empty
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(id: id, firstName: firstName,lastName:lastName, email: email, picture: picture);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        email: entity.email,
        picture: entity.picture);
  }

  @override
  List<Object?> get props => [id, firstName,lastName, email, picture];
}
