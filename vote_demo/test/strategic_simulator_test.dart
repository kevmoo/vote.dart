import 'dart:math';

import 'package:test/test.dart';
import 'package:vote_demo/src/model/strategic_simulator.dart';
import 'package:vote_demo/src/model/vote_town.dart';

void main() {
  group('VoteTownPreset & detectPluralitySpoiler', () {
    test('twoCandidates preset has no spoiler and all methods agree', () {
      final town = VoteTownPreset.twoCandidates.createTown();
      expect(town.candidates, hasLength(2));
      expect(town.pluralityElection.singleWinner?.id, 'A');
      expect(town.condorcetElection.singleWinner?.id, 'A');
      expect(town.irvElection.singleWinner?.id, 'A');
      expect(detectPluralitySpoiler(town), isNull);
    });

    test('pluralitySpoiler preset flips Plurality to B while A wins Condorcet '
        'and IRV', () {
      final town = VoteTownPreset.pluralitySpoiler.createTown();
      expect(town.candidates, hasLength(3));
      expect(town.pluralityElection.singleWinner?.id, 'B');
      expect(town.condorcetElection.singleWinner?.id, 'A');
      expect(town.irvElection.singleWinner?.id, 'A');

      final spoiler = detectPluralitySpoiler(town);
      expect(spoiler, isNotNull);
      expect(spoiler!.pluralityWinner.id, 'B');
      expect(spoiler.condorcetWinner.id, 'A');
      expect(spoiler.spoilerCandidate?.id, 'C');
      expect(
        spoiler.condorcetOverPluralityVotes,
        greaterThan(spoiler.pluralityOverCondorcetVotes),
      );
    });

    test('irvCenterSqueeze preset squeezes center candidate A out in IRV and '
        'Plurality while A wins Condorcet', () {
      final town = VoteTownPreset.irvCenterSqueeze.createTown();
      expect(town.distancePlaces.first.single.id, 'A');
      expect(town.distancePlaces.first.averageDistance, 0.0);
      expect(town.condorcetElection.singleWinner?.id, 'A');
      expect(town.pluralityElection.singleWinner?.id, isNot('A'));
      expect(town.irvElection.singleWinner?.id, isNot('A'));
    });
  });

  group('computeStrategicMove & advancePhysicsFrame', () {
    test(
      'All Selfish under Condorcet converges from corners toward center',
      () {
        var town = VoteTown.fromLocations(const [
          Point(15, 15),
          Point(135, 15),
          Point(15, 135),
          Point(135, 135),
        ]);

        double totalDistance(VoteTown t) => t.candidates.fold<double>(
          0,
          (sum, c) => sum + averageVoterDistanceTo(t, c.location),
        );

        final initialDistance = totalDistance(town);

        for (var turn = 0; turn < 16; turn++) {
          final step = computeStrategicMove(
            town,
            candidateIndex: turn % town.candidates.length,
            method: TargetElectionMethod.condorcet,
            mode: SimulationMode.selfish,
          );
          town = step.town;
        }

        expect(totalDistance(town), lessThan(initialDistance * 0.35));
      },
    );

    test('Kingmaker Mole (moleHelpsA) splits rival B vote so trailing A wins '
        'Plurality', () {
      // A is off-center (left), B is at center (75,75) winning 1-on-1, C (Mole)
      // starts in a far corner.
      var town = VoteTown.fromLocations(const [
        Point(35, 75), // A
        Point(75, 75), // B (currently winning)
        Point(135, 135), // C (Mole helping A)
      ]);
      expect(town.pluralityElection.singleWinner?.id, 'B');

      for (var i = 0; i < 6; i++) {
        final step = computeStrategicMove(
          town,
          candidateIndex: 2, // Move only the Mole C
          method: TargetElectionMethod.plurality,
          mode: SimulationMode.moleHelpsA,
        );
        expect(step.isMole, isTrue);
        town = step.town;
      }

      expect(town.pluralityElection.singleWinner?.id, 'A');
    });

    test('Saboteur Mole (moleHurtsA) shadows A to make A lose Plurality, but '
        'cannot dethrone center A in Condorcet', () {
      // A is at center (75,75) beating B at (105,75); C is the Saboteur Mole.
      var town = VoteTown.fromLocations(const [
        Point(75, 75), // A (center)
        Point(105, 75), // B
        Point(15, 15), // C (Mole hurting A)
      ]);
      expect(town.pluralityElection.singleWinner?.id, 'A');
      expect(town.condorcetElection.singleWinner?.id, 'A');

      for (var i = 0; i < 6; i++) {
        town = computeStrategicMove(
          town,
          candidateIndex: 2, // Move only the Mole C
          method: TargetElectionMethod.plurality,
          mode: SimulationMode.moleHurtsA,
        ).town;
      }

      // Mole C successfully spoiled Plurality against A (squeezing A down to
      // last place in Plurality), yet A still wins Condorcet outright on the
      // 15x15 grid!
      expect(town.pluralityElection.singleWinner?.id, isNot('A'));
      expect(town.pluralityElection.places.last.single.id, 'A');
      expect(town.condorcetElection.singleWinner?.id, 'A');
    });

    test('advancePhysicsFrame steers with momentum and enforces minimum '
        'candidate separation', () {
      var town = VoteTown.fromLocations(const [Point(20, 75), Point(130, 75)]);
      var velocities = <Point<double>>[const Point(0, 0), const Point(0, 0)];
      // Both candidates aim for the exact same center point (75, 75).
      final targets = <Point<double>>[VoteTown.center, VoteTown.center];

      for (var frame = 0; frame < 180; frame++) {
        final res = advancePhysicsFrame(
          town,
          velocities: velocities,
          targets: targets,
          dtSeconds: 0.016,
        );
        town = res.town;
        velocities = res.velocities;
      }

      final posA = town.candidates[0].location;
      final posB = town.candidates[1].location;
      expect(posA.distanceTo(VoteTown.center), lessThan(18.0));
      expect(posB.distanceTo(VoteTown.center), lessThan(18.0));
      expect(posA.distanceTo(posB), greaterThanOrEqualTo(17.49));
    });
  });
}
