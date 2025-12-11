// This file contains sample notes and topics for initial data population.
import '../models/note.dart';
import '../models/topic.dart';

class SampleData {
  static List<Topic> getSampleTopics() {
    return [
      const Topic(
        id: 1,
        name: 'Práce',
        description: 'Pracovní úkoly a projekty',
        icon: 'work',
      ),
      const Topic(
        id: 2,
        name: 'Osobní',
        description: 'Osobní život a denní aktivity',
        icon: 'favorite',
      ),
      const Topic(
        id: 3,
        name: 'Nákupy',
        description: 'Nákupní seznamy a plánované nákupy',
        icon: 'shoppingCart',
      ),
      const Topic(
        id: 4,
        name: 'Zdraví & Fitness',
        description: 'Sledování zdraví a fitness cílů',
        icon: 'fitnessCenter',
      ),
      const Topic(
        id: 5,
        name: 'Učení',
        description: 'Studijní poznámky a vzdělávací obsah',
        icon: 'school',
      ),
      const Topic(
        id: 6,
        name: 'Cestování',
        description: 'Cestovní plány a destinace',
        icon: 'flight',
      ),
      const Topic(
        id: 7,
        name: 'Nápady',
        description: 'Kreativní nápady a brainstorming',
        icon: 'lightbulb',
      ),
    ];
  }

  static List<Note> getSampleNotes() {
    return [
      Note(
        id: 1,
        title: 'Q1 Projektová prezentace',
        content:
            'Připravit slajdy na čtvrtletní kontrolní meeting. Zahrnout metriky, úspěchy a plán na Q2.',
        topicIds: const [1],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        icon: 'code',
      ),
      Note(
        id: 2,
        title: 'Týdenní nákup potravin',
        content:
            'Mléko, vejce, chléb, sýr, rajčata, těstoviny, olivový olej, kuřecí prsa, banány, káva',
        topicIds: const [3, 2],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        icon: 'shoppingCart',
      ),
      Note(
        id: 3,
        title: 'Flutter Best Practices',
        content:
            'Používat const konstruktory, vyhýbat se zbytečným rebuildům, používat keys pro list items, upřednostňovat kompozici před dědičností.',
        topicIds: const [5, 1],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        icon: 'code',
      ),
      Note(
        id: 4,
        title: 'Ranní cvičební rutina',
        content:
            '10 min rozcvička, 20 min kardio, 15 min posilování, 5 min protažení. Nezapomenout pít vodu!',
        topicIds: const [4],
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        icon: 'sports',
      ),
      Note(
        id: 5,
        title: 'Plánování letní dovolené',
        content:
            'Výlet do Řecka: Zarezervovat lety do března, rezervovat hotel na Santorini, prozkoumat aktivity v Athénách.',
        topicIds: const [6, 2],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        icon: 'flight',
      ),
      Note(
        id: 6,
        title: 'Nápady na funkce aplikace',
        content:
            'Přidat tmavý režim, implementovat vyhledávací funkcionalitu, vytvořit štítky pro poznámky, přidat export do PDF.',
        topicIds: const [7, 1],
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        icon: 'lightbulb',
      ),
      Note(
        id: 7,
        title: 'Poznámky z týmového meetingu',
        content:
            'Prodiskutovány cíle sprintu, přiděleny úkoly, naplánované code review. Další meeting: pátek 14:00.',
        topicIds: const [1],
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        icon: 'business',
      ),
      Note(
        id: 8,
        title: 'Nápady na narozeninové dárky',
        content:
            'Máma: nová kuchařka nebo zahradní nářadí\nTáta: bezdrátová sluchátka nebo chytré hodinky',
        topicIds: const [2, 3],
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
        icon: 'shoppingCart',
      ),
      Note(
        id: 9,
        title: 'Cíle učení jazyků',
        content:
            'Cvičit španělštinu 30 min denně, dokončit lekce Duolingo, sledovat španělské filmy s titulky.',
        topicIds: const [5, 2],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        icon: 'school',
      ),
      Note(
        id: 10,
        title: 'Nedělní příprava jídel',
        content:
            'Kuřecí teriyaki s rýží, zeleninový stir-fry, overnight oats na snídani. Připravit na 5 dní.',
        topicIds: const [4, 3],
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        icon: 'kitchen',
      ),
      Note(
        id: 11,
        title: 'Doporučené knihy',
        content:
            'Atomové návyky od Jamese Cleara, The Pragmatic Programmer, Clean Code od Roberta Martina',
        topicIds: const [5, 2],
        createdAt: DateTime.now().subtract(const Duration(days: 13)),
        icon: 'menuBook',
      ),
      Note(
        id: 12,
        title: 'Nápady na domácí kancelář',
        content:
            'Pořídit stůl na stání, ergonomická židle, druhý monitor, lepší osvětlení. Rozpočet: 20 000 Kč',
        topicIds: const [1, 2, 3],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        icon: 'home',
      ),
      Note(
        id: 13,
        title: 'Víkendový výlet do hor',
        content:
            'Trasa: Národní park Šumava. Vzít: turistickou obuv, láhev na vodu, svačiny, lékárničku, fotoaparát.',
        topicIds: const [6, 4, 2],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        icon: 'explore',
      ),
    ];
  }
}
