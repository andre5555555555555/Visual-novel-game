import 'package:helloworld_hellolove/scenes/scene.dart';
import 'package:helloworld_hellolove/sets/characters.dart';

class SceneSets {
  final String name;
  final List<Scene> scenes;

  SceneSets({required this.name, required this.scenes});
}

List<SceneSets> getChapters() {
  return [
    SceneSets(
      name: 'Chapter1',
      scenes: [
        // Scene 1: Show school - Morning
        Scene(
          location: 'School Rooftop_Day',
          dialogueText:
              "The first day of classes always feels the same, nerve wracking.\n"
              "New faces, new buildings, but all the same uneasy environment.\n"
              "Although I’m enrolled in a different school now, the scent of the classroom is still the same.\n"
              "ByteStream University.\n"
              "An elite institution made to raise future Information Technologists.\n"
              "When I applied, I thought that meant an academy for creative media... Turns out, 'Information Technology' isn’t about making things look good… it’s about making them work.\n"
              "And I… might’ve made a terrible mistake.",
        ),

        // Scene 2: Classroom - Morning
        Scene(
          location: 'School Rooftop_Day',
          characterAtCenter: akagiKohaku,
          dialogueText:
              "Classmate: Zup bud, quite the face you’re making for the first day of class.\n"
              "MC: Oh, I’m ____.\n"
              "Kohaku: What a name. Anyways, back to the earlier question, what’s with the face?\n"
              "MC: I might have enrolled in the wrong school…\n"
              "Kohaku: WHAT?! You enrolled thinking this was an art school?!",
        ),

        // Scene 3: Classroom - Afternoon
        Scene(
          location: 'School Rooftop_Night',
          charactersAtLeft: [akagiKohaku],
          dialogueText:
              "MC: Akagi-kun… Tasukete~!\n"
              "Kohaku: Dude… It’s just the first day yet you look like you just barely survived the examination.\n"
              "MC: I am unfamiliar with the words you guys are talking about.\n"
              "Kohaku: Sucks to be you. I’m off to apply for a club.\n"
              "MC: Too bad, guess I’ll just hit the library then.",
        ),

        // Scene 4: Library - Afternoon
        Scene(
          location: 'School Rooftop_Day',
          characterAtCenter: habaneAkari,
          dialogueText:
              "Akari: It was you!\n"
              "MC: It's embarrassing, but yes, it was me…\n"
              "Akari: But why though? The earlier lessons were easy, no?\n"
              "MC: For you, maybe. I enrolled here by mistake…\n"
              "Akari: So, what's your plan now? It's going to be hard for you in the long run.\n"
              "MC: That's why I came here, to somehow get a grasp on what hell I entered.\n"
              "Akari: That's impressive, but won't having a friend teach you help?",
        ),

        // Scene 5: Classroom
        Scene(
          location: 'School Rooftop_Day',
          charactersAtRight: [akagiKohaku],
          dialogueText:
              "Kohaku: Oh, you’re looking less dead today.\n"
              "MC: Yeah, somehow…\n"
              "Kohaku: So, how was your library run?\n"
              "MC: Blessed by a goddess.\n"
              "Nozomi-sensei: Back to your seats, brats!\n"
              "Nozomi-sensei: Today, we’ll talk about the basics of Programming Logic...",
        ),

        // Scene 6: Library - Afternoon (Mini game 1)
        Scene(
          location: 'School Rooftop_Day',
          characterAtCenter: habaneAkari,
          dialogueText:
              "Akari: You finally came! Ready for our study time? Let's review what we learned this morning.\n"
              "MC: Wawit, already?\n"
              "Akari: Of course! Pop quiz~",
        ),

        // Scene 7: Classroom
        Scene(
          location: 'School Rooftop_Day',
          charactersAtLeft: [akagiKohaku],
          dialogueText:
              "Kohaku: So, any improvement?\n"
              "MC: The goddess graced me again.",
        ),

        // Scene 8: Library
        Scene(
          location: 'School Rooftop_Day',
          charactersAtRight: [hotaruYuna],
          dialogueText:
              "Akari: Hi again, ready for today?\n"
              "MC: Can’t have what happened yesterday stop me!\n"
              "Akari: I love the spirit. Oh, right, this is my friend, Yuno.\n"
              "Yuno: Hotaru Yuna desu~. A… uh… resident chef, I guess?\n"
              "MC: Chef?\n"
              "Akari: She’s here to observe.",
        ),

        // Scene 9: Classroom
        Scene(
          location: 'Coast Road',
          characterAtCenter: akagiKohaku,
          dialogueText:
              "Nozomi-sensei: Today’s topic is about Loops...\n"
              "Imagine you want to tell a computer to say 'Hello' ten times...",
        ),

        // Scene 10: Library (Mini game 2)
        Scene(
          location: 'School Rooftop_Day',
          characterAtCenter: habaneAkari,
          dialogueText:
              "Akari: First Question: What is the main purpose of a loop?\n"
              "MC: To repeat actions automatically.",
        ),

        // Scene 11: Classroom
        Scene(
          location: 'School Rooftop_Day',
          charactersAtLeft: [akagiKohaku],
          charactersAtRight: [habaneAkari],
          dialogueText:
              "Kohaku: And today we’ll review Operators.\n"
              "MC: Got it.",
        ),
      ],
    ),
  ];
}
