import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/services/services.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String routerName = 'CheckAuthScreen';
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Text('');

            print('----------Snapdata ${snapshot.data} --------------');
            // if(snapshot.data=='')
            //Como el future builder tiene de retornar un widget , se creafuture para que
            //se ejecute la navegacion despues de return
            Future.microtask(() {
              //Para evitar que se vea una pantalla en blanco con la transicion de una a otra
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        snapshot.data != '' ? HomeScreen() : LoginScreen(),
                    transitionDuration: Duration(seconds: 0)),
              );
            });

            return Container();
          },
        ),
      ),
    );
  }
}
