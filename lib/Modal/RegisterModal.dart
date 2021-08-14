


class RegisterModal {
  String ? first_name,last_name,username,email,password,Auth_Token,phone;
  RegisterModal({this.first_name,this.last_name,this.email,this.password,this.username,this.phone});
  Map<String,String> toJson(json) {
    List<String> name = json['name']!.split(" ");
    print(name.toString());
    print(name.length);

    return{
      "name":json['name'],
      "username": json['email'],
      "email": json['email'],
      "password": json['password'],
      "phone": json['phone'],
    };
  }
}
