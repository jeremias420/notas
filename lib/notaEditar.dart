import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notas/main.dart';

class EditarNota extends StatefulWidget {
  //dataNota contiene los datos del documento que seleccione el usuario para editar
  //es un parametro requerido
  final DocumentSnapshot dataNota;  
  EditarNota (this.dataNota);

  @override _EditarNotaState createState() => _EditarNotaState();
}

class _EditarNotaState extends State<EditarNota> {

  //los controladores se utilizan para poder acceder a los datos de los TextFields en otro widget
  TextEditingController _controllerTitulo;
  TextEditingController _controllerNota;

  @override
  void initState() {
    //se inicializan los controladores
    //con los datos del documento que recibie al iniciar el widget
    _controllerTitulo = TextEditingController(text:widget.dataNota['titulo'].toString());
    _controllerNota = TextEditingController(text:widget.dataNota['descripcion'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Nueva Nota"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child:Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Titulo"),
                  controller: _controllerTitulo,
                )
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 10,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(hintText: "Nota"),
                  controller: _controllerNota,
                ),
              )
            ],
          ),
        ) 
      ,),
      //boton para aplicar los cambios
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.check),
        onPressed: (){
          widget.dataNota.reference.update({
            'titulo': _controllerTitulo.text,
            'descripcion': _controllerNota.text
          });
          Navigator.push(context,MaterialPageRoute(builder: (context) => MisNotas()));
        }        
      ),
    );
  }
}