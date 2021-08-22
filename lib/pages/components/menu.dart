import 'package:flutter/material.dart';
import 'package:ambulance_hailer/models/menu_list_item.dart';
import 'package:ambulance_hailer/pages/authentification/help_support.dart';
import 'package:ambulance_hailer/pages/trip/news_offers.dart';
import 'package:ambulance_hailer/pages/user/RateCard.dart';
import 'package:ambulance_hailer/pages/user/emergency_contact.dart';
import 'package:ambulance_hailer/pages/trip/my_trips.dart';
import 'package:get/get.dart';
import 'package:ambulance_hailer/pages/user/profile.dart';
import 'package:ambulance_hailer/utils/CustomTextStyle.dart';
import 'package:ambulance_hailer/utils/menu_title.dart';


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuListItem> listMenuItem = new List();

  @override
  void initState() {
    super.initState();
    listMenuItem
        .add(createMenuItem(MenuTitle.MENU_PROFILE, "images/menu/user.png"));
    listMenuItem.add(
        createMenuItem(MenuTitle.MENU_MY_TRIPS, "images/menu/my_trips.png"));
    listMenuItem
        .add(createMenuItem(MenuTitle.MENU_NEWS_OFFERS, "images/menu/payment.png"));
    listMenuItem.add(createMenuItem(MenuTitle.MENU_HELP_SUPPORT,
        "images/menu/emergency_contacts.png"));
    listMenuItem.add(createMenuItem(MenuTitle.ABOUT,
        "images/menu/emergency_contacts.png"));
  }

  createMenuItem(String title, String imgIcon) {
    return MenuListItem(title, imgIcon);
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16))),
            elevation: 0,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade50,
                          blurRadius: 1,
                          offset: Offset(0, 1)),
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12, top: 8, right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            key: Key("UserNameMobile"),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Cephas ZOUBGA",
                                style: CustomTextStyle.mediumTextStyle,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text("06 39 60 79 53",
                                  style: CustomTextStyle.mediumTextStyle
                                      .copyWith(color: Colors.grey, fontSize: 12))
                            ],
                          ),
                          IconButton(
                              key: Key("CloseIcon"),
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      key: Key("ListMenu"),
                      shrinkWrap: true,
                      primary: true,
                      itemBuilder: (context, position) {
                        return createMenuListItemWidget(position);
                      },
                      itemCount: listMenuItem.length,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )),
          )
        ],
      );
  }

  createMenuListItemWidget(int position) {
    return GestureDetector(
     /*   listMenuItem
            .add(createMenuItem(MenuTitle.MENU_PROFILE, "images/menu/user.png"));
        listMenuItem.add(
        createMenuItem(MenuTitle.MENU_MY_TRIPS, "images/menu/my_trips.png"));
    listMenuItem
        .add(createMenuItem(MenuTitle.MENU_NEWS_OFFERS, "images/menu/payment.png"));
    listMenuItem.add(createMenuItem(MenuTitle.MENU_HELP_SUPPORT,
    "images/menu/emergency_contacts.png"));
    listMenuItem.add(createMenuItem(MenuTitle.ABOUT,*/
      onTap: () {
        if (listMenuItem[position].title == MenuTitle.MENU_PROFILE) {{Get.to(Profile());}
        }  else if (listMenuItem[position].title == MenuTitle.MENU_MY_TRIPS) {{Get.to(MyTrips());}
        } else if (listMenuItem[position].title == MenuTitle.MENU_NEWS_OFFERS) {{Get.to(NewsOffers());}}
        else if (listMenuItem[position].title ==
            MenuTitle.MENU_HELP_SUPPORT) {Get.to(HelpSupport());}
        else if (listMenuItem[position].title ==
            MenuTitle.ABOUT) {Get.to(HelpSupport());}},
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Image(
              image: AssetImage(listMenuItem[position].imgIcon),
            ),
            SizedBox(
              width: 14,
            ),
            Container(
              child: Text(listMenuItem[position].title),
              margin: EdgeInsets.only(left: 12),
            )
          ],
        ),
      ),
    );
  }
}
