from django import forms

from .models import DietInfo
from .models import UserInfo
from .models import DietEaten
class diet_info(forms.ModelForm):

    class Meta:
        model = DietInfo
        fields = ('dietName',
                   'dietQuantity',
                    'carbs',
                    'protein',
                    'fat',
                    'calorie',

            )



class user_info(forms.ModelForm):
    class Meta:
        model = UserInfo
        fields = ('weight',
                  'height_ft',
                  'height_inch',
                   'weight_target',
                   'carbs_target',
                    'calorie_target',
                     'fat_target',
                      'protein_target',)

class diet_eaten(forms.ModelForm):
    class Meta:
        model = DietEaten
        fields = ('dietNameQuantity',
                    'quantityEaten',
            )
