import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String imagePath = '';
  late File? _image;
  late ImagePicker picker = ImagePicker();
  late XFile? pickedFile;
  String? _retrieveDataError;
  dynamic _pickedImageError;

  bool chooseImageFromGallery = true;

  set _imageFile(XFile? value) {
    pickedFile = (value == null) ? null : value;
  }

  Future pickImage() async {
    try {
      if (chooseImageFromGallery) {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      } else {
        pickedFile = await picker.pickImage(source: ImageSource.camera);
      }
      setState(() {
        _imageFile = pickedFile;
        _image = File(pickedFile!.path);
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.image) {
          // _handleImage(response.file);
          _imageFile = response.file;
          _image = File(pickedFile!.path);
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
      // ErrorHandler()
      //     .errorDialog(context, 'Something went wrong try again later');
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget onErrorDisplay(BuildContext context, String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Text(
          // 'Something went wrong try again later',
          e,
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xff28293D),
      ),
    );
    return Image.asset(
      'assets/logos/bgImage.jpg',
      fit: BoxFit.fill,
    );
  }

  Widget displayImage() {
    Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (pickedFile != null) {
      // return Image.network(pickedFile!.path, fit: BoxFit.cover, width: 160, height: 160,);
      return Material(
        color: Colors.transparent,
        child: Ink.image(
          image: FileImage(File(pickedFile!.path)),
          fit: BoxFit.fill,
          // child: InkWell(onTap: onClicked),
        ),
      );
    } else if (_pickedImageError != null) {
      return onErrorDisplay(context, _pickedImageError);
    } else {
      return Image.asset(
        'assets/logos/bgImage.jpg',
        fit: BoxFit.fill,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // ignore: prefer_const_constructors
              SizedBox(
                height: 100,
              ),
              // ignore: prefer_const_constructors
              Text(
                'Teachable Machine CNN',
                // ignore: prefer_const_constructors
                style: TextStyle(
                  color: const Color(0xFFEEDA28),
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'Detect Dogs and Cats',
                style: TextStyle(
                  color: Color(0xFFE99600),
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/cat.png',
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          chooseImageFromGallery = false;
                        });
                        pickImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 260,
                        alignment: Alignment.center,
                        // ignore: prefer_const_constructors
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 17,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE99600,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Take a picture'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          chooseImageFromGallery = true;
                        });
                        pickImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 260,
                        alignment: Alignment.center,
                        // ignore: prefer_const_constructors
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 17,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE99600,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Choose a picture from gallery'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
