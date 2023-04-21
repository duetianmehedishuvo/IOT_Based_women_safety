import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:women_safety/helper/helpline_number_data.dart';
import 'package:women_safety/shared/appbar.dart';

class HelplineNumberScreen extends StatefulWidget {
  const HelplineNumberScreen({Key? key}) : super(key: key);

  @override
  _HelplineNumberScreenState createState() => _HelplineNumberScreenState();
}

class _HelplineNumberScreenState extends State<HelplineNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeHervenAppBar("Helpline", isHome: false),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: HelplineNumberController.allHelplinesData.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await FlutterPhoneDirectCaller.callNumber(HelplineNumberController.allHelplinesData[index].number);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(HelplineNumberController.allHelplinesData[index].title, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 5),
                    Text(HelplineNumberController.allHelplinesData[index].number,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
