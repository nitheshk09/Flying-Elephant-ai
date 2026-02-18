import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../search/data/models/search_intent_model.dart';

/// Premium dark vehicle list — Apple-style cards
class VehicleListView extends StatelessWidget {
  final List<PlaceResult> vehicles;
  const VehicleListView({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: vehicles.length,
      itemBuilder: (ctx, i) => _VehicleListCard(vehicle: vehicles[i]),
    );
  }
}

class _VehicleListCard extends StatefulWidget {
  final PlaceResult vehicle;
  const _VehicleListCard({required this.vehicle});

  @override
  State<_VehicleListCard> createState() => _VehicleListCardState();
}

class _VehicleListCardState extends State<_VehicleListCard> {
  bool _dealersExpanded = false;

  PlaceResult get v => widget.vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2C2C2E), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image
          _buildImage(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand + model header
                _buildHeader(theme),
                const SizedBox(height: 16),

                // Price
                if (v.approxPrice != null) ...[
                  Text(
                    v.approxPrice!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Key specs grid
                _buildSpecsGrid(theme),
                const SizedBox(height: 16),

                // AI match - Premium Glassmorphism Feel
                if (v.whyItMatches != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2C2C2E).withOpacity(0.5)),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1C1C1E),
                          const Color(0xFF2C2C2E).withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 18,
                            color: Color(0xFFD4D4D8)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            v.whyItMatches!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              fontSize: 13,
                              color: const Color(0xFFAEAEB2),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Features
                if (v.featuresList != null && v.featuresList!.isNotEmpty) ...[
                  _buildFeatures(theme),
                  const SizedBox(height: 16),
                ],

                // Pros & Cons
                if (v.pros != null || v.cons != null) ...[
                  _buildProsCons(theme),
                  const SizedBox(height: 16),
                ],

                // Dealers expandable
                if (v.dealers != null && v.dealers!.isNotEmpty)
                  _buildDealerSection(theme),

                const SizedBox(height: 12),

                // Action buttons
                _buildActions(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C1C1E), Color(0xFF0A0A0A)],
          ),
        ),
        child: v.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: v.imageUrl!,
                fit: BoxFit.contain,
                placeholder: (_, __) => _imagePlaceholder(),
                errorWidget: (_, __, ___) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(),
            size: 48,
            color: const Color(0xFF3A3A3C),
          ),
          const SizedBox(height: 8),
          Text(
            '${v.brand ?? ''} ${v.model ?? ''}',
            style: const TextStyle(
              color: Color(0xFF48484A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand logo
        if (v.logoUrl != null)
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: v.logoUrl!,
              fit: BoxFit.contain,
              width: 28,
              height: 28,
              errorWidget: (_, __, ___) => Center(
                child: Text(
                  v.brandLogoLetter ?? v.brand?.substring(0, 1) ?? '',
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                v.brandLogoLetter ?? v.brand?.substring(0, 1) ?? '',
                style: const TextStyle(
                  color: Color(0xFFF5F5F7),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (v.brand ?? '').toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                v.model ?? 'Unknown',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              if (v.variantSuggestion != null)
                Text(
                  v.variantSuggestion!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF636366),
                  ),
                ),
            ],
          ),
        ),
        if (v.year != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${v.year}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFFF5F5F7),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecsGrid(ThemeData theme) {
    final specs = <_SpecItem>[];
    if (v.engine != null) specs.add(_SpecItem('Engine', v.engine!, Icons.settings_outlined));
    if (v.horsepower != null) specs.add(_SpecItem('Power', v.horsepower!, Icons.speed_rounded));
    if (v.torque != null) specs.add(_SpecItem('Torque', v.torque!, Icons.rotate_right_rounded));
    if (v.mpgOrRange != null) specs.add(_SpecItem('Economy', v.mpgOrRange!, Icons.eco_outlined));
    if (v.safetyRating != null) specs.add(_SpecItem('Safety', v.safetyRating!, Icons.security_rounded));
    if (v.cargoSpace != null) specs.add(_SpecItem('Cargo', v.cargoSpace!, Icons.inventory_2_outlined));
    if (v.transmissionOptions != null) specs.add(_SpecItem('Trans.', v.transmissionOptions!.join(', '), Icons.alt_route_rounded));
    if (v.fuelOptions != null) specs.add(_SpecItem('Fuel', v.fuelOptions!.join(', '), Icons.local_gas_station_outlined));

    if (specs.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: specs.map((s) => Container(
        width: (MediaQuery.of(context).size.width - 92) / 4, // 4 per row
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2C2C2E), width: 0.5),
        ),
        child: Column(
          children: [
            Icon(s.icon, size: 12, color: const Color(0xFFD4D4D8)),
            const SizedBox(height: 4),
            Text(
              s.label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFF636366),
                letterSpacing: 0.5,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Text(
              s.value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF5F5F7),
                fontSize: 9,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildFeatures(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: v.featuresList!.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF2C2C2E)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(f,
          style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 11)),
      )).toList(),
    );
  }

  Widget _buildProsCons(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (v.pros != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Strengths",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF32D74B),
                      letterSpacing: 0.5,
                    )),
                const SizedBox(height: 6),
                ...v.pros!.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('+ ', style: TextStyle(color: Color(0xFF32D74B), fontSize: 12, fontWeight: FontWeight.w700)),
                      Expanded(child: Text(p, style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 12))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        if (v.pros != null && v.cons != null) const SizedBox(width: 16),
        if (v.cons != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weak Points",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFFF453A),
                      letterSpacing: 0.5,
                    )),
                const SizedBox(height: 6),
                ...v.cons!.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('– ', style: TextStyle(color: Color(0xFFFF453A), fontSize: 12, fontWeight: FontWeight.w700)),
                      Expanded(child: Text(c, style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 12))),
                    ],
                  ),
                )),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDealerSection(ThemeData theme) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _dealersExpanded = !_dealersExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2C2C2E)),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded, size: 18, color: Color(0xFF8E8E93)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dealers Near You  (${v.dealers!.length})',
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
                  ),
                ),
                AnimatedRotation(
                  turns: _dealersExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF636366), size: 20),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: v.dealers!.map((d) => _buildDealerTile(d, theme)).toList(),
            ),
          ),
          crossFadeState: _dealersExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildDealerTile(DealerInfo d, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C2C2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.name ?? 'Dealer', style: theme.textTheme.titleSmall),
          if (d.city != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(d.city!,
                  style: const TextStyle(color: Color(0xFF636366), fontSize: 11)),
            ),
          if (d.address != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF636366)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(d.address!,
                    style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12, height: 1.4)),
                ),
              ],
            ),
          ],
          if (d.description != null) ...[
            const SizedBox(height: 6),
            Text(d.description!,
              style: const TextStyle(color: Color(0xFF48484A), fontSize: 11, height: 1.3),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (d.phone != null)
                _dealerBtn(Icons.call_outlined, 'Call', () {
                  launchUrl(Uri(scheme: 'tel', path: d.phone));
                }),
              if (d.phone != null) const SizedBox(width: 8),
              _dealerBtn(Icons.map_outlined, 'Directions', () {
                if (d.latitude != null && d.longitude != null) {
                  launchUrl(
                    Uri.parse('https://www.google.com/maps/search/?api=1&query=${d.latitude},${d.longitude}'),
                    mode: LaunchMode.externalApplication,
                  );
                }
              }),
              if (d.website != null) ...[
                const SizedBox(width: 8),
                _dealerBtn(Icons.language_rounded, 'Website', () {
                  launchUrl(Uri.parse(d.website!), mode: LaunchMode.externalApplication);
                }),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _dealerBtn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2C2C2E)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: const Color(0xFF8E8E93)),
              const SizedBox(width: 4),
              Text(label,
                style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Row(
      children: [
        if (v.officialUrl != null)
          Expanded(
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(v.officialUrl!), mode: LaunchMode.externalApplication),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Configure & Price',
                    style: TextStyle(color: Color(0xFF0A0A0A), fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        if (v.officialUrl != null) const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => launchUrl(
              Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent("${v.brand ?? ''} ${v.model ?? ''} dealers near me New York")}'),
              mode: LaunchMode.externalApplication,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2C2C2E)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Search Dealers',
                  style: TextStyle(color: Color(0xFFAEAEB2), fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon() {
    switch (v.category) {
      case 'bike': return Icons.two_wheeler_rounded;
      case 'truck': return Icons.local_shipping_rounded;
      default: return Icons.directions_car_rounded;
    }
  }
}

class _SpecItem {
  final String label;
  final String value;
  final IconData icon;
  const _SpecItem(this.label, this.value, this.icon);
}
