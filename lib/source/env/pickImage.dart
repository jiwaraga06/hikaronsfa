import 'package:image_picker/image_picker.dart';

Future selectPhoto({ImageSource? source}) async {
  XFile? pickedFile = await ImagePicker().pickImage(source: source!, imageQuality: 10);
  //File image = await ImagePicker.pickImage(source: ImageSource.gallery);
  return pickedFile;
}
