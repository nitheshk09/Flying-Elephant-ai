import 'package:json_annotation/json_annotation.dart';

part 'search_intent_model.g.dart';

@JsonSerializable()
class SearchIntentModel {
  @JsonKey(name: 'intent')
  final String intent;
  @JsonKey(name: 'query_cleaned')
  final String queryCleaned;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'price_check_needed')
  final bool? priceCheckNeeded;
  @JsonKey(name: 'needs_phone_number')
  final bool? needsPhoneNumber;
  @JsonKey(name: 'needs_buy_link')
  final bool? needsBuyLink;
  @JsonKey(name: 'results')
  final List<PlaceResult>? results;
  @JsonKey(name: 'followup_questions')
  final List<String>? followupQuestions;
  @JsonKey(name: 'missing_fields')
  final List<String>? missingFields;
  @JsonKey(name: 'vehicle')
  final VehicleSlots? vehicle;

  SearchIntentModel({
    required this.intent,
    required this.queryCleaned,
    required this.location,
    this.priceCheckNeeded,
    this.needsPhoneNumber,
    this.needsBuyLink,
    this.results,
    this.followupQuestions,
    this.missingFields,
    this.vehicle,
  });

  factory SearchIntentModel.fromJson(Map<String, dynamic> json) =>
      _$SearchIntentModelFromJson(_normalizeIntentJson(json));
  Map<String, dynamic> toJson() => _$SearchIntentModelToJson(this);
}

@JsonSerializable()
class VehicleSlots {
  final String? category;
  final String? condition;
  final String? brand;
  @JsonKey(name: 'body_type')
  final String? bodyType;
  final int? seats;
  @JsonKey(name: 'budget_usd_min')
  final int? budgetMin;
  @JsonKey(name: 'budget_usd_max')
  final int? budgetMax;
  final String? fuel;
  final String? transmission;
  @JsonKey(name: 'must_have')
  final List<String>? mustHave;
  final List<String>? exclude;

  VehicleSlots({
    this.category, this.condition, this.brand, this.bodyType, this.seats,
    this.budgetMin, this.budgetMax, this.fuel, this.transmission,
    this.mustHave, this.exclude,
  });

  factory VehicleSlots.fromJson(Map<String, dynamic> json) =>
      _$VehicleSlotsFromJson(_normalizeVehicleSlots(json) ?? <String, dynamic>{});
  Map<String, dynamic> toJson() => _$VehicleSlotsToJson(this);
}

@JsonSerializable()
class DealerInfo {
  final String? name;
  final String? address;
  final String? phone;
  final String? city;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? website;

  DealerInfo({
    this.name, this.address, this.phone, this.city,
    this.description, this.latitude, this.longitude, this.website,
  });

  factory DealerInfo.fromJson(Map<String, dynamic> json) =>
      _$DealerInfoFromJson(_normalizeDealer(json));
  Map<String, dynamic> toJson() => _$DealerInfoToJson(this);
}

@JsonSerializable()
class PlaceResult {
  final String? name;
  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;
  @JsonKey(name: 'formatted_phone_number')
  final String? formattedPhoneNumber;
  final double? rating;
  @JsonKey(name: 'user_ratings_total')
  final int? userRatingsTotal;
  final String? website;
  @JsonKey(name: 'url')
  final String? mapsUrl;
  final String? description;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'price_range')
  final String? priceRange;
  @JsonKey(name: 'fee_range')
  final String? feeRange;
  final String? speciality;
  final String? duration;
  final String? availability;
  @JsonKey(name: 'service_type')
  final String? serviceType;

  // Vehicle fields
  final String? category;
  final String? brand;
  final String? model;
  final int? year;
  @JsonKey(name: 'variant_suggestion')
  final String? variantSuggestion;
  @JsonKey(name: 'body_type')
  final String? bodyType;
  final int? seats;
  @JsonKey(name: 'fuel_options')
  final List<String>? fuelOptions;
  @JsonKey(name: 'transmission_options')
  final List<String>? transmissionOptions;
  @JsonKey(name: 'approx_price')
  final String? approxPrice;
  @JsonKey(name: 'mpg_or_range')
  final String? mpgOrRange;
  final String? engine;
  final String? horsepower;
  final String? torque;
  @JsonKey(name: 'cargo_space')
  final String? cargoSpace;
  @JsonKey(name: 'ground_clearance')
  final String? groundClearance;
  @JsonKey(name: 'safety_rating')
  final String? safetyRating;
  final String? infotainment;
  final int? airbags;
  @JsonKey(name: 'features_list')
  final List<String>? featuresList;
  final List<String>? pros;
  final List<String>? cons;
  @JsonKey(name: 'why_it_matches')
  final String? whyItMatches;
  @JsonKey(name: 'official_url')
  final String? officialUrl;
  @JsonKey(name: 'color_hex')
  final String? colorHex;
  @JsonKey(name: 'brand_logo_letter')
  final String? brandLogoLetter;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<DealerInfo>? dealers;

  PlaceResult({
    this.name, this.formattedAddress, this.formattedPhoneNumber,
    this.rating, this.userRatingsTotal, this.website, this.mapsUrl,
    this.description, this.logoUrl, this.latitude, this.longitude,
    this.priceRange, this.feeRange, this.speciality, this.duration,
    this.availability, this.serviceType,
    this.category, this.brand, this.model, this.year, this.variantSuggestion,
    this.bodyType, this.seats, this.fuelOptions, this.transmissionOptions,
    this.approxPrice, this.mpgOrRange, this.engine, this.horsepower,
    this.torque, this.cargoSpace, this.groundClearance, this.safetyRating,
    this.infotainment, this.airbags, this.featuresList, this.pros, this.cons,
    this.whyItMatches, this.officialUrl, this.colorHex, this.brandLogoLetter,
    this.imageUrl, this.dealers,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) =>
      _$PlaceResultFromJson(_normalizePlaceResult(json));
  Map<String, dynamic> toJson() => _$PlaceResultToJson(this);
}

Map<String, dynamic> _normalizeIntentJson(Map<String, dynamic> json) {
  final normalized = <String, dynamic>{
    'intent': (json['intent'] ?? 'other').toString(),
    'query_cleaned': (json['query_cleaned'] ?? json['queryCleaned'] ?? '').toString(),
    'location': (json['location'] ?? 'New York').toString(),
    'price_check_needed': json['price_check_needed'] ?? json['priceCheckNeeded'],
    'needs_phone_number': json['needs_phone_number'] ?? json['needsPhoneNumber'],
    'needs_buy_link': json['needs_buy_link'] ?? json['needsBuyLink'],
    'followup_questions': _asStringList(json['followup_questions']) ?? <String>[],
    'missing_fields': _asStringList(json['missing_fields']) ?? <String>[],
  };

  final vehicle = _normalizeVehicleSlots(json['vehicle']);
  if (vehicle != null) {
    normalized['vehicle'] = vehicle;
  }

  final results = _normalizeResults(json['results']);
  if (results != null) {
    normalized['results'] = results;
  }

  return normalized;
}

Map<String, dynamic>? _normalizeVehicleSlots(dynamic input) {
  if (input == null || input is! Map) return null;
  final map = Map<String, dynamic>.from(input as Map);

  return {
    'category': map['category']?.toString(),
    'condition': map['condition']?.toString(),
    'brand': map['brand']?.toString(),
    'body_type': map['body_type']?.toString(),
    'seats': _asInt(map['seats']),
    'budget_usd_min': _asInt(map['budget_usd_min'] ?? map['budgetMin']),
    'budget_usd_max': _asInt(map['budget_usd_max'] ?? map['budgetMax']),
    'fuel': map['fuel']?.toString(),
    'transmission': map['transmission']?.toString(),
    'must_have': _asStringList(map['must_have']),
    'exclude': _asStringList(map['exclude']),
  };
}

List<Map<String, dynamic>>? _normalizeResults(dynamic input) {
  if (input == null) return null;
  if (input is Map<String, dynamic>) {
    return [_normalizePlaceResult(input)];
  }
  if (input is! List) return null;

  return input
      .whereType<Map>()
      .map((e) => _normalizePlaceResult(Map<String, dynamic>.from(e as Map)))
      .toList();
}

Map<String, dynamic> _normalizePlaceResult(Map<String, dynamic> json) {
  return {
    'name': json['name']?.toString(),
    'formatted_address': json['formatted_address']?.toString(),
    'formatted_phone_number': json['formatted_phone_number']?.toString(),
    'rating': _asDouble(json['rating']),
    'user_ratings_total': _asInt(json['user_ratings_total']),
    'website': json['website']?.toString(),
    'url': json['url']?.toString(),
    'description': json['description']?.toString(),
    'logo_url': json['logo_url']?.toString(),
    'latitude': _asDouble(json['latitude']),
    'longitude': _asDouble(json['longitude']),
    'price_range': json['price_range']?.toString(),
    'fee_range': json['fee_range']?.toString(),
    'speciality': json['speciality']?.toString(),
    'duration': json['duration']?.toString(),
    'availability': json['availability']?.toString(),
    'service_type': json['service_type']?.toString(),
    'category': json['category']?.toString(),
    'brand': json['brand']?.toString(),
    'model': json['model']?.toString(),
    'year': _asInt(json['year']),
    'variant_suggestion': json['variant_suggestion']?.toString(),
    'body_type': json['body_type']?.toString(),
    'seats': _asInt(json['seats']),
    'fuel_options': _asStringList(json['fuel_options']),
    'transmission_options': _asStringList(json['transmission_options']),
    'approx_price': json['approx_price']?.toString(),
    'mpg_or_range': json['mpg_or_range']?.toString(),
    'engine': json['engine']?.toString(),
    'horsepower': json['horsepower']?.toString(),
    'torque': json['torque']?.toString(),
    'cargo_space': json['cargo_space']?.toString(),
    'ground_clearance': json['ground_clearance']?.toString(),
    'safety_rating': json['safety_rating']?.toString(),
    'infotainment': json['infotainment']?.toString(),
    'airbags': _asInt(json['airbags']),
    'features_list': _asStringList(json['features_list']),
    'pros': _asStringList(json['pros']),
    'cons': _asStringList(json['cons']),
    'why_it_matches': json['why_it_matches']?.toString(),
    'official_url': json['official_url']?.toString(),
    'color_hex': json['color_hex']?.toString(),
    'brand_logo_letter': json['brand_logo_letter']?.toString(),
    'image_url': json['image_url']?.toString(),
    'dealers': _normalizeDealers(json['dealers']),
  };
}

List<Map<String, dynamic>>? _normalizeDealers(dynamic input) {
  if (input == null || input is! List) return null;

  return input
      .whereType<Map>()
      .map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        return _normalizeDealer(map);
      })
      .toList();
}

Map<String, dynamic> _normalizeDealer(Map<String, dynamic> json) {
  return {
    'name': json['name']?.toString(),
    'address': json['address']?.toString(),
    'phone': json['phone']?.toString(),
    'city': json['city']?.toString(),
    'description': json['description']?.toString(),
    'latitude': _asDouble(json['latitude']),
    'longitude': _asDouble(json['longitude']),
    'website': json['website']?.toString(),
  };
}

List<String>? _asStringList(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value
        .map((e) => e?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9\-]'), '');
    return int.tryParse(cleaned);
  }
  return null;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9\.\-]'), '');
    return double.tryParse(cleaned);
  }
  return null;
}
