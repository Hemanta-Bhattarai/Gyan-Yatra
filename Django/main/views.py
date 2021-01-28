from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.shortcuts import redirect
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required




from .models import DietInfo
from .models import UserInfo
from .models import DietEaten
from .forms import diet_info
from .forms import user_info
from .forms import diet_eaten
# Create your views here.

def home(request):
    return render(request,'main/home.html')

@login_required
def dietInfo(request):
    if request.method == "POST":
        form = diet_info(request.POST) 
        if form.is_valid():
            diet = form.save(commit=False)
            diet.name = request.user.username
            diet.save()
            return HttpResponseRedirect(reverse('main-home'))
    else:
        form = diet_info()
    return render(request,'main/diet_info.html',{'form':form}) 




@login_required
def userInfo(request):
    if request.method =="POST":
        form = user_info(request.POST)
        if form.is_valid():
            info = form.save(commit=False)
            info.name = request.user.username
            info.save()
            return HttpResponseRedirect(reverse('main-home'))
    else:
        form=user_info()
    return render(request,'main/user_info.html',{'form':form})

import datetime


@login_required
def dietEaten(request):
    user_name = request.user.username
    #dietList = DietInfo.objects.filter(name=user_name)
    if request.method == "POST":
        form = diet_eaten(request.POST) 
        if form.is_valid():
            diet = form.save(commit=False)
            diet.name = request.user.username
            #diet.dietNameQuantity.choices=[(selected.dietName,"::".join([selected.dietName,selected.dietQuantity])) for selected in dietList]
            diet.save()
            return HttpResponseRedirect(reverse('main-home'))
    else:
        form = diet_eaten()
    return render(request,'main/diet_eaten.html',{'form':form}) 




from datetime import date
@login_required
def dietConsumedUpdate(request):
    user_name = request.user.username
    today = date.today() 
    eatenList = DietEaten.objects.filter(currentDate=today, name=user_name)
    totalCalorie=0
    totalCarbs=0
    totalFat = 0
    totalProtein = 0
    for eatenDiet in eatenList:
        nameDiet=eatenDiet.dietNameQuantity
        quantity=eatenDiet.quantityEaten
        selectedDiet = DietInfo.objects.filter(dietName=nameDiet)[0]
        totalCalorie = totalCalorie + quantity * selectedDiet.calorie
        totalCarbs = totalCarbs + quantity * selectedDiet.carbs
        totalProtein = totalProtein + quantity * selectedDiet.protein
        totalFat = totalFat + quantity * selectedDiet.fat
    
    userInfoList=UserInfo.objects.filter(name=user_name)
    if (len(userInfoList) != 0):
        targetCalorie = userInfoList[0].calorie_target
        targetProtein = userInfoList[0].protein_target
        targetFat   = userInfoList[0].fat_target
        targetCarbs = userInfoList[0].carbs_target
    else:
        targetCalorie = 0
        targetProtein = 0
        targetFat   = 0
        targetCarbs = 0
    context = { 'totalCalorie':totalCalorie,
            'totalCarbs':totalCarbs,
            'totalProtein':totalProtein,
            'totalFat':totalFat,
            'targetCalorie':targetCalorie,
            'targetProtein':targetProtein,
            'targetFat':targetFat,
            'targetCarbs':targetCarbs,
        }
        
    return render(request,'main/diet_track.html',context) 
