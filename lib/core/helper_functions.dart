import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:random_images/presentation/widget/image_loading.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
displayImage(imagePath, {double radius = 30.0, double? height, double? width, Key? key}) {
  return CachedNetworkImage(
    key: key,
      imageUrl: imagePath.toString(),
      height: height,
      width: width,
      placeholder: (context, url) {
        return radius > 0
            ? Container(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10, bottom: 5),
          width:  radius * 2 ,
          height:  radius * 2 ,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey
          ),

        )
            : ImageLoading();
      },
      errorWidget: (context, url, error) {
        return radius > 0
            ? Container(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10, bottom: 5),
          width: radius * 2,
          height: radius * 2,
          decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
              border: Border.all(color: Colors.grey[100]!),
          ),

        )
            : Container(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10, bottom: 5),
          width: radius * 2,
          height: radius * 2,
          decoration:  BoxDecoration(
            color: Colors.black26,
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Icon(Icons.warning,color: Colors.redAccent,),

        );
      },
      imageBuilder: (context, image) {
        return radius > 0
            ? CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: image,
          radius: radius,
        )
            : Image(
          image: image,
          fit: BoxFit.cover,
        );
      });
}

Widget customTextWidget(String? word,
    {double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    Color elevationColor = Colors.black38,
    TextAlign textAlign = TextAlign.left,
    int? maxLines = 7,
    double? height = 1.2,
    double? decorationThickness = 1,
    TextStyle? style,
    TextOverflow? overflow = TextOverflow.ellipsis,
    TextDecoration textDecoration = TextDecoration.none,
    TextStyle? textStyle,
    int shadow = 0}) {
  return Text(
    word ?? '...',
    softWrap: true,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    style: style ??
        textStyle ??
        TextStyle(
          decoration: textDecoration,
          decorationThickness: decorationThickness,
          height: height,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: shadow > 0
              ? elevation(color: elevationColor, elevation: shadow)
              : [],
        ),
  );
}
List<BoxShadow> elevation({required Color color, required int elevation}) {
  return [
    BoxShadow(
        color: color.withOpacity(0.6),
        offset: const Offset(0.0, 4.0),
        blurRadius: 3.0 * elevation,
        spreadRadius: -1.0 * elevation),
    BoxShadow(
        color: color.withOpacity(0.44),
        offset: const Offset(0.0, 1.0),
        blurRadius: 2.2 * elevation,
        spreadRadius: 1.5),
    BoxShadow(
        color: color.withOpacity(0.12),
        offset: const Offset(0.0, 1.0),
        blurRadius: 4.6 * elevation,
        spreadRadius: 0.0),
  ];
}

TextStyle appStyle(
    {
      double fontSize = 14,
      double? size = 16,
      double? height,
      Color? color =  Colors.black,
      FontWeight fontWeight = FontWeight.w400,
      double? decorationThickness = 1,
      FontStyle fonStyle = FontStyle.normal,
      TextDecoration textDecoration = TextDecoration.none,
    }) {
  return TextStyle(
      fontWeight: fontWeight, fontSize: size, color: color,decoration: textDecoration,decorationThickness: decorationThickness,height:height );
}

// Generate palette from an image
Future<Color?> generatePalette(String imageUrl) async {
  // Load your image
  final ImageProvider imageProvider = NetworkImage(imageUrl);

  // Generate palette
  final PaletteGeneratorMaster paletteGenerator =
  await PaletteGeneratorMaster.fromImageProvider(
    imageProvider,
    maximumColorCount: 16,
    colorSpace: ColorSpace.lab, // Use LAB color space for better accuracy
    generateHarmony: true,      // Generate color harmony
  );

  // Access extracted colors
  final Color? dominantColor = paletteGenerator.dominantColor?.color;
  final Color? vibrantColor = paletteGenerator.vibrantColor?.color;
  final Color? mutedColor = paletteGenerator.mutedColor?.color;

  // Get all extracted colors
  final List<PaletteColorMaster> allColors = paletteGenerator.paletteColors;

  return dominantColor;
}