import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/approval_list_item.dart';
import 'package:approval_gratika/repository/repository.dart';
import 'package:approval_gratika/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../app_routes.dart';
import '../../model/push_notification.dart';
import '../login/detail/detail_approval_screen.dart';
import '../notification_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<ApprovalListItem> listApproval = [];
  List<ApprovalListItem> filteredList = [];
  bool isSearching = false; // Track whether the search icon is clicked
  Repository repository = Repository();
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  getData() async {
    if (await repository.getApprovalListData() == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      listApproval = await repository.getApprovalListData();
      filteredList = listApproval;
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      // Send this token to your server
    });
    _totalNotifications = 0;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    checkForInitialMessage();

    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register as an observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when disposing
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getData();
    }
  }

  void filterList(String query) {
    setState(() {
      filteredList = listApproval.where((item) {
        return item.noBukti.toLowerCase().contains(query.toLowerCase()) ||
            item.modul.toLowerCase().contains(query.toLowerCase()) ||
            item.tanggal.toLowerCase().contains(query.toLowerCase()) ||
            item.namaPp.toLowerCase().contains(query.toLowerCase()) ||
            item.nilai.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    NotificationBadge(totalNotifications: _totalNotifications),
                    Text(
                      "Approval Management\nSystem",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 22),
                    Container(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            style: TextStyle(fontSize: 12),
                            onChanged: (value) {
                              filterList(value);
                            },
                            cursorColor: AppColors.primaryColor,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,color: Colors.grey,),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              floatingLabelStyle:
                                  TextStyle(color: AppColors.primaryColor),
                              labelText: 'Search',
                            ),
                          )),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isSearching = false;
                                filteredList = listApproval;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                // Wrap ListView.builder with Expanded
                child: Container(
                  child: GlowingOverscrollIndicator(
                    color: AppColors.primaryColor,
                    axisDirection: AxisDirection.down,
                    child: filteredList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailApprovalScreen(
                                              no_bukti:
                                              filteredList[index].noBukti,
                                              modul: filteredList[index].modul),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Container(
                                      margin: EdgeInsets.all(25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.modul,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                formatCurrency(
                                                    double.parse(item.nilai)),
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            item.keterangan,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.namaPp,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 12,
                                                color: AppColors.primaryColor,
                                              ),
                                              // Your icon here
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                item.tanggal,
                                                style: TextStyle(fontSize: 10),
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
                          )
                        : Center(child: Text("Tidak ada data pengajuan.")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
