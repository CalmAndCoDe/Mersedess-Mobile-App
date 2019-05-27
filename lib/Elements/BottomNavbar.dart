import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/LoginUser.dart';
import 'package:mobile_app/Elements/AppBar.dart';
import 'package:mobile_app/Elements/MenuItemBuilder.dart';



class Menu extends StatelessWidget {
  final CustomAppBar appbar;
  final AnimationController _menuAnimationController;
  final ValueNotifier<String> menuSelected;
  final PageController _menuController;

  
  const Menu({
    Key key,
    @required this.appbar,
    @required AnimationController menuAnimationController,
    @required this.menuSelected,
    @required PageController menuController,
  })  : _menuAnimationController = menuAnimationController,
        _menuController = menuController,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      height: MediaQuery.of(context).size.width * .20,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          shrinkWrap: false,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomMenuItem(
                  isMenuButton: true,
                  onTap: () {
                    appbar.menuState.value
                        ? _menuAnimationController.reverse().orCancel
                        : _menuAnimationController.forward().orCancel;
                    appbar.menuState.value = !appbar.menuState.value;
                  },
                  itemColor: Theme.of(context).textTheme.body2.color,
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: menuSelected,
                  builder: (context, menu, child) {
                    return Row(
                      children: <Widget>[
                        CustomMenuItem(
                          onTap: () {
                            _menuController.previousPage(
                                curve: Curves.easeInOutCirc,
                                duration: Duration(milliseconds: 500));
                            menuSelected.value = 'home';
                          },
                          isSelected: menu == 'home',
                          isMenuButton: false,
                          itemColor: Theme.of(context).textTheme.body2.color,
                          child: Icon(
                            Icons.home,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                        ),
                        CustomMenuItem(
                          onTap: () {
                            _menuController.nextPage(
                                curve: Curves.easeInOutCirc,
                                duration: Duration(milliseconds: 500));
                            menuSelected.value = 'bookmark';
                          },
                          isSelected: menu == 'bookmark',
                          itemColor: Theme.of(context).textTheme.body2.color,
                          child: Icon(
                            Icons.bookmark_border,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                        ),
                        CustomMenuItem(
                          onTap: () => menuSelected.value = 'profile',
                          isSelected: menu == 'profile',
                          itemColor: Theme.of(context).textTheme.body2.color,
                          child: Icon(
                            FontAwesomeIcons.userCircle,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                        ),
                        CustomMenuItem(
                          onTap: () {
                            LoginUser.instance().loginEvents.add(Error.AuthenticationError);
                            menuSelected.value = 'logout';
                          },
                          isSelected: menu == 'logout',
                          itemColor: Theme.of(context).textTheme.body2.color,
                          child: Icon(
                            FontAwesomeIcons.signOutAlt,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ]),
    );
  }
}