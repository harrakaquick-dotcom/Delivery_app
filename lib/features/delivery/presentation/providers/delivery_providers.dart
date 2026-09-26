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
