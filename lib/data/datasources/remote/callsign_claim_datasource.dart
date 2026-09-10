import 'package:cloud_firestore/cloud_firestore.dart';

enum ClaimResult {
  /// Callsign successfully claimed by this uid.
  claimed,
  /// Callsign already owned by this uid (re-login / reinstall case).
  alreadyOwned,
  /// Callsign registered to a different Google account.
  takenByOther,
}

class CallsignClaimDatasource {
  final FirebaseFirestore _db;

  CallsignClaimDatasource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _claims =>
      _db.collection('callsign_claims');

  /// Returns the uid that owns [callsign], or null if unclaimed.
  Future<String?> getClaimOwner(String callsign) async {
    final doc = await _claims.doc(callsign.toUpperCase()).get();
    if (!doc.exists) return null;
    return doc.data()?['uid'] as String?;
  }

  /// Attempts to claim [callsign] for [uid].
  /// Returns [ClaimResult] indicating outcome.
  Future<ClaimResult> claimCallsign(String callsign, String uid) async {
    final cs = callsign.toUpperCase();
    final docRef = _claims.doc(cs);
    final snap = await docRef.get();

    if (!snap.exists) {
      await docRef.set({
        'uid': uid,
        'claimedAt': FieldValue.serverTimestamp(),
      });
      return ClaimResult.claimed;
    }

    final existingUid = snap.data()?['uid'] as String?;
    if (existingUid == uid) return ClaimResult.alreadyOwned;
    return ClaimResult.takenByOther;
  }
}
