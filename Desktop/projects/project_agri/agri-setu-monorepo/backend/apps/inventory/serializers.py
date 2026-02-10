from rest_framework import serializers
from rest_framework_gis.serializers import GeoFeatureModelSerializer
from .models import Machine

class MachineSerializer(GeoFeatureModelSerializer):
    """
    Serializer for Machine model.
    Uses GeoJSON format for the location field.
    """
    owner_name = serializers.ReadOnlyField(source='owner.username')

    class Meta:
        model = Machine
        geo_field = "location"
        fields = ['id', 'owner', 'owner_name', 'name', 'category', 'description', 'price_per_hour', 'image', 'location', 'is_active', 'created_at']
        read_only_fields = ['owner', 'created_at']
