import 'package:flutter_web/material.dart' hide TextStyle;
import 'package:flutter_web_ui/ui.dart';
import 'package:provider/provider.dart';

import 'model.dart';

class VoteTownWidget extends StatelessWidget {
  const VoteTownWidget();

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _VoteTownPainter(Provider.of<VoteTown>(context)),
        size: const Size(400, 400),
      );
}

final _voterPaint = Paint()..color = Colors.blue;
final _candidatePaint = Paint()
  ..color = const Color.fromARGB(255, 255, 102, 102);
final _backgroundPaint = Paint()..color = const Color.fromARGB(12, 0, 0, 0);

class _VoteTownPainter extends CustomPainter {
  final VoteTown _voteTown;

  _VoteTownPainter(this._voteTown);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, _backgroundPaint);

    const offsetMultiplier = 4.0;
    const radius = 2.5 * offsetMultiplier;

    for (var voter in _voteTown.voters) {
      canvas.drawCircle(
          voter.location.toOffset() * offsetMultiplier, radius, _voterPaint);
    }

    for (var candidate in _voteTown.candidates) {
      final center = candidate.location.toOffset() * offsetMultiplier;
      canvas.drawCircle(center, radius * 2, _candidatePaint);

      final pb = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: radius * 2,
        ),
      )
        ..pushStyle(
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
        ..addText(candidate.id);

      const candidateParagraphConstraints =
          ParagraphConstraints(width: radius * 4);

      final paragraph = pb.build()..layout(candidateParagraphConstraints);

      canvas.drawParagraph(
          paragraph, center - const Offset(radius * 2, radius * 1.2));
    }
  }

  @override
  bool shouldRepaint(_VoteTownPainter oldDelegate) =>
      _voteTown != oldDelegate._voteTown;
}