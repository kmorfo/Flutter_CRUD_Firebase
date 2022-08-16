import 'package:flutter/material.dart';
import 'package:fire_crud/models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  const TodoCard({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: _cardBorders(),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(todo.nombre)),
              Positioned(
                  top: 0,
                  right: 0,
                  child: _TagLabel(fecha: todo.fecha, colorSel: todo.getColor()))
            ])));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _TagLabel extends StatelessWidget {
  final String fecha;
  final Color colorSel;
  const _TagLabel({
    Key? key,
    required this.fecha,
    required this.colorSel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: colorSel,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
        child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(fecha,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            )));
  }
}
