import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../search/data/models/search_intent_model.dart';

class PlaceCard extends StatelessWidget {
  final PlaceResult place;
  final double? userLat;
  final double? userLng;

  const PlaceCard({super.key, required this.place, this.userLat, this.userLng});

  String? _calculateDistance() {
    if (userLat == null || userLng == null || place.latitude == null || place.longitude == null) {
      return null;
    }
    const p = 0.017453292519943295; // pi / 180
    final a = 0.5 -
        cos((place.latitude! - userLat!) * p) / 2 +
        cos(userLat! * p) * cos(place.latitude! * p) *
            (1 - cos((place.longitude! - userLng!) * p)) / 2;
    final km = 12742 * asin(sqrt(a)); // 2 * R * asin(sqrt(a))
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _openMaps(String? url) async {
    if (url != null) {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (place.latitude != null && place.longitude != null) {
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWebsite(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final distance = _calculateDistance();
    final priceDisplay = place.priceRange ?? place.feeRange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logo + Name + Rating
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: place.logoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: place.logoUrl!,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Icon(
                              _getIntentIcon(),
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              _getIntentIcon(),
                              color: colorScheme.primary,
                              size: 24,
                            ),
                          )
                        : Icon(
                            _getIntentIcon(),
                            color: colorScheme.primary,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name ?? "Unknown Place",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              place.formattedAddress ?? "Address not available",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Rating + Distance + Price chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (place.rating != null)
                  _InfoChip(
                    icon: Icons.star_rounded,
                    iconColor: Colors.amber,
                    label: '${place.rating}${place.userRatingsTotal != null ? " (${place.userRatingsTotal})" : ""}',
                  ),
                if (distance != null)
                  _InfoChip(
                    icon: Icons.near_me_rounded,
                    iconColor: colorScheme.tertiary,
                    label: distance,
                  ),
                if (priceDisplay != null)
                  _InfoChip(
                    icon: Icons.currency_rupee_rounded,
                    iconColor: Colors.green,
                    label: priceDisplay,
                  ),
                if (place.speciality != null)
                  _InfoChip(
                    icon: Icons.medical_services_rounded,
                    iconColor: colorScheme.error,
                    label: place.speciality!,
                  ),
                if (place.duration != null)
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    iconColor: colorScheme.secondary,
                    label: place.duration!,
                  ),
                if (place.availability != null)
                  _InfoChip(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: place.availability == "In Stock" ? Colors.green : Colors.orange,
                    label: place.availability!,
                  ),
              ],
            ),
          ),

          // Description
          if (place.description != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                place.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                if (place.formattedPhoneNumber != null)
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.call_rounded,
                      label: "Call",
                      color: Colors.green,
                      onPressed: () => _makeCall(place.formattedPhoneNumber!),
                    ),
                  ),
                if (place.formattedPhoneNumber != null) const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.map_rounded,
                    label: "Directions",
                    color: colorScheme.primary,
                    onPressed: () => _openMaps(place.mapsUrl),
                    outlined: true,
                  ),
                ),
                if (place.website != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.language_rounded,
                      label: "Website",
                      color: colorScheme.secondary,
                      onPressed: () => _openWebsite(place.website!),
                      outlined: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIntentIcon() {
    if (place.speciality != null) return Icons.local_hospital_rounded;
    if (place.duration != null) return Icons.school_rounded;
    if (place.availability != null) return Icons.shopping_bag_rounded;
    if (place.serviceType != null) return Icons.build_rounded;
    return Icons.store_rounded;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _InfoChip({required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool outlined;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
