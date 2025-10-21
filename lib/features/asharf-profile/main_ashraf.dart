// // main.dart
// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   // ✅ إعداد Firebase للـ Web باستخدام بياناتك
// //   await Firebase.initializeApp(
// //     options: const FirebaseOptions(
// //       apiKey: "AIzaSyCD6_yqIiayAxBhLMF7GtzcOe8s_CypbAA",
// //       authDomain: "final-depi-project.firebaseapp.com",
// //       projectId: "final-depi-project",
// //       storageBucket: "final-depi-project.firebasestorage.app",
// //       messagingSenderId: "940514634281",
// //       appId: "1:940514634281:web:42ed9d6e4072c125b94a38",
// //     ),
// //   );

// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: UsersScreen(),
// //     );
// //   }
// // }

// // class UsersScreen extends StatelessWidget {
// //   const UsersScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final usersRef = FirebaseFirestore.instance.collection('users');

// //     return Scaffold(
// //       backgroundColor: const Color(0xFF000920),
// //       appBar: AppBar(
// //         title: const Text("All Users"),
// //         centerTitle: true,
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: usersRef.snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (snapshot.hasError) {
// //             return Center(child: Text("Error: ${snapshot.error}"));
// //           }
// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return const Center(child: Text("No users found"));
// //           }

// //           final users = snapshot.data!.docs;

// //           return ListView.builder(
// //             itemCount: users.length,
// //             itemBuilder: (context, index) {
// //               final data = users[index].data() as Map<String, dynamic>;

// //               return Card(
// //                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 color: const Color(0xFF001233),
// //                 elevation: 3,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //                 child: ListTile(
// //                   leading: CircleAvatar(
// //                     backgroundImage: NetworkImage(data['profilePicture'] ?? ""),
// //                     radius: 25,
// //                   ),
// //                   title: Text(
// //                     data['fullName'] ?? "No Name",
// //                     style: const TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   subtitle: Text(
// //                     data['email'] ?? "No Email",
// //                     style: const TextStyle(color: Colors.white70),
// //                   ),
// //                   trailing: Icon(
// //                     data['isTeacher'] == true
// //                         ? Icons.school
// //                         : Icons.person,
// //                     color: Colors.tealAccent,
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProfileScreen(),
//     );
//   }
// }
