import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/simple_ballot_editor.dart';

class SimpleEditorWidget extends StatelessWidget {
  const SimpleEditorWidget();

  @override
  Widget build(BuildContext context) => Consumer<SimpleBallotEditor>(
        builder: (_, editor, __) => Form(
          autovalidate: true,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 500,
                height: 500,
                padding: const EdgeInsets.all(10),
                color: editor.error
                    ? Colors.redAccent.shade100
                    : Colors.grey.shade100,
                child: TextFormField(
                  controller: editor.textController,
                  validator: editor.validator,
                  decoration: const InputDecoration(errorStyle: _monoStyle),
                  maxLines: null,
                  style: _monoStyle,
                ),
              ),
              if (editor.valueChanged)
                FloatingActionButton(
                  child: Icon(Icons.save_alt),
                  disabledElevation: 0,
                  onPressed: editor.commitChange,
                ),
            ],
          ),
        ),
      );
}

const _monoStyle = TextStyle(fontFamily: 'RobotoMono');
