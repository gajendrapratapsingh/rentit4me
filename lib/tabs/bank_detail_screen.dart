import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me/themes/constant.dart';

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({Key key}) : super(key: key);

  @override
  _BankDetailScreenState createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen>{

  bool _loading = false;

  final banknameController = TextEditingController();
  final branchnameController = TextEditingController();
  final accountnumberController = TextEditingController();
  final ifsccodeController = TextEditingController();
  final adharnumberController = TextEditingController();
  final kycController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: ModalProgressHUD(
         inAsyncCall: _loading,
         child: SingleChildScrollView(
           child: Column(
             children: [
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: banknameController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   maxLength: 40,
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Enter your bank name",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: accountnumberController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   maxLength: 40,
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Account Number",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: accountnumberController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   maxLength: 40,
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Account Type",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: branchnameController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   maxLength: 40,
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Branch Name",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "IFSC Code",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "KYC",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Adhar Number",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: InputDecoration(
                       counterText: "",
                       hintText: "Upload Adhar Card",
                       suffixIcon: ElevatedButton(
                           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                               textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16))),
                           onPressed: () {
                             FocusScope.of(context).unfocus();
                             //showPhotoCaptureOptions("SAC");
                           },
                           child: Text("Upload")),
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Select Country",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Select State",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Select City",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(7.0),
                 child: TextFormField(
                   validator: (value) {
                     if (value.isEmpty)
                       return "Required Field";
                     else
                       return null;
                   },
                   controller: ifsccodeController,
                   textCapitalization: TextCapitalization.words,
                   keyboardType: TextInputType.text,
                   inputFormatters: [
                     //FilteringTextInputFormatter.digitsOnly
                   ],
                   onChanged: (val) {
                     if (val.length == 12) {
                       FocusScope.of(context).unfocus();
                     }
                   },
                   decoration: const InputDecoration(
                       counterText: "",
                       hintText: "Address",
                       border: OutlineInputBorder(
                           borderSide: BorderSide(color: Color(0xffD0D5DD))),
                       fillColor: Colors.white,
                       contentPadding: EdgeInsets.all(10),
                       isDense: true,
                       filled: true),
                 ),
               ),
             ],
           ),
         ),
       ),
    );
  }
}
