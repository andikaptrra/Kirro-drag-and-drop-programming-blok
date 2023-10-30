import 'package:flutter/material.dart';
import '../global_Variabel/variabel.dart';
import '../utillitas/database/database_user.dart';


class _LeaderBoardState extends State<LeaderBoard> {
  
  DatabaseUser databaseUser = DatabaseUser();

  
  Future<void> getAllUser() async {
    userList = await databaseUser.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Leader Board',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usersRank.length,
              itemBuilder: (context, index) {
                final user = usersRank[index];
                print('${user.name} , ${user.score}');
                return ListTile(
                  leading: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    user.score.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardUser {
  final String name;
  final int score;

  LeaderboardUser({required this.name, required this.score});
}

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}
