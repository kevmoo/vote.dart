import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/simple_ballot_editor.dart';

class SimpleEditorWidget extends StatelessWidget {
  const SimpleEditorWidget();

  @override
  Widget build(BuildContext context) => Consumer<SimpleBallotEditor>(
        builder: (_, editor, __) => Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 500,
              height: 500,
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade100,
              child: TextField(
                decoration: null,
                maxLines: null,
                controller: editor.textController,
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.save_alt),
              onPressed: editor.action,
            ),
          ],
        ),
      );
}
