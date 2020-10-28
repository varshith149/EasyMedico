from django.db import models

# Create your models here.
class User(models.Model):
    ID = models.AutoField(primary_key=True)
    ADDRESS = models.CharField(max_length=500, blank=True)
    EMAIL_ID = models.EmailField(max_length=256)
    PASSWORD = models.CharField(max_length=256, blank=True)
    DEVICE_ID = models.CharField(max_length=256)
    LATITUDE = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    LONGITUDE = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    CREATED_DATE = models.DateField(auto_now_add=True, auto_now=False, blank=True)
    MODIFIED_DATE = models.DateField(auto_now=True, blank=True)
    IsActive = models.BooleanField(default=True)
    IsLogout = models.BooleanField(default=False)




class Prescriptions(models.Model):
    USER_ID = models.ForeignKey(User, on_delete=models.CASCADE)
    Image_ID = models.AutoField(primary_key=True)
    Image_Name = models.CharField(max_length=255)	
    Image_URL = models.ImageField(upload_to='images/')	
    DEVICE_ID = models.CharField(max_length=255)
    IMAGE_UPLOAD_DATE = models.DateField()	
    IMAGE_UPLOAD_TIME = models.TimeField()	
    CREATED_DATE = models.DateField(auto_now_add=True, auto_now=False, blank=True)
    MODIFIED_DATE = models.DateField(auto_now=True, blank=True)

