import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_editor/models/text_info.dart';
import 'package:image_editor/screens/edit_image_screen.dart';
import 'package:image_editor/utils/utils.dart';
import 'package:image_editor/widgets/defalut_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  //controller control text which we want to write on image
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();

  //this help to take ss and  of edited image
  ScreenshotController screenshotController = ScreenshotController();

  //this list contains data of edited things like size ,possiton, font
  List<TextInfo> text = [];

  int currentIndex = 0; //  index to select text

  //to save image to gellery
  saveToGallery(BuildContext context) {
    if (text.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery!'),
          ),
        );
      });
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestiPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  //this help tp delet text on long press
  removeText(BuildContext context) {
    setState(() {
      text.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

//select text
  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected For Styling',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      text[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      text[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      text[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (text[currentIndex].fontWeight == FontWeight.bold) {
        text[currentIndex].fontWeight = FontWeight.normal;
      } else {
        text[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (text[currentIndex].fontStyle == FontStyle.italic) {
        text[currentIndex].fontStyle = FontStyle.normal;
      } else {
        text[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      text[currentIndex].text = text[currentIndex].text.replaceAll(' ', '\n');
    });
  }

  addNewText(BuildContext content) {
    setState(
      () {
        text.add(
          TextInfo(
            text: textEditingController.text,
            left: 0,
            top: 0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            textAlign: TextAlign.left,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  addNewDiloge(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefalutButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.white,
                textColor: Colors.black,
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              DefalutButton(
                onPressed: () => addNewText(context),
                color: Colors.red,
                textColor: Colors.white,
                child: const Text(
                  'Add Text',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
