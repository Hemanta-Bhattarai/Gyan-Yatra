from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.http import HttpResponse,HttpRequest
from django.core.validators import MaxValueValidator, MinValueValidator

from django import forms
# Create your models here.
valid=[MinValueValidator(0),MaxValueValidator(10000000)]

class DietInfo(models.Model):
    name = models.CharField(max_length=1000, default="username")
    dietName = models.CharField(max_length=10000)
    dietQuantity=models.CharField(max_length=1000)
    carbs=models.FloatField(null=False,blank=False,default=0,validators=valid)
    protein=models.FloatField(null=False,blank=False,default=0,validators=valid)
    fat=models.FloatField(null=False,blank=False,default=0,validators=valid)
    calorie=models.FloatField(null=False,blank=False,default=0,validators=valid)


class UserInfo(models.Model):
    name = models.CharField(max_length=1000, default="username")
    weight=models.FloatField(null=False,blank=False,default=0,validators=valid)
    height_ft=models.IntegerField(null=False,blank=False,default=0,validators=valid)
    height_inch=models.IntegerField(null=False,blank=False,default=0,validators=valid)
    weight_target=models.FloatField(null=False,blank=False,default=0,validators=valid)
   
    calorie_target=models.FloatField(null=False,blank=False,default=0,validators=valid)
    carbs_target=models.FloatField(null=False,blank=False,default=0,validators=valid)
    fat_target=models.FloatField(null=False,blank=False,default=0,validators=valid)
    protein_target=models.FloatField(null=False,blank=False,default=0,validators=valid)




class DietEaten(models.Model):
    name = models.CharField(max_length=1000, default="username")
    CATEGORIES = []
    try:
        dietList=DietInfo.objects.all()
        for enteries in dietList:
            enteriesDict = enteries.__dict__
            diet_name = enteriesDict['dietName']
            diet_quantity = enteriesDict['dietQuantity']
            CATEGORIES.append((diet_name,"::".join([diet_name, diet_quantity])))
    except:
        print("No data table found")
     
    dietNameQuantity = models.CharField(max_length=10000, choices=CATEGORIES)
    quantityEaten=models.FloatField(null=False,blank=False,default=0,validators=valid)
    currentDate = models.DateField(auto_now=True)
    currentTime = models.TimeField(auto_now=True)
