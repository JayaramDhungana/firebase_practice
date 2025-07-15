import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';

Future<void> postUpdateDialog({
  required BuildContext rootcontext,
  required BuildContext context,
  required TextEditingController updateController,
  required FocusNode updateFocusNode,
  required String postTitle,
  required FirebaseAuth auth,
  required DatabaseReference fireBaseRef,
  required String id,
}) {
  updateController.text = postTitle;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Update"),
        content: TextFormField(
          focusNode: updateFocusNode,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          controller: updateController,
          decoration: InputDecoration(
            labelText: "Update",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              fireBaseRef
                  .child(id)
                  .update({'post': updateController.text.trim().toString()})
                  .then((value) {
                    ScaffoldMessenger.of(rootcontext).showSnackBar(
                      snackBarWidget(
                        textToShow: "Data is Successfully Updated",
                      ),
                    );
                  })
                  .onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}
