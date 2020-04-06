import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class GenerateScreen extends StatefulWidget {
  final String docID;

  GenerateScreen({this.docID});

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  GlobalKey globalKey = new GlobalKey();
  String _dataString;
  bool _status;
  var filePath;

  requestPermissions() {
    if (Platform.isAndroid) {
      Permission.storage.isGranted.then((status) {
        setState(() {
          _status = status;
        });
      });
      Permission.storage.isUndetermined.then((status) {
        Permission.storage.request();
      });
    } else if (Platform.isIOS) {
      Permission.photos.isGranted.then((status) {
        setState(() {
          _status = status;
        });
      });
      Permission.photos.isUndetermined.then((status) {
        Permission.storage.request();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dataString = widget.docID;
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _captureAndSave,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          ),
        ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
      print(filePath);

      if (_status) {
        await ShareExtend.share(filePath, "image");
      } else {
        requestPermissions();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _captureAndSave() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      if (_status) {
        final result = await ImageGallerySaver.saveImage(pngBytes);
        print(result);
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            tittle: 'Success',
            desc: 'QR code is saved to your gallery',
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
              Navigator.of(context, rootNavigator: false).pop();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/homepage', (r) => false);
            }).show();
      } else {
        requestPermissions();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.all(15),
      color: const Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  backgroundColor: Colors.white,
                  size: 0.5 * bodyHeight,
                ),
              ),
            ),
          ),
          RaisedButton(
            child: Text('Home'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context, rootNavigator: false).pop();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/homepage', (r) => false);
            },
          )
        ],
      ),
    );
  }
}
