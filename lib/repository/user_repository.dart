import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    await _firebaseAuth.signInWithCredential(credential);

    return  _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithCredentials(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<FirebaseUser> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}