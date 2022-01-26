class HighScores { //<>// //<>//
  // object that holds methods related to the highscore system

  final int PODIUMCOUNT = 10;
  String TARGETTXT;
  String TARGETTUTORIAL;
  String[] instructions;


  NamesAndScoresPair pair;
  String[] lines;

  // useless constructor
  HighScores(String type, String inst) {
    TARGETTXT = type;
    TARGETTUTORIAL = inst;
  }

  String[] readFile() {
    String[] savedScores = loadStrings(TARGETTXT);
    instructions = loadStrings(TARGETTUTORIAL);

    return savedScores;
  }

  void loadInst(String inst) {
  }

  int getScore(int i) {
    if (readFile().length < i) {
      return 0;
    }
    return pair.scores[i-1];
  }

  NamesAndScoresPair sortScores( HighScore[] lines ) {
    // if one element is bigger than the next, swap em
    // repeat until the whole thing is sorted
    // this algorithm is slow compared to others, but it was the easiest to come up with and write
    // consider writing a new one?
    boolean stillSorting = true;
    while ( stillSorting ) {
      stillSorting = false;
      for ( int i = 0; i < lines.length-1; i++ ) {
        if (lines[i].score < lines[i+1].score) {
          HighScore temp;
          temp = lines[i];
          lines[i] = lines[i+1];
          lines[i+1] = temp;
          stillSorting = true;
        }
      }
    }

    // return the two arrays together
    pair = new NamesAndScoresPair( lines );
    return pair;
  }

  void write(NamesAndScoresPair arrays) {
    // new printwriter object
    PrintWriter output;
    String[] lines = new String[arrays.scores.length];

    for (int i = 0; i < arrays.scores.length; i++) {
      String str;
      str = arrays.names[i] + " " + str(arrays.scores[i]);
      lines[i] = str;
      //println("scores[i]:", in.scores[i]);
      //println("names[i]:", in.names[i]);
      //println("str:", str);
    }
    output = createWriter(TARGETTXT);

    // write each line in my array to the file
    for (int i = 0; i<lines.length; i++) {
      output.println(lines[i]);
    }

    output.flush(); // Writes the remaining data to the file or something
    output.close();
  }

  String[] arrayPairToStr() {
    String[] out = new String[pair.scores.length]; // NPE
    for (int i = 0; i < pair.scores.length; i++) {
      out[i] = pair.names[i] + " " + str(pair.scores[i]);
    }
    return out;
  }

  void readAndSortScores() {
    // get my data from the file
    String[] savedScores = readFile();
    // make an array of scores and names that are connected with each other
    HighScore[] lines = new HighScore[savedScores.length]; // npe

    // for each item in my data...
    for ( int i = 0; i < savedScores.length; i++ ) {
      String scoreRow = savedScores[i];
      /*
       split the line by the space so i have the score and the name seperate.
       they're written in the file like this:
       abc 1000
       def 500
       ghi 350
       jkl 1500
       mno 1250
       */
      String[] lineInfo = split(scoreRow, ' ');
      // make a new HighScore object with the
      HighScore currentLine = new HighScore( int(lineInfo[1]), lineInfo[0] );
      lines[i] = currentLine;
    }

    NamesAndScoresPair myarrays = sortScores( lines );
    write(myarrays);
  }

  void saveScore(String userInitials) {
    // add a score to the lists
    pair.scores = append(pair.scores, actualScore);
    pair.names = append(pair.names, userInitials);
    // save the scores to the file
    write(pair);
    // sort and update my lists
    readAndSortScores();
  }

  void drawMenuInstructions(int y) {
    for (int i = 0; i < instructions.length; i++ ) {
      text(instructions[i], centreText(instructions[i]), y + i*40);
    }
  }

  boolean checkHighScore( int newScore ) {
    // checks if a score is in the top ten
    if ( newScore > getScore(PODIUMCOUNT) || readFile().length < PODIUMCOUNT ) {
      return true;
    }
    return false;
  }
}

class HighScore {
  // object that holds a name and a score together
  int score;
  String name;

  HighScore ( int s, String n ) {
    score = s;
    name = n;
  }
}

class NamesAndScoresPair {
  // this class is so that i can store two arrays and they can be returned together
  // consider getting rid of and implement into the HighScore class?
  int[] scores;
  String[] names;

  NamesAndScoresPair( HighScore[] a ) {
    scores = new int[a.length];
    names = new String[a.length];
    for ( int i = 0; i < a.length; i++ ) {
      scores[i] = a[i].score;
      names[i] = a[i].name;
    }
  }
}
