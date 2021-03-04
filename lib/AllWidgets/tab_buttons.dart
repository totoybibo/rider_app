import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/location_input.dart';
import 'package:rider_app/constants.dart';
import 'divider.dart';

class TabButtons extends StatefulWidget {
  @override
  _TabButtonsState createState() => _TabButtonsState();
}

class _TabButtonsState extends State<TabButtons> {
  int _selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      height: 30,
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
                    'Menu',
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
                    'List',
                    style: TextStyle(
                        fontWeight: _selectedIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
          Container(
            child: ListInputMenus(addWork: () {}, addHome: () {}),
          )
        ],
      ),
    );
  }
}

class ListInputMenus extends StatelessWidget {
  ListInputMenus({
    @required this.addWork,
    @required this.addHome,
  });

  final Function addWork;
  final Function addHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          constraints: kBoxConstraints,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          highlightColor: Colors.lightBlueAccent,
          onPressed: addWork,
          child: kFavoriteListItem,
        ),
        DividerWidget(),
        RawMaterialButton(
          constraints: kBoxConstraints,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          highlightColor: Colors.lightBlueAccent,
          onPressed: addHome,
          child: kHomeListItem,
        ),
        DividerWidget(),
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
