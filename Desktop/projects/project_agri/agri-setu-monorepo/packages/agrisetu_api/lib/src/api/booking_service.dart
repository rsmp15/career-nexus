import '../models/booking.dart';
import 'api_client.dart';

class BookingService {
  final ApiClient apiClient;

  BookingService(this.apiClient);

  Future<Booking> createBooking(Booking booking) async {
    final response = await apiClient.dio.post(
      '/api/bookings/',
      data: booking.toJson(),
    );
    return Booking.fromJson(response.data);
  }

  Future<List<Booking>> getBookings() async {
    final response = await apiClient.dio.get('/api/bookings/');
    final list = response.data as List;
    return list.map((e) => Booking.fromJson(e)).toList();
  }

  Future<void> approveBooking(int id) async {
    await apiClient.dio.post('/api/bookings/$id/approve/');
  }

  Future<void> rejectBooking(int id) async {
    await apiClient.dio.post('/api/bookings/$id/reject/');
  }

  Future<void> completeBooking(int id) async {
    await apiClient.dio.post('/api/bookings/$id/complete/');
  }

  Future<void> cancelBooking(int id) async {
    await apiClient.dio.post('/api/bookings/$id/cancel/');
  }
}
