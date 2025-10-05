import 'package:google_sign_in/google_sign_in.dart';
import 'package:ttcs/screens/task_list_screen.dart'; // Sử dụng đường dẫn package
import 'package:ttcs/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttcs/models/user_model.dart'; // Sửa đường dẫn
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Lấy user hiện tại
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  // Đăng nhập bằng email và mật khẩu
  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await UserService().updateUserLastActive(user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen(userId: user.uid)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng nhập thất bại: Không lấy được thông tin người dùng.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: ${e.toString()}")),
      );
    }
  }

  // Đăng ký tài khoản mới
  Future<void> signUpWithEmail(String email, String password, String username, BuildContext context) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        UserModel newUser = UserModel(
          id: user.uid,
          username: username,
          email: email,
          avatar: null,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
          isAdmin: false,
        );
        await UserService().createUser(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen(userId: user.uid)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thất bại: ${e.toString()}")),
      );
    }
  }

  // Đăng nhập bằng Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToFirestore(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen(userId: user.uid)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập bằng Google thất bại: $e")),
      );
    }
  }

  // Đăng nhập bằng Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        final User? user = userCredential.user;

        if (user != null) {
          await _saveUserToFirestore(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TaskListScreen(userId: user.uid)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng nhập Facebook thất bại: ${loginResult.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập Facebook thất bại: $e")),
      );
    }
  }

  // Lưu thông tin người dùng vào Firestore
  Future<void> _saveUserToFirestore(User user) async {
    final userService = UserService();
    final userExists = await userService.checkUserExists(user.uid);

    if (!userExists) {
      UserModel newUser = UserModel(
        id: user.uid,
        username: user.displayName ?? "Người dùng",
        email: user.email ?? "",
        avatar: null,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        isAdmin: false,
      );
      await userService.createUser(newUser);
    } else {
      await userService.updateUserLastActive(user.uid);
    }
  }

  Future<void> signOut(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Đăng xuất"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await auth.signOut();
      await googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng xuất thành công.")),
      );
    }
  }
}