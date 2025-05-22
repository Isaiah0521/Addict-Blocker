import 'package:flutter/material.dart';

class VisitData extends ChangeNotifier {
  final Map<String, int> websiteVisits = {};
  final Map<String, int> appVisits = {};

  void addWebsiteVisit(String website) {
    websiteVisits[website] = (websiteVisits[website] ?? 0) + 1;
    notifyListeners();
  }

  void addAppVisit(String app) {
    appVisits[app] = (appVisits[app] ?? 0) + 1;
    notifyListeners();
  }
}
