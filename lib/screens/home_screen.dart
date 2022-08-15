import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fire_crud/models/todo.dart';
import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/providers/providers.dart';
import 'package:fire_crud/widgets/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fire_crud/themes/app_theme.dart';
import 'package:fire_crud/services/services.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoService todoService = Provider.of<TodoService>(context);

    return ChangeNotifierProvider(
      create: (_) => TodoFormProvider(todoService.todoSel),
      child: _TodoBody(todoService: todoService),
    );
  }
}

class _TodoBody extends StatelessWidget {
  final TodoService todoService;
  const _TodoBody({Key? key, required this.todoService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final todoForm = Provider.of<TodoFormProvider>(context);
    Todo todoSel = todoForm.todo;
    Color colorSelect;

    //Se agrega el para poder editar el texto desde codigo
    var txtEditCrl = TextEditingController();

    const placeholderImage =
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('ToDo Firebase'),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL ??
                          placeholderImage))),
          actions: [
            IconButton(
                onPressed: () {
                  authService.signOut();
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routerName);
                },
                icon: Icon(Icons.login_outlined))
          ]),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Form(
                    key: todoForm.formKey,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        TextFormField(
                          controller: txtEditCrl,
                          onChanged: (value) {
                            todoSel.nombre = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Limpiar el horno',
                            labelText: 'Contenido del ToDo',
                          ),
                        ),
                        Positioned(
                            top: 5,
                            right: 0,
                            child: _ColorSelect(todoSel: todoSel)),
                      ],
                    )))),
        Expanded(
            child: SizedBox(
                child: ListView.builder(
                    itemCount: todoService.todosList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                            onTap: () {
                              //Se pasan los datos del todo seleccionado al select
                              txtEditCrl.text =
                                  todoService.todosList[index].nombre;

                              todoSel = todoService.todosList[index].clone();
                              print(todoSel.id);
                            },
                            child: TodoCard(
                              todo: todoService.todosList[index],
                            )))))
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!todoService.isLoading) {
              FocusScope.of(context).requestFocus(FocusNode());
              

              todoService.saveTodo(todoSel.clone());
              

              todoForm.formKey.currentState!.reset();
            }
          },
          child: todoService.isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ColorSelect extends StatefulWidget {
  const _ColorSelect({Key? key, required this.todoSel}) : super(key: key);

  final Todo todoSel;

  @override
  State<_ColorSelect> createState() => _ColorSelectState();
}

class _ColorSelectState extends State<_ColorSelect> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Color pickerColor = Color(0xff443a49);
        // Color currentColor = Color(0xff443a49);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                scrollable: true,
                title: const Text('Seleccione un color'),
                titlePadding: const EdgeInsets.all(5),
                contentPadding: const EdgeInsets.all(25),
                content: SingleChildScrollView(
                  child: MaterialPicker(
                    pickerColor: widget.todoSel.getColor(),
                    onColorChanged: (colorChanged) {
                      widget.todoSel.red = colorChanged.red;
                      widget.todoSel.green = colorChanged.green;
                      widget.todoSel.blue = colorChanged.blue;

                      setState(() {});
                    },
                    enableLabel: false,
                    portraitOnly: true,
                  ),
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                        child: const Text('OK'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppTheme.primary)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  )
                ]);
          },
        );
      },
      child: Icon(Icons.color_lens_outlined),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(widget.todoSel.getColor())),
    );
  }
}
