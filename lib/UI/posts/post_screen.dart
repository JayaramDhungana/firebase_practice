import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/UI/posts/add_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text("Post Screen", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          //Yo talako code chai stream builder bata gareko ho, stream builder pani ekdamai important 
          //kura ho 
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Center(child: CircularProgressIndicator());
          //       }

          //       if (snapshot.hasError) {
          //         return Center(child: Text("Error: ${snapshot.error}"));
          //       }

          //       final value = snapshot.data?.snapshot.value;

          //       if (value == null || value is! Map) {
          //         return Center(child: Text("No data found"));
          //       }

          //       // yeha value bhaneko chai firebase bata aayeko raw data ho jaslai 
          //       //yeha Map ma forcefully rakhidai xa

          //       final map = value as Map<dynamic, dynamic>;
          //       //Yo talako line le chai map lai ekaichoti list banaidinxa
          //       final list = map.values.toList();

          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (context, index) {
          //           final dataToShow = list[index];
          //           final title = dataToShow['post'] ?? 'No Title';
          //           return ListTile(
          //             leading: CircleAvatar(child: Text("${index + 1}")),
          //             title: Text(title.toString()),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(child: CircularProgressIndicator()),
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(snapshot.child("post").value.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPost()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
