import 'dart:async';
import 'package:formvalidation/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class LoginBloc with Validators{

  //Variables para controlar el flujo de trabajo y el patron bloc
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Stream para combinar los anteriores con rxdart
  Stream<bool> get formValidStream =>
     CombineLatestStream.combine2(emailStream, passwordStream, (e,p) => true);


  //Recuperar los datos del Stream
  Stream<String> get emailStream => 
      _emailController.stream.transform(validarEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform( validarPassword );

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;


  //Cerrar los stream
  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

}