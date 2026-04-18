import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Opens an in-app capture flow that uses the front-facing camera when available.
///
/// The platform image picker only hints lens facing on Android; many OEM camera
/// apps ignore that hint, so this page uses the Camera plugin instead.
Future<String?> openSelfieCapture(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const SelfieCapturePage(),
    ),
  );
}

class SelfieCapturePage extends StatefulWidget {
  const SelfieCapturePage({super.key});

  @override
  State<SelfieCapturePage> createState() => _SelfieCapturePageState();
}

class _SelfieCapturePageState extends State<SelfieCapturePage> {
  CameraController? _controller;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    unawaited(_initCamera());
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = _pickFrontCamera(cameras);
      if (camera == null) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      try {
        await controller.initialize();
      } on Object {
        await controller.dispose();
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } on Object {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  static CameraDescription? _pickFrontCamera(List<CameraDescription> cameras) {
    for (final c in cameras) {
      if (c.lensDirection == CameraLensDirection.front) {
        return c;
      }
    }
    return cameras.isEmpty ? null : cameras.first;
  }

  Future<void> _onCapture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    try {
      final shot = await controller.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(shot.path);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the photo. Try again.')),
      );
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF5E6E6)),
        ),
      );
    }

    final controller = _controller!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF6B0000),
                  foregroundColor: const Color(0xFFF5E6E6),
                  onPressed: _onCapture,
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
