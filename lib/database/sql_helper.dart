import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE blogs(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      blogid TEXT,
      title TEXT,
      imageurl TEXT
    )
''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('blogs.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<void> createBlog(
      String title, String imageUrl, String id) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'blogid': id,
      'imageurl': imageUrl,
      // 'description': description
    };
    await db.insert('blogs', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getBlogs() async {
    final db = await SQLHelper.db();
    return db.query('blogs', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getBlog(String id) async {
    final db = await SQLHelper.db();
    return db.query('blogs',
        orderBy: 'id', where: 'blogid = ?', whereArgs: [id], limit: 1);
  }

  // static Future<List<Map<String, dynamic>>> getFavouriteBlogs() async {
  //   final db = await SQLHelper.db();
  //   return db.query('blogs', orderBy: 'id', where: 'favourite = 1');
  // }

  static Future<void> updateBlog(
      String id, String title, String imageUrl) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'imageurl': imageUrl,
      // 'description': description
    };

    await db.update('blogs', data, where: 'blogid = ?', whereArgs: [id]);
  }

  static Future<void> deleteBlog(String id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('blogs', where: 'blogdid = ?', whereArgs: [id]);
    } catch (e) {
      throw ('e');
    }
  }

  static Future<void> deleteBlogs() async {
    final db = await SQLHelper.db();
    try {
      await db.delete('blogs');
    } catch (e) {
      throw ('e');
    }
  }
}
