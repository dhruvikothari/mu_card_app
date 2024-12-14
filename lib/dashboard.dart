import 'package:flutter/material.dart';
import 'package:mu_card/connection.dart';
import 'package:mu_card/get_size.dart';

import 'package:mu_card/mycards.dart';
import 'package:mu_card/profiles.dart';

import 'drawer.dart';

int pageNumber = 0;

class Dashboard extends StatefulWidget {
  static int userId = 0;
  static int businessId = 0;
  Dashboard({super.key, required int userId}) {
    Dashboard.userId = userId;
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        drawer: DrawerMenu(userId: Dashboard.userId),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(2, 3.5, 0, 3.5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: const Color.fromARGB(255, 57, 55, 55)),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(26, 39, 39, 39),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.double_arrow_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'EKAGRATA',
            style: TextStyle(
                fontFamily: 'Mooli',
                fontSize: 22,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 90,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (pageNumber == 1) ...[
                  Profiles(userId: Dashboard.userId),
                ],
                if (pageNumber == 2) ...[
                  const Connection(),
                ],
                if (pageNumber == 0) ...[
                  MyCards(userId: Dashboard.userId),
                ],
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 49, 49, 50)),
                        color: const Color.fromARGB(55, 64, 63, 63),
                        borderRadius: BorderRadius.circular(12)),
                    height: 70,
                    width: getWidth(context, 0.95),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (pageNumber == 0) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 27, 0, 136)),
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.credit_card,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  label: const Text(
                                    'My Cards',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Mooli'),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pageNumber = 0;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.credit_card,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (pageNumber == 1) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 27, 0, 136)),
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.perm_contact_calendar_sharp,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  label: const Text(
                                    'Profiles',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Mooli'),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pageNumber = 1;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.perm_contact_calendar_sharp,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (pageNumber == 2) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: getWidth(context, 0.4),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.connect_without_contact,
                                    size: 30,
                                    color: Colors.amber,
                                  ),
                                  label: const Text(
                                    'Connect',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Mooli'),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pageNumber = 2;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.connect_without_contact,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
