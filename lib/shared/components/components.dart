import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/fonts.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

buildVerticalSpace({double? height = 20.0}) => SizedBox(
      height: height,
    );

buildHorizontalSpace({double? width = 20.0}) => SizedBox(
      width: width,
    );

TextTheme getTextTheme(context) => Theme.of(context).textTheme;

buildDefaultTextField({
  required context,
  required TextEditingController controller,
  required String label,
  required TextInputType type,
  required String? Function(String?) validator,
  IconData? suffixIcon,
  bool isSecure = false,
  void Function()? onSuffixPressed,
  bool focusedOutlineBorder = true,
  bool enabledOutlineBorder = true,
  Color focusBorderColor = WHITE_COLOR,
  Color enabledBorderColor = WHITE_COLOR,
  Color textColor = WHITE_COLOR,
  double borderRadius = 5,
  Function(String?)? onChange,
}) {
  return TextFormField(
    obscureText: isSecure,
    keyboardType: type,
    style: getTextTheme(context).bodyText1!.copyWith(
          color: textColor,
        ),
    onChanged: onChange,
    decoration: InputDecoration(
      labelStyle: getTextTheme(context)
          .bodyText1!
          .copyWith(color: focusBorderColor, height: 1, fontSize: 13),
      focusedBorder: focusedOutlineBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: focusBorderColor,
                width: 2.5,
              ))
          : UnderlineInputBorder(
              borderSide: BorderSide(
              color: focusBorderColor,
              width: 1.8,
            )),
      enabledBorder: enabledOutlineBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: enabledBorderColor, width: 1.2))
          : UnderlineInputBorder(
              borderSide: BorderSide(color: enabledBorderColor, width: 1.2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: enabledBorderColor, width: 1.2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: enabledBorderColor, width: 1.2)),
      //borders

      labelText: label,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(
                suffixIcon,
                color: PRIMARY_SWATCH,
              ),
              onPressed: () {
                onSuffixPressed!();
              },
            )
          : null,
    ),
    validator: validator,
    controller: controller,
  );
}

buildDefaultBtn({
  required void Function()? onPressed,
  required String txt,
  required context,
  double radius = 5,
  TextStyle? textStyle,
  double width = double.infinity,
  double fontSize = FONT_21,
}) {
  return Container(
    decoration: BoxDecoration(
        color: PRIMARY_SWATCH, borderRadius: BorderRadius.circular(radius)),
    child: MaterialButton(
      minWidth: width,
      height: 50,
      disabledColor: Colors.grey,
      onPressed: onPressed,
      child: Text(txt,
          style: textStyle == null
              ? getTextTheme(context).bodyText1!.copyWith(
                  color: WHITE_COLOR,
                  fontSize: fontSize,
                  fontFamily: REGULAR_FONT)
              : textStyle),
    ),
  );
}

buildLogoImage() {
  return Hero(
    tag: '$LOGO',
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Image(
        image: AssetImage('$WHITE_LOGO'),
      ),
    ),
  );
}

buildSmallLogo(
    {required String imageAssetName, Color color = PRIMARY_SWATCH, double width = 15, double height = 15}) {
  return SvgPicture.asset(
    imageAssetName,
    color: color,
    width: width,
    height: height,
  );
}

buildDividerView({double height = 0.5, double padding = 15.0}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: padding),
    child: Container(
      width: double.infinity,
      height: height,
      color: WHITE30,
    ),
  );
}

buildTextButton(
    {required String txt,
    required BuildContext context,
    required void Function() onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(txt,
        style:
            getTextTheme(context).bodyText1!.copyWith(color: PRIMARY_SWATCH)),
  );
}

showToast(String msg, {Toast duration = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: duration,
    backgroundColor: Colors.transparent,
    textColor: Colors.red,
    fontSize: FONT_17,
    gravity: ToastGravity.SNACKBAR,
  );
}

/*buildCircleImage(String? imageUrl, double size,
    {FileImage? pickedImage, bool anonymousImage = false}) {
  return CircleAvatar(
    backgroundColor: PRIMARY_SWATCH,
    radius: size == MEDIUM_PHOTO_SIZE ? size + 4 : size + 2,
    child: CircleAvatar(
      backgroundImage: pickedImage == null
          ? handleImage(imageUrl, anonymousImage)
          : pickedImage,
      backgroundColor: WHITE_COLOR,
      radius: size,
    ),
  );
}*/

buildCircleImage(String? imageUrl, double size,
    {FileImage? pickedImage, bool anonymousImage = false,bool assetImage = false}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: WHITE_COLOR,
        shape: BoxShape.circle,
        border: Border.all(color: PRIMARY_SWATCH, width: 2),
        image: DecorationImage(
            image: pickedImage == null
                ? handleImage(imageUrl, anonymousImage,assetImage)
                : pickedImage,
            fit: BoxFit.cover)),
  );
}

ImageProvider handleImage(imageUrl, bool anonymousImage,bool assetImage) {
  if (imageUrl == '' || imageUrl == null)
    return AssetImage(
      !anonymousImage ? AVATAR_PHOTO : ANONYMOUS_PHOTO,
    );
  else if (assetImage)
    return AssetImage(
        imageUrl
    );
  else
    return NetworkImage(
      imageUrl,
    );
}

buildCircleImageWithTitle(
    String? imageUrl, String title, BuildContext context) {
  return Row(
    children: [
      buildCircleImage(imageUrl, SMALL_PHOTO_SIZE),
      buildHorizontalSpace(width: 15),
      Expanded(
        child: Text(
          title,
          style: getTextTheme(context).headline2!.copyWith(fontSize: 15),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      )
    ],
  );
}
