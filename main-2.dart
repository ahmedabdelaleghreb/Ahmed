import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) => MaterialApp(title:'Ahmed - تعليم الأطفال', home: HomePage(), debugShowCheckedModeBanner:false);
}
class HomePage extends StatefulWidget { @override _HomePageState createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage>{
  Map<String,dynamic> content = {};
  final AudioPlayer player = AudioPlayer();
  @override void initState(){ super.initState(); loadContent(); }
  Future<void> loadContent() async {
    final str = await rootBundle.loadString('assets/content.json');
    setState(()=> content = json.decode(str));
  }
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Ahmed - تعليم الأطفال')),
      drawer: Drawer(child: ListView(children:[DrawerHeader(child:Text('القائمة')), ListTile(title:Text('الحروف'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ListPage(keyName:'letters_ar',title:'الحروف')))), ListTile(title:Text('الأرقام'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ListPage(keyName:'numbers',title:'الأرقام')))), ListTile(title:Text('الحيوانات'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ListPage(keyName:'animals',title:'الحيوانات')))), ListTile(title:Text('اختبار الحيوانات'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>QuizPage()))),],)),
      body: Center(child:Text('مرحبًا! افتح القائمة لاختيار درس', style:TextStyle(fontSize:18)))
    );
  }
}
class ListPage extends StatelessWidget{ final String keyName; final String title; ListPage({required this.keyName, required this.title}); @override Widget build(BuildContext context){
  return FutureBuilder(future: rootBundle.loadString('assets/content.json'), builder:(c,snap){ if(!snap.hasData) return Scaffold(appBar:AppBar(title:Text(title)), body:Center(child:CircularProgressIndicator())); final data = json.decode(snap.data as String); final items = (data[keyName] ?? []) as List; return Scaffold(appBar:AppBar(title:Text(title)), body:ListView.builder(itemCount:items.length,itemBuilder:(c,i){ final it = items[i] as Map<String,dynamic>; return ListTile(leading: CircleAvatar(child: Text(it['display'] ?? '')), title: Text(it['word'] ?? it['name_ar'] ?? ''), onTap: ()=>Navigator.push(c, MaterialPageRoute(builder: (_)=>DetailPage(item:it)))); })); });
} }
class DetailPage extends StatelessWidget{ final Map<String,dynamic> item; DetailPage({required this.item}); @override Widget build(BuildContext context){ final player = AudioPlayer(); final img = item['image'] ?? ''; final title = item['word'] ?? item['name_ar'] ?? ''; return Scaffold(appBar:AppBar(title:Text(title)), body:Padding(padding:EdgeInsets.all(12), child:Column(children:[ Expanded(child: img==''?Icon(Icons.image,size:120):Image.asset(img, fit: BoxFit.contain)), SizedBox(height:8), Text(title, style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)), SizedBox(height:8), ElevatedButton.icon(onPressed: () async { final aud = item['audio']; if(aud!=null){ await player.play(DeviceFileSource(aud)); } }, icon:Icon(Icons.volume_up), label:Text('استمع')) ]))); } }
class QuizPage extends StatefulWidget{ @override _QuizPageState createState()=>_QuizPageState(); }
class _QuizPageState extends State<QuizPage>{ List options=[]; String correct=''; String message=''; @override void initState(){ super.initState(); loadQ(); } Future<void> loadQ() async { final str = await rootBundle.loadString('assets/content.json'); final data = json.decode(str); final animals = (data['animals'] as List).toList(); animals.shuffle(); options = animals.take(3).toList(); correct = options[0]['id']; options.shuffle(); setState((){}); } void select(String id){ setState(()=> message = id==correct? 'صح! ممتاز 👍' : 'حاول تاني'); Future.delayed(Duration(seconds:1), ()=> loadQ()); } @override Widget build(BuildContext context){ return Scaffold(appBar:AppBar(title:Text('اختبار الحيوانات')), body: options.isEmpty?Center(child:CircularProgressIndicator()):Padding(padding:EdgeInsets.all(12), child:Column(children:[ Text('اضغط على الصورة الصحيحة', style:TextStyle(fontSize:20)), SizedBox(height:8), Expanded(child: GridView.count(crossAxisCount:2, children: options.map((opt)=> GestureDetector(onTap: ()=> select(opt['id']), child: Card(child: Column(children:[ Expanded(child: opt['image']!=null? Image.asset(opt['image'], fit:BoxFit.cover) : Icon(Icons.image)), SizedBox(height:8), Text(opt['name_ar'] ?? '', style:TextStyle(fontSize:16)) ])) ).toList())), SizedBox(height:8), Text(message, style:TextStyle(fontSize:20)) ])) ); } }
