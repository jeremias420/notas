import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notas/notaEditar.dart';
import 'package:notas/notaNueva.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TextField',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MisNotas(),
    );
  }
}

class MisNotas extends StatefulWidget {  @override  _MisNotasState createState() => _MisNotasState();}
class _MisNotasState extends State<MisNotas> {
  showAlertDialog(BuildContext context, DocumentSnapshot document) {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed:  () {Navigator.of(context).pop();},

    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed:  () {
        document.reference.delete();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Borrar"),
      content: Text("¿Desea borrar esta nota?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot document){
    return ListTile(      
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['titulo'],
              style: Theme.of(context).textTheme.headline4,
            )
          ),
          // Divider(),   
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Borrar',
            onPressed: () { 
              showAlertDialog(context,document);             
            },
          ),                            
        ],       
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditarNota(document)));
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final CollectionReference query = FirebaseFirestore.instance.collection('notas');  

    return Scaffold(
      appBar: AppBar(
        title:Text("Mis Notas"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.orderBy('titulo', descending: false).snapshots(),
        builder: (context, stream){
          //indicador de espera
          if (stream.connectionState == ConnectionState.waiting) {return Center(child: CircularProgressIndicator());}

          //control en caso de erorr
          if (stream.hasError) {return Center(child: Text(stream.error.toString()));}
         
          QuerySnapshot querySnapshot = stream.data;
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: querySnapshot.size,
            itemBuilder: (context, index){           
            return buildListItem(context, querySnapshot.docs[index]);//pasa el documento seleccionado al builder de la lista
            }
          );
        }
      ),
      //boton para agregar una nueva nota
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed:(){
          Navigator.push(context,MaterialPageRoute(builder: (context) => NuevaNota(coleccion: query,)));          
        }       
      ), 
    );
  }
}