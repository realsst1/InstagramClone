import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:insta_clone/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService{
  static Future<String> uploadUserProfileImage(String url,File imageFile)async{
    String photoID=Uuid().v4();
    File image=await compressedImage(photoID, imageFile);
    StorageUploadTask uploadTask=storageRef.child('images/users/userProfile_$photoID.jpg').putFile(image);
    StorageTaskSnapshot storageTaskSnapshot=await uploadTask.onComplete;
    String downloadUrl=await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File>  compressedImage(String photoId,File image)async{
    final tempDir=await getTemporaryDirectory();
    final path=tempDir.path;
    File compressedImageFile=await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        '$path/img_$photoId.jpg',
      quality: 70
    );
    return compressedImageFile;
  }
}