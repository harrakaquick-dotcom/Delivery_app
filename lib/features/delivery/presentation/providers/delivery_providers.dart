import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sample_order.dart';
import '../../domain/entities/delivery_order.dart';

/// The order currently being requested or delivered (demo data for now).
final activeOrderProvider = Provider<DeliveryOrder>((ref) => sampleOrder);

/// Which order lines the agent has ticked off at the store.
class PickupChecklistNotifier extends StateNotifier<Set<int>> {
  PickupChecklistNotifier() : super(const {});

  void toggle(int index) {
    final next = {...state};
    if (!next.add(index)) next.remove(index);
    state = next;
  }

  void reset() => state = const {};
}

final pickupChecklistProvider =
    StateNotifierProvider<PickupChecklistNotifier, Set<int>>(
      (ref) => PickupChecklistNotifier(),
    );

/// The 4-digit code the customer reads out at hand-over.
class DropCodeNotifier extends StateNotifier<String> {
  DropCodeNotifier() : super('');

  static const int length = 4;

  void add(String digit) {
    if (state.length < length) state = state + digit;
  }

  void backspace() {
    if (state.isNotEmpty) state = state.substring(0, state.length - 1);
  }

  void reset() => state = '';
}

final dropCodeProvider = StateNotifierProvider<DropCodeNotifier, String>(
  (ref) => DropCodeNotifier(),
);

/// How the customer paid for the active order.
final paymentModeProvider = StateProvider<PaymentMode>(
  (ref) => PaymentMode.mpesa,
);

/// Cash the agent is carrying, in KES, before the active order is settled.
final cashInBagProvider = StateProvider<int>((ref) => 3610);
