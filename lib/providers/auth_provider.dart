import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final _googleSignInProvider =
    Provider<GoogleSignIn>((_) => GoogleSignIn());

/// Emits the current Firebase user (null = signed out).
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async =>
      ref.watch(firebaseAuthProvider).currentUser;

  Future<User?> signInWithGoogle() async {
    final googleSignIn = ref.read(_googleSignInProvider);
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await ref
        .read(firebaseAuthProvider)
        .signInWithCredential(credential);
    return result.user;
  }

  Future<void> signOut() async {
    await ref.read(_googleSignInProvider).signOut();
    await ref.read(firebaseAuthProvider).signOut();
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
