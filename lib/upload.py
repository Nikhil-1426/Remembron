import firebase_admin
from firebase_admin import credentials, storage

cred = credentials.Certificate(r"C:/Users/Nikhil/Downloads/remembron-firebase-adminsdk-pd0su-809d94bc31.json")  
firebase_admin.initialize_app(cred, {
    'storageBucket': 'remembron.appspot.com'  
})

bucket = storage.bucket()

def upload_image(local_image_path, destination_folder, new_image_name):

    try:
        blob = bucket.blob(destination_folder + "/" + new_image_name)
        blob.upload_from_filename(local_image_path)
        print("Image uploaded successfully.")
    except Exception as e:
        print("Error uploading image:", e)

local_image_path = r"C:/Users/Nikhil/Nikhil Data/Coding/Projects/image_server/images/image.jpg"  
destination_folder = "Uploaded images"  
new_image_name = "my_uploaded_image.jpg"  

upload_image(local_image_path, destination_folder, new_image_name)