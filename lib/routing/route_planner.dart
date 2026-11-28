import 'package:more/graph.dart';

import 'package:flutter_blind_navigation/model/node_connections.dart';

/// En kısa rota hesaplamasının sonucu.
class RouteResult {
  /// Başlangıçtan hedefe sıralı, yönlü bağlantılar. Her biri [TurnDirection]
  /// bilgisini taşır; sesli yönlendirme bu listeden üretilecek.
  final List<NodeConnections> connections;

  /// Rotanın toplam uzunluğu (metre).
  final double totalDistanceMeters;

  RouteResult({required List<NodeConnections> connections})
    : connections = List.unmodifiable(connections),
      totalDistanceMeters = connections.fold(0.0, (sum, c) => sum + c.distance);

  /// Başlangıç ve hedef aynıysa rota boştur.
  bool get isEmpty => connections.isEmpty;
}

/// Yönlü düğüm grafiği üzerinde en kısa rotayı hesaplar (Dijkstra, `more`).
///
/// Saf Dart'tır: SQLite, NFC, TTS veya Flutter arayüzü gerektirmez.
class RoutePlanner {
  final Set<int> _nodeIds;
  final Graph<int, NodeConnections> _graph;

  RoutePlanner._(this._nodeIds, this._graph);

  /// [nodeIds]: bilinen düğüm ID'leri. [connections]: yönlü bağlantılar
  /// (mesafe metre cinsinden, sonlu ve > 0).
  ///
  /// Aynı yönde birden fazla bağlantı varsa en kısası kullanılır.
  /// Bilinmeyen bir düğüme işaret eden veya mesafesi pozitif olmayan
  /// bağlantılar [ArgumentError] fırlatır.
  factory RoutePlanner({
    required Iterable<int> nodeIds,
    required Iterable<NodeConnections> connections,
  }) {
    final ids = nodeIds.toSet();
    final graph = Graph<int, NodeConnections>(isDirected: true)..addVertices(ids);

    for (final c in connections) {
      if (!ids.contains(c.startNodeId) || !ids.contains(c.destinationNodeId)) {
        throw ArgumentError.value(
          c,
          'connections',
          'Bağlantı bilinmeyen bir düğüme işaret ediyor: '
              '${c.startNodeId} → ${c.destinationNodeId}',
        );
      }
      // isFinite, NaN ve sonsuz değerleri de eler.
      if (!c.distance.isFinite || c.distance <= 0) {
        throw ArgumentError.value(
          c.distance,
          'connections',
          'Bağlantı mesafesi sonlu ve pozitif olmalı: '
              '${c.startNodeId} → ${c.destinationNodeId}',
        );
      }
      final existing = graph.getEdge(c.startNodeId, c.destinationNodeId);
      if (existing == null || c.distance < existing.value.distance) {
        graph.addEdge(c.startNodeId, c.destinationNodeId, value: c);
      }
    }
    return RoutePlanner._(ids, graph);
  }

  /// [startNodeId]'den [destinationNodeId]'ye en kısa rotayı döndürür.
  ///
  /// Rota yoksa `null` döner. Başlangıç ve hedef aynıysa boş rota (0 m)
  /// döner. Bilinmeyen düğüm ID'si [ArgumentError] fırlatır.
  RouteResult? findRoute(int startNodeId, int destinationNodeId) {
    for (final id in [startNodeId, destinationNodeId]) {
      if (!_nodeIds.contains(id)) {
        throw ArgumentError.value(id, 'nodeId', 'Bilinmeyen düğüm');
      }
    }

    final path = _graph.shortestPath(
      startNodeId,
      destinationNodeId,
      edgeCost: (source, target) =>
          _graph.getEdge(source, target)!.value.distance,
    );
    if (path == null) return null;

    final vertices = path.vertices;
    return RouteResult(
      connections: [
        for (var i = 0; i < vertices.length - 1; i++)
          _graph.getEdge(vertices[i], vertices[i + 1])!.value,
      ],
    );
  }
}
