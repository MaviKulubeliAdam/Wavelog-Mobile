import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models/planned_activation_model.dart';

class CommunityDatasource {
  final FirebaseFirestore _db;
  final FirebaseMessaging _fcm;

  CommunityDatasource({
    FirebaseFirestore? db,
    FirebaseMessaging? fcm,
  })  : _db = db ?? FirebaseFirestore.instance,
        _fcm = fcm ?? FirebaseMessaging.instance;

  CollectionReference<Map<String, dynamic>> get _activations =>
      _db.collection('planned_activations');

  // Yaklaşan aktivasyonları gerçek zamanlı dinle
  Stream<List<PlannedActivationModel>> watchUpcomingActivations() {
    final now = Timestamp.fromDate(DateTime.now().toUtc());
    return _activations
        .where('expiresAt', isGreaterThan: now)
        .orderBy('expiresAt')
        .orderBy('scheduledAt')
        .limit(50)
        .snapshots()
        .map((s) => s.docs
            .map(PlannedActivationModel.fromFirestore)
            .toList());
  }

  Future<String> addActivation(PlannedActivationModel activation) async {
    final data = activation.toFirestore();
    data['notified'] = false; // Cloud Function kullanır, tekrar bildirim önler
    final ref = await _activations.add(data);
    return ref.id;
  }

  Future<void> deleteActivation(String id) =>
      _activations.doc(id).delete();

  // FCM: Bu aktivasyona bildirim almak isteyen
  Future<void> subscribeToActivation(String activationId) async {
    await _fcm.subscribeToTopic('activation_$activationId');
    await _activations.doc(activationId).update({
      'subscriberCount': FieldValue.increment(1),
    });
  }

  Future<void> unsubscribeFromActivation(String activationId) async {
    await _fcm.unsubscribeFromTopic('activation_$activationId');
    await _activations.doc(activationId).update({
      'subscriberCount': FieldValue.increment(-1),
    });
  }

  // Rate-limit: aynı callsign'dan son 5 dk içinde aktivasyon var mı?
  Future<bool> canPostActivation(String callsign) async {
    final since = Timestamp.fromDate(
      DateTime.now().toUtc().subtract(const Duration(minutes: 5)),
    );
    final q = await _activations
        .where('callsign', isEqualTo: callsign.toUpperCase())
        .where('createdAt', isGreaterThan: since)
        .limit(1)
        .get();
    return q.docs.isEmpty;
  }
}
