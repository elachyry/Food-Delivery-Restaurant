// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../controllers/restaurant_controller.dart';

// class ProfileHead extends StatefulWidget {
//   ProfileHead({
//     super.key,
//     required this.restaurnat,
//     required this.pickedImage,
//     required this.pickedImageLogo,
//     required this.webImage,
//     required this.webImageLogo,
//   });
//   final restaurnat;
//   File? pickedImage;
//   Uint8List webImage;

//   File? pickedImageLogo;
//   Uint8List webImageLogo;

//   @override
//   State<ProfileHead> createState() => _ProfileHeadState();
// }

// final restaurantController = Get.put(RestaurantController());

// class _ProfileHeadState extends State<ProfileHead> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.elliptical(MediaQuery.of(context).size.width, 40),
//             ),
//             image: DecorationImage(
//               image: widget.pickedImage == null
//                   ? NetworkImage(
//                       widget.restaurnat['imageUrl'],
//                     )
//                   : kIsWeb
//                       ? MemoryImage(widget.webImage) as ImageProvider
//                       : FileImage(widget.pickedImage as File),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: SizedBox(
//             width: 120,
//             height: 120,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: FadeInImage(
//                   placeholder: AssetImage('assets/restaurant.png'),
//                   image: widget.pickedImageLogo == null
//                       ? NetworkImage(
//                           widget.restaurnat['logoUrl'],
//                         )
//                       : kIsWeb
//                           ? MemoryImage(widget.webImageLogo) as ImageProvider
//                           : FileImage(widget.pickedImageLogo as File),
//                   imageErrorBuilder: (context, error, stackTrace) =>
//                       Image.asset('assets/restaurant.png'),
//                 )),
//           ),
//         ),
//         Positioned(
//           right: 0,
//           top: 0,
//           child: Container(
//             height: 35,
//             width: 35,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Theme.of(context).primaryColorDark),
//             child: IconButton(
//               onPressed: () async {
//                 await _pickImageCover();
//               },
//               icon: const Icon(
//                 Icons.edit,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           right: 0,
//           bottom: 0,
//           left: 0,
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 35,
//               width: 35,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: Theme.of(context).primaryColorDark),
//               child: IconButton(
//                 onPressed: () async {
//                   await _pickImageLogo();
//                 },
//                 icon: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
