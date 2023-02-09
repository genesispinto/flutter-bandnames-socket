import 'dart:io';

import 'package:band_names_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Caramelos C', votes: 0),
    Band(id: '2', name: 'Mana', votes: 3),
    Band(id: '3', name: 'Rawayana', votes: 5),
    Band(id: '4', name: 'Pericos', votes: 2),
    Band(id: '5', name: 'Romeo Santos', votes: 1)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('BandNAmes', style: TextStyle(color: Colors.black87),)),
        elevation: 1,
        ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: bands.length,
        itemBuilder: ((context, index) => _bandTile(bands[index]))
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: addNewBand,
      elevation: 1,
      child: const Icon(Icons.add),
      
      ),
    );
  }


  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ((direction) {
        print('direction: $direction');
        print('id: ${band.id}');
      }),
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.blue[100],
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete_rounded, color: Colors.white, size: 45,),
        ),
        ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(band.name.substring(0,2)),
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}',style:const  TextStyle(fontSize: 20)),
          onTap: () {
            print(band.name);
          },
          ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();

    if(Platform.isAndroid){
        return showDialog(
          context: context, 
          builder: ((context) {
          return  AlertDialog(
          title: const  Text('New band name:'),
          content:  TextField(
          controller: textController,
          ),
          actions: [
            MaterialButton(
              onPressed: (() => addBandToList(textController.text)),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Add'),
            )
          ],
        );
        }));
    }

    showCupertinoDialog(
      context: context, 
      builder:((context) {
        return CupertinoAlertDialog(
          title: const  Text('New band name:') ,
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: (() => addBandToList(textController.text)),
              isDefaultAction: true,
              child: const Text('Add')),
              CupertinoDialogAction(
              onPressed: (() => Navigator.pop(context)),
              isDestructiveAction: true,
              child: const Text('Dismiss'))
          ],
        );
      }) );
    
  }

  void addBandToList (String name){
    if(name.length > 1){
      bands.add(Band(
        id: DateTime.now().toString(),
       name: name, 
       votes: 5));

       setState(() {});
    }
    
    Navigator.pop(context);
  }
}