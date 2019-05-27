import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wananzhuo_flutter/api/ApiConfig.dart';
import 'package:wananzhuo_flutter/api/HttpUtils.dart';
import 'package:wananzhuo_flutter/pages/detail/ArticleDetailPage.dart';
import 'package:wananzhuo_flutter/widget/BannerWidget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int listPage = 0;
  List listData = new List();
  List bannerData;
  ScrollController scrollController = new ScrollController();
  bool isLoadingMore = false;
  bool loadMoreEnable = true;

  _HomePageState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          loadMoreEnable &&
          !isLoadingMore) {
        getHomeList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null || listData.length == 0) {
      return Center(child: CircularProgressIndicator());
    }

    var listView = new ListView.builder(
      itemBuilder: (context, index) {
        return buildItem(index);
      },
      itemCount: listData.length + 2,
      controller: scrollController,
    );
    return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
  }

  Future<Null> pullToRefresh() async {
    listPage = 0;
    getHomeBanner();
    getHomeList();
    return null;
  }

  Widget buildItem(int index) {
    if (index == 0) {
      return buildBannerItem();
    }
    var realIndex = index - 1;
    if (realIndex == listData.length) {
      if (loadMoreEnable) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Center(
              child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )),
        );
      } else {
        return Center(
          child: Text("没有更多了"),
        );
      }
    }
    var itemData = listData[realIndex];
    return InkWell(
      child: Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
                  child: Text(
                    itemData["title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
                  child: Text(
                      "@${itemData["author"]} ${itemData["superChapterName"]}"),
                ),
                Text(
                  itemData["niceDate"],
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ArticleDetailPage(
              title: listData[realIndex]["title"], url: listData[realIndex]["link"]);
        }));
      },
    );
  }

  Widget buildBannerItem() {
    var bannerList = new List<BannerItem>();
    bannerData.forEach((item) {
      var bannerItem =
          BannerItem.defaultBannerItem(item["imagePath"], item["title"]);
      bannerList.add(bannerItem);
    });
    var bannerView = BannerView(
      160.0,
      bannerList.toList(),
      onItemClickListener: (position, bannerItem) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ArticleDetailPage(
              title: bannerData[position]["title"],
              url: bannerData[position]["url"]);
        }));
      },
    );
    return bannerView;
  }

  @override
  void initState() {
    super.initState();
    getHomeList();
    getHomeBanner();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void getHomeList() {
    if (!isLoadingMore) {
      if (listPage > 0) {
        isLoadingMore = true;
      }
      HttpUtils.get(ApiConfig.HOME_LIST + "$listPage/json", (data) {
        if (data != null) {
          Map<String, dynamic> map = data;
          var curListData = map["datas"];
          var totalPageCount = map["pageCount"];
          setState(() {
            if (listPage == 0) {
              listData.clear();
            }
            var newListData = new List();
            newListData.addAll(listData);
            newListData.addAll(curListData);
            if (totalPageCount == listPage) {
              loadMoreEnable = false;
            } else {
              listPage++;
            }
            listData = newListData;
            isLoadingMore = false;
          });
        }
      });
    }
  }

  void getHomeBanner() {
    HttpUtils.get(ApiConfig.HOME_BANNER, (data) {
      if (data != null) {
        setState(() {
          bannerData = data as List;
        });
      }
    });
  }
}
