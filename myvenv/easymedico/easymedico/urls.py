"""easymedico URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf.urls import url
from PrescriptionDashboard.views import Registration, Login, Logout, forgot_password, upload_prescription
from rest_framework.authtoken.views import obtain_auth_token
from django.conf import settings
from django.conf.urls.static import static



urlpatterns = [
    path('admin/', admin.site.urls),
    url(r'^WebServices/Signup/$',Registration.as_view(), name='Signup'),
    url(r'^api-token-auth/', obtain_auth_token, name='api-token-auth'),
    url(r'^WebServices/Login/$',Login.as_view(), name='Login'),
    url(r'^WebServices/Logout/$',Logout.as_view(), name='Logout'),
    url(r'^WebServices/Forgot_password/$',forgot_password.as_view(), name='Forgot_password'),
    url(r'^WebServices/Upload_prescription/$',upload_prescription.as_view(), name='Upload_prescription')
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)

