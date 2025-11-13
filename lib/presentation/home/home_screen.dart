import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:random_images/business_logic/cubit/random_image_cubit.dart';
import 'package:random_images/core/helper_functions.dart';
import 'package:random_images/presentation/models/image_presentation_model.dart';
import 'package:random_images/presentation/widget/global_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_images/presentation/widget/image_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RandomImageCubit _randomImageCubit;
  ImagePresentationModel? _currentImage;
  bool _isExtractingColor = false;

  @override
  void initState() {
    super.initState();
    _randomImageCubit = BlocProvider.of<RandomImageCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _randomImageCubit.fetchRandomImage();
    });
  }

  /// Extract background color from image - UI concern stays in presentation layer
  Future<void> _extractBackgroundColor(String imageUrl) async {
    if (_isExtractingColor) return;

    setState(() {
      _isExtractingColor = true;
    });

    try {
      final color = await generatePalette(imageUrl);
      log("color:$color");
      if (mounted) {
        setState(() {
          _currentImage = _currentImage?.copyWith(backgroundColor: color);
          _isExtractingColor = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExtractingColor = false;
          _currentImage = _currentImage?.copyWith(backgroundColor: Colors.black);
          log("color cache:$e");


        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return BlocListener<RandomImageCubit, RandomImageState>(
      listener: (context, state) {
        if (state is RandomImageLoaded) {
          _currentImage = ImagePresentationModel(imageUrl: state.imageUrl);
          _extractBackgroundColor(state.imageUrl);
        }
      },
      child: BlocBuilder<RandomImageCubit, RandomImageState>(
        builder: (context, state) {
          final backgroundColor = _currentImage?.backgroundColor ??
              (isDarkMode ? Colors.black : Colors.white);
          log("backgroundColor:$backgroundColor");
          return Scaffold(
            backgroundColor: backgroundColor,
            key: ValueKey(backgroundColor),
            body: AnimatedContainer(
              key: ValueKey(backgroundColor),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              color: backgroundColor,
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is RandomImageLoading)
                        Semantics(
                          label: 'Loading random image',
                          child: const ImageLoading(),
                        )
                      else if (state is RandomImageError)
                        Semantics(
                          label: 'Error: ${state.errorMessage}',
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: customTextWidget(
                              state.errorMessage,
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else if (state is RandomImageLoaded)
                        Semantics(
                          label: 'Random image loaded',
                          image: true,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: displayImage(
                              state.imageUrl,
                              radius: 0,
                              height: 200,
                              width: 200,
                              key: ValueKey(state.imageUrl),
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Cache indicator
                      if (state is RandomImageLoaded && state.isFromCache)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.offline_bolt,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Loaded from cache',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Main button
                      Semantics(
                        button: true,
                        label: 'Load another random image',
                        enabled: state is! RandomImageLoading,
                        child: GlobalButton(
                          isEnabled: state is! RandomImageLoading,
                          title: "Another",
                          onPress: () {
                            _randomImageCubit.fetchRandomImage();
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Additional actions
                      if (state is! RandomImageLoading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Refresh button
                            TextButton.icon(
                              onPressed: () {
                                _randomImageCubit.forceRefresh();
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Refresh'),
                              style: TextButton.styleFrom(
                                foregroundColor: isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Clear cache button
                            TextButton.icon(
                              onPressed: () async {
                                await _randomImageCubit.clearImageCache();
                                _randomImageCubit.fetchRandomImage();
                              },
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Clear Cache'),
                              style: TextButton.styleFrom(
                                foregroundColor: isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
