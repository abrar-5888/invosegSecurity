import 'package:flutter/material.dart';
import 'package:invoseg_security/appSecurity/mainFile.dart';
import 'package:invoseg_security/comlpetedLogs.dart';
import 'package:invoseg_security/pendingLogs.dart';
import 'package:invoseg_security/rejectedLogs.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(15, 39, 127, 1),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const appSecurity(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Log Screen",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: Container(),
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Completed Tab Content
            Center(
              child: PendingLogs(),
            ),

            // Pending Tab Content
            Center(
              child: CompletedLogs(),
            ),
            Center(
              child: RejectedLogs(),
            ),
          ],
        ),
      ),
    );
  }
}
