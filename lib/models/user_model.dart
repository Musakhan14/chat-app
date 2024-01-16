class UserModel {
  String? uId;
  String? fullName;
  String? email;
  String? profilePicture;

  UserModel({this.email, this.fullName, this.profilePicture, this.uId});

  //here we use named constructor for receiving data from freebase
  UserModel.fromMap(Map<String, dynamic> map) {
    uId = map['uId'];
    fullName = map['fullName'];
    email = map['email'];
    profilePicture = map['profilePicture'];
  }

  //here we use function to transfer to map for uploading data to freebase

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
