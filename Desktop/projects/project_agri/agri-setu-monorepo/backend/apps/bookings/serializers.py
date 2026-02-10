from rest_framework import serializers
from .models import Booking
from apps.inventory.serializers import MachineSerializer # For nested details

class BookingSerializer(serializers.ModelSerializer):
    """
    Serializer for Booking model.
    """
    machine_details = MachineSerializer(source='machine', read_only=True)
    duration = serializers.SerializerMethodField()
    class Meta:
        model = Booking
        fields = ['id', 'farmer', 'machine', 'machine_details', 'start_time', 'end_time', 'duration', 'total_price', 'payment_status', 'status', 'created_at']
        read_only_fields = ['farmer', 'created_at', 'status', 'total_price', 'payment_status'] # Status & Price managed via actions/logic
    
    def get_duration(self, obj):
        diff = obj.end_time - obj.start_time
        return diff.days if diff.days > 0 else 1 # Minimum 1 day for simplicity
    
    def validate(self, data):
        """
        Check for overlapping bookings.
        """
        # Simple overlap check
        machine = data['machine']
        start = data['start_time']
        end = data['end_time']
        
        overlapping = Booking.objects.filter(
            machine=machine,
            status=Booking.Status.CONFIRMED,
            start_time__lt=end,
            end_time__gt=start
        ).exists()
        
        if overlapping:
            raise serializers.ValidationError("This machine is already booked for the selected time slot.")
            
        return data
