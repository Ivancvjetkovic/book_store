import 'package:book_store/post_model.dart';
import 'package:flutter/material.dart';
import 'package:book_store/http_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'http_service.dart';

final HttpService httpService = HttpService();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

var dropDownValue = '10';
var items = ['10', '20', '30'];
RefreshController _refreshController = RefreshController(initialRefresh: false);

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('BOOKSHOP'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff7585db),
        actions: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const SizedBox.shrink(),
                value: dropDownValue,
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValue = newValue!;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: httpService.getBookPosts(quantity: int.parse(dropDownValue)),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<BookPosts>> snapshot,
        ) {
          if (snapshot.hasData) {
            List<BookPosts>? bookPosts = snapshot.data;

            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                setState(() {
                  httpService.getBookPosts(quantity: int.parse(dropDownValue));
                });
                _refreshController.refreshCompleted();
              },
              child: _refreshController.isRefresh
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: bookPosts?.length,
                      itemBuilder: (context, index) =>
                          bookTemplate(bookPosts![index]),
                    ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Widget bookTemplate(BookPosts model) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    color: const Color.fromARGB(255, 214, 214, 214),
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 60,
                  color: const Color(0xff7585db),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    model.genre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0, bottom: 20.0),
                child: Text(
                  model.author,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              Container(
                width: 200,
                height: 80,
                child: Text(
                  model.description,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                child: Text(
                  model.isbn,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                ),
              ),
              Row(
                children: [
                  Text(
                    model.publisher,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    model.published,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}
