import 'dart:io';
import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final formKey = GlobalKey<FormState>();
  final artistNameController = TextEditingController();
  final songNameController = TextEditingController();
  Color selectedColor = AppPallet.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    artistNameController.dispose();
    songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading == true),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedImage: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      selectedColor: selectedColor,
                    );
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: AppPallet.borderColor,
                                  dashPattern: [10, 4],
                                  radius: Radius.circular(10),
                                  strokeWidth: 1,
                                ),

                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      SizedBox(height: 15),
                                      Text(
                                        'Select the thumbnail for your song',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 40),

                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomTextField(
                              hintText: 'Pick song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      SizedBox(height: 20),

                      CustomTextField(
                        hintText: 'Artist',
                        controller: artistNameController,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Song name',
                        controller: songNameController,
                      ),
                      SizedBox(height: 20),

                      ColorPicker(
                        pickersEnabled: {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
