from django.shortcuts import render, redirect

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import *
from rest_framework.permissions import IsAuthenticated
from django.conf import settings
from django.core.mail import EmailMessage,send_mail
from django.template import Context
from django.template.loader import render_to_string, get_template



class Registration(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        model = User.objects.all()
        serializer = UserSerializer(model, many=True)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)
        
        if serializer.is_valid():
            email_id = request.data.get('EMAIL_ID')
            p = User.objects.filter(EMAIL_ID=email_id)
            if p.exists():
                data = { 'RESPONSE_CODE': 201,
                         'RESPONSE_MESSAGE':"Email id already exists."}
                return  Response(data, status=status.HTTP_200_OK)
                 
            else:
            
                serializer.save()
                Mydata = { 'ID' : serializer.data.get('ID'),
                           'EMAIL_ID': serializer.data.get('EMAIL_ID'),
                           'RESPONSE_CODE' : 200,
                           'RESPONSE_MESSAGE': "Record created successfully."}
            
                return  Response(Mydata, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
         
        



class Login(APIView):

    permission_classes = (IsAuthenticated,)
     
    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            device_id = request.data.get('DEVICE_ID')
            email_id = request.data.get('EMAIL_ID')
            password = request.data.get('PASSWORD')
            
            if User.objects.filter(EMAIL_ID=email_id,PASSWORD=password).exists():
                p = User.objects.get(EMAIL_ID=email_id,PASSWORD=password)

                Islogout = p.IsLogout
                if (Islogout==False):
                    
                    if (p.DEVICE_ID==device_id):
                        
                        login_success_data = {'ID': p.ID,
                                              'EMAIL_ID': p.EMAIL_ID,
                                              'RESPONSE_CODE':200,
                                              'RESPONSE_MESSAGE':"Login successful.",
                                             }
                        return Response(login_success_data, status=status.HTTP_200_OK)
                    else:
                        login_error = {'RESPONSE_CODE':202,
                                       'RESPONSE_MESSAGE':"User is already logged-in from other device."}
                        return Response(login_error, status=status.HTTP_200_OK)
                else:
                    p.IsLogout = 0
                    p.DEVICE_ID = device_id
                    serializer = UserSerializer(p, data=request.data)
                    if serializer.is_valid():


                    #element = User.objects.filter(EMAIL_ID=email_id).update(DEVICE_ID=device_id, IsLogout=False)
                        serializer.save()
                        login_success_data = {'ID': serializer.data.get('ID'),
                                              'EMAIL_ID': serializer.data.get('EMAIL_ID'),
                                              'RESPONSE_CODE':200,
                                              'RESPONSE_MESSAGE':"Login successful."
                                             }   
                             
                                             
                    
                        return Response(login_success_data, status=status.HTTP_200_OK)
                    
                    return Response(serializer.errors ,status=status.HTTP_400_BAD_REQUEST)

            else:
                
                login_error = {'RESPONSE_CODE': 201,
                               'RESPONSE_MESSAGE':"Entered Email or Password is incorrect. Please check."}
                return Response(login_error, status=status.HTTP_200_OK)            

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)      
                 
            

class Logout(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        
        id = request.data.get('USER_ID')
        
        p = User.objects.get(ID=id)
            
        p.IsLogout = 1
        serializer = UserSerializer(p, data=request.data)
        if serializer.is_valid():
            serializer.save()
            logged_out = {'RESPONSE_CODE':200,
                          'RESPONSE_MESSAGE':"Logged-out successfully."}
            return Response(logged_out, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)





            


class forgot_password(APIView):
    permission_classes = (IsAuthenticated,)
    


    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)
        
        
        if serializer.is_valid:
            email_id = request.data.get('EMAIL_ID')

            if User.objects.filter(EMAIL_ID=email_id).exists():
                p = User.objects.get(EMAIL_ID=email_id)
                #def sendmail(request):
                ctx = {
                    'password': p.PASSWORD
                }
                ms = get_template('mail.html').render(ctx)
                
                msg = EmailMessage(

                    subject="EMPRESAPP:Auto Generated Mail",
                    body= ms,
                    from_email='easymedico.app@easymedico.com',
                    to=[p.EMAIL_ID],
                )
                msg.content_subtype = "html"             # Main content is now text/html
                msg.send()
                    
                    
                
                mydata ={'ID': p.ID,
                         'EMAIL': p.EMAIL_ID, 
                         'RESPONSE_CODE': 200, 
                         'RESPONSE_MESSAGE': "Your password has been reset. Please check your email."
                        }
                return Response(mydata, status=status.HTTP_200_OK)
            else:
                mydata = {"RESPONSE_CODE": 201, 
                        "RESPONSE_MESSAGE": "Invalid User."
                       }
                
                return Response(mydata, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class upload_prescription(APIView):
    permission_classes = permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        
        serializer = ImageSerializer(data=request.data)
        
        
        if serializer.is_valid():
            mydata ={"RESPONSE_CODE": 200, 
                     "RESPONSE_MESSAGE": "Image(s) upload successfully."
                    }
            serializer.save()
            return Response(mydata, status=status.HTTP_200_OK)
        else:
            mydata ={"RESPONSE_CODE": 201, 
                    "RESPONSE_MESSAGE": "Error while uploading the image. Please try later!."
                    } 
            return Response(mydata, status=status.HTTP_200_OK )

    def get(self, request):
        model = Prescriptions.objects.all()
        serializer = ImageSerializer(model, many=True)
        return Response(serializer.data)





    








                

                 




    

     
        