import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/simple_ballot_editor.dart';

class SimpleEditorWidget extends StatelessWidget {
  const SimpleEditorWidget();

  @override
  Widget build(BuildContext context) => Consumer<SimpleBallotEditor>(
        builder: (context, editor, __) => Form(
          autovalidateMode: AutovalidateMode.always,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 500,
                height: 500,
                padding: const EdgeInsets.all(10),
                color: editor.error
                    ? Theme.of(context).errorColor.withAlpha(85)
                    : Theme.of(context).dialogBackgroundColor,
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
                  disabledElevation: 0,
                  onPressed: editor.commitChange,
                  child: const Icon(Icons.save_alt),
                ),
            ],
          ),
        ),
      );
}

const _monoStyle = TextStyle(fontFamily: 'RobotoMono');
