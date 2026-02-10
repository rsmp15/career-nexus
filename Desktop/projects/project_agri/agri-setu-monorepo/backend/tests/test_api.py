from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from apps.inventory.models import Machine
from django.contrib.gis.geos import Point

User = get_user_model()

class APITests(APITestCase):
    def setUp(self):
        # Users
        self.farmer = User.objects.create_user(username='9876543210', phone_number='9876543210', role=User.Role.FARMER)
        self.partner = User.objects.create_user(username='1234567890', phone_number='1234567890', role=User.Role.PARTNER)
        
        # Partner creates a machine
        self.machine = Machine.objects.create(
            owner=self.partner,
            name="Test Tractor",
            price_per_hour=500,
            location=Point(77.2090, 28.6139) # Connaught Place
        )

    def test_auth_flow(self):
        """
        Test OTP flow.
        1. Send OTP
        2. Verify OTP (Correct) -> Token
        3. Verify OTP (Incorrect) -> Error
        """
        # Send
        response = self.client.post(reverse('send-otp'), {'phone_number': '5555555555'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Verify Wrong
        response = self.client.post(reverse('verify-otp'), {'phone_number': '5555555555', 'otp': '0000'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        # Verify Correct
        response = self.client.post(reverse('verify-otp'), {'phone_number': '5555555555', 'otp': '1234'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('token', response.data)
        print("\n[TEST] Auth Flow: PASSED")

    def test_inventory_search(self):
        """
        Test Spatial Search.
        """
        url = reverse('machine-list')
        
        # Search far away -> Should be empty
        response = self.client.get(url, {'point': '0,0', 'dist': '1000'})
        self.assertEqual(len(response.data['features']), 0)

        # Search near -> Should find machine
        # Note: Point format in djangorestframework-gis filter might be lon,lat or lat,lon depending on config.
        # Default is usually lon,lat.
        response = self.client.get(url, {'point': '77.2090,28.6139', 'dist': '5000'}) # 5km
        self.assertEqual(len(response.data['features']), 1)
        print("\n[TEST] Inventory Search: PASSED")

    def test_booking_create(self):
        """
        Test Booking Creation.
        """
        self.client.force_authenticate(user=self.farmer)
        url = reverse('booking-list')
        data = {
            'machine': self.machine.id,
            'start_time': '2026-02-10T10:00:00Z',
            'end_time': '2026-02-10T12:00:00Z'
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['status'], 'PENDING')
        print("\n[TEST] Booking Creation: PASSED")
