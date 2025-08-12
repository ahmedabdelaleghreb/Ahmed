
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const AhmedKidsApp());
}

class AhmedKidsApp extends StatelessWidget {
  const AhmedKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أحمد عبدالعال - تعلم الأطفال',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Sans',
      ),
      home: const HomePage(),
      locale: const Locale('ar'),
      supportedLocales: [Locale('ar'), Locale('en')],
      localizationsDelegates: [],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _sfx = AudioPlayer();

  List letters = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr = await rootBundle.loadString('assets/data/letters_ar.json');
    final data = json.decode(jsonStr);
    setState(() {
      letters = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('أحمد عبدالعال - تعلم الأطفال')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('القوائم', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LettersPage(letters: letters)));
            },
            icon: const Icon(Icons.font_download_outlined),
            label: const Text('حروف عربية'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AnimalsPage()));
            },
            icon: const Icon(Icons.pets),
            label: const Text('مكتبة الحيوانات'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage(letters: letters)));
            },
            icon: const Icon(Icons.quiz),
            label: const Text('اختبار سريع'),
          ),
        ],
      ),
    );
  }
}

class LettersPage extends StatelessWidget {
  final List letters;
  const LettersPage({super.key, required this.letters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحروف العربية')),
      body: PageView.builder(
        itemCount: letters.length,
        itemBuilder: (context, idx) {
          final item = letters[idx];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['char'], style: const TextStyle(fontSize: 140, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Image.asset(item['image'], width: 260, height: 260),
                const SizedBox(height: 12),
                Text(item['word'], style: const TextStyle(fontSize: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  List animals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final s = await rootBundle.loadString('assets/data/animals.json');
    animals = List.from(json.decode(s));
    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('الحيوانات')),
      body: GridView.count(
        crossAxisCount: 2,
        children: animals.map((a) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () async {
                try {
                  final player = AudioPlayer();
                  final name = a['id'] as String;
                  await player.play(AssetSource('assets/audio/ar/'+name+'_eg.wav'));
                } catch (e){}
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(a['image'], width: 120, height: 120),
                  const SizedBox(height: 8),
                  Text(a['name_ar'], style: const TextStyle(fontSize: 20))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final List letters;
  const QuizPage({super.key, required this.letters});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  late List choices;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final letters = widget.letters;
    index = (index + 1) % letters.length;
    // simple choices: correct + two others
    final correct = letters[index];
    choices = [correct];
    for (var l in letters) {
      if (l['id'] != correct['id'] && choices.length < 3) choices.add(l);
    }
    choices.shuffle();
    setState((){});
  }

  void _answer(Map choice) {
    final correct = widget.letters[index];
    final ok = choice['id'] == correct['id'];
    if (ok) {
      score++;
      _sfx.stop();
      _sfx.play(AssetSource('assets/audio/sfx/correct_combo.wav'));
    } else {
      _sfx.stop();
      _sfx.play(AssetSource('assets/audio/sfx/wrong.wav'));
    }
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(ok ? 'صحيح! 🎉' : 'خطأ'),
      content: Text(ok ? 'أحسنت' : 'الإجابة الصحيحة: ${correct['word']}'),
      actions: [TextButton(onPressed: (){
        Navigator.pop(context);
        _nextQuestion();
      }, child: const Text('التالي'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.letters[index];
    return Scaffold(
      appBar: AppBar(title: const Text('اختبار')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ما الصورة المناسبة للحرف ${correct['char']}؟', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: choices.map((c){
                  return GestureDetector(
                    onTap: () => _answer(c),
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(c['image'], width: 120, height: 120),
                        const SizedBox(height: 8),
                        Text(c['word'], style: const TextStyle(fontSize: 18)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
            Text('النتيجة: $score', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
