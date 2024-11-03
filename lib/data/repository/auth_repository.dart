import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/core/resources/data_state.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  Future<DataState<User>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const DataInternalError('Sign in aborted');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);

      FirebaseAnalytics.instance.logLogin(loginMethod: 'google');

      return DataSuccess(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return DataErrorAuth(e, e.message);
    } on Exception catch (e) {
      return DataInternalError(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  User? get user => _firebaseAuth.currentUser;
}
