import 'package:flutter/material.dart';
import 'package:mor_release/pages/items/icon_bar.dart';
import 'package:mor_release/models/item.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

import 'itemDetails/details.dart';

class ItemCard extends StatelessWidget {
  final List<Item> itemData;
  final int index;

  ItemCard(this.itemData, this.index);

  @override
  Widget build(BuildContext context) {
    return !itemData[index].disabled
        ? Card(
            color: Colors.white,
            // color: Color(0xFFFFFFF1),
            elevation: 20.0,
            child: Column(children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      // color: Color.fromARGB(255, 66, 165, 245),
                      //constraints: BoxConstraints.tight(Size(90, 100)),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              itemData[index].promoItemsDetails.length > 0
                                  ? Container(
                                      width: 150,
                                      height: 55,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: itemData[index]
                                              .promoItemsDetails
                                              .length,
                                          itemBuilder: (context, i) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  itemData[index]
                                                      .promoItemsDetails[i]
                                                      .itemId,
                                                  style: TextStyle(
                                                      fontSize: 10.5,
                                                      color: Colors.orange[800],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                ScopedModelDescendant<
                                                        MainModel>(
                                                    builder:
                                                        (BuildContext context,
                                                            Widget child,
                                                            MainModel model) {
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Details(
                                                                  itemData[index]
                                                                          .promoItemsDetails[
                                                                      i],
                                                                  model.getCaouselItems(
                                                                      itemData[index]
                                                                              .promoItemsDetails[
                                                                          i])),
                                                            ));
                                                      },
                                                      child: CircleAvatar(
                                                        child: Text(
                                                          'GRATIS',
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[800]),
                                                        ),
                                                        radius: 19,
                                                        backgroundColor:
                                                            Colors.grey[300],
                                                        backgroundImage:
                                                            NetworkImage(
                                                          itemData[index]
                                                              .promoItemsDetails[
                                                                  i]
                                                              .imageUrl,
                                                        ),
                                                      ));
                                                })
                                              ],
                                            );
                                          }),
                                    )
                                  : Container(),
                              Image.network(
                                itemData[index].imageUrl ??
                                    '', //'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F${itemData[index].image[0].toString()}_${itemData[index].itemId}.png?alt=media&token=274fc65f-8295-43d5-909c-e2b174686439',
                                scale: 2.5,
                              ),
                            ],
                          ),

                          // : Container(),
                          itemData[index].promoImageUrl == '' ||
                                  itemData[index].promoImageUrl == null
                              ? Container()
                              : Positioned(
                                  left: 3.0,
                                  bottom: 20,
                                  child: Opacity(
                                      opacity: 0.70,
                                      child: Image.network(
                                        itemData[index].promoImageUrl ??
                                            '', //  'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2F1540155801359_tag-50.png?alt=media',
                                        scale: 1.1,
                                      )

                                      //
                                      )),
                        ],
                      ),
                    ),
                    Container(
                      child: Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                            ),
                            Text(
                              itemData[index].itemId,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color(0xFFFF8C00), //Colors.amber[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                            ),

                            Text(
                              itemData[index].name,
                              // textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 14.5, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                            ),
                            itemData[index].size != null ||
                                    itemData[index].unit != null
                                ? Text(
                                    itemData[index].size.toString() +
                                        '  ' +
                                        itemData[index].unit,
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(''),

////////////////////////////////////////////////////////////////////////////////
                            ScopedModelDescendant<MainModel>(builder:
                                (BuildContext context, Widget child,
                                    MainModel model) {
                              return Flex(
                                mainAxisSize: MainAxisSize.min,
                                direction: Axis.vertical,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconBar(itemData, index)
                                    ],
                                  ),
                                ],
                              );
                            }),

                            Flex(
                              direction: Axis.vertical,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'Rp ${itemData[index].priceFormat}',
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Bp ${itemData[index].bp.toString()}',
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
              ),
            ]),
          )
        : Container();
  }
}
