// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:depi_final_project/core/constants/app_constants.dart';
// import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizCubit.dart';
// import 'package:depi_final_project/features/Teacher/cubit/createQuizCubit/quizState.dart';
// import 'package:depi_final_project/features/Teacher/screens/viewQuizScreen.dart';
// import 'package:depi_final_project/features/Teacher/wrapper_teacher_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Recentquizzes extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       endDrawer:drawer(context) ,
//       appBar: AppBar(title: Text("Recent Quizzes",style: TextStyle(
//             fontFamily: 'Judson',
//             fontSize: screenWidth * 0.065,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
      
//       )),
//       body: BlocBuilder<CreateQuizCubit, CreateQuizState>(
//         builder: (context, state) {
//           if (state is GetQuiz) {
//             final quizzes = state.quizList;
//             final quizzesid=state.quizzesId;
//             if (quizzes.isEmpty) {
//               return Center(child: Text("NO Quiz Available"));
//             }

//             return ListView.builder(
//               itemCount: quizzes.length,
//               itemBuilder: (context, index) {
//                 final quiz = quizzes[index];
//                 return GestureDetector(
//                   child: container(index,context, screenHeight * .00015, screenWidth *.00009, quiz[AppConstants.title],quiz[AppConstants.createdAt],quiz,quizzesid));
//               },
//             );
//           } else if (state is GetQuizError) {
//             return Center(child: Text("Error: ${state.message}"));
//           }

//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }


//     Widget container(int index,BuildContext context, double heightFactor, double widthFactor, String txt,dynamic createdAt,dynamic quiz,List<dynamic> quizzesId) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//       String formattedDate = "";
//   if (createdAt is Timestamp) {
//     DateTime date = createdAt.toDate();
//     formattedDate =
//         "${date.day}/${date.month}/${date.year}";
//   } else if (createdAt is DateTime) {
//     formattedDate =
//         "${createdAt.day}/${createdAt.month}/${createdAt.year}";
//   } else {
//     formattedDate = createdAt?.toString() ?? "Unknown";
//   }
//     return Center(
//       child: Container(
//         height: screenHeight * heightFactor,
//         width:  screenWidth * 0.9, 
//         margin:EdgeInsets.only(bottom:  screenHeight *.04),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: const Color.fromARGB(255, 86, 176, 180),
//             width: 2,
//           ),
//         ),  
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       txt,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: const Color(0xffFFFFFF),
//                         fontWeight: FontWeight.w700,
//                         fontSize: screenWidth * 0.05,
//                       ),
//                           ),
                          
//                     Text(
//                       "Created on ${formattedDate}" ,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: const Color(0xffFFFFFF),
//                         fontWeight: FontWeight.w400,
//                         fontSize: screenWidth * 0.03,
//                       ),
//                           ),
//                   ],
//                 ),
//                  IconButton(onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewQuizScreen(title: quiz["title"],duration: quiz["duration"],questions: quiz["questions"],createdAt: formattedDate,quizzesId:quiz["quizid"]??"")));
//                  }, icon: Icon( Icons.preview_outlined))
//               ],
//             ),
//           ),
//       ),
//     );
//   }
//     Widget drawer(BuildContext context) {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;

//   return Drawer(
//     backgroundColor: const Color(0xff061438),
//     child: ListView(
//       children: [
//         DrawerHeader(
//           decoration: BoxDecoration(
//             color: const Color(0xff061438),
//             border: Border(
//               bottom: BorderSide(
//                 color: const Color(0xff4FB3B7),
//                 width: screenHeight * 0.001,
//               ),
//             ),
//           ),
//           child: Row(
//             children: [
//               SizedBox(
//                 height: screenHeight * 0.08,
//                 width: screenHeight * 0.08,
//                 child: Image.asset("assets/images/brain_logo.png"),
//               ),
//               SizedBox(width: screenWidth * 0.02),
//               Text(
//                 "QUIZLY",
//                 style: TextStyle(
//                   color: const Color(0xff62DDE1),
//                   fontSize: screenWidth * 0.085,
//                   fontFamily: "DMSerifDisplay",
//                 ),
//               ),
//             ],
//           ),
//         ),
//         listtitle(
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const WrapperTeacherPage()),
//           ),
//           context,
//           const Icon(Icons.home_outlined, color: Color(0xff62DDE1)),
//           "Home",
//         ),
//         listtitle(
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 1)),
//           ),
//           context,
//           const Icon(Icons.person_outlined, color: Color(0xff62DDE1)),
//           "Profile",
//         ),
//         listtitle(
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 2)),
//           ),
//           context,
//           const Icon(Icons.list, color: Color(0xff62DDE1)),
//           "My Quizzes",
//         ),
//         Container(
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: const Color(0xff4FB3B7),
//                 width: screenHeight * 0.001,
//               ),
//             ),
//           ),
//           child: ListTile(
//             leading: const Icon(Icons.settings, color: Color(0xff62DDE1)),
//             title: Text(
//               "Setting",
//               style: TextStyle(
//                 color: const Color(0xff62DDE1),
//                 fontSize: screenWidth * 0.06,
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const WrapperTeacherPage(index: 3)),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget listtitle(Function callback, BuildContext context, Icon icon, String txt) {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;

//   return Container(
//     decoration: BoxDecoration(
//       border: Border(
//         bottom: BorderSide(
//           color: const Color(0xff4FB3B7),
//           width: screenHeight * 0.001,
//         ),
//       ),
//     ),
//     child: ListTile(
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: screenWidth * 0.04,
//         vertical: screenHeight * 0.01,
//       ),
//       leading: icon,
//       title: Text(
//         txt,
//         style: TextStyle(
//           color: const Color(0xff62DDE1),
//           fontSize: screenWidth * 0.06,
//         ),
//       ),
//       onTap: () => callback(),
//     ),
//   );
// }

// }
