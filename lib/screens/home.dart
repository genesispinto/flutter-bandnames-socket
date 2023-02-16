import 'dart:io';

import 'package:band_names_app/models/band.dart';
import 'package:band_names_app/providers/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){

    bands = (payload as List)
      .map((band) => Band.fromMap(band))
      .toList();

      setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context,listen: false);

    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('BandNAmes', style: TextStyle(color: Colors.black87),)),
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child:
            socketService.serverStatus == ServerStatus.online 
            
            ? Icon(Icons.check_circle, color: Colors.blue[300],)
            : Icon(Icons.check_circle, color: Colors.red[300],),
            
          )
        ],
        ),
      body: Column(
        children: [
           _showGraph(bands),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: bands.length,
              itemBuilder: ((context, index) => _bandTile(bands[index]))
              ),
          ),
        ],
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: addNewBand,
      elevation: 1,
      child: const Icon(Icons.add),
      
      ),
    );

  }


  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context,listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ((_) => socketService.socket.emit('delete-band', {'id': band.id})),
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
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id})),
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
    final socketService = Provider.of<SocketService>(context,listen: false);
    if(name.length > 1){

      socketService.socket.emit('add-band', {'name': name});
    }
    
    Navigator.pop(context);
  }
}

Widget _showGraph(bands){

  Map<String, double> dataMap = {};

  bands.forEach((band){
    dataMap.putIfAbsent(band.name
    , () => band.votes.toDouble());
  });


return PieChart(
  dataMap: dataMap.isEmpty ? {'no hay datos':0}: dataMap,
  
  );
}