import 'package:e_imavi/services/permits_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final permitsService = Provider((_) => PermitsServices());