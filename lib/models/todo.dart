import 'dart:convert';

import 'package:flutter/material.dart';

class Todo {
    Todo({
        this.id = '-1',
        required this.nombre,
        required this.red,
        required this.green,
        required this.blue,
        required this.fecha,
    });

    String? id;
    String nombre;
    int red;
    int green;
    int blue;
    String fecha;

    factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        nombre: json["nombre"],
        red: json["red"],
        green: json["green"],
        blue: json["blue"],
        fecha: json["fecha"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "red": red,
        "green": green,
        "blue": blue,
        "fecha": fecha,
    };

  Todo clone() => Todo(id: id, nombre: nombre, fecha: fecha, red: red, green: green, blue: blue);
  
  Color getColor() {
    return Color.fromRGBO(red, green, blue, 1);
  }
}
