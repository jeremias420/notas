import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notas/main.dart';
///////////////////////////////////
///
class NuevaNota extends StatefulWidget {
  final CollectionReference coleccion;  

  const NuevaNota ({ Key key, this.coleccion }): super(key: key);

  @override _NuevaNotaState createState() => _NuevaNotaState();
}

class _NuevaNotaState extends State<NuevaNota> {
  
  //los controladores se utilizan para poder acceder a los datos de los TextFields en otro widget
  TextEditingController _controllerTitulo;
  TextEditingController _controllerNota;

  
  @override
  void initState() {
    //se inicializan los controladores
    _controllerTitulo = TextEditingController();
    _controllerNota = TextEditingController();
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
        child: new Icon(Icons.add),
        onPressed: (){
          widget.coleccion.doc().set({
            'titulo': _controllerTitulo.text,
            'descripcion': _controllerNota.text
          });
          Navigator.push(context,MaterialPageRoute(builder: (context) => MisNotas()));
        }
      ),
    );
  }
}