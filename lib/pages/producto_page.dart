import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/models/producto_model.dart';
import 'package:formvalidation/provider/productos_provider.dart';
import 'package:formvalidation/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final scafoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardado = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    //Recuperar los argumentos del producto seleccionado
    final proData = ModalRoute.of(context).settings.arguments;
    if(proData != null){
      producto = proData;
    }

    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          //Es como un formulario html
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre()
  {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value)=>producto.titulo = value,
      validator: ( value ){
        if( value.length < 3 )
          {
            return 'Ingrese el nombre del producto';
          }else{
          return null;
        }
      },
    );
  }

  Widget _crearPrecio()
  {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'precio',
      ),
      onSaved: (value)=>producto.valor = double.parse(value),
      validator: ( value ){
        if( utils.isNumeric(value) ){
          return null;
        }else{
          return 'solo numeros';
        }
      },
    );
  }


  Widget _crearDisponible()
  {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }


  Widget _crearBoton()
  {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      elevation: 5,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      onPressed: (_guardado) ? null : _submit,
    );
  }

  Widget _mostrarProgress()
  {
    return Container(
      child:     LinearProgressIndicator(),
    );
  }

  void _submit() async{
    if (!formKey.currentState.validate()) return;
    //salvar los datos insertados en los input
    formKey.currentState.save();

    setState(() {
      _guardado = true;
    });

    if(foto != null)
      {
        producto.fotoUrl = await productoProvider.subirImagen(foto);
      }

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
      mostrarSnackbar('Registro Almacenado');
    }else{
      productoProvider.editarProducto(producto);
      mostrarSnackbar('Registro Editado');
    }
    Navigator.pop(context);
  }


  void mostrarSnackbar(String mensaje)
  {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.deepPurple,
      elevation: 5.0,
    );
    scafoldKey.currentState.showSnackBar(snackBar);
  }


  Widget _mostrarFoto(){
    if ( producto.fotoUrl != null ){
      return FadeInImage(
        image: NetworkImage( producto.fotoUrl ),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no_image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async
  {
    foto = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );

    if(foto != null){
      //limpieza
    }

    setState(() {

    });
  }


  _tomarFoto() async
  {
    foto = await ImagePicker.pickImage(
        source: ImageSource.camera
    );

    if(foto != null){
      //limpieza
      producto.fotoUrl = null;
    }

    setState(() {

    });
  }


}
