import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/widgets/edit_image_viewmodel.dart';
import 'package:image_editor/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  final String selectedImage;
  const EditImageScreen({
    super.key,
    required this.selectedImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < text.length; i++)
                  Positioned(
                    left: text[i].left,
                    top: text[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: text[i]),
                        child: ImageText(textInfo: text[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            text[i].top = off.dy - 92;
                            text[i].left = off.dx;
                          });
                        },
                      ),
                    ),
                  ),
                creatorText.text.isEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _addnewTextFab,
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(widget.selectedImage),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget get _addnewTextFab => FloatingActionButton(
        onPressed: () => addNewDiloge(context),
        backgroundColor: Colors.white,
        tooltip: 'Add New Text',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              IconButton(
                icon: const Icon(Icons.save, color: Colors.black),
                onPressed: () => saveToGallery(context),
                tooltip: 'Save Image',
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () => increaseFontSize(),
                tooltip: 'Increase font size',
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.black),
                onPressed: () => decreaseFontSize(),
                tooltip: 'Decrease font size',
              ),
              IconButton(
                icon: const Icon(Icons.format_align_left, color: Colors.black),
                onPressed: () => alignLeft(),
                tooltip: 'Aign Left',
              ),
              IconButton(
                icon:
                    const Icon(Icons.format_align_center, color: Colors.black),
                onPressed: () => alignCenter(),
                tooltip: 'Align Center',
              ),
              IconButton(
                icon: const Icon(Icons.format_align_right, color: Colors.black),
                onPressed: () => alignRight,
                tooltip: 'Align Right',
              ),
              IconButton(
                icon: const Icon(Icons.format_bold, color: Colors.black),
                onPressed: () => boldText(),
                tooltip: 'Bold',
              ),
              IconButton(
                icon: const Icon(Icons.format_italic, color: Colors.black),
                onPressed: () => italicText(),
                tooltip: 'Italic',
              ),
              IconButton(
                icon: const Icon(Icons.space_bar, color: Colors.black),
                onPressed: () => addLinesToText(),
                tooltip: 'Add New Line',
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Red',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.red),
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Black',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.black),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'White',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.white),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 231, 226, 226),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Blue',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.blue),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Yellow',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.yellow),
                  child: const CircleAvatar(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Green',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.green),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Orange',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.orange),
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Pink',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.pink),
                  child: const CircleAvatar(
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      );
}
