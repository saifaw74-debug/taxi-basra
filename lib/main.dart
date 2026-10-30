import 'package:flutter/material.dart';
void main()=>runApp(MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
class Home extends StatelessWidget{
@override
Widget build(c){
return Scaffold(body: SingleChildScrollView(child: Column(children: [
SizedBox(height: 50),
Container(margin: EdgeInsets.all(15), height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFF0D4DFF)), child: Center(child: Text('گول بلي لخصومات المعزب 50%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFF7F7FF), borderRadius: BorderRadius.circular(15)), child: Column(children: [
Row(children: [service("طعام","🍔"), service("تكسي","🚕")]),
SizedBox(height: 10),
Row(children: [service("سجل كابتن","🚗"), service("بطاقات","💳")]),
])),
Container(margin: EdgeInsets.all(15), height: 120, decoration: BoxDecoration(color: Color(0xFF0D4DFF), borderRadius: BorderRadius.circular(12)), child: Center(child: Text('سجل كابتن 1,800,000\nربحك الشهري', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
Container(margin: EdgeInsets.symmetric(horizontal: 15), height: 100, decoration: BoxDecoration(color: Color(0xFF0D4DFF), borderRadius: BorderRadius.circular(12)), child: Center(child: Text('اشتري رصيد زين من بلي\nوادخل السحب على آيفون', style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center))),
]))); 
}
Widget service(String t, String e){return Expanded(child: Container(margin: EdgeInsets.all(5), height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(e, style: TextStyle(fontSize: 35)), Text(t, style: TextStyle(fontWeight: FontWeight.bold))])));}
}
