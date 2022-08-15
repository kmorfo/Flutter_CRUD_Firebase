import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_crud/models/todo.dart';
import 'package:fire_crud/services/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TodoService extends ChangeNotifier {
  final List<Todo> todosList = [];
  String error = '';
  String verificationId = '';
  String collection = '';

  late Todo todoSel;

  bool _isLoading = false;

  void set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  TodoService() {
    todoSel =
        Todo(nombre: 'nombre', red: 0, green: 0, blue: 0, fecha: '01/01/2022');

    this.loadTodos();
  }

  Future<List<Todo>> loadTodos() async {
    isLoading = true;
    notifyListeners();
    collection = await FirebaseAuth.instance.currentUser!.uid;

    final db = await FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Todo todoTMP = Todo.fromMap(data);
        // print(todoTMP.toJson());
        // print("${doc.id} => ${doc.data()}");
        todosList.add(todoTMP.clone());
      }
      notifyListeners();
    });

    //TODO Aqui el codigo para obtener los todos de firebase

    isLoading = false;
    notifyListeners();

    return todosList;
  }

  Future<List<Todo>> saveTodo(Todo todo) async {
    isLoading = true;
    notifyListeners();

    //Se busca el indice en el que se encuentra el producto
    final index = todosList.indexWhere(((element) => element.id == todo.id));
    print('Se va a editar ${todo.id} esta en la posicion ${index}');

    if (todo.id == '-1') todo.id = new DateTime.now().toString();

    final DateTime now = DateTime.now();
    if (index >= 0) {
      //Si es una actualizacion
      todosList[index] = todo;
      print('se edita${todosList[index].nombre}');
    } else {
      //Si es uno nuevo se añade la fecha
      todo.fecha = '${now.day}/${now.month}/${now.year}';
      todosList.add(todo);
      print('se add');
    }

    //Inserta el todo en la colleccion del usuario
    final db = FirebaseFirestore.instance
        .collection(collection)
        .doc(todo.id)
        .set(todo.toMap());

    isLoading = false;
    notifyListeners();

    return todosList;
  }

  Future<List<Todo>> deleteTodo(Todo todo) async {
    isLoading = true;
    notifyListeners();

    //TODO Aqui el codigo para borrar el todo firebase
    final index = todosList.indexWhere(((element) => element.id == todo.id));
    print('Se va a borrar ${todo.id} esta en la posicion ${index}');

    todosList.removeAt(index);
    final db = FirebaseFirestore.instance
        .collection(collection)
        .doc(todo.id)
        .delete()
        .onError((error, stackTrace) =>
            NotificationsService.showSnackBar('${error}'));

    isLoading = false;
    notifyListeners();

    return todosList;
  }
}
