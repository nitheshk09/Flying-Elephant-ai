// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_intent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchIntentModel _$SearchIntentModelFromJson(Map<String, dynamic> json) =>
    SearchIntentModel(
      intent: json['intent'] as String,
      queryCleaned: json['query_cleaned'] as String,
      location: json['location'] as String,
      priceCheckNeeded: json['price_check_needed'] as bool?,
      needsPhoneNumber: json['needs_phone_number'] as bool?,
      needsBuyLink: json['needs_buy_link'] as bool?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      followupQuestions: (json['followup_questions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      missingFields: (json['missing_fields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vehicle: json['vehicle'] == null
          ? null
          : VehicleSlots.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchIntentModelToJson(SearchIntentModel instance) =>
    <String, dynamic>{
      'intent': instance.intent,
      'query_cleaned': instance.queryCleaned,
      'location': instance.location,
      'price_check_needed': instance.priceCheckNeeded,
      'needs_phone_number': instance.needsPhoneNumber,
      'needs_buy_link': instance.needsBuyLink,
      'results': instance.results,
      'followup_questions': instance.followupQuestions,
      'missing_fields': instance.missingFields,
      'vehicle': instance.vehicle,
    };

VehicleSlots _$VehicleSlotsFromJson(Map<String, dynamic> json) => VehicleSlots(
  category: json['category'] as String?,
  condition: json['condition'] as String?,
  brand: json['brand'] as String?,
  bodyType: json['body_type'] as String?,
  seats: (json['seats'] as num?)?.toInt(),
  budgetMin: (json['budget_usd_min'] as num?)?.toInt(),
  budgetMax: (json['budget_usd_max'] as num?)?.toInt(),
  fuel: json['fuel'] as String?,
  transmission: json['transmission'] as String?,
  mustHave: (json['must_have'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  exclude: (json['exclude'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$VehicleSlotsToJson(VehicleSlots instance) =>
    <String, dynamic>{
      'category': instance.category,
      'condition': instance.condition,
      'brand': instance.brand,
      'body_type': instance.bodyType,
      'seats': instance.seats,
      'budget_usd_min': instance.budgetMin,
      'budget_usd_max': instance.budgetMax,
      'fuel': instance.fuel,
      'transmission': instance.transmission,
      'must_have': instance.mustHave,
      'exclude': instance.exclude,
    };

DealerInfo _$DealerInfoFromJson(Map<String, dynamic> json) => DealerInfo(
  name: json['name'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  city: json['city'] as String?,
  description: json['description'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  website: json['website'] as String?,
);

Map<String, dynamic> _$DealerInfoToJson(DealerInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'city': instance.city,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'website': instance.website,
    };

PlaceResult _$PlaceResultFromJson(Map<String, dynamic> json) => PlaceResult(
  name: json['name'] as String?,
  formattedAddress: json['formatted_address'] as String?,
  formattedPhoneNumber: json['formatted_phone_number'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  userRatingsTotal: (json['user_ratings_total'] as num?)?.toInt(),
  website: json['website'] as String?,
  mapsUrl: json['url'] as String?,
  description: json['description'] as String?,
  logoUrl: json['logo_url'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  priceRange: json['price_range'] as String?,
  feeRange: json['fee_range'] as String?,
  speciality: json['speciality'] as String?,
  duration: json['duration'] as String?,
  availability: json['availability'] as String?,
  serviceType: json['service_type'] as String?,
  category: json['category'] as String?,
  brand: json['brand'] as String?,
  model: json['model'] as String?,
  year: (json['year'] as num?)?.toInt(),
  variantSuggestion: json['variant_suggestion'] as String?,
  bodyType: json['body_type'] as String?,
  seats: (json['seats'] as num?)?.toInt(),
  fuelOptions: (json['fuel_options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  transmissionOptions: (json['transmission_options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  approxPrice: json['approx_price'] as String?,
  mpgOrRange: json['mpg_or_range'] as String?,
  engine: json['engine'] as String?,
  horsepower: json['horsepower'] as String?,
  torque: json['torque'] as String?,
  cargoSpace: json['cargo_space'] as String?,
  groundClearance: json['ground_clearance'] as String?,
  safetyRating: json['safety_rating'] as String?,
  infotainment: json['infotainment'] as String?,
  airbags: (json['airbags'] as num?)?.toInt(),
  featuresList: (json['features_list'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pros: (json['pros'] as List<dynamic>?)?.map((e) => e as String).toList(),
  cons: (json['cons'] as List<dynamic>?)?.map((e) => e as String).toList(),
  whyItMatches: json['why_it_matches'] as String?,
  officialUrl: json['official_url'] as String?,
  colorHex: json['color_hex'] as String?,
  brandLogoLetter: json['brand_logo_letter'] as String?,
  imageUrl: json['image_url'] as String?,
  dealers: (json['dealers'] as List<dynamic>?)
      ?.map((e) => DealerInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlaceResultToJson(PlaceResult instance) =>
    <String, dynamic>{
      'name': instance.name,
      'formatted_address': instance.formattedAddress,
      'formatted_phone_number': instance.formattedPhoneNumber,
      'rating': instance.rating,
      'user_ratings_total': instance.userRatingsTotal,
      'website': instance.website,
      'url': instance.mapsUrl,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'price_range': instance.priceRange,
      'fee_range': instance.feeRange,
      'speciality': instance.speciality,
      'duration': instance.duration,
      'availability': instance.availability,
      'service_type': instance.serviceType,
      'category': instance.category,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'variant_suggestion': instance.variantSuggestion,
      'body_type': instance.bodyType,
      'seats': instance.seats,
      'fuel_options': instance.fuelOptions,
      'transmission_options': instance.transmissionOptions,
      'approx_price': instance.approxPrice,
      'mpg_or_range': instance.mpgOrRange,
      'engine': instance.engine,
      'horsepower': instance.horsepower,
      'torque': instance.torque,
      'cargo_space': instance.cargoSpace,
      'ground_clearance': instance.groundClearance,
      'safety_rating': instance.safetyRating,
      'infotainment': instance.infotainment,
      'airbags': instance.airbags,
      'features_list': instance.featuresList,
      'pros': instance.pros,
      'cons': instance.cons,
      'why_it_matches': instance.whyItMatches,
      'official_url': instance.officialUrl,
      'color_hex': instance.colorHex,
      'brand_logo_letter': instance.brandLogoLetter,
      'image_url': instance.imageUrl,
      'dealers': instance.dealers,
    };
