import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rentit4me/network/api.dart';
import 'package:rentit4me/themes/constant.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/myticket_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewTicketScreen extends StatefulWidget {
  String ticketid;
  ViewTicketScreen({this.ticketid});

  @override
  State<ViewTicketScreen> createState() => _ViewTicketScreenState(ticketid);
}

class _ViewTicketScreenState extends State<ViewTicketScreen> {
  String ticketid;
  _ViewTicketScreenState(this.ticketid);

  bool _loading = false;

  String tktid;
  String priority;
  String title;
  String message;
  String status;
  String created;
  String updated;

  String attachmentdoc;
  String comment;

  //get data
  List<dynamic> getcommentdatalist = [];
  String name;

  String usertype;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getViewTicket(ticketid);
    _getcomments(ticketid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Ticket", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Ticket ID", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)),
                                        SizedBox(height: 5.0),
                                        tktid == null ? SizedBox() : Text(tktid, style: TextStyle(color: Colors.black))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Priority", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)),
                                        SizedBox(height: 5.0),
                                        priority == null ? SizedBox() : Container(
                                          height: 30,
                                          width: 80,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.circular(8.0)
                                          ),
                                          child: Text(priority, style: TextStyle(color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ]),
                              SizedBox(height: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Title", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)),
                                  const SizedBox(height: 5.0),
                                  title == null ? const SizedBox() : Text(title, style: const TextStyle(color: Colors.black, fontSize: 16))
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Message", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 5.0),
                                  message == null ? const SizedBox() : Text(message, style: const TextStyle(color: Colors.black))
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Status", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5.0),
                                      status == null ? const SizedBox() : _getStatus(status)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Created At", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 5.0),
                                      created == null ? SizedBox() : Text(created, style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Align(
                                alignment: Alignment.topLeft,
                                child: getcommentdatalist.length == 0 || getcommentdatalist.isEmpty ? const Text("Discussion (0)", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Discussion (${getcommentdatalist.length.toString()})", style: TextStyle(color: Colors.black, fontSize: 16)),
                              ),
                              getcommentdatalist.length == 0 || getcommentdatalist.isEmpty ? SizedBox() :  SizedBox(height: 10.0),
                              getcommentdatalist.length == 0 || getcommentdatalist.isEmpty ? SizedBox() : getcommentdatalist.length != 1 ? Container(
                                height: 150,
                                width: double.infinity,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: getcommentdatalist.length,
                                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap:(){
                                        if(usertype == "3"){
                                          _save("https://dev.techstreet.in/rentit4me/public/assets/consumer/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                        }
                                        else{
                                          _save("https://dev.techstreet.in/rentit4me/public/assets/business/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: getcommentdatalist[index]['attachment'] == null ? Container(height: 80, width: 80, child: Image.asset('assets/images/no_image.jpg', fit: BoxFit.fill, color: Colors.white)) : CachedNetworkImage(
                                                height: 80,
                                                width: 80,
                                                imageUrl: _getAttachmentPath(usertype, getcommentdatalist[index]['attachment'].toString()),
                                                imageBuilder: (context, imageProvider) => Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn)
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Image.asset('assets/images/profile_placeholder.png', color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 5.0),
                                            Expanded(
                                                child: Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        name == null ? SizedBox() : Text(name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                                        Text(getcommentdatalist[index]['created_at'].toString().split('T')[0].toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                                      ],
                                                    ),
                                                    SizedBox(height: 4.0),
                                                    Row(
                                                      children: [
                                                        Text(getcommentdatalist[index]['comment'].toString(), style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      ],
                                                    ),
                                                    getcommentdatalist[index]['attachment'] == null ? SizedBox() : InkWell(
                                                        onTap :(){
                                                          if(usertype == "3"){
                                                            _save("https://dev.techstreet.in/rentit4me/public/assets/consumer/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                                          }
                                                          else{
                                                            //my code is here
                                                          }

                                                        },
                                                        child: Text(getcommentdatalist[index]['attachment'].toString(), style: TextStyle(color: Colors.deepOrangeAccent)))
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ) : Container(
                                width: double.infinity,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: getcommentdatalist.length,
                                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap:(){
                                        if(usertype == "3"){
                                          _save("https://dev.techstreet.in/rentit4me/public/assets/consumer/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                        }
                                        else{
                                          _save("https://dev.techstreet.in/rentit4me/public/assets/business/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: getcommentdatalist[index]['attachment'] == null ? Container(height: 80, width: 80, child: Image.asset('assets/images/no_image.jpg', fit: BoxFit.fill, color: Colors.white)) : CachedNetworkImage(
                                                height: 80,
                                                width: 80,
                                                imageUrl: _getAttachmentPath(usertype, getcommentdatalist[index]['attachment'].toString()),
                                                imageBuilder: (context, imageProvider) => Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn)
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Image.asset('assets/images/profile_placeholder.png', color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 5.0),
                                            Expanded(
                                                child: Column(
                                                  crossAxisAlignment : CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        name == null ? SizedBox() : Text(name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                                        Text(getcommentdatalist[index]['created_at'].toString().split('T')[0].toString(), style: TextStyle(color: Colors.black, fontSize: 14))
                                                      ],
                                                    ),
                                                    SizedBox(height: 4.0),
                                                    Row(
                                                      children: [
                                                        Text(getcommentdatalist[index]['comment'].toString(), style: TextStyle(color: Colors.black, fontSize: 16)),
                                                      ],
                                                    ),
                                                    getcommentdatalist[index]['attachment'] == null ? SizedBox() : InkWell(
                                                        onTap :(){
                                                          if(usertype == "3"){
                                                            _save("https://dev.techstreet.in/rentit4me/public/assets/consumer/attachment/"+getcommentdatalist[index]['attachment'].toString());
                                                          }
                                                          else{
                                                            //my code is here
                                                          }

                                                        },
                                                        child: Text(getcommentdatalist[index]['attachment'].toString(), style: TextStyle(color: Colors.deepOrangeAccent)))
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.deepOrangeAccent
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        hintText: "Your message",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value){
                                        comment = value;
                                      },
                                    ),
                                  )
                              ),
                              SizedBox(height: 5),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.deepOrangeAccent
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        attachmentdoc.toString() == "" || attachmentdoc.toString() == "null" ? SizedBox() : CircleAvatar(
                                          radius: 25,
                                          backgroundImage: FileImage(File(attachmentdoc)),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            _captureattachment();
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 120,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Colors.deepOrangeAccent,
                                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                                            ),
                                            child: Text("Choose file", style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: (){
                                    if(comment == null || comment == ""){
                                      showToast("Please enter your message as comment");
                                    }
                                    else if(comment != null && attachmentdoc == null){
                                      _postticketwithoutdoc(ticketid, comment);
                                    }
                                    else if(comment != null || attachmentdoc != null){
                                      _postticketcommentwithdoc(ticketid, comment, attachmentdoc);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Text("Submit", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _getViewTicket(String id) async {
    setState((){
      _loading = true;
    });
    final body = {"ticket_id": id};
    var response = await http.post(Uri.parse(BASE_URL + viewticket),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState((){
            tktid = data['ticket_id'].toString();
            priority = data['priority'].toString();
            title = data['title'].toString();
            message = data['message'].toString();
            status = data['status'].toString();
            created = data['created_at'].toString().split("T")[0].toString();
            //usertype = data['user_type'].toString();
      });

    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getcomments(String id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"ticket_id": id};
    var response = await http.post(Uri.parse(BASE_URL + fetchticket),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
    });
    setState((){
      _loading = false;
    });
    if(response.statusCode == 200) {
      List data = json.decode(response.body)['Response'];
      if(data.length != 0 || data.isNotEmpty){
        setState((){
          name = prefs.getString('name');
          usertype = data[0]['user_type'].toString();
          getcommentdatalist.addAll(data);
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Widget _getStatus(String status){
     if(status == "Open"){
        return Container(
           height: 30,
           width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.green
           ),
           alignment: Alignment.center,
           child: Text(status, style: TextStyle(color: Colors.white, fontSize: 16)),
        );
     }
     else{
       return Container(
         height: 30,
         width: 80,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(8.0),
           color: Colors.red
         ),
         alignment: Alignment.center,
         child: Text(status, style: TextStyle(color: Colors.white, fontSize: 16)),
       );
     }
  }

  Future _postticketcommentwithdoc(String ticketid, String message, String doc) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    print("0 "+prefs.getString('userid'));
    print("1 "+doc);
    print("2 "+message);
    print("3 "+ticketid);

    var requestMulti = http.MultipartRequest('POST', Uri.parse(BASE_URL+ticketpostcomment));
    requestMulti.fields["user_id"] = prefs.getString('userid');
    requestMulti.fields["ticket_id"] = ticketid;
    requestMulti.fields["comment"] = message;

    requestMulti.files.add(await http.MultipartFile.fromPath('attachment', doc));

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          setState((){
            _loading = false;
          });
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorCode'].toString() == "0") {
            showToast(jsonData['ErrorMessage'].toString());
            _getViewTicket(ticketid);
          } else {
            showToast(jsonData['ErrorMessage'].toString());
          }
        } catch (e) {
          setState((){
            _loading = false;
          });
        }
      });
    });
  }
  Future _postticketwithoutdoc(String ticketid, String message) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      _loading = true;
    });
    final body = {
      "user_id" : prefs.getString('userid'),
      "ticket_id" : ticketid,
      "comment" : message,
    };
    var response = await http.post(Uri.parse(BASE_URL + ticketpostcomment),
        body: jsonEncode(body),
        headers: {
          "Accept" : "application/json",
          'Content-Type' : 'application/json'
        }
    );
    if(response.statusCode == 200) {
       showToast(json.decode(response.body)['ErrorMessage'].toString());
       _getViewTicket(ticketid);
       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  MyticketScreen()));
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _captureattachment() async {
    final ImagePicker _picker = ImagePicker();
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 7, 0),
                    child: Text(
                      'Select',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );
                            if (result != null) {
                              setState(() {
                                attachmentdoc = result.path.toString();
                              });
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.camera, color: Colors.black),
                          label: const Text("Camera", style: TextStyle(color: Colors.black))),
                      const SizedBox(width: 30),
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );

                            if (result != null) {
                              setState(() {
                                  attachmentdoc = result.path.toString();
                              });
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.photo, color: Colors.black),
                          label: const Text("Gallery", style: TextStyle(color: Colors.black))),
                    ],
                  )
                ])));
  }

  _save(String url) async {
         if(await Permission.storage.request().isGranted) {
           setState((){
              _loading = true;
          });
          try{
            var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
            final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(response.data),
                quality: 60,
                name: "image");
            if(result['isSuccess']){
              showToast('Image downloaded successfully!');
              setState((){
                _loading = false;
              });
            }
            else{
              showToast('Downloading failed!');
              setState((){
                _loading = false;
              });
            }
          }
          catch(error){
            setState((){
              _loading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image not found!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
          }
    }
  }

  _getAttachmentPath(String usertype, String imagename){
     if(usertype == "1"){
       return "https://dev.techstreet.in/rentit4me/public/assets/admin/ticket-attachment/"+imagename;
     }
     else if(usertype == "3"){
       return "https://dev.techstreet.in/rentit4me/public/assets/consumer/attachment/"+imagename;
     }
     else{
       return "https://dev.techstreet.in/rentit4me/public/assets/business/attachment/"+imagename;
     }
  }

}
