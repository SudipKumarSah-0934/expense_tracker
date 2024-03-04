import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/features/authentication/data/models/user_model.dart';
import 'package:news_app/features/authentication/domain/entities/user_entity.dart';

import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;


  FirebaseRemoteDataSourceImpl(this.fireStore, this.auth, this.googleSignIn);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUId();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        uid: uid,
        email: user.email,
      ).toDocument();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
        return;
      } else {
        userCollection.doc(uid).update(newUser);
        debugPrint("user already exist");
        return;
      }
    }).catchError((error) {
      debugPrint(error);
    });
  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> googleAuth() async {
    final usersCollection = fireStore.collection("users");

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information = (await auth.signInWithCredential(credential)).user;
      usersCollection.doc(auth.currentUser!.uid).get().then((user) async {
        if (!user.exists) {
          var uid = auth.currentUser!.uid;
          var newUser = UserModel(
                  name: information!.displayName!,
                  email: information.email!,
                  uid: information.uid)
              .toDocument();

          usersCollection.doc(uid).set(newUser);
        }
      }).whenComplete(() {
        debugPrint("New User Created Successfully");
      }).catchError((e) {
        debugPrint("getInitializeCreateCurrentUser ${e.toString()}");
      });
    } catch (e) {
      debugPrint(e as String);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signIn(UserEntity user) async {
    await auth.signInWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  @override
  Future<void> signUp(UserEntity user) async {
    await auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    Map<String, dynamic> userInformation = Map();
    debugPrint(user.name);
    final userCollection = fireStore.collection("users");

    if (user.name != null && user.name != "") {
      userInformation["name"] = user.name;
    }

    userCollection.doc(user.uid).update(userInformation);
  }
}
