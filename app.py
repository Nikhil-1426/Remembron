# from flask import Flask, request

# app = Flask(__name__)

# @app.route('/upload-image', methods=['POST'])
# def upload_image():
#     if 'image' not in request.files:
#         return 'No image uploaded', 400
    
#     image_file = request.files['image']
#     # Save the uploaded image file to a folder
#     image_file.save('uploaded_image.jpg')

#     return 'Image uploaded successfully', 200

# if __name__ == '__main__':
#     app.run(debug=True)



