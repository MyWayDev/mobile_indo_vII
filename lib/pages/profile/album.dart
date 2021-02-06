import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mor_release/pages/messages/chat.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';

class ProfileAlbum extends StatefulWidget {
  final MainModel model;

  final String idPhotoUrl;
  final String taxPhotoUrl;
  final String bankPhotoUrl;

  ProfileAlbum(
      {@required this.model,
      @required this.idPhotoUrl,
      @required this.taxPhotoUrl,
      @required this.bankPhotoUrl});
  @override
  _ProfileAlbumState createState() => _ProfileAlbumState();
}

class _ProfileAlbumState extends State<ProfileAlbum> {
  SharedPreferences prefs;
  final String noImage =
      'https://firebasestorage.googleapis.com/v0/b/mobile-coco.appspot.com/o/flamelink%2Fmedia%2Fsized%2F375_9999_100%2Fno%20image.png?alt=media&token=6a6764c8-9d01-4887-b22c-7e13b40ff5e8';
  String idPhotoUrl = '';
  String taxPhotoUrl = '';
  String bankPhotoUrl = '';

  bool isLoading = false;
  File idImageFile;
  File taxImageFile;
  File bankImageFile;

  @override
  void initState() {
    _readLocal();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    String idImageString() {
      String idImage;
      widget.idPhotoUrl == '' || widget.idPhotoUrl.isEmpty
          ? idImage = ''
          : idImage = widget.idPhotoUrl;
      return idImage;
    }

    String taxImageString() {
      String taxImage;
      widget.taxPhotoUrl == '' || widget.taxPhotoUrl.isEmpty
          ? taxImage = ''
          : taxImage = widget.taxPhotoUrl;
      return taxImage;
    }

    String bankImageString() {
      String bankImage;
      widget.bankPhotoUrl == '' || widget.bankPhotoUrl.isEmpty
          ? bankImage = ''
          : bankImage = widget.bankPhotoUrl;
      return bankImage;
    }

    idPhotoUrl = idImageString();
    taxPhotoUrl = taxImageString();
    bankPhotoUrl = bankImageString();
    // Force refresh input
    setState(() {});
  }

  Future getIdImage() async {
    final _picker = ImagePicker();
    final _img =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    if (_img != null) {
      setState(() {
        idImageFile = File(_img.path);
        isLoading = true;
      });
    }
    uploadFileId();
  }

  Future getBankImage() async {
    final _picker = ImagePicker();
    final _img =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    if (_img != null) {
      setState(() {
        bankImageFile = File(_img.path);
        isLoading = true;
      });
    }
    uploadFileBank();
  }

  Future getTaxImage() async {
    // ignore: deprecated_member_use
    final _picker = ImagePicker();
    final _img =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    if (_img != null) {
      setState(() {
        taxImageFile = File(_img.path);
        isLoading = true;
      });
    }
    uploadFileTax();
  }

  Future uploadFileBank() async {
    Random random = new Random();
    String fileName =
        widget.model.userInfo.key + '-bk-' + random.nextInt(10000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child("avatars/$fileName");
    StorageUploadTask uploadTask = reference.putFile(bankImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          bankPhotoUrl = downloadUrl;
          FirebaseDatabase.instance
              .reference()
              .child('indoDb/users/en-US/${widget.model.userInfo.key}')
              .update({
            //'name': name,
            //'areaId': areaId,
            // 'idPhotoUrl': idPhotoUrl,
            'bankPhotoUrl': bankPhotoUrl
          }).then((data) async {
            await prefs.setString('taxPhotoUrl', taxPhotoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadFileTax() async {
    Random random = new Random();
    String fileName =
        widget.model.userInfo.key + '-tx-' + random.nextInt(10000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child("avatars/$fileName");
    StorageUploadTask uploadTask = reference.putFile(taxImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          taxPhotoUrl = downloadUrl;
          FirebaseDatabase.instance
              .reference()
              .child('indoDb/users/en-US/${widget.model.userInfo.key}')
              .update({
            //'name': name,
            //'areaId': areaId,
            // 'idPhotoUrl': idPhotoUrl,
            'taxPhotoUrl': taxPhotoUrl
          }).then((data) async {
            await prefs.setString('taxPhotoUrl', taxPhotoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadFileId() async {
    Random random = new Random();
    String fileName =
        widget.model.userInfo.key + '-id-' + random.nextInt(10000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child("avatars/$fileName");
    StorageUploadTask uploadTask = reference.putFile(idImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          idPhotoUrl = downloadUrl;
          FirebaseDatabase.instance
              .reference()
              .child('indoDb/users/en-US/${widget.model.userInfo.key}')
              .update({
            //'name': name,
            // 'areaId': areaId,
            'idPhotoUrl': idPhotoUrl,
            //'taxPhotoUrl': taxPhotoUrl
          }).then((data) async {
            await prefs.setString('idPhotoUrl', idPhotoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Personal Id ',
                        style: TextStyle(
                            color: Colors.pink[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontStyle: FontStyle.italic),
                      ),
                      GestureDetector(
                          onTap: getIdImage,
                          onDoubleTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return ImageDetails(
                                image: idPhotoUrl,
                              );
                            }));
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: idPhotoUrl != ''
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: MediaQuery.of(context)
                                                  .devicePixelRatio <=
                                              1.5
                                          ? 180
                                          : 220,
                                      height: MediaQuery.of(context)
                                                  .devicePixelRatio <=
                                              1.5
                                          ? 100
                                          : 120,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    imageUrl: idPhotoUrl,
                                    width: MediaQuery.of(context)
                                                .devicePixelRatio <=
                                            1.5
                                        ? 180
                                        : 220,
                                    height: MediaQuery.of(context)
                                                .devicePixelRatio <=
                                            1.5
                                        ? 100
                                        : 120,
                                    fit: BoxFit.cover,
                                  )
                                : Opacity(
                                    opacity: .1,
                                    child: Icon(
                                      Icons.image_search,
                                      size: 95.0,
                                      color: Colors.pink[900],
                                    ),
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            clipBehavior: Clip.hardEdge,
                          ))

                      /*: Material(
                              child: Image.file(
                                idImageFile,
                                width:
                                    MediaQuery.of(context).devicePixelRatio <=
                                            1.5
                                        ? 230
                                        : 250,
                                height:
                                    MediaQuery.of(context).devicePixelRatio <=
                                            1.5
                                        ? 100
                                        : 120,
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.0)),
                              clipBehavior: Clip.hardEdge,
                            ),*/
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(5.0),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Tax Id',
                                style: TextStyle(
                                    color: Colors.pink[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic),
                              ),
                              GestureDetector(
                                  onTap: getTaxImage,
                                  onDoubleTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return ImageDetails(
                                        image: taxPhotoUrl,
                                      );
                                    }));
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    child: taxPhotoUrl != ''
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(themeColor),
                                              ),
                                              width: MediaQuery.of(context)
                                                          .devicePixelRatio <=
                                                      1.5
                                                  ? 180
                                                  : 220,
                                              height: MediaQuery.of(context)
                                                          .devicePixelRatio <=
                                                      1.5
                                                  ? 100
                                                  : 120,
                                              padding: EdgeInsets.all(10.0),
                                            ),
                                            imageUrl: taxPhotoUrl,
                                            width: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 180
                                                : 220,
                                            height: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 100
                                                : 120,
                                            fit: BoxFit.cover,
                                          )
                                        : Opacity(
                                            opacity: .1,
                                            child: Icon(
                                              Icons.image_search,
                                              size: 95.0,
                                              color: Colors.pink[900],
                                            )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ))

                              /*  : Material(
                                      child: Image.file(
                                        taxImageFile,
                                        width: MediaQuery.of(context)
                                                    .devicePixelRatio <=
                                                1.5
                                            ? 230
                                            : 250,
                                        height: MediaQuery.of(context)
                                                    .devicePixelRatio <=
                                                1.5
                                            ? 100
                                            : 120,
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),*/
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                      ),
                    ),
                    VerticalDivider(
                      endIndent: 5,
                      width: 3,
                      color: Colors.pink[900],
                      indent: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Bank Id',
                                style: TextStyle(
                                    color: Colors.pink[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic),
                              ),
                              GestureDetector(
                                onTap: getBankImage,
                                onDoubleTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return ImageDetails(
                                          image: bankPhotoUrl,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  child: bankPhotoUrl != ''
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      themeColor),
                                            ),
                                            width: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 180
                                                : 220,
                                            height: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 100
                                                : 120,
                                            padding: EdgeInsets.all(10.0),
                                          ),
                                          imageUrl: bankPhotoUrl,
                                          width: MediaQuery.of(context)
                                                      .devicePixelRatio <=
                                                  1.5
                                              ? 180
                                              : 220,
                                          height: MediaQuery.of(context)
                                                      .devicePixelRatio <=
                                                  1.5
                                              ? 100
                                              : 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Opacity(
                                          opacity: 0.1,
                                          child: Icon(
                                            Icons.image_search,
                                            size: 100.0,
                                            color: Colors.pink[900],
                                          )),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
        ),

        // Loading
      ],
    );
  }
}
