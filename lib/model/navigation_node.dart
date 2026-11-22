import 'package:flutter_blind_navigation/service/database_service.dart';

class NavigationNode {
  int? id;
  final String name;
  final String nfcId;

  NavigationNode({required this.id, required this.name, required this.nfcId});

  factory NavigationNode.fromMap(Map<String, dynamic> map) {
    return NavigationNode(
      id: map[DBConstants.nodeId] as int?,
      name: map[DBConstants.nodeName] as String,
      nfcId: map[DBConstants.nodeNfcId] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBConstants.nodeId: id,
      DBConstants.nodeName: name,
      DBConstants.nodeNfcId: nfcId,
    };
  }
}
