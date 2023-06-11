import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/config.dart';
import '../model/user.dart';
import '../model/items.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddItemScreen extends StatefulWidget {
  final User user;
  final Item item;
  final Position position;
  final List<Placemark> placemarks;
  const AddItemScreen(
      {super.key,
      required this.user,
      required this.item,
      required this.position,
      required this.placemarks});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _itempriceEditingController =
      TextEditingController();
  final TextEditingController _itemdelEditingController = TextEditingController();
  final TextEditingController _itemqtyEditingController = TextEditingController();
  final TextEditingController _itemstateEditingController =
      TextEditingController();
  final TextEditingController _itemlocalEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _lat, _lng;
  late Position _position;

  @override
  void initState() {
    super.initState();
    _checkPermissionGetLoc();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _itemstateEditingController.text =
        widget.placemarks[0].administrativeArea.toString();
    _itemlocalEditingController.text = widget.placemarks[0].locality.toString();
  }

  File? _image;
  var pathAsset = "assets/images/camera.png";
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Tool")),
      body: SingleChildScrollView(
          child: Column(
        children: [
          GestureDetector(
            onTap: _selectImageDialog,
            child: Card(
              elevation: 8,
              child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image!) as ImageProvider,
                          fit: BoxFit.cover))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Add New Tool",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _itemnameEditingController,
                        validator: (value) =>
                            value!.isEmpty || (value.length < 3)
                                ? "Tool name must be longer than 3 letters"
                                : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Tool Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.precision_manufacturing),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _itemdescEditingController,
                        validator: (value) =>
                            value!.isEmpty || (value.length < 10)
                                ? "Tool description must be longer than 10"
                                : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Tool Description',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.post_add),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itempriceEditingController,
                              validator: (value) => value!.isEmpty
                                  ? "Tool rent price must contain a value"
                                  : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Tool Rental Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itemqtyEditingController,
                              validator: (value) => value!.isEmpty
                                  ? "Quantity should be at least 1"
                                  : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Tool Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.ad_units),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itemstateEditingController,
                              validator: (value) =>
                                  value!.isEmpty || (value.length < 3)
                                      ? "Current State"
                                      : null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itemlocalEditingController,
                              validator: (value) =>
                                  value!.isEmpty || (value.length < 10)
                                      ? "Current Address"
                                      : null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Address',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itemdelEditingController,
                              validator: (value) =>
                                  value!.isEmpty ? "Must contain value" : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Delivery Fees (Optional)',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.delivery_dining),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                            flex: 5,
                            child: CheckboxListTile(
                                title: const Text(
                                    "I hereby declare that my tool stated is lawful item and in good condition"),
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                })),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        child: const Text("Add tool"),
                        onPressed: (() => {
                              _newToolDialog(),
                            }),
                      ),
                    )
                  ],
                )),
          ),
        ],
      )),
    );
    
  }

  void _newToolDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your tool",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the tool registration first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check the declaration checkbox",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add this tool to your list?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addItem();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
          child: AlertDialog(
          title: const Text(
            "Select picture from:",
            style: TextStyle(),
          ),
 content: Wrap(
    alignment: WrapAlignment.spaceAround,
    children: [
      GestureDetector(
        onTap: _onCamera,
        child: Column(
          children: const [
            Icon(Icons.camera_alt, size: 64),
            Text(
              "Camera",
              style: TextStyle(),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: _onGallery,
        child: Column(
          children: [
            Icon(Icons.image, size: 64),
            const Text(
              "Gallery",
              style: TextStyle(),
            ),
          ],
        ),
      ),
    ],
  ),
));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
      //setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.indigo,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  void _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(_position.latitude);
    print(_position.longitude);
    _getAddress(_position);
  }

  _getAddress(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.position.latitude, widget.position.longitude);
      setState(() {
        _itemstateEditingController.text =
            placemarks[0].administrativeArea.toString();
        _itemlocalEditingController.text = placemarks[0].locality.toString();
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error in fix your location. Try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Navigator.of(context).pop();
    }
  }


  void addItem() {
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemprice = _itempriceEditingController.text;
    String delivery = _itemdelEditingController.text;
    String qty = _itemqtyEditingController.text;
    String state = _itemstateEditingController.text;
    String local = _itemlocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(
        Uri.parse("${Config.SERVER}/php/insert_item.php"),
        body: {
          'userid': widget.user.id,
          'itemname': itemname,
          'itemdesc': itemdesc,
          'itemprice': itemprice,
          'delivery': delivery,
          'qty': qty,
          'state': state,
          'local': local,
          'lat': _lat,
          'lng': _lng,
          'image': base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        print("item added successfully");
        Fluttertoast.showToast(
            msg: "Item added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        print("Unable to register item");
        Fluttertoast.showToast(
            msg: "Unable to register item",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
