class User {
  int id;
  String firstName;
  String lastName;
  String username;
  String email;
  String password;

  User({this.id, this.firstName, this.lastName, this.username, this.email, this.password});

  String fullName() => "${this.firstName} ${this.lastName}";

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "email": email,
      };

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, username: $username, email: $email, password: $password}';
  }


}
