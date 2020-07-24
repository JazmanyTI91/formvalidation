import 'package:flutter/material.dart';
import 'package:formvalidation/blocs/login_bloc.dart';
export 'package:formvalidation/blocs/login_bloc.dart';



class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if ( _instancia == null ){
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

   Provider._internal({Key key, Widget child})
     : super(key : key, child : child);

  final loginBloc = LoginBloc();

  //Método constructor del provider
 // Provider({Key key, Widget child})
 //   : super(key : key, child : child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Este código va a buscar por medio del contexto un widget tipo provider
  //o del tipo especificado
  //static LoginBloc of ( BuildContext context ) {
    //return ( context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  //}

  static LoginBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

}