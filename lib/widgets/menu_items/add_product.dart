import 'package:dotted_border/dotted_border.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fde_restaurant_panel/models/models.dart';
import 'package:fde_restaurant_panel/screens/menu_items/menu_items_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import '../../config/size_config.dart';
import '../../controllers/controllers.dart';
import '../../style/style.dart';
import '../widgets.dart';

class AddProduct extends StatefulWidget {
  AddProduct({
    super.key,
    required this.categoriesController,
    required this.descriptionController,
    required this.ingrediantsController,
    required this.priceController,
    required this.nameController,
  });

  final nameController;
  final descriptionController;
  final priceController;
  final SingleValueDropDownController categoriesController;
  final MultiValueDropDownController ingrediantsController;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final menuItemsController = Get.put(MenuItemsController());
  final ingrediantController = Get.put(IngredientController());
  final categoryController = Get.put(CategoryController());
  final userController = Get.put(LoginController());
  final RegExp regExp = RegExp(r"^[0-9]+(\.[0-9]+)?$");

  File? _pickedImage;
  Uint8List _webImage = Uint8List(8);
  bool isCitySelected = true;
  List<String> selected = [];
  Map<String, String> elements = {};

  late final _formKey;

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          menuItemsController.pickedImage.value = selected;
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

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
  }

  // @override
  // void dispose() {
  //   nameController.dispose();
  //   descriptionController.dispose();
  //   categoriesController.dispose();
  //   ingrediantsController.dispose();
  //   priceController.dispose();
  //   elementsController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Obx(
            () => Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: _pickedImage == null &&
                      menuItemsController.editImage.value.isEmpty
                  ? DottedBorder(
                      radius: Radius.circular(30),
                      borderType: BorderType.RRect,
                      child: GestureDetector(
                        onTap: () async {
                          await _pickImage();
                          print(_pickedImage == null);
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/menu-item-placeholder.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 0,
                              right: 0,
                              child: Text(
                                'Select an Image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: menuItemsController.isEditing.value &&
                              _pickedImage == null
                          ? Image.network(
                              menuItemsController.editImage.value,
                              fit: BoxFit.cover,
                            )
                          : kIsWeb
                              ? Image.memory(
                                  _webImage,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _pickedImage as File,
                                  fit: BoxFit.cover,
                                ),
                    ),
            ),
          ),
        ),
        Obx(
          () => Container(
            child: _pickedImage != null ||
                    menuItemsController.editImage.value.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            await _pickImage();
                          },
                          child: PrimaryText(
                            text: 'Change Image',
                            size: 18,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Column(
                  children: <Widget>[
                    costumContainer(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: widget.nameController,
                        onChanged: (value) {
                          if (widget.nameController.text.isNotEmpty) {
                            menuItemsController.isCleanName.value = false;
                          } else {
                            menuItemsController.isCleanName.value = true;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Name",
                          suffixIcon: menuItemsController.isCleanName.value
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    widget.nameController.clear();
                                    menuItemsController.isCleanName.value =
                                        true;
                                  },
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The menu item name field can\'t be empty';
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    costumContainer(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        controller: widget.descriptionController,
                        onChanged: (value) {
                          if (widget.descriptionController.text.isNotEmpty) {
                            menuItemsController.isCleanDescription.value =
                                false;
                          } else {
                            menuItemsController.isCleanDescription.value = true;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Description",
                          suffixIcon: menuItemsController
                                  .isCleanDescription.value
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    widget.descriptionController.clear();
                                    menuItemsController
                                        .isCleanDescription.value = true;
                                  },
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    Obx(
                      () => menuItemsController.isEditing.value
                          ? Container()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                    ),
                    costumContainer(
                      child: Row(
                        children: [
                          Obx(
                            () => menuItemsController.isEditing.value
                                ? Container()
                                : Expanded(
                                    flex: 12,
                                    child: DropDownTextField(
                                      controller: widget.categoriesController,
                                      clearOption: true,
                                      enableSearch: true,
                                      searchDecoration: const InputDecoration(
                                          hintText: "Search for a category"),
                                      validator: (value) {
                                        if (value == null) {
                                          return "Category field can\'t be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      dropDownItemCount: 6,
                                      dropDownList: categoryController
                                          .categories
                                          .map(
                                            (category) => DropDownValueModel(
                                              name: category.name,
                                              value: category.id,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {},
                                    ),
                                  ),
                          ),
                          Obx(
                            () => menuItemsController.isEditing.value
                                ? Container()
                                : Expanded(
                                    flex: 3,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AddCategoryDialog(),
                                        );
                                      },
                                    )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    costumContainer(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: widget.priceController,
                        onChanged: (value) {
                          if (widget.priceController.text.isNotEmpty) {
                            menuItemsController.isCleanPrice.value = false;
                          } else {
                            menuItemsController.isCleanPrice.value = true;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Price",
                          suffixIcon: menuItemsController.isCleanPrice.value
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    widget.priceController.clear();
                                    menuItemsController.isCleanPrice.value =
                                        true;
                                  },
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Price field can\'t be empty';
                          }
                          if (!regExp.hasMatch(value)) {
                            return 'The entered price must contains only numbers.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Obx(
                      () => menuItemsController.isEditing.value
                          ? Container()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                    ),
                    costumContainer(
                      child: Row(
                        children: [
                          Obx(
                            () => menuItemsController.isEditing.value
                                ? Container()
                                : Expanded(
                                    flex: 12,
                                    child: DropDownMultiSelect(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selected = x;
                                        });
                                      },
                                      options: ingrediantController.ingrediants
                                          .map(
                                            (element) => element.name,
                                          )
                                          .toList(),
                                      selectedValues: selected,
                                      // whenEmpty: 'Select Ingrediants',
                                      hint: Text('Select Ingrediants'),
                                    ),
                                  ),
                          ),
                          Obx(
                            () => menuItemsController.isEditing.value
                                ? Container()
                                : Expanded(
                                    flex: 3,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AddIngrediantDialog(),
                                        );
                                      },
                                    )),
                          )
                        ],
                      ),
                    ),
                    Obx(
                      () => menuItemsController.isEditing.value
                          ? Container()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                    ),
                    Obx(
                      () => menuItemsController.isEditing.value
                          ? Container()
                          : costumContainer(
                              child: AddMenuElements(
                                elements: elements,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Container(
                      width: double.infinity,
                      height: SizeConfig.blockSizeVertical * 8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onPressed: menuItemsController.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    menuItemsController.isLoading.value = true;
                                    final url;

                                    if (_pickedImage == null &&
                                        menuItemsController.isEditing.value ==
                                            false) {
                                      menuItemsController.isLoading.value =
                                          false;
                                      userController.showSnackBar(
                                          'Error',
                                          'Please select the menu item image',
                                          Colors.red.shade400);
                                      return;
                                    }
                                    final id = Uuid().v4();
                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child('restaurants')
                                        .child(userController
                                            .firebaseUser.value!.uid)
                                        .child('menu_iems')
                                        .child('$id.jpg');

                                    if (!kIsWeb) {
                                      await ref.putFile(_pickedImage as File);
                                    } else {
                                      await ref.putData(_webImage);
                                    }
                                    url = await ref.getDownloadURL();

                                    if (widget.categoriesController
                                                .dropDownValue ==
                                            null &&
                                        menuItemsController.isEditing.value ==
                                            false) {
                                      menuItemsController.isLoading.value =
                                          false;

                                      userController.showSnackBar(
                                          'Error',
                                          'Please select the menu item category',
                                          Colors.red.shade400);
                                      return;
                                    }

                                    if (selected.isEmpty &&
                                        menuItemsController.isEditing.value ==
                                            false) {
                                      menuItemsController.isLoading.value =
                                          false;

                                      userController.showSnackBar(
                                          'Error',
                                          'Please select the menu item ingrdiants',
                                          Colors.red.shade400);
                                      return;
                                    }

                                    if (elements.isEmpty &&
                                        menuItemsController.isEditing.value ==
                                            false) {
                                      menuItemsController.isLoading.value =
                                          false;

                                      userController.showSnackBar(
                                          'Error',
                                          'Please select the menu item elements',
                                          Colors.red.shade400);
                                      return;
                                    }

                                    if (menuItemsController.isEditing.value) {
                                      print('is Edit ');
                                      MenuItem menuitem2 = menuItemsController
                                          .menuItem.value as MenuItem;
                                      menuItemsController.updateMenuItem(
                                        MenuItem(
                                          id: menuitem2.id,
                                          restaurantId: menuitem2.restaurantId,
                                          name: widget.nameController.text,
                                          categoryId: menuitem2.categoryId,
                                          description:
                                              widget.descriptionController.text,
                                          elements: menuitem2.elements,
                                          ingredientsId:
                                              menuitem2.ingredientsId,
                                          price: double.parse(
                                              widget.priceController.text),
                                          imageUrl: _pickedImage == null
                                              ? menuItemsController
                                                  .editImage.value
                                              : url,
                                          ratingsId: menuitem2.ratingsId,
                                        ),
                                      );
                                      widget.nameController.clear();
                                      widget.descriptionController.clear();
                                      widget.priceController.clear();
                                      menuItemsController.isEditing.value =
                                          false;
                                      menuItemsController.isShowInfos.value =
                                          false;

                                      menuItemsController.editImage.value = '';
                                    } else {
                                      final menuItem = MenuItem(
                                        id: id,
                                        restaurantId: userController
                                            .firebaseUser.value!.uid,
                                        name: widget.nameController.text,
                                        categoryId: widget.categoriesController
                                            .dropDownValue!.value,
                                        description:
                                            widget.descriptionController.text,
                                        elements: elements,
                                        ingredientsId: selected,
                                        price: double.parse(
                                            widget.priceController.text),
                                        imageUrl: url,
                                      );
                                      menuItemsController.addMenuItem(menuItem);
                                      Navigator.of(context)
                                          .pushNamed(MenuItemsScreen.appRoute);
                                    }

                                    menuItemsController
                                        .isCleanDescription.value = true;
                                    menuItemsController.isCleanName.value =
                                        true;
                                    menuItemsController.isCleanPrice.value =
                                        true;
                                    menuItemsController.isLoading.value = false;

                                    // menuItemsController.isSidBarExpanded.value =
                                    //     false;
                                  } catch (error) {
                                    menuItemsController.isLoading.value = false;
                                    userController.showSnackBar(
                                        'Error',
                                        'An error occurred, please try again later.',
                                        Colors.red.shade400);
                                    rethrow;
                                  }
                                }
                              },
                        child: menuItemsController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Obx(
                                () => Text(menuItemsController.isEditing.value
                                    ? 'Update menu item'
                                    : "Add menu item"),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
