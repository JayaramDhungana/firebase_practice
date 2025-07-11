import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/UI/posts/post_screen.dart';
import 'package:firebase_practice/provider/loading_provider.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPost extends ConsumerStatefulWidget {
  const AddPost({super.key});

  @override
  ConsumerState<AddPost> createState() => _AddPostState();
}

class _AddPostState extends ConsumerState<AddPost> {
  TextEditingController postController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref("Post");

  //Focus Node
  FocusNode postFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text("Add Post", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              focusNode: postFocusNode,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                hintText: "What's on your Mind? ",
              ),
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                ref.read(loadingProvider).changeLoadingState(true);
                databaseRef
                    .child(DateTime.now().microsecondsSinceEpoch.toString())
                    //Khas ma Yo child ma chai id jastai dine raixa yo chai hamro data ko parent node
                    //bando raixa , yesko pani arko sub node dina chai ".child" garera pheri dina milxa re
                    //yehi mathi nai
                    .set({
                      'id': DateTime.now().microsecondsSinceEpoch.toString(),
                      'post': postController.text.toString(),
                    })
                    .then((value) {
                      ref.read(loadingProvider).changeLoadingState(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.green,
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 25),
                              Text(
                                "Data is Added Successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          elevation: 6,
                          margin: EdgeInsets.all(16),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      postController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostScreen()),
                      );
                    })
                    .onError((error, stackTrace) {
                      ref.read(loadingProvider).changeLoadingState(false);
                      Utils().toastMessage(
                        error.toString().split(']').toString(),
                      );
                    });
              },
              child: roundedButton(
                backgroundColor: Colors.deepPurple,
                buttonText: " Add ",
                apploadingstate: ref.watch(loadingProvider).isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
