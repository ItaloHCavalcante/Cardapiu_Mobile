import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../dominio/delivery_location.dart';

class LiveDeliveryMap extends StatelessWidget {
  const LiveDeliveryMap({
    super.key,
    required this.location,
    required this.history,
  });

  final DeliveryLocation location;
  final List<LatLng> history;

  @override
  Widget build(BuildContext context) {
    final point = location.point;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 320,
        child: FlutterMap(
          key: ValueKey(location.updatedAt.toIso8601String()),
          options: MapOptions(initialCenter: point, initialZoom: 16),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.cardapiu.cardapiu_mobile',
            ),
            if (history.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: history,
                    color: Theme.of(context).colorScheme.secondary,
                    strokeWidth: 4,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 56,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x33000000),
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
