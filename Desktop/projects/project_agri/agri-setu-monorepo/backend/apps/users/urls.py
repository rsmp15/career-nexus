from django.urls import path
from .views import SendOTPView, VerifyOTPView, MeView, GoogleLoginView

urlpatterns = [
    path('auth/otp/send/', SendOTPView.as_view(), name='send-otp'),
    path('auth/otp/verify/', VerifyOTPView.as_view(), name='verify-otp'),
    path('auth/google/', GoogleLoginView.as_view(), name='google-login'),
    path('auth/me/', MeView.as_view(), name='me'),
]
