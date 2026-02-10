from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    class Role(models.TextChoices):
        FARMER = 'FARMER', 'Farmer'
        PARTNER = 'PARTNER', 'Partner'
        ADMIN = 'ADMIN', 'Admin'

    role = models.CharField(
        max_length=10, 
        choices=Role.choices, 
        default=Role.FARMER
    )
    phone_number = models.CharField(max_length=15, unique=True, null=True, blank=True)

    def __str__(self):
        return self.username
