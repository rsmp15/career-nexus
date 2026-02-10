from django.test import TestCase
from django.contrib.auth import get_user_model
from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D
from apps.inventory.models import Machine

User = get_user_model()

class FoundationTests(TestCase):
    def test_user_roles(self):
        """
        Verify that users can be created with specific roles.
        """
        farmer = User.objects.create_user(username='farmer', password='pw', role=User.Role.FARMER)
        partner = User.objects.create_user(username='partner', password='pw', role=User.Role.PARTNER)
        
        self.assertEqual(farmer.role, User.Role.FARMER)
        self.assertEqual(partner.role, User.Role.PARTNER)
        print("\n[TEST] User Role Verification: PASSED")

    def test_geo_query(self):
        """
        Verify spatial filtering.
        Create 2 machines: one 5km away, one 50km away.
        Search with radius=10km.
        Assert only the 5km machine is returned.
        """
        owner = User.objects.create_user(username='owner', password='pw', role=User.Role.PARTNER)
        
        # Center point (e.g., New Delhi Connaught Place approx)
        center_lat, center_lon = 28.6139, 77.2090
        center_point = Point(center_lon, center_lat) # Longitude first

        # Machine 1: ~5km north
        # 1 degree lat ~= 111km. 5km ~= 0.045 degrees
        m1_point = Point(center_lon, center_lat + 0.045)
        machine_near = Machine.objects.create(
            owner=owner, 
            name="Near Tractor", 
            price_per_hour=100, 
            location=m1_point
        )

        # Machine 2: ~50km north
        # 50km ~= 0.45 degrees
        m2_point = Point(center_lon, center_lat + 0.45)
        machine_far = Machine.objects.create(
            owner=owner, 
            name="Far Tractor", 
            price_per_hour=100, 
            location=m2_point
        )

        # Query: Filter machines within 10km of center_point
        # We use dwithin for distance queries
        qm = Machine.objects.filter(location__dwithin=(center_point, D(km=10)))

        self.assertIn(machine_near, qm)
        self.assertNotIn(machine_far, qm)
        self.assertEqual(qm.count(), 1)
        print("\n[TEST] Geo Spatial Query Verification: PASSED")
