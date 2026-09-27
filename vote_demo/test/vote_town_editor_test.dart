import 'package:test/test.dart';
import 'package:vote_demo/src/model/strategic_simulator.dart';
import 'package:vote_demo/src/model/vote_town.dart';
import 'package:vote_demo/src/view_model/vote_town_editor.dart';

void main() {
  test('stable add and remove', () {
    const count = 5;

    // ignore: avoid_redundant_argument_values
    final editor = VoteTownEditor(VoteTown.random(candidateCount: count));

    final locations = editor.value.candidates
        .map((e) => e.intLocation)
        .toList();
    expect(locations, hasLength(count));

    while (editor.value.candidates.length > 1) {
      editor.removeCandidate!();
    }

    expect(editor.value.candidates, hasLength(1));
    expect(editor.value.candidates.single.intLocation, locations.first);

    while (editor.value.candidates.length < count) {
      editor.addCandidate!();
    }

    expect(editor.value.candidates, hasLength(count));

    for (var i = 0; i < count; i++) {
      expect(
        editor.value.candidates[i].intLocation,
        locations[i],
        reason: 'Candidate added back at index $i should match old location.',
      );
    }
  });

  test('applyPreset, stepSimulation, and moleBadgeFor', () {
    final editor = VoteTownEditor(VoteTown.random());
    addTearDown(editor.dispose);

    editor.applyPreset(VoteTownPreset.pluralitySpoiler);
    expect(editor.value.candidates, hasLength(3));
    expect(editor.nextCandidateIndex, 0);
    expect(editor.lastMovedCandidate, isNull);
    expect(editor.isMole(editor.value.candidates.last), isFalse);

    editor.simulationMode = SimulationMode.moleHelpsA;
    expect(editor.isMole(editor.value.candidates.last), isTrue);
    expect(editor.moleBadgeFor(editor.value.candidates.last), '+A');
    expect(editor.moleBadgeFor(editor.value.candidates.first), isNull);

    editor.simulationMode = SimulationMode.moleHurtsA;
    expect(editor.moleBadgeFor(editor.value.candidates.last), '−A');

    final step1 = editor.stepSimulation();
    expect(step1.candidate.id, 'A');
    expect(editor.lastMovedCandidate?.id, 'A');
    expect(editor.nextCandidateIndex, 1);

    editor.scatterCandidates();
    expect(editor.value.candidates, hasLength(3));
    expect(editor.nextCandidateIndex, 0);
    expect(editor.lastMovedCandidate, isNull);
  });
}
