import 'dart:async';
import 'dart:developer';

import 'package:games_services/games_services.dart';

/// Allows awarding achievements and leaderboard scores,
/// and also showing the platforms' UI overlays for achievements
/// and leaderboards.
///
/// A facade of `package:games_services`.
class GamesServicesController {
  final Completer<bool> _signedInCompleter = Completer();
  Future<bool> get signedIn => _signedInCompleter.future;

  /// Unlocks an achievement on Game Center / Play Games.
  ///
  /// You must provide the achievement ids via the [iOS] and [android]
  /// parameters.
  ///
  /// Does nothing when the game isn't signed into the underlying
  /// games service.
  Future<void> awardAchievement(
      {required String iOS, required String android}) async {
    if (!await signedIn) {
      log('Trying to award achievement when not logged in.');
      return;
    }

    try {
      await GamesServices.unlock(
        achievement: Achievement(
          androidID: android,
          iOSID: iOS,
        ),
      );
    } catch (e) {
      log('Cannot award achievement: $e');
    }
  }

  /// Signs into the underlying games service.
  Future<void> initialize() async {
    try {
      await GamesServices.signIn();
      // The API is unclear so we're checking to be sure. The above call
      // returns a String, not a boolean, and there's no documentation
      // as to whether every non-error result means we're safely signed in.
      final signedIn = await GamesServices.isSignedIn;
      _signedInCompleter.complete(signedIn);
    } catch (e) {
      log('Cannot log into GamesServices: $e');
      _signedInCompleter.complete(false);
    }
  }

  /// Launches the platform's UI overlay with achievements.
  Future<void> showAchievements() async {
    if (!await signedIn) {
      log('Trying to show achievements when not logged in.');
      return;
    }

    try {
      await GamesServices.showAchievements();
    } catch (e) {
      log('Cannot show achievements: $e');
    }
  }

  /// Launches the platform's UI overlay with leaderboard(s).
  Future<void> showLeaderboard() async {
    if (!await signedIn) {
      log('Trying to show leaderboard when not logged in.');
      return;
    }

    try {
      await GamesServices.showLeaderboards(
        iOSLeaderboardID: "topLevel",
        // androidLeaderboardID: "sOmE_iD_fRoM_gPlAy",
      );
    } catch (e) {
      log('Cannot show leaderboard: $e');
    }
  }

  /// Submits [score] to the leaderboard.
  Future<void> submitLeaderboardScore(int score) async {
    if (!await signedIn) {
      log('Trying to submit leaderboard when not logged in.');
      return;
    }

    log('Submitting $score to leaderboard.');

    try {
      await GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: 'topLevel',
          // androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
          value: score,
        ),
      );
    } catch (e) {
      log('Cannot submit leaderboard score: $e');
    }
  }
}
