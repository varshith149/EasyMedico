from rest_framework import serializers
from PrescriptionDashboard.models import User,Prescriptions

from django.core.exceptions import ValidationError
from django.core.files.base import ContentFile
import base64
import six
import imghdr
#from datetime import datetime
import uuid


class Base64ImageField(serializers.ImageField):

    def to_internal_value(self, data):
        

        # Check if this is a base64 string
        if isinstance(data, six.string_types):
            # Check if the base64 string is in the "data:" format
            if 'data:' in data and ';base64,' in data:
            	# Break out the header from the base64 content
            	header, data = data.split(';base64,')

            # Try to decode the file. Return validation error if it fails.
            try:
            	decoded_file = base64.b64decode(data)
            except TypeError:
            	self.fail('invalid_image')

            # Generate file name:
            #now = datetime.now()
            #datetime_str = now.strftime("%Y-%m-%d/ %H-%M%S")
            file_name = str(uuid.uuid4())[:12] # 12 characters are more than enough.
            
            # Get the file name extension:
            file_extension = self.get_file_extension(file_name, decoded_file)

            complete_file_name = "%s.%s" % (file_name, file_extension, )

            data = ContentFile(decoded_file, name=complete_file_name)

        return super(Base64ImageField, self).to_internal_value(data)

    def get_file_extension(self, file_name, decoded_file):

    	extension = imghdr.what(file_name, decoded_file)
    	extension = "jpg" if extension == "jpeg" else extension

    	return extension


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'



class ImageSerializer(serializers.ModelSerializer):
    Image_URL = Base64ImageField(
        max_length=None, use_url=True
    )
    class Meta:
        model = Prescriptions
        fields = ['Image_URL','USER_ID','Image_Name','DEVICE_ID','IMAGE_UPLOAD_DATE','IMAGE_UPLOAD_TIME']




def update(self, instance, validated_data):
    instance.id = validated_data.get('id', instance.id)
    instance.DEVICE_ID = validated_data.get('DEVICE_ID', instance.DEVICE_ID)
    instance.IsLogout = validated_data.get('IsLogout', instance.IsLogout)
    instance.EMAIL_ID = validated_data.get('EMAIL_ID', instance.EMAIL_ID)
    instance.save()
    return instance