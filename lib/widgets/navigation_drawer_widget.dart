import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentit4me/helper/dialog_helper.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:rentit4me/views/Alllisting_screen.dart';
import 'package:rentit4me/views/OfferRecievedScreen.dart';
import 'package:rentit4me/views/activelisting_screen.dart';
import 'package:rentit4me/views/activeorders_screen.dart';
import 'package:rentit4me/views/add_list_screen.dart';
import 'package:rentit4me/views/change_password_screen.dart';
import 'package:rentit4me/views/chat_screen.dart';
import 'package:rentit4me/views/completed_order_screen.dart';
import 'package:rentit4me/views/generate_ticket_screen.dart';

import 'package:rentit4me/views/inactivelisting_screen.dart';
import 'package:rentit4me/views/login_screen.dart';
import 'package:rentit4me/views/message_screen.dart';
import 'package:rentit4me/views/myorders_screen.dart';
import 'package:rentit4me/views/myticket_screen.dart';
import 'package:rentit4me/views/offer_made_screen.dart';
import 'package:rentit4me/views/order_recieved_screen.dart';
import 'package:rentit4me/views/payment_screen.dart';
import 'package:rentit4me/views/pending_status_screen.dart';
import 'package:rentit4me/views/profile_screen.dart';
import 'package:rentit4me/views/promotedlist_screen.dart';
import 'package:rentit4me/views/select_membership_screen.dart';
import 'package:rentit4me/views/user_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NavigationDrawerWidget extends StatefulWidget {

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  String name;
  String email;
  String urlImage;
  String mobile;

  //Check Approval
  String usertype;
  String trustedbadge;
  String trustedbadgeapproval;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getuserdetail();
    _getcheckapproveData();
  }

  Future _getuserdetail() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getString('name') == null || prefs.getString('name') == "" || prefs.getString('name') == "null"){
       Future temp = _getprofileData();
       temp.then((value) {
          if(value != null){
            setState(() {
              urlImage = sliderpath+value['User']['avatar_path'].toString();
              name = value['User']['name'].toString() == null ? "Hi Guest" : prefs.getString('name');
              email = value['User']['email'].toString();
              mobile = value['User']['mobile'].toString();
            });
          }
       });

       _setUserdetail(urlImage, name, email, mobile);
     }
     else{
        setState((){
            urlImage = prefs.getString('profile');
            name = prefs.getString('name') == null ? "Hi Guest" : prefs.getString('name');
            email = prefs.getString('email');
            mobile = prefs.getString('mobile');
        });
     }
  }

  void _setUserdetail(String profilepicurl, String name, String email, String mobile) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('profile', sliderpath+profilepicurl);
     prefs.setString('name', name);
     prefs.setString('email', email);
     prefs.setString('mobile', mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: kPrimaryColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).pop()
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    title: Text("MY ACCOUNT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1") {
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectMemberShipScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectMemberShipScreen(pageswitch: "Home")));
                            }
                          }

                        },
                        child: const Align(
                            alignment : Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Membership & Subscriptions", style: TextStyle(color: Colors.white, fontSize: 16)),
                            )
                        ),
                      ),
                      InkWell(
                        onTap:() async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                           else{
                             if(trustedbadge == "1") {
                               if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                               }
                               else{
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
                               }
                             }
                             else{
                               Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
                             }
                           }
                        },
                        child: const Align(
                            alignment : Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Payment", style: TextStyle(color: Colors.white, fontSize: 16)),
                            )
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateTicketScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateTicketScreen()));
                            }
                          }
                        },
                        child: const Align(
                            alignment : Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Generate Ticket", style: TextStyle(color: Colors.white, fontSize: 16)),
                            )
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyticketScreen()));
                              }
                            }
                            else{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyticketScreen()));
                            }
                          }
                        },
                        child: const Align(
                            alignment : Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("My Ticket", style: TextStyle(color: Colors.white, fontSize: 16)),
                            )
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white70),
                  ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    title: Text("MY LISTING", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                            else{
                              if(trustedbadge == "1"){
                                if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddlistingScreen()));
                                }
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddlistingScreen()));
                              }
                            }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Listing Ads", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == "") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                           else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AlllistingScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AlllistingScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("All Listing", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == "") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ActivelistingScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ActivelistingScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Active Listing", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                           else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => InactivelsitingScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InactivelsitingScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Inactive Listing", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                             SharedPreferences prefs = await SharedPreferences.getInstance();
                             if(prefs.getString('userid') == null || prefs.getString('userid') == "") {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                             }
                             else{
                               if(trustedbadge == "1"){
                                 if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                                 }
                                 else{
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => PromotedlistScreen()));
                                 }
                               }
                               else{
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PromotedlistScreen()));
                               }
                             }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Promoted Listing", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white70),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Text("MY INBOX", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Chat", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Messages", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                           else{
                             if(trustedbadge == "1"){
                               if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                               }
                               else{
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => OfferMadeScreen()));
                               }
                             }
                             else{
                               Navigator.push(context, MaterialPageRoute(builder: (context) => OfferMadeScreen()));
                             }
                           }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:  Text("Offers Made", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OfferRecievedScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OfferRecievedScreen()));
                            }
                          }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Offers Recieved", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white70),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Text("MY ORDERS", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                             if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                             }
                             else{
                               if(trustedbadge == "1") {
                                 if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                                 }
                                 else{
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen()));
                                 }
                               }
                               else{
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen()));
                               }
                             }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                             padding: EdgeInsets.all(8.0),
                            child: Text("My Orders", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1") {
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveOrderScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveOrderScreen()));
                            }
                          }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0), child: Text("Active Orders", style: TextStyle(color: Colors.white, fontSize: 16))),
                        ),
                      ),
                      InkWell(
                        onTap:() async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedOrderScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedOrderScreen()));
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Completed Orders", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRecievedScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRecievedScreen()));
                            }
                          }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Orders Recieved", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),

                    ],
                  ),
                  Divider(color: Colors.white70),
                  ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    title: Text("MANAGE PROFILE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    children: <Widget>[
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            if(trustedbadge == "1"){
                              if(trustedbadgeapproval == null || trustedbadgeapproval == "null" || trustedbadgeapproval == "" || trustedbadgeapproval == "Pending" || trustedbadgeapproval == "pending"){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PendingStatusScreen()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen()));
                              }
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen()));
                            }
                          }

                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Basic Detail", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           if(prefs.getString('userid') == null || prefs.getString('userid') == ""){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                           }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                          }
                          },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Security", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(
      {String urlImage, String name, String email, VoidCallback onClicked}) {
    return Column(
      children: [
        InkWell(
          onTap: onClicked,
          child: Container(
            padding: padding.add(EdgeInsets.symmetric(vertical: 15)),
            child: const Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: urlImage == "" || urlImage == null || urlImage == "null" ? Container(height: 80, width: 80, child: Image.asset('assets/images/profile_placeholder.png', fit: BoxFit.fill, color: Colors.white)) : Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                shape: BoxShape.circle
            ),
            child: CachedNetworkImage(
              imageUrl: urlImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.white, width: 2),
                  //borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn)
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset('assets/images/profile_placeholder.png', color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        name == "" || name == null ? Text("") : Text(name, style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
        SizedBox(height: 5.0),
        email == "" || email == null ? Text("") : Text(email, style: TextStyle(color: Colors.white, fontSize: 14))
      ],
    );
  }

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ));
        break;
      case 1:
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SelectMemberShipScreen(),
        ));
        break;
      case 3:
        DialogHelper.logout(context);
        break;
    }
  }

  Future _getprofileData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userid'));
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      return data;
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getcheckapproveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      //"user_id": "846",  //this is business user id
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + checkapprove),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if(data != null){
        if(mounted == true){
          setState(() {
            usertype = data['user_type'].toString();
            trustedbadge = data['trusted_badge'].toString();
            trustedbadgeapproval = data['trusted_badge_approval'].toString();
          });
        }
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }
}
