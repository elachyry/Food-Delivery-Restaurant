import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart' as mime;

import '../../component/appBarActionItems.dart';
import '../../component/sideMenu.dart';
import '../../config/responsive.dart';
import '../../config/size_config.dart';
import '../../controllers/controllers.dart';
import '../../style/colors.dart';
import '../../style/style.dart';

class ProfileScreen extends StatefulWidget {
  static final String appRoute = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  final addressController = TextEditingController();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final descriptionController = TextEditingController();

  final deliveryFeesController = TextEditingController();

  final deliveryTimeController = TextEditingController();

  final latitudeController = TextEditingController();

  final longitutudeController = TextEditingController();

  File? _pickedImage;

  Uint8List _webImage = Uint8List(8);

  File? _pickedImageLogo;

  Uint8List _webImageLogo = Uint8List(8);

  final restaurantController = Get.put(RestaurantController());

  final userController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future<void> _pickImageCover() async {
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        if (image != null) {
          var selected = File(image.path);
          setState(() {
            // restaurantController.pickedImage.value = selected;
          });
        } else {}
      } else if (kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        if (image != null) {
          var f = await image.readAsBytes();
          setState(() {
            _webImage = f;
            _pickedImage = File('a');
          });
        } else {}
      } else {}
    }

    Future<void> _pickImageLogo() async {
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        if (image != null) {
          var selected = File(image.path);
          setState(() {
            // restaurantController.pickedImageLogo.value = selected;
          });
        } else {}
      } else if (kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);
        print('image : $image == null');
        if (image != null) {
          print('image : ttest');

          var f = await image.readAsBytes();
          setState(() {
            _webImageLogo = f;
            _pickedImageLogo = File('a');
          });
        } else {}
      } else {}
    }

    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.menu, color: AppColors.black)),
              actions: [
                AppBarActionItems(),
              ],
            )
          : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            Expanded(
              flex: 14,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                      text: 'Restaurant Informations',
                                      size: 30,
                                      fontWeight: FontWeight.w800),
                                ]),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      Obx(() {
                        if (restaurantController.myData.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final restaurant = restaurantController.myData;
                          nameController.text = restaurant['name'];
                          phoneController.text = restaurant['phone'];
                          descriptionController.text =
                              restaurant['description'];
                          deliveryFeesController.text =
                              restaurant['deliveryFee'].toString();
                          deliveryTimeController.text =
                              restaurant['deliveryTime'].toString();
                          addressController.text =
                              restaurant['location']['name'];
                          latitudeController.text =
                              restaurant['location']['lat'].toString();
                          longitutudeController.text =
                              restaurant['location']['lng'].toString();

                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  Responsive.isDesktop(context) ? 100 : 0,
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.elliptical(
                                              MediaQuery.of(context).size.width,
                                              40),
                                        ),
                                        image: DecorationImage(
                                          image: _pickedImage == null
                                              ? NetworkImage(
                                                  restaurant['imageUrl'],
                                                )
                                              : kIsWeb
                                                  ? MemoryImage(_webImage)
                                                      as ImageProvider
                                                  : FileImage(
                                                      _pickedImage as File),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    'assets/restaurant.png'),
                                                image: _pickedImageLogo == null
                                                    ? NetworkImage(
                                                        restaurant['logoUrl'],
                                                      )
                                                    : kIsWeb
                                                        ? MemoryImage(
                                                                _webImageLogo)
                                                            as ImageProvider
                                                        : FileImage(
                                                            _pickedImageLogo
                                                                as File),
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  print(
                                                      '_pickedImageLogo ${_pickedImageLogo == null}');
                                                  return Image.asset(
                                                      'assets/restaurant.png');
                                                },
                                              )),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        child: IconButton(
                                          onPressed: () async {
                                            await _pickImageCover();
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                          child: IconButton(
                                            onPressed: () async {
                                              await _pickImageLogo();
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 5,
                                ),
                                if (Responsive.isDesktop(context))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: nameController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Name",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant name field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeVertical * 4,
                                      ),
                                      Expanded(
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: phoneController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Phone",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant phone field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      costumContainer(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          controller: nameController,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Name",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The restaurant name field can\'t be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                      ),
                                      costumContainer(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          controller: phoneController,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Phone",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The restaurant phone field can\'t be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4,
                                ),
                                costumContainer(
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    textInputAction: TextInputAction.next,
                                    controller: descriptionController,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Description field can\'t be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4,
                                ),
                                if (Responsive.isDesktop(context))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: deliveryTimeController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Delivery Time",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant delivery time field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeVertical * 4,
                                      ),
                                      Expanded(
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: deliveryFeesController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Delivery Fees",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant delivery Fees field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      costumContainer(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          controller: deliveryTimeController,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Delivery Time",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The restaurant delivery time field can\'t be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                      ),
                                      costumContainer(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          controller: deliveryFeesController,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Delivery Fees",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The restaurant delivery Fees field can\'t be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4,
                                ),
                                if (Responsive.isDesktop(context))
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: addressController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Address",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant address field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeVertical * 2,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: latitudeController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Latitude",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant latitude field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeVertical * 2,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: costumContainer(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: longitutudeController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Longitude",
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'The restaurant longitude field can\'t be empty';
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      costumContainer(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          controller: addressController,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Address",
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The restaurant address field can\'t be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: costumContainer(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: latitudeController,
                                                onChanged: (value) {},
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Latitude",
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'The restaurant latitude field can\'t be empty';
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeVertical *
                                                    4,
                                          ),
                                          Expanded(
                                            child: costumContainer(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    longitutudeController,
                                                onChanged: (value) {},
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Longitude",
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'The restaurant longitude field can\'t be empty';
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () => ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.blockSizeVertical *
                                                      4,
                                            ),
                                          ),
                                          onPressed: restaurantController
                                                  .isLoading.value
                                              ? null
                                              : () async {
                                                  restaurantController
                                                      .isLoading.value = true;

                                                  String logoExtension = 'jpg';
                                                  String coverExtenion = 'jpg';
                                                  if (!kIsWeb) {
                                                    String logoFileName =
                                                        path.basename(
                                                            _pickedImageLogo!
                                                                .path);
                                                    logoExtension = path
                                                        .extension(logoFileName)
                                                        .toLowerCase();
                                                  } else {
                                                    String mimeType = mime
                                                            .lookupMimeType(
                                                                '.bin',
                                                                headerBytes:
                                                                    _webImageLogo)
                                                        as String;
                                                    logoExtension =
                                                        mime.extensionFromMime(
                                                            mimeType);
                                                  }

                                                  if (!kIsWeb) {
                                                    String coverFileName =
                                                        path.basename(
                                                            _pickedImage!.path);
                                                    logoExtension = path
                                                        .extension(
                                                            coverFileName)
                                                        .toLowerCase();
                                                  } else {
                                                    String mimeType = mime
                                                            .lookupMimeType(
                                                                '.bin',
                                                                headerBytes:
                                                                    _webImage)
                                                        as String;
                                                    logoExtension =
                                                        mime.extensionFromMime(
                                                            mimeType);
                                                  }

                                                  final ref = FirebaseStorage
                                                      .instance
                                                      .ref()
                                                      .child('restaurants')
                                                      .child(
                                                          'restaurants-covers')
                                                      .child(
                                                          '${userController.firebaseUser.value!.uid}cover.$coverExtenion');
                                                  final ref2 = FirebaseStorage
                                                      .instance
                                                      .ref()
                                                      .child('restaurants')
                                                      .child(
                                                          'restaurants-logos')
                                                      .child(
                                                          '${userController.firebaseUser.value!.uid}logo.$logoExtension');

                                                  if (!kIsWeb) {
                                                    if (_pickedImage != null) {
                                                      await ref.putFile(
                                                          _pickedImage as File);
                                                    }
                                                    if (_pickedImageLogo !=
                                                        null) {
                                                      await ref2.putFile(
                                                          _pickedImageLogo
                                                              as File);
                                                    }
                                                  } else {
                                                    if (_pickedImage != null) {
                                                      await ref
                                                          .putData(_webImage);
                                                    }
                                                    if (_pickedImageLogo !=
                                                        null) {
                                                      await ref2.putData(
                                                          _webImageLogo);
                                                    }
                                                  }
                                                  var coverUrl = await ref
                                                      .getDownloadURL();
                                                  var logoUrl = await ref2
                                                      .getDownloadURL();

                                                  restaurantController
                                                      .updateRestaurant({
                                                    'imageUrl':
                                                        _pickedImage != null
                                                            ? coverUrl
                                                            : restaurant[
                                                                'imageUrl'],
                                                    'logoUrl':
                                                        _pickedImageLogo != null
                                                            ? logoUrl
                                                            : restaurant[
                                                                'logoUrl'],
                                                    'name': nameController.text,
                                                    'phone':
                                                        phoneController.text,
                                                    'description':
                                                        descriptionController
                                                            .text,
                                                    'deliveryFee': double.parse(
                                                        deliveryFeesController
                                                            .text),
                                                    'deliveryTime': int.parse(
                                                        deliveryTimeController
                                                            .text),
                                                    'location': {
                                                      'name': addressController
                                                          .text,
                                                      'lat': double.parse(
                                                          latitudeController
                                                              .text),
                                                      'lng': double.parse(
                                                          longitutudeController
                                                              .text),
                                                    },
                                                  });
                                                },
                                          child: restaurantController
                                                  .isLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container costumContainer({required Widget child}) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100),
          ),
        ),
        child: child);
  }
}
