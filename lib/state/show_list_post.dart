import 'package:aeygiffarine/models/post_model.dart';
import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/state/add_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShowListPost extends StatefulWidget {
  @override
  _ShowListPostState createState() => _ShowListPostState();
}

class _ShowListPostState extends State<ShowListPost> {
  List<PostModel> postModels = List();
  List<String> namePosts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readPost();
  }

  Future<Null> readPost() async {
    print('ReadPost Work');

    if (postModels.length != 0) {
      postModels.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('post')
          .snapshots()
          .listen((event) async {
        for (var item in event.docs) {
          PostModel model = PostModel.fromMap(item.data());
          setState(() {
            postModels.add(model);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (postModels.length == 0)
          ? buildNoListPost()
          : ListView.builder(
              itemCount: postModels.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('Tou Click index ==> $index');
                  showDetail(postModels[index]);
                },
                child: Card(
                  color: index % 2 == 0 ? Colors.lime.shade200 : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 13,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTitle(index),
                                  buildNamePost(index),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 13,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: Image.network(
                                postModels[index].urlImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 26,
                              child: Text(
                                shotDetail(postModels[index].detail),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Text buildNamePost(int index) => Text(postModels[index].namePost);

  Text buildTitle(int index) => Text(
        postModels[index].title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  Center buildNoListPost() {
    return Center(
      child: Text('No List Post'),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPost(),
          )).then((value) => readPost()),
      child: Text('Post'),
    );
  }

  String shotDetail(String detail) {
    String result = detail;
    if (result.length > 200) {
      result = result.substring(0, 200);
      result = '$result ...';
    }
    return result;
  }

  Future<Null> showDetail(PostModel postModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.reorder,
            size: 45,
          ),
          title: Text(
            postModel.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.network(postModel.urlImage),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(postModel.detail),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok')),
            ],
          )
        ],
      ),
    );
  }
}
