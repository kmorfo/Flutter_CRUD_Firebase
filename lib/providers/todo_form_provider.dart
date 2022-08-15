import 'package:fire_crud/models/todo.dart';
import 'package:flutter/material.dart';

class TodoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Todo todo;

  TodoFormProvider(this.todo);

  

}
