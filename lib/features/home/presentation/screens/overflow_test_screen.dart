// import 'package:flutter/material.dart';
// import 'home_screen.dart';
//
// class OverflowTestScreen extends StatelessWidget {
//   const OverflowTestScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     final bool isTablet = screenSize.width > 600;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Overflow Test'),
//         backgroundColor: const Color(0xFF904E93),
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Test very long username
//               _buildTestSection(
//                 'Long Username Test',
//                 HomeScreen(
//                   userName:
//                       'SuperLongUsernameWithManyCharactersThatMightCauseOverflow@example.com',
//                 ),
//                 context,
//               ),
//
//               SizedBox(height: isTablet ? 32 : 24),
//
//               // Test long text content
//               _buildTextOverflowTest(isTablet),
//
//               SizedBox(height: isTablet ? 32 : 24),
//
//               // Test grid with many items
//               _buildGridOverflowTest(isTablet),
//
//               SizedBox(height: isTablet ? 32 : 24),
//
//               // Test responsive sizing
//               _buildResponsiveTest(screenSize),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTestSection(
//     String title,
//     Widget testWidget,
//     BuildContext context,
//   ) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF904E93),
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(height: 300, child: testWidget),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextOverflowTest(bool isTablet) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Text Overflow Test',
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF904E93),
//               ),
//             ),
//             SizedBox(height: isTablet ? 20 : 16),
//
//             // Test title overflow
//             Container(
//               width: 200,
//               child: Text(
//                 'This is a very long title that should test overflow handling with ellipsis',
//                 style: TextStyle(
//                   fontSize: isTablet ? 18 : 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//             ),
//
//             SizedBox(height: isTablet ? 16 : 12),
//
//             // Test subtitle overflow
//             Container(
//               width: 150,
//               child: Text(
//                 'This is an extremely long subtitle that definitely should be truncated with proper overflow handling',
//                 style: TextStyle(
//                   fontSize: isTablet ? 14 : 12,
//                   color: Colors.grey,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGridOverflowTest(bool isTablet) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Grid Overflow Test',
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF904E93),
//               ),
//             ),
//             SizedBox(height: isTablet ? 20 : 16),
//
//             SizedBox(
//               height: 300,
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: crossAxisCount,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                       childAspectRatio: 0.9,
//                     ),
//                     itemCount: 8,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.quiz,
//                                 size: isTablet ? 40 : 32,
//                                 color: const Color(0xFF904E93),
//                               ),
//                               SizedBox(height: isTablet ? 12 : 8),
//                               Text(
//                                 'Very Long Category Name $index',
//                                 style: TextStyle(
//                                   fontSize: isTablet ? 16 : 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFF904E93),
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                               ),
//                               SizedBox(height: isTablet ? 8 : 4),
//                               Text(
//                                 'This is a very long subtitle that tests overflow',
//                                 style: TextStyle(
//                                   fontSize: isTablet ? 12 : 10,
//                                   color: Colors.grey,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResponsiveTest(Size screenSize) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Responsive Size Test',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF904E93),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             Text('Screen Width: ${screenSize.width.toStringAsFixed(1)}px'),
//             Text('Screen Height: ${screenSize.height.toStringAsFixed(1)}px'),
//             Text(
//               'Device Type: ${screenSize.width > 900
//                   ? 'Desktop'
//                   : screenSize.width > 600
//                   ? 'Tablet'
//                   : 'Mobile'}',
//             ),
//
//             const SizedBox(height: 16),
//
//             // Responsive font sizes demonstration
//             Text(
//               'Responsive Title',
//               style: TextStyle(
//                 fontSize: screenSize.width > 600 ? 24 : 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'Responsive subtitle with adaptive sizing',
//               style: TextStyle(
//                 fontSize: screenSize.width > 600 ? 16 : 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
