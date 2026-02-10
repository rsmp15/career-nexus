from django.contrib.gis.db import models
from django.conf import settings

class Machine(models.Model):
    CATEGORY_CHOICES = [
        ('tractor', 'Tractor'),
        ('harvester', 'Harvester'),
        ('plough', 'Plough'),
        ('sprayer', 'Sprayer'),
        ('seeder', 'Seeder'),
        ('other', 'Other'),
    ]

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='machines'
    )
    name = models.CharField(max_length=100)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='other')
    description = models.TextField(blank=True)
    price_per_hour = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='machines/', null=True, blank=True)
    location = models.PointField(geography=True)  # GeoDjango PointField with geography support
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} - {self.owner.username}"
