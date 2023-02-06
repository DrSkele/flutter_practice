import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePickerApp extends StatelessWidget {
  const MyImagePickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: ImagePickerCustom(),
    );
  }
}

class ImagePickerCustom extends StatefulWidget {
  const ImagePickerCustom({super.key});

  @override
  State<ImagePickerCustom> createState() => _ImagePickerCustomState();
}

class _ImagePickerCustomState extends State<ImagePickerCustom> {
  List<XFile>? _imageFileList;

  void _addToImageFileList(XFile? value) {
    if (value == null) {
      return;
    } else {
      if (_imageFileList == null) {
        setState(() {
          _imageFileList = <XFile>[value];
        });
      } else {
        setState(() {
          _imageFileList!.add(value);
        });
      }
    }
  }

  void _removeFromImageFileList(XFile? value) {
    if (value == null || _imageFileList == null) {
      return;
    } else {
      setState(() {
        _imageFileList!.remove(value);
      });
    }
  }

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String? _retrieveDataError;

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _addToImageFileList(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _addToImageFileList(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('custom image picker')),
      body: Center(
        child: FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _showImages();
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onImageButtonPressed(ImageSource.gallery, context: context);
        },
        heroTag: 'image0',
        tooltip: 'Pick Image from gallery',
        child: const Icon(Icons.photo),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _showImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return ListView.builder(
        key: UniqueKey(),
        itemBuilder: (BuildContext context, int index) {
          return ImageFileListTile(
            file: _imageFileList![index],
            onClose: _removeFromImageFileList,
          );
        },
        itemCount: _imageFileList!.length,
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
}

class ImageFileListTile extends StatelessWidget {
  const ImageFileListTile({
    super.key,
    required this.file,
    required this.onClose,
  });

  final XFile file;
  final Function(XFile file) onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(10),
          child: Image.file(File(file.path)),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                onClose(file);
              },
              icon: Container(
                decoration: BoxDecoration(
                    color: const Color(0x8fffffff),
                    borderRadius: BorderRadius.circular(25)),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        )
      ],
    );
  }
}
