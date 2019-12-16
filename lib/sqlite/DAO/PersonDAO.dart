import 'package:solpac_teste/entity/Person.dart';
import 'package:solpac_teste/sqlite/DBProvider.dart';

class PersonDAO {

  static insertPerson(final Person person) async {
    final db = await DBProvider().database;
    var res = await db.insert("person", person.toMap());
    return res;
  }

  static getPersonById(final int id) async {
    final db = await DBProvider().database;
    var res =await  db.query("person", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Person.fromMap(res.first) : null ;
  }

  static getPersonByEmail(final String email) async {
    final db = await DBProvider().database;
    var res = await  db.query("person", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty ? Person.fromMap(res.first) : null;
  }

  static getAllPersons() async {
    final db = await DBProvider().database;
    var res = await db.query("person");
    List<Person> list =
    res.isNotEmpty ? res.map((c) => Person.fromMap(c)).toList() : [];
    return list;
  }

}