from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Booking
from .serializers import BookingSerializer

class BookingViewSet(viewsets.ModelViewSet):
    """
    CRUD for Bookings.
    Farmers can create.
    Owners can approve/reject.
    """
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        # Calculate price
        machine = serializer.validated_data['machine']
        start_time = serializer.validated_data['start_time']
        end_time = serializer.validated_data['end_time']
        
        duration = end_time - start_time
        hours = duration.total_seconds() / 3600
        total_price = round(hours * float(machine.price_per_hour), 2)
        
        serializer.save(
            farmer=self.request.user,
            total_price=total_price
        )

    def get_queryset(self):
        """
        Filter bookings based on user role.
        Farmer: sees their own bookings.
        Partner: sees bookings for their machines.
        """
        user = self.request.user
        if user.is_staff:
            return Booking.objects.all()
        if user.role == 'FARMER':
            return Booking.objects.filter(farmer=user)
        elif user.role == 'PARTNER':
            return Booking.objects.filter(machine__owner=user)
        return Booking.objects.none()

    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        booking = self.get_object()
        if request.user != booking.machine.owner:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
        
        booking.status = Booking.Status.CONFIRMED
        booking.save()
        return Response({'status': 'confirmed'})

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        booking = self.get_object()
        if request.user != booking.machine.owner:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
            
        booking.status = Booking.Status.REJECTED
        booking.save()
        return Response({'status': 'rejected'})

    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        booking = self.get_object()
        if request.user != booking.machine.owner:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
            
        booking.status = Booking.Status.COMPLETED
        booking.save()
        return Response({'status': 'completed'})

    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        booking = self.get_object()
        if request.user != booking.farmer:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
            
        if booking.status != Booking.Status.PENDING:
             return Response({'error': 'Cannot cancel a processed booking'}, status=status.HTTP_400_BAD_REQUEST)

        booking.status = Booking.Status.CANCELLED
        booking.save()
        return Response({'status': 'cancelled'})
