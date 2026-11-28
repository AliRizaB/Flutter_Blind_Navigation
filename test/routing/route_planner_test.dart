import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_blind_navigation/model/node_connections.dart';
import 'package:flutter_blind_navigation/routing/route_planner.dart';

void main() {
  const a = 1, b = 2, c = 3;

  final ab = NodeConnections(
    startNodeId: a,
    destinationNodeId: b,
    distance: 3,
    direction: TurnDirection.forward,
  );
  final bc = NodeConnections(
    startNodeId: b,
    destinationNodeId: c,
    distance: 4,
    direction: TurnDirection.left,
  );
  final ac = NodeConnections(
    startNodeId: a,
    destinationNodeId: c,
    distance: 12,
    direction: TurnDirection.right,
  );

  late RoutePlanner planner;

  setUp(() {
    planner = RoutePlanner(nodeIds: [a, b, c], connections: [ab, bc, ac]);
  });

  test('A→C en kısa rota A→B→C ve 7 m', () {
    final route = planner.findRoute(a, c);

    expect(route, isNotNull);
    expect(route!.connections, [ab, bc]);
    expect(route.totalDistanceMeters, 7);
    expect(
      route.connections.map((e) => e.direction),
      [TurnDirection.forward, TurnDirection.left],
    );
  });

  test('C→A ters bağlantı olmadığı için rota yok', () {
    expect(planner.findRoute(c, a), isNull);
  });

  test('A→A boş rota ve 0 m', () {
    final route = planner.findRoute(a, a);

    expect(route, isNotNull);
    expect(route!.connections, isEmpty);
    expect(route.totalDistanceMeters, 0);
  });

  test('bilinmeyen düğüm ArgumentError fırlatır', () {
    expect(() => planner.findRoute(a, 99), throwsArgumentError);
  });

  group('aynı yönde paralel bağlantılar', () {
    final long = NodeConnections(
      startNodeId: a,
      destinationNodeId: b,
      distance: 12,
      direction: TurnDirection.right,
    );
    final short = NodeConnections(
      startNodeId: a,
      destinationNodeId: b,
      distance: 3,
      direction: TurnDirection.left,
    );

    for (final (name, order) in [
      ('önce 12 m, sonra 3 m', [long, short]),
      ('önce 3 m, sonra 12 m', [short, long]),
    ]) {
      test('$name eklenince 3 m seçilir', () {
        final p = RoutePlanner(nodeIds: [a, b], connections: order);
        final route = p.findRoute(a, b)!;

        expect(route.connections, [same(short)]);
        expect(route.totalDistanceMeters, 3);
        expect(route.connections.single.direction, TurnDirection.left);
      });
    }
  });

  test('double.infinity mesafe reddedilir', () {
    final infinite = NodeConnections(
      startNodeId: a,
      destinationNodeId: b,
      distance: double.infinity,
      direction: TurnDirection.forward,
    );

    expect(
      () => RoutePlanner(nodeIds: [a, b], connections: [infinite]),
      throwsArgumentError,
    );
  });
}
