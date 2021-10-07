import 'dart:collection';

import 'package:collection/collection.dart';

import '../ranked_ballot.dart';
import 'ballot_line.dart';
import 'parse.dart';

String _defaultCandidateText(Object candidate) => candidate.toString();

/// A helper for creating [RankedBallot]s by parsing text input.
///
/// Useful for development and debugging.
class BallotLines<TCandidate extends Comparable> {
  final int countWidth;
  final int candidateWidth;
  final List<BallotLine<TCandidate>> _lines;

  final String Function(TCandidate) candidateToText;

  BallotLines(
    this._lines, {
    this.candidateToText = _defaultCandidateText,
  })  : countWidth = _longest(_lines.map((l) => l.count.toString())),
        candidateWidth =
            _longest(_lines.expand((l) => l.candidates).map(candidateToText));

  factory BallotLines.fromBallots(
    Iterable<RankedBallot<TCandidate>> ballots, {
    String Function(TCandidate) candidateToText = _defaultCandidateText,
  }) {
    final grouped = ballots.fold<Map<RankedBallot<TCandidate>, int>>(
      <RankedBallot<TCandidate>, int>{},
      (map, ballot) {
        map[ballot] = (map[ballot] ?? 0) + 1;
        return map;
      },
    );

    return BallotLines(
      grouped.entries
          .map((e) => BallotLine(e.value, e.key.rank))
          .toList(growable: false)
        ..sort(),
      candidateToText: candidateToText,
    );
  }

  factory BallotLines.parse(
    String input,
    Map<String, TCandidate> Function(Set<String>) candidateFromText, {
    String Function(TCandidate) candidateToText = _defaultCandidateText,
  }) {
    final map = LinkedHashMap<List<String>, int>(
      equals: const ListEquality<String>().equals,
      hashCode: const ListEquality<String>().hash,
    );

    for (var value in parse(input)) {
      map[value.candidates] = (map[value.candidates] ?? 0) + value.count;
    }

    final candidateStrings = map.keys.expand((c) => c).toSet();

    final candidateCache = candidateFromText(candidateStrings);

    final lines = map.entries
        .map(
          (e) => BallotLine<TCandidate>(
            e.value,
            e.key
                .map((string) => candidateCache[string]!)
                .toList(growable: false),
          ),
        )
        .toList(growable: false)
      ..sort();

    return BallotLines(lines, candidateToText: candidateToText);
  }

  String? _text;

  String get text => _text ??= _lines.map((b) {
        final candidates = b.candidates
            .map((c) => candidateToText(c).padRight(candidateWidth))
            .join(' > ');
        return '${b.count.toString().padLeft(countWidth)} : $candidates';
      }).join('\n');

  Iterable<RankedBallot<TCandidate>> get ballots sync* {
    for (var line in _lines) {
      final ballot = RankedBallot<TCandidate>(line.candidates);
      yield* Iterable.generate(line.count, (_) => ballot);
    }
  }

  @override
  bool operator ==(Object other) =>
      other is BallotLines<TCandidate> &&
      ListEquality<BallotLine<TCandidate>>().equals(other._lines, _lines);

  @override
  int get hashCode => Object.hashAll(_lines);
}

int _longest(Iterable<String> values) => values.fold<int>(0, (length, c) {
      if (c.length > length) {
        return c.length;
      }
      return length;
    });
