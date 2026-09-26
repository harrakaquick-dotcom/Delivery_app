import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/agent_profile.dart';

/// The signed-in agent.
final agentProvider = Provider<AgentProfile>((ref) => sampleAgent);

/// Whether the agent is currently on duty (accepting orders).
final onlineProvider = StateProvider<bool>((ref) => false);

/// Selected bottom-tab index in the main shell (duty, orders, earn, alerts, me).
final mainTabProvider = StateProvider<int>((ref) => 0);

/// Indices of the main shell tabs, so other features can jump to one.
class MainTab {
  MainTab._();

  static const int duty = 0;
  static const int orders = 1;
  static const int earnings = 2;
  static const int alerts = 3;
  static const int profile = 4;
}
