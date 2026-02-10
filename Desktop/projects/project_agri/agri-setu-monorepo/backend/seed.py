import os
import django
from django.contrib.gis.geos import Point

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.users.models import User
from apps.inventory.models import Machine

def seed():
    # Create Partner
    partner, created = User.objects.get_or_create(
        username='partner_dev', 
        defaults={'phone_number': '1111111111', 'role': 'PARTNER'}
    )
    if created:
        partner.set_password('pass')
        partner.save()
        print("Created Partner User")

    # Create Machine near default location (Connaught Place: 77.2090, 28.6139)
    # The App searches with 50km radius around this point.
    
    # Machine 1: Very close
    m1, _ = Machine.objects.get_or_create(
        name="Mahindra JIVO 245",
        owner=partner,
        defaults={
            'description': "4WD Compact Tractor, 24 HP. Good for orchards.",
            'price_per_hour': 450,
            'location': Point(77.2090, 28.6139)
        }
    )
    print(f"Seeded: {m1.name}")

    # Machine 2: 5km away
    m2, _ = Machine.objects.get_or_create(
        name="John Deere 5105",
        owner=partner,
        defaults={
            'description': "40 HP, Power Steering. Heavy duty.",
            'price_per_hour': 800,
            'location': Point(77.25, 28.65)
        }
    )
    print(f"Seeded: {m2.name}")

if __name__ == '__main__':
    seed()
