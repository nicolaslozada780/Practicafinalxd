import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main()=>runApp(MiApp());
class MiApp extends StatelessWidget {
  const MiApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi App 2",
      home: Inicio(),
    );
  }
}
class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  
  Future <List<Product>>getData() async {
  var response = await http.get(
    Uri.parse("https://apprecuperaciondiego.azurewebsites.net/Api/products"),
    headers: {"Accept":"Application/json"}
  );
  var data=json.decode(response.body);
  print(data);
  List<Product> products=[];
  for(var p in data){
    Product product=Product(p["ProductId"], p["Description"], p["Price"]);
    products.add(product);
  }
  print(products.length);
  return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title:Text("Leonardo App")
    ),
    body: Container(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext  context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if(snapshot.data == null){
            return Container(child: Center(child: Text("Cagando..."),),);
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int productid){
                return ListTile(title:Text(snapshot.data[productid].description),
                subtitle: Text(snapshot.data[productid].price.toString()),
                );

              },
               );
          }
        },
      ) ,
      )
    );
  }
}

class Product {
  final int productid;
  final String description;
  final double price;

  Product (this.productid, this.description, this.price);
}