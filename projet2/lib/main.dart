import "package:flutter/material.dart";
import "dart:math";
 
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
 
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
 
  List<String> words = ["OK", "CODE", "AYITI", "LEKOL", "MANJE", "Danse", "TRAVAY"];
  List<String> hints = ["DI ou dako ak yon bagay", "Sa kifew ka gn whatsapp sou tfn ou", "Peyi nou", "Kote ou al aprann", "Pou ranpli fonksyon vital kò ou", "Depi gen mizik ou pap pa fel", "Sa ou fè pouw fe lajan"];
 
  String word = "";
  String hint = "";
  List<String> clickedLetters = [];
  int chances = 5;
  bool gameOver = false;
  bool playerWon = false;
  int navIndex = 1;
 
  @override
  void initState() { super.initState(); startNewGame(); }
 
  // lase yon nouvo pati
  void startNewGame() {
    setState(() {
      int i = Random().nextInt(words.length);
      word = words[i]; hint = hints[i];
      clickedLetters = []; chances = 5; gameOver = false; playerWon = false;
    });
  }
 
// metod pou vefye yon let
  void checkLetter(String letter) {
    if (gameOver) return;
    setState(() { clickedLetters.add(letter); });
    if (!word.contains(letter)) setState(() => chances--);
 
    bool won = true;
    for (int i = 0; i < word.length; i++) {
      if (!clickedLetters.contains(word[i])) won = false;
    }
    if (won) setState(() { gameOver = true; playerWon = true; });
    else if (chances == 0) setState(() { gameOver = true; playerWon = false; });
  }
 
  //dyalog pou edew
  void showHelp() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Kijan Jwe?"),
      content: Text("Devine mo a lèt pa lèt.\nChak erè = -1 chans.\nOu gen 5 chans total!"),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK!"))],
    ));
  }
 
  // metod pou nom vi ou genyen
  List<Widget> buildHearts() {
    List<Widget> hearts = [];
    for (int i = 0; i < 5; i++) {
      hearts.add(Icon(i < chances ? Icons.favorite : Icons.favorite_border,
          color: i < chances ? Colors.red : Colors.grey, size: 20));
    }
    return hearts;
  }
 
  //metod pou mo ki kache an
  List<Widget> buildWord() {
    List<Widget> list = [];
    for (int i = 0; i < word.length; i++) {
      String ch = word[i];
      list.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue, width: 2))),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          clickedLetters.contains(ch) ? ch : "*",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
              color: clickedLetters.contains(ch) ? Colors.blue[800] : Colors.grey[400]),
        ),
      ));
    }
    return list;
  }
 
  // metod pou klavye an
  List<Widget> buildKeyboard() {
    List<Widget> list = [];
    for (int i = 0; i < "QWERTYUIOPASDFGHJKLZXCVBNM".length; i++) {
      String l = "QWERTYUIOPASDFGHJKLZXCVBNM"[i];
      bool clicked = clickedLetters.contains(l);
      list.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (clicked && word.contains(l)) ? Colors.green : clicked ? Colors.red[200] : Colors.blue,
          foregroundColor: Colors.white, padding: EdgeInsets.zero,
          minimumSize: Size(36, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: clicked ? null : () => checkLetter(l),
        child: Text(l, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ));
    }
    return list;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: TextButton(onPressed: () {}, child: Icon(Icons.help_outline, color: Colors.white)),
        title: Text("Mo Kache", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          ...buildHearts(),
          IconButton(icon: Icon(Icons.refresh, color: Colors.white), onPressed: startNewGame),
          IconButton(icon: Icon(Icons.settings, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: gameOver ? buildResultScreen() : buildGameScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        selectedItemColor: Colors.blue,
        onTap: (i) => setState(() => navIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Skor"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akèy"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Èd"),
        ],
      ),
    );
  }
 
  // ekran jwet la
  Widget buildGameScreen() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: buildWord()),
      SizedBox(height: 16),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50], borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lightbulb, color: Colors.amber, size: 20),
          SizedBox(width: 8),
          Text("Endis: $hint", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue[800])),
        ]),
      ),
      Spacer(),
      Container(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          shrinkWrap: true, crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6,
          children: buildKeyboard(),
        ),
      ),
      SizedBox(height: 10),
    ]);
  }
 
  // reziltaa
  Widget buildResultScreen() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(playerWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
          size: 80, color: playerWon ? Colors.amber : Colors.grey),
      SizedBox(height: 20),
      Text(
        playerWon ? "🎉 BRAVO! OU GENYEN!" : "😢 OU PÈDI!\nMo a te: $word",
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
            color: playerWon ? Colors.green[700] : Colors.red[700]),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 40),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
        onPressed: startNewGame,
        icon: Icon(Icons.replay),
        label: Text("REKÒMANSE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 16),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue,
            side: BorderSide(color: Colors.blue, width: 2),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
        onPressed: showHelp,
        icon: Icon(Icons.help_outline),
        label: Text("KIJAN POU JWEN?"),
      ),
      SizedBox(height: 16),
      TextButton(
        onPressed: startNewGame,
        child: Text("Eseye yon lòt mo...",
            style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.underline)),
      ),
    ]));
  }
}