import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
void main() { runApp(const MyApp()); }
class MyApp extends StatelessWidget { const MyApp({super.key}); @override Widget build(BuildContext c)=> MaterialApp(home: const Home(), debugShowCheckedModeBanner:false); }
class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=> _HomeState(); }
class _HomeState extends State<Home> {
  List letters=[]; List animals=[]; bool loading=true; final AudioPlayer sfx=AudioPlayer();
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async {
    final a = await rootBundle.loadString('assets/data/letters_ar.json');
    final b = await rootBundle.loadString('assets/data/animals.json');
    letters = json.decode(a); animals = json.decode(b);
    setState(()=>loading=false);
  }
  @override Widget build(BuildContext ctx){
    if(loading) return const Scaffold(body: Center(child:CircularProgressIndicator()));
    return Scaffold(appBar: AppBar(title: const Text('برنامج أحمد عبدالعال')), body: ListView(children: [
      ListTile(title: const Text('الحروف'), onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>Letters(letters:letters)))),
      ListTile(title: const Text('الحيوانات'), onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>Animals(animals:animals)))),
      ListTile(title: const Text('اختبار'), onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>Quiz(letters:letters)))),
    ]));
  }
}
class Letters extends StatelessWidget{ final List letters; const Letters({super.key, required this.letters}); @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: const Text('الحروف')), body: ListView(children: letters.map((e)=>ListTile(leading: Image.asset(e['image'],width:50), title:Text(e['word']), trailing: IconButton(icon: Icon(Icons.play_arrow), onPressed:(){AudioPlayer().play(AssetSource(e['audio'].replaceFirst('assets/','')));}))).toList()));}
class Animals extends StatelessWidget{ final List animals; const Animals({super.key, required this.animals}); @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: const Text('الحيوانات')), body: ListView(children: animals.map((a)=>ListTile(leading: Image.asset(a['image'],width:50), title:Text(a['name_ar']), trailing: IconButton(icon: Icon(Icons.play_arrow), onPressed:(){AudioPlayer().play(AssetSource(a['audio'].replaceFirst('assets/','')));}))).toList()));}
class Quiz extends StatefulWidget{ final List letters; const Quiz({super.key, required this.letters}); @override State<Quiz> createState()=> _QuizState();}
class _QuizState extends State<Quiz>{ int i=0,score=0; List choices=[]; @override void initState(){ super.initState(); _next(); } void _next(){ i=(i+1)%widget.letters.length; final c=widget.letters[i]; choices=[c]; for(var x in widget.letters){ if(choices.length>=3) break; if(x['id']!=c['id']) choices.add(x);} choices.shuffle(); setState((){});} void _answer(Map choice){ final ok = choice['id']==widget.letters[i]['id']; if(ok) score++; showDialog(context: context, builder: (_)=>AlertDialog(title: Text(ok?'صحيح':'خطأ'), content: Text(ok? 'أحسنت':'حاول تاني'), actions:[TextButton(onPressed:(){Navigator.pop(context); _next();}, child: const Text('التالي'))])); } @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: const Text('اختبار')), body: GridView.count(crossAxisCount:2, children: choices.map((ch)=>GestureDetector(onTap: ()=>_answer(ch), child: Card(child: Column(children:[Image.asset(ch['image'],width:120,height:120), Text(ch['word'])])))).toList())); }
