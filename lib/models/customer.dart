class Customer {
  int id;
  String name;
  int age;
  String gender;
  String birthday;
  String phone;
  String occupation;
  String address;
  String mark;

  Customer({this.id, this.name, this.age, this.gender, this.birthday, this.phone,
    this.occupation, this.address, this.mark});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['name'] = name;
    map['age'] = age;
    map['gender'] = gender;
    map['birthday'] = birthday;
    map['phone'] = phone;
    map['occupation'] = occupation;
    map['address'] = address;
    map['mark'] = mark;
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Customer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    age = map['age'];
    gender = map['gender'];
    birthday = map['birthday'];
    phone = map['phone'];
    occupation = map['occupation'];
    address = map['address'];
    mark = map['mark'];
  }
}
