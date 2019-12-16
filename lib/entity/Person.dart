import 'dart:convert';

class Person {
  int id;
  String name;
  String document;
  String email;
  String password;

  Person({this.id, this.name, this.document, this.email, this.password});

  Person.fromMap(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    document = json["document"];
    email = json["email"];
    password = json["password"];
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "document": document,
        "email": email,
        "password": password,
      };

  @override
  String toString() {
    return 'Person{id: $id, name: $name, document: $document, email: $email, password: $password}';
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['document'] = this.document;
    data['password'] = this.password;
    return data;
  }

  String getJsonPerson(){
    Map map = toJson();
    String json = jsonEncode(map);
    print("JSON: $json");
    return json;
  }

  static Person getPersonFromJson(String json){
    Map map = jsonDecode(json);
    Person person = Person.fromMap(map);
    return person;
  }
}

