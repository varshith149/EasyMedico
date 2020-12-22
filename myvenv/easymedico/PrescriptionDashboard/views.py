from django.shortcuts import render, redirect
import requests

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
from PrescriptionDashboard.models import DrugDetails
from django.contrib import messages
from django.contrib.auth.models import auth
from django.http import HttpResponseRedirect,HttpResponse
from PrescriptionDashboard.constants import *
from requests.exceptions import *



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



def view(request):
    if request.session.has_key('username'):
        #if request.method=='POST':
            #pid = request.POST['text']
            #a = DrugDetails.objects.all().filter(PRESCRIPTION_ID=pid)
            #b = a.DRUG_NAME
            #print(b)
        imagedata = Prescriptions.objects.all().select_related('USER_ID')
        drugdata = DrugDetails.objects.all().select_related('PRESCRIPTION_ID').order_by("DRUG_NAME")
        print(drugdata)

        context = {'imagedata':imagedata, 'drugdata':drugdata}
        return render(request,"view.html",context)

    else :
        return redirect('/login')

def login(request):
    if request.method =='POST':
        username = request.POST['username']
        password = request.POST['password']

        #user = auth.authenticate(username=username,password=password)
        if username=='admin' and password=='admin':
            request.session['username'] = username
            #auth.login(request,user)

            return redirect('/view')
        else:
            messages.info(request,'Invalid Credentials')
            return redirect('/login')

    else: 
        return render(request,'login.html')

def Image_Popup(request, value):
    if request.session.has_key('username'):
        if request.method =='POST':
            if 'record' in request.POST:
                try: 
                    data = request.POST.get('record')
                    import speech_recognition as sr
                    output=""
                    CNUA = ""


                    # get audio from the microphone
                    r = sr.Recognizer()
                    m = sr.Microphone(device_index=2)
                    def loop():
                        with m as source:
                            audio = r.adjust_for_ambient_noise(source)
                            audio = r.listen(source)
                            try:
                                output = r.recognize_google(audio,language="en-IN")
                            except sr.UnknownValueError:
                                CNUA = "Could not understand audio"
                            except sr.RequestError as e:
                                CNUA = "Could not request results; {0}".format(e)

                    loop()
                   # with m as source:
                        #print("Speak:")
                        #audio = r.adjust_for_ambient_noise(source)
                        #audio = r.listen(source)

                    #try:    
                        #output = r.recognize_google(audio,language="en-IN")
                    #except sr.UnknownValueError:
                        #CNUA = "Could not understand audio"
                    #except sr.RequestError as e:
                        #CNUA = "Could not request results; {0}".format(e)
                    data =output
                    holder = CNUA
                    pid = Prescriptions.objects.filter(Image_ID=value)
                    context = {'pid':pid, 'data':data, 'holder':holder}


                    return render(request,'Image_Popup.html',context) 
                except requests.exceptions.RequestException as e:  # This is the correct syntax
                    raise SystemExit(e)
                except requests.exceptions.HTTPError as err:
                    raise SystemExit(err)

        
            elif 'testing' in request.POST :
                MedicineName = request.POST['MedicineName']
                MedicineCount = request.POST['Medicine_Count']
                val = Prescriptions.objects.get(Image_ID=value)

                if DrugDetails.objects.filter(PRESCRIPTION_ID=val, DRUG_NAME__iexact= MedicineName).exists():
                    messages.info(request,'Medicine already exists!!')
                    return HttpResponseRedirect(request.path_info) 

                

                
                else:   
                    p = DrugDetails(PRESCRIPTION_ID=val,DRUG_NAME=MedicineName,DRUG_REQ_QTY=MedicineCount)
                    p.save()

                    messages.info(request,'Saved Successfully!!')
                    
                    return HttpResponseRedirect(request.path_info)

        
            
            elif 'dropdown' in request.POST :
                try:

                    data = request.POST['MedicineName']
                    url = URL
                    header = HEADER
                    data1 = {"SEARCH_KEY":data,"USER_ID":USER_ID,"IS_OTHER":True}
                    response = requests.post(url, headers=header , json=data1, timeout=30)

                    hello = list()
                    count =  len(response.json()['PRODUCT']['PRODUCTS'])
                    for i in range(count) :
                        hel = response.json()['PRODUCT']['PRODUCTS'][i]['NAME']
                        hello.append(hel) 
                    
                    
                    
                    pid = Prescriptions.objects.filter(Image_ID=value)
                    context = {'pid':pid, 'data':data, 'response' : hello}  
                            

                    return render(request,'Image_Popup.html',context)
                except requests.Timeout:
                    html = "<html><body>Timeout error</body></html>"
                    return HttpResponse(html)
                except requests.exceptions.RequestException as e:  # This is the correct syntax
                    raise SystemExit(e)
                except requests.exceptions.HTTPError as err:
                    raise SystemExit(err)


            elif 'update' in request.POST:
                uname = request.POST['dname']
                uqty = request.POST['dqty']
                pname = request.POST['pname']
                pqty =  request.POST['pqty']
                val = Prescriptions.objects.get(Image_ID=value)
 
                d = DrugDetails.objects.get(PRESCRIPTION_ID=val, DRUG_NAME=pname, DRUG_REQ_QTY=pqty)
                d.DRUG_NAME = uname
                d.DRUG_REQ_QTY = uqty
                d.save()
                messages.info(request,'Updated Successfully!!')
                return HttpResponseRedirect(request.path_info)



                
                    
                

        else:
            pid = Prescriptions.objects.filter(Image_ID=value)
            drugdata = DrugDetails.objects.filter(PRESCRIPTION_ID=value).order_by('DRUG_NAME')
            
            context = {'pid':pid, 'drugdata':drugdata}
            
            
            return render(request,'Image_Popup.html',context)
    
    else :
        return redirect('/login')


def yesno_popup(request):
    if request.session.has_key('username'):
        return render(request,'yesno_popup.html')

    else :
        return redirect('/login')
    
def logout(request):
    del request.session['username']
    return redirect('/login')




                

                 




    

     
        