import 'package:flutter_blind_navigation/service/database_service.dart';

enum TurnDirection {
  left('left', 'Sola dönün', 'Sol'),
  right('right', 'Sağa dönün', 'Sağ'),
  forward('forward', 'Düz ilerleyin', 'İleri'),
  backward('backward', 'Geri dönün', 'Geri'),
  upStairs('up_stairs', 'Merdivenden yukarı çıkın', 'Merdiven Yukarı'),
  downStairs('down_stairs', 'Merdivenden aşağı inin', 'Merdiven Aşağı'),
  upElevator('up_elevator', 'Asansörle yukarı çıkın', 'Asansör Yukarı'),
  downElevator('down_elevator', 'Asansörle aşağı inin', 'Asansör Aşağı');

  final String dbValue;
  final String ttsPhrase;
  final String shortLabel;

  const TurnDirection(this.dbValue, this.ttsPhrase, this.shortLabel);

  String toDb() => dbValue;

  static TurnDirection fromDb(String value) {
    return TurnDirection.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => TurnDirection.forward,
    );
  }
}

class NodeConnections {
  final int? id;
  final int startNodeId;
  final int destinationNodeId;
  final double distance;
  final TurnDirection direction;

  NodeConnections({
    this.id,
    required this.startNodeId,
    required this.destinationNodeId,
    required this.distance,
    required this.direction,
  });

  factory NodeConnections.fromMap(Map<String, dynamic> map) {
    return NodeConnections(
      id: map[DBConstants.connectionId] as int?,
      startNodeId: map[DBConstants.startNodeId] as int,
      destinationNodeId: map[DBConstants.destinationNodeId] as int,
      distance: (map[DBConstants.distanceMeters] as num).toDouble(),
      direction: TurnDirection.fromDb(map[DBConstants.direction] as String) ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBConstants.connectionId: id,
      DBConstants.startNodeId: startNodeId,
      DBConstants.destinationNodeId: destinationNodeId,
      DBConstants.distanceMeters: distance,
      DBConstants.direction: direction.toDb(),
    };
  }
}
