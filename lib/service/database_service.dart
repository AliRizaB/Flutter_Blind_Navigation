import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBConstants {
  // Nodes table
  static const String nodeTable = 'nodes';
  static const String nodeId = 'node_id';
  static const String nodeName = 'node_name';
  static const String nodeNfcId = 'node_nfc_id';

  // NodeConnections table
  static const String connectionTable = 'node_connections';
  static const String connectionId = 'connection_id';
  static const String startNodeId = 'start_node_id';
  static const String destinationNodeId = 'destination_node_id';
  static const String distanceMeters = 'distance_meters';
  static const String direction = 'direction';
}

class DatabaseService extends GetxService {
  static Database? _db;

  Database get db => _db!;

  Future<DatabaseService> init() async {
    if (_db != null) return this;
    _db = await getDatabase();
    return this;
  }

  Future<Database> getDatabase() async {
    final databaseDirectory = await getDatabasesPath();
    final path = join(databaseDirectory, "nodes_db.db");
    final database = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );

    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE ${DBConstants.nodeTable} (
        ${DBConstants.nodeId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.nodeName} TEXT NOT NULL,
        ${DBConstants.nodeNfcId} TEXT UNIQUE NOT NULL
      )''');

    await db.execute('''
      CREATE TABLE ${DBConstants.connectionTable} (
        ${DBConstants.connectionId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.startNodeId} INTEGER NOT NULL,
        ${DBConstants.destinationNodeId} INTEGER NOT NULL,
        ${DBConstants.distanceMeters} REAL NOT NULL CHECK (${DBConstants.distanceMeters} > 0),
        ${DBConstants.direction} TEXT NOT NULL CHECK (${DBConstants.direction} in (
          'left', 'right', 
          'forward', 'backward',
          'up_stairs', 'down_stairs',
          'up_elevator', 'down_elevator'
        )),

        FOREIGN KEY(${DBConstants.startNodeId}) REFERENCES ${DBConstants.nodeTable} (${DBConstants.nodeId}) ON DELETE CASCADE,
        FOREIGN KEY(${DBConstants.destinationNodeId}) REFERENCES ${DBConstants.nodeTable} (${DBConstants.nodeId}) ON DELETE CASCADE
      )
''');
    // For faster look-ups Index tables are created
    db.execute(
      'CREATE INDEX idx_nodes_nfc ON ${DBConstants.nodeTable} (${DBConstants.nodeNfcId})',
    );

    db.execute(
      'CREATE INDEX idx_conn_start ON ${DBConstants.connectionTable} (${DBConstants.startNodeId})',
    );
  }


  // TODO: QUERYYING Add Here or Make a special Repository
}
