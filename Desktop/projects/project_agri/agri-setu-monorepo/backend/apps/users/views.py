from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework import status
from django.contrib.auth import get_user_model
from .serializers import UserSerializer
import requests
import uuid

User = get_user_model()

class SendOTPView(APIView):
    """
    Simulates sending an OTP.
    For development, the OTP is always '1234'.
    """
    def post(self, request):
        phone_number = request.data.get('phone_number')
        if not phone_number:
            return Response({'error': 'Phone number required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # In real world: Generate OTP + Send via SMS
        # Dev world: Log it
        print(f"[OTP-DEV] OTP for {phone_number} is 1234")
        
        return Response({'message': 'OTP sent successfully', 'dev_otp': '1234'})

class VerifyOTPView(APIView):
    """
    Verifies OTP and returns user token.
    Creates a new user if one doesn't exist (Simplified flow).
    """
    def post(self, request):
        phone_number = request.data.get('phone_number')
        otp = request.data.get('otp')
        role = request.data.get('role', User.Role.FARMER) # Default to Farmer if new

        if not phone_number or not otp:
            return Response({'error': 'Phone number and OTP required'}, status=status.HTTP_400_BAD_REQUEST)

        if otp != '1234':
            return Response({'error': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)

        # Get or Create User
        # Username hack: use phone number as username
        user, created = User.objects.get_or_create(
            username=phone_number,
            defaults={'phone_number': phone_number, 'role': role}
        )

        token, _ = Token.objects.get_or_create(user=user)

        return Response({
            'token': token.key,
            'user': UserSerializer(user).data,
            'is_new': created
        })

class GoogleLoginView(APIView):
    """
    Verifies Google ID Token and returns user token.
    Creates a new user if one doesn't exist.
    """
    def post(self, request):
        id_token = request.data.get('id_token')
        role = request.data.get('role', User.Role.FARMER)

        if not id_token:
            return Response({'error': 'ID Token required'}, status=status.HTTP_400_BAD_REQUEST)

        # Verify Token with Google
        try:
            # Using requests to verify token via Google's tokeninfo endpoint
            # In production, consider using google-auth library for local verification to save latency
            response = requests.get(f'https://oauth2.googleapis.com/tokeninfo?id_token={id_token}')
            
            if response.status_code != 200:
                 return Response({'error': 'Invalid Google Token'}, status=status.HTTP_400_BAD_REQUEST)
            
            google_data = response.json()
            email = google_data.get('email')
            
            if not email:
                return Response({'error': 'Email not found in token'}, status=status.HTTP_400_BAD_REQUEST)

            # Get or Create User
            # Username hack: use email as username for Google users
            user, created = User.objects.get_or_create(
                username=email,
                defaults={'role': role}
            )
            
            token, _ = Token.objects.get_or_create(user=user)

            return Response({
                'token': token.key,
                'user': UserSerializer(user).data,
                'is_new': created
            })

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class MeView(APIView):
    permisison_classes = [] 
    # Workaround: Permission classes should be imported, but putting inside checks is okay for now.
    # Ideally should be at top level but fixing import error from original file.
    
    def get(self, request):
        from rest_framework.permissions import IsAuthenticated
        if not request.user.is_authenticated:
             return Response({'error': 'Not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(UserSerializer(request.user).data)
