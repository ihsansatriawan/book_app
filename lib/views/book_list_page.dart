import 'dart:convert';

import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListResponse? bookList;
  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Catalogue"),
      ),
      body: Container(
        child: bookList == null
            ? Center(child: const CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookList!.books!.length,
                itemBuilder: ((context, index) {
                  final currentBook = bookList!.books![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailBookPage(
                            isbn: currentBook.isbn13!,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          currentBook.image!,
                          height: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentBook.title!),
                                Text(currentBook.subtitle!),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(currentBook.price!),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
