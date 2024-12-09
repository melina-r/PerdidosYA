import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



 Cloudinary getCloudinary() {
  return Cloudinary.signedConfig(
    apiKey: '357441315894697',
    apiSecret: 'p8ULbYmFC7zBoPcbYOoatmyoH0g',
    cloudName: 'dvxipdnn7',
  );
}

Future<String?> uploadImage(String imagePath) async {
  final cloudinary = getCloudinary();

    final response = await cloudinary.upload(
    file: imagePath,
    resourceType: CloudinaryResourceType.image,
  );
  // response.url;
  print(response.url);
  if (response.isSuccessful) {
    print('Imagen subida 1: ${response.secureUrl}'); 
    return response.secureUrl;
  } else {
    print('Error al subir la imagen: ${response.error}');
  }
}

Future<String?> pickAndUploadImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return await uploadImage(image.path);
  }else{
    return null;
  }
}


