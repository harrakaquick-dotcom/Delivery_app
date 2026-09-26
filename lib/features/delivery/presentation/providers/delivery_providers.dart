import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sample_order.dart';
import '../../domain/entities/delivery_order.dart';

/// The order currently being requested or delivered (demo data for now).
final activeOrderProvider = Provider<DeliveryOrder>((ref) => sampleOrder);
