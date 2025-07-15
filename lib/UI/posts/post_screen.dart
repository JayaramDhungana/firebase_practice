import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/UI/login_screen.dart';
import 'package:firebase_practice/UI/posts/add_post.dart';
import 'package:firebase_practice/provider/search_provider.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/post_delete_dialog.dart';
import 'package:firebase_practice/widgets/post_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final auth = FirebaseAuth.instance;
  final fireBaseRef = FirebaseDatabase.instance.ref("Post");

  //TextField
  TextEditingController searchController = TextEditingController();
  TextEditingController updateController = TextEditingController();

  //FocusNode
  FocusNode searchFocusNode = FocusNode();
  FocusNode updateFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchFocusNode.dispose();
    updateFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchProvider).searchQuery.toLowerCase();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text("Post Screen", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                debugPrint("Button Tapped");
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("Do you Really Want to LogOut?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            auth
                                .signOut()
                                .then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                })
                                .onError((error, StackTrace) {
                                  Utils().toastMessage(error.toString());
                                });
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          //Yo talako code chai stream builder bata gareko ho, stream builder pani ekdamai important
          //kura ho
          // Expanded(
          //   child: StreamBuilder(
          //     stream: fireBaseRef.onValue,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              focusNode: searchFocusNode,
              controller: searchController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                ref.read(searchProvider).updateSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(child: CircularProgressIndicator()),
              query: fireBaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('post').value.toString();

                // Apply search filtering
                if (searchQuery.isNotEmpty &&
                    !title.toLowerCase().contains(searchQuery)) {
                  return SizedBox.shrink(); // Don't render this item
                }

                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(title),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            postUpdateDialog(
                              id: snapshot.child('id').value.toString(),
                              fireBaseRef: fireBaseRef,
                              auth: auth,
                              postTitle: title,
                              context: context,
                              updateController: updateController,
                              updateFocusNode: updateFocusNode,
                              rootcontext: context,
                            );
                          },
                          value: 1,
                          child: ListTile(
                            leading: CircleAvatar(child: Icon(Icons.edit)),
                            title: Text("Edit"),
                          ),
                        ),

                        PopupMenuItem(
                          onTap: () {
                            postDeleteDialog(
                              fireBaseRef: fireBaseRef,
                              context: context,
                              rootcontext: context,
                              id: snapshot.child('id').value.toString(),
                            );
                          },
                          value: 2,
                          child: ListTile(
                            leading: CircleAvatar(child: Icon(Icons.delete)),
                            title: Text("Delete"),
                          ),
                        ),
                      ];
                    },
                  ),
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
