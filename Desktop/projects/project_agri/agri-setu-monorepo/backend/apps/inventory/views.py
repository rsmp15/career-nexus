from rest_framework import viewsets, permissions, filters
from rest_framework_gis.filters import DistanceToPointFilter
from .models import Machine
from .serializers import MachineSerializer

class MachineViewSet(viewsets.ModelViewSet):
    """
    CRUD for Machines.
    Includes spatial search via ?dist=radius&point=long,lat
    """
    queryset = Machine.objects.all()
    serializer_class = MachineSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    
    # Spatial Filter
    # usage: /api/machines/?dist=10000&point=77.2090,28.6139
    filter_backends = [DistanceToPointFilter]
    distance_filter_field = 'location'
    distance_filter_convert_meters = True 

    def get_queryset(self):
        qs = super().get_queryset()
        # Filter by owner=me
        if self.request.query_params.get('owner') == 'me' and self.request.user.is_authenticated:
            return qs.filter(owner=self.request.user)
        
        # Filter by category
        category = self.request.query_params.get('category')
        if category:
            return qs.filter(category=category)
            
        return qs

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)
