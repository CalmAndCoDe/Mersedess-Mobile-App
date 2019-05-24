import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/Third.dart';

class ImageSelector extends StatefulWidget {
  final image;
  const ImageSelector({
    Key key,
    this.image,
  }) : super(key: key);
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> with SingleTickerProviderStateMixin {
  var third = ThirdCreate.instance();
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );

    _animation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn
    ));

    _animationController.forward().orCancel;

    super.initState();
  }
  

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FractionalTranslation(
          translation: Offset(-0.2, 0.5),
          child: Container(
            height: 100,
            width: 100,
            constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                widget?.image != null
                    ? ClipOval(
                        child: Image.file(
                        widget.image,
                        fit: BoxFit.cover,
                      ))
                    : Container(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Theme.of(context).textTheme.body2.color),
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.camera,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
