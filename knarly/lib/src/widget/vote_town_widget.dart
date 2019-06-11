import 'dart:math' as math;

import 'package:flutter_web/material.dart' hide TextStyle;
import 'package:flutter_web_ui/ui.dart';
import 'package:provider/provider.dart';

import '../model/vote_town.dart';

class VoteTownWidget extends StatelessWidget {
  const VoteTownWidget();

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _VoteTownPainter(Provider.of<VoteTown>(context)),
        size: const Size(400, 400),
        isComplex: true,
        willChange: true,
      );
}

class _VoteTownPainter extends CustomPainter {
  final VoteTown _voteTown;

  _VoteTownPainter(this._voteTown);

  @override
  void paint(Canvas canvas, Size size) {
    final smallerDimension = math.min(size.height, size.width);

    final offsetMultiplier = smallerDimension / 100;
    final radius = 2.5 * offsetMultiplier;

    for (var voter in _voteTown.voters) {
      canvas.drawCircle(voter.location.toOffset() * offsetMultiplier, radius,
          Paint()..color = voter.closestCandidates.first.dartColor);
    }

    for (var candidate in _voteTown.candidates) {
      final center = candidate.location.toOffset() * offsetMultiplier;

      canvas
        ..drawCircle(
          center,
          radius * 2,
          Paint()
            ..color = candidate.color
            ..style = PaintingStyle.fill,
        )
        ..drawCircle(
          center,
          radius * 2,
          Paint()
            ..color = Colors.black.withAlpha(128)
            ..style = PaintingStyle.stroke,
        );

      final pb = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: radius * 2.5,
        ),
      )
        ..pushStyle(
          TextStyle(
            color: Colors.black,
            //fontWeight: FontWeight.bold,
          ),
        )
        ..addText(candidate.id);

      final candidateParagraphConstraints =
          ParagraphConstraints(width: radius * 4);

      final paragraph = pb.build()..layout(candidateParagraphConstraints);

      canvas.drawParagraph(
          paragraph, center - Offset(radius * 2, radius * 1.4));
    }
  }

  @override
  bool shouldRepaint(_VoteTownPainter oldDelegate) =>
      _voteTown != oldDelegate._voteTown;
}
