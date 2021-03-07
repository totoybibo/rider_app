import 'package:flutter/material.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/AllWidgets/component_widgets.dart';

class TabButtons extends StatefulWidget {
  final Function addFavorites;
  final Function addHome;
  final Function addWork;
  TabButtons(
      {@required this.addFavorites,
      @required this.addWork,
      @required this.addHome});
  @override
  _TabButtonsState createState() => _TabButtonsState();
}

class _TabButtonsState extends State<TabButtons>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    animationDuration: const Duration(milliseconds: 500),
                    side: BorderSide(
                        color: _selectedIndex == 1
                            ? Colors.blueAccent
                            : kDarkModeColor,
                        width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () => setState(() => _selectedIndex = 1),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    animationDuration: const Duration(milliseconds: 500),
                    side: BorderSide(
                        color: _selectedIndex == 2
                            ? Colors.blueAccent
                            : kDarkModeColor,
                        width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () => setState(() => _selectedIndex = 2),
                  child: Text(
                    'Result',
                    style: TextStyle(
                        fontWeight: _selectedIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          HDividerWidget(),
          Container(
            child: ListInputMenus(
              addFavorites: widget.addFavorites,
              addWork: widget.addWork,
              addHome: widget.addHome,
            ),
          ),
        ],
      ),
    );
  }
}

class ListInputMenus extends StatelessWidget {
  final Function addFavorites;
  final Function addHome;
  final Function addWork;
  ListInputMenus(
      {@required this.addFavorites,
      @required this.addHome,
      @required this.addWork});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          constraints: kBoxConstraints,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          highlightColor: Colors.lightBlueAccent,
          onPressed: addFavorites,
          child: kFavoriteListItem,
        ),
        HDividerWidget(),
        RawMaterialButton(
          constraints: kBoxConstraints,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          highlightColor: Colors.lightBlueAccent,
          onPressed: addHome,
          child: kHomeListItem,
        ),
        HDividerWidget(),
        RawMaterialButton(
          constraints: kBoxConstraints,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          highlightColor: Colors.lightBlueAccent,
          onPressed: addWork,
          child: kWorkListItem,
        ),
      ],
    );
  }
}
