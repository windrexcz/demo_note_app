import 'package:flutter/material.dart';

/// Centralized constant icon definitions for the app.
/// This allows Flutter to tree-shake unused icons in release builds.
class AppIcons {
  AppIcons._(); // Private constructor to prevent instantiation

  // Icon definitions
  static const IconData note = Icons.note;
  static const IconData noteAlt = Icons.note_alt;
  static const IconData description = Icons.description;
  static const IconData article = Icons.article;
  static const IconData editNote = Icons.edit_note;

  static const IconData category = Icons.category;
  static const IconData folder = Icons.folder;
  static const IconData topic = Icons.topic;
  static const IconData label = Icons.label;
  static const IconData bookmark = Icons.bookmark;

  static const IconData school = Icons.school;
  static const IconData book = Icons.book;
  static const IconData menuBook = Icons.menu_book;
  static const IconData libraryBooks = Icons.library_books;
  static const IconData autoStories = Icons.auto_stories;

  static const IconData work = Icons.work;
  static const IconData business = Icons.business;
  static const IconData assignment = Icons.assignment;
  static const IconData task = Icons.task;
  static const IconData checklist = Icons.checklist;

  static const IconData chat = Icons.chat;
  static const IconData message = Icons.message;
  static const IconData email = Icons.email;
  static const IconData forum = Icons.forum;
  static const IconData comment = Icons.comment;

  static const IconData palette = Icons.palette;
  static const IconData brush = Icons.brush;
  static const IconData draw = Icons.draw;
  static const IconData create = Icons.create;
  static const IconData designServices = Icons.design_services;

  static const IconData computer = Icons.computer;
  static const IconData code = Icons.code;
  static const IconData terminal = Icons.terminal;
  static const IconData developerMode = Icons.developer_mode;
  static const IconData bugReport = Icons.bug_report;

  static const IconData science = Icons.science;
  static const IconData biotech = Icons.biotech;
  static const IconData park = Icons.park;
  static const IconData eco = Icons.eco;
  static const IconData nature = Icons.nature;

  static const IconData fitnessCenter = Icons.fitness_center;
  static const IconData healthAndSafety = Icons.health_and_safety;
  static const IconData medicalServices = Icons.medical_services;
  static const IconData sports = Icons.sports;
  static const IconData selfImprovement = Icons.self_improvement;

  static const IconData travelExplore = Icons.travel_explore;
  static const IconData flight = Icons.flight;
  static const IconData map = Icons.map;
  static const IconData locationOn = Icons.location_on;
  static const IconData explore = Icons.explore;

  static const IconData sportsEsports = Icons.sports_esports;
  static const IconData musicNote = Icons.music_note;
  static const IconData movie = Icons.movie;
  static const IconData photoCamera = Icons.photo_camera;
  static const IconData videocam = Icons.videocam;

  static const IconData shoppingCart = Icons.shopping_cart;
  static const IconData accountBalance = Icons.account_balance;
  static const IconData creditCard = Icons.credit_card;
  static const IconData payments = Icons.payments;
  static const IconData monetizationOn = Icons.monetization_on;

  static const IconData home = Icons.home;
  static const IconData kitchen = Icons.kitchen;
  static const IconData bed = Icons.bed;
  static const IconData chair = Icons.chair;
  static const IconData yard = Icons.yard;

  static const IconData star = Icons.star;
  static const IconData favorite = Icons.favorite;
  static const IconData priorityHigh = Icons.priority_high;
  static const IconData warning = Icons.warning;
  static const IconData lightbulb = Icons.lightbulb;

  /// Map of icon keys to IconData for serialization/deserialization
  static const Map<String, IconData> iconMap = {
    'note': note,
    'noteAlt': noteAlt,
    'description': description,
    'article': article,
    'editNote': editNote,
    'category': category,
    'folder': folder,
    'topic': topic,
    'label': label,
    'bookmark': bookmark,
    'school': school,
    'book': book,
    'menuBook': menuBook,
    'libraryBooks': libraryBooks,
    'autoStories': autoStories,
    'work': work,
    'business': business,
    'assignment': assignment,
    'task': task,
    'checklist': checklist,
    'chat': chat,
    'message': message,
    'email': email,
    'forum': forum,
    'comment': comment,
    'palette': palette,
    'brush': brush,
    'draw': draw,
    'create': create,
    'designServices': designServices,
    'computer': computer,
    'code': code,
    'terminal': terminal,
    'developerMode': developerMode,
    'bugReport': bugReport,
    'science': science,
    'biotech': biotech,
    'park': park,
    'eco': eco,
    'nature': nature,
    'fitnessCenter': fitnessCenter,
    'healthAndSafety': healthAndSafety,
    'medicalServices': medicalServices,
    'sports': sports,
    'selfImprovement': selfImprovement,
    'travelExplore': travelExplore,
    'flight': flight,
    'map': map,
    'locationOn': locationOn,
    'explore': explore,
    'sportsEsports': sportsEsports,
    'musicNote': musicNote,
    'movie': movie,
    'photoCamera': photoCamera,
    'videocam': videocam,
    'shoppingCart': shoppingCart,
    'accountBalance': accountBalance,
    'creditCard': creditCard,
    'payments': payments,
    'monetizationOn': monetizationOn,
    'home': home,
    'kitchen': kitchen,
    'bed': bed,
    'chair': chair,
    'yard': yard,
    'star': star,
    'favorite': favorite,
    'priorityHigh': priorityHigh,
    'warning': warning,
    'lightbulb': lightbulb,
  };

  /// List of available icons for the icon picker
  static const List<MapEntry<String, IconData>> availableIcons = [
    MapEntry('note', note),
    MapEntry('noteAlt', noteAlt),
    MapEntry('description', description),
    MapEntry('article', article),
    MapEntry('editNote', editNote),
    MapEntry('category', category),
    MapEntry('folder', folder),
    MapEntry('topic', topic),
    MapEntry('label', label),
    MapEntry('bookmark', bookmark),
    MapEntry('school', school),
    MapEntry('book', book),
    MapEntry('menuBook', menuBook),
    MapEntry('libraryBooks', libraryBooks),
    MapEntry('autoStories', autoStories),
    MapEntry('work', work),
    MapEntry('business', business),
    MapEntry('assignment', assignment),
    MapEntry('task', task),
    MapEntry('checklist', checklist),
    MapEntry('chat', chat),
    MapEntry('message', message),
    MapEntry('email', email),
    MapEntry('forum', forum),
    MapEntry('comment', comment),
    MapEntry('palette', palette),
    MapEntry('brush', brush),
    MapEntry('draw', draw),
    MapEntry('create', create),
    MapEntry('designServices', designServices),
    MapEntry('computer', computer),
    MapEntry('code', code),
    MapEntry('terminal', terminal),
    MapEntry('developerMode', developerMode),
    MapEntry('bugReport', bugReport),
    MapEntry('science', science),
    MapEntry('biotech', biotech),
    MapEntry('park', park),
    MapEntry('eco', eco),
    MapEntry('nature', nature),
    MapEntry('fitnessCenter', fitnessCenter),
    MapEntry('healthAndSafety', healthAndSafety),
    MapEntry('medicalServices', medicalServices),
    MapEntry('sports', sports),
    MapEntry('selfImprovement', selfImprovement),
    MapEntry('travelExplore', travelExplore),
    MapEntry('flight', flight),
    MapEntry('map', map),
    MapEntry('locationOn', locationOn),
    MapEntry('explore', explore),
    MapEntry('sportsEsports', sportsEsports),
    MapEntry('musicNote', musicNote),
    MapEntry('movie', movie),
    MapEntry('photoCamera', photoCamera),
    MapEntry('videocam', videocam),
    MapEntry('shoppingCart', shoppingCart),
    MapEntry('accountBalance', accountBalance),
    MapEntry('creditCard', creditCard),
    MapEntry('payments', payments),
    MapEntry('monetizationOn', monetizationOn),
    MapEntry('home', home),
    MapEntry('kitchen', kitchen),
    MapEntry('bed', bed),
    MapEntry('chair', chair),
    MapEntry('yard', yard),
    MapEntry('star', star),
    MapEntry('favorite', favorite),
    MapEntry('priorityHigh', priorityHigh),
    MapEntry('warning', warning),
    MapEntry('lightbulb', lightbulb),
  ];

  /// Get IconData from string key
  static IconData? fromKey(String? key) {
    if (key == null) return null;
    return iconMap[key];
  }

  /// Get string key from IconData (for reverse lookup)
  static String? toKey(IconData? iconData) {
    if (iconData == null) return null;
    for (final entry in iconMap.entries) {
      if (entry.value.codePoint == iconData.codePoint) {
        return entry.key;
      }
    }
    return null;
  }
}
