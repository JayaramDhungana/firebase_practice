import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';

Future<void> postDeleteDialog({
  required DatabaseReference fireBaseRef,
  required BuildContext rootcontext,
  required BuildContext context,
  required String id,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text("Do you  really want to delete this Post?"),
        actions: [
          TextButton(
            onPressed: () {
              fireBaseRef.child(id).remove();
              ScaffoldMessenger.of(rootcontext).showSnackBar(
                snackBarWidget(
                  backgroundColor: Colors.red,
                  textToShow: "Post Deleted Successfully",
                ),
              );
              Navigator.pop(context);
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
}
