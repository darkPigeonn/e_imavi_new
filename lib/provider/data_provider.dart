import 'package:e_imavi/model/model_attendances.dart';
import 'package:e_imavi/model/model_kronik.dart';
import 'package:e_imavi/model/model_permit.dart';
import 'package:e_imavi/model/model_schedule.dart';
import 'package:e_imavi/model/model_user.dart';
import 'package:e_imavi/model/user.dart';
import 'package:e_imavi/services/attendances_services.dart';
import 'package:e_imavi/services/kronik_services.dart';
import 'package:e_imavi/services/permits_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userAttendanceProvider = StateNotifierProvider<ModelAttendances, AsyncValue()
final userAttendanceProvider =
    FutureProvider<List<ModelAttendances>>((ref) async {
  return ref.read(apiProvider).getAttendances();
});

final userProfileProvider = FutureProvider<ModelUser>((ref) async {
  return ref.read(apiProvider).getProfile();
});

final articlesProvider = FutureProvider<List<ModelResources1>>((ref) async {
  return ref.read(apiProvider).getArticles();
});

final newsProvider = FutureProvider<List<ModelResources1>>((ref) async {
  return ref.read(apiProvider).getNews();
});

final prayersProvider = FutureProvider<List<ModelResources1>>((ref) async {
  return ref.read(apiProvider).getPrayers();
});

final kalenderLiturgiProvider =
    FutureProvider<List<ModelResources1>>((ref) async {
  return ref.read(apiProvider).getNews();
});

final permitsProvider = FutureProvider<List<PermitModel>> ((ref) async{
  return ref.read(permitProvider).getHistoryPermit();
});

final kronikProvider = FutureProvider<List<KronikModel>>((ref) async {
  return ref.read(kronikService).getHistoryKronik();
});


