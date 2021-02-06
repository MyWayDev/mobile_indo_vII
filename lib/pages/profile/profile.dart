import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/pages/profile/album.dart';
import 'package:mor_release/pages/profile/profileForm.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SettingsScreen(
        model: model,
      );
    });
  }
}

class SettingsScreen extends StatefulWidget {
  final MainModel model;

  /*final String id;
  final String name;
  final String areaId;
  final String idPhotoUrl;
  final String taxPhotoUrl;
*/
  SettingsScreen({
    @required this.model,
  });

  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _profileAlbumBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.white70,
        elevation: 26,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return ProfileAlbum(
            model: widget.model,
            idPhotoUrl: widget.model.userInfo.idPhotoUrl,
            taxPhotoUrl: widget.model.userInfo.taxPhotoUrl,
            bankPhotoUrl: widget.model.userInfo.bankPhotoUrl,
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          widget.model.user.name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 30,
        clipBehavior: Clip.none,
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
            top: 1,
            right: 8,
            child: Icon(
              Icons.add,
              size: 18,
            ),
          ),
          Positioned(
              bottom: 8,
              left: 2,
              right: 2,
              child: Icon(
                Icons.photo_album,
                size: 32,
              ))
        ]),
        backgroundColor: Colors.pink[500],
        onPressed: () => _profileAlbumBottomSheet(context),
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: true,
          child: Column(children: <Widget>[
            ProfileForm(
              widget.model,
            ),
          ]),
        ),
        inAsyncCall: widget.model.isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }
}
