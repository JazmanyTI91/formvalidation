import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formvalidation/blocs/provider.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context){

    //creamos instancia de nuestro bloc
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 160.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                //Creamos los campos de texto
                SizedBox(height: 40.0),
                _crearEmail( bloc ),
                SizedBox(height: 30.0),
                _crearPassword( bloc ),
                SizedBox(height: 30.0),
                _crearBoton(bloc),
              ],
            ),
          ),

          FlatButton(
            color: Colors.indigo,
            child: Text('Crear cuenta', style: TextStyle(color: Colors.black45, fontSize: 16, fontStyle: FontStyle.italic)),
            onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
          ),
          //SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
                hintText: 'ejemplo@correo.com',
                labelText: 'correo electronico',
                counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      }
    );

  }


  Widget _crearPassword(LoginBloc bloc){

    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
                  labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error,
              ),
              onChanged: bloc.changePassword,
            ),
          );
        }
     );

  }


  Widget _crearBoton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 3.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  //Método para obtener valor del stream
  _login(LoginBloc bloc, BuildContext context)
  {
    print('===============');
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
    print('===============');
    Navigator.pushReplacementNamed(context, 'home');
  }
  
  Widget _crearFondo(BuildContext context){
    final size = MediaQuery.of(context).size;
    final fondoMorado =  Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        ),
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(129, 180, 217,0.3)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 50.0, left: 25.0, child: circulo),
        Positioned(top: -25.0, right: -25.0, child: circulo),
        Positioned(top: 178, right: -50.0, child: circulo),

        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              Icon( Icons.person_pin_circle, color: Colors.white70, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity ),
              Text('Ing. Jazmany Juárez', style: TextStyle( color: Colors.white70, fontSize: 25.0 ))
            ],
          ),
        ),
      ],
    );
  }
  
  
}
