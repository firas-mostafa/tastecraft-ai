# Serializers for the user API view
from django.contrib.auth import (
    get_user_model,
    authenticate
    )
# from django.utils.translation import gettext as _

from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    # Serializer for the user object and their nested health profile
    age = serializers.IntegerField(required=False, allow_null=True)
    height_cm = serializers.FloatField(required=False, allow_null=True)
    weight_kg = serializers.FloatField(required=False, allow_null=True)
    is_onboarded = serializers.BooleanField(required=False, default=False)
    image = serializers.ImageField(required=False, allow_null=True)
    allergies = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    diseases = serializers.CharField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = get_user_model()
        fields = ['email', 'password', 'name', 'image', 'age', 'height_cm', 'weight_kg', 'allergies', 'diseases', 'is_onboarded']
        extra_kwargs = {'password': {'write_only': True, 'min_length': 5}}

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        health_profile = getattr(instance, 'healthprofile', None)
        if health_profile:
            ret['age'] = health_profile.age
            ret['height_cm'] = health_profile.height_cm
            ret['weight_kg'] = health_profile.weight_kg
            ret['is_onboarded'] = health_profile.is_onboarded
            ret['allergies'] = ", ".join([a.name for a in health_profile.allergies.all()])
            ret['diseases'] = ", ".join([d.name for d in health_profile.diseases.all()])
            if health_profile.image:
                request = self.context.get('request')
                if request:
                    ret['image'] = request.build_absolute_uri(health_profile.image.url)
                else:
                    ret['image'] = health_profile.image.url
            else:
                ret['image'] = None
        else:
            ret['age'] = None
            ret['height_cm'] = None
            ret['weight_kg'] = None
            ret['is_onboarded'] = False
            ret['allergies'] = ""
            ret['diseases'] = ""
            ret['image'] = None
        return ret

    def create(self, validated_data):
        age = validated_data.pop('age', None)
        height_cm = validated_data.pop('height_cm', None)
        weight_kg = validated_data.pop('weight_kg', None)
        is_onboarded = validated_data.pop('is_onboarded', False)
        image = validated_data.pop('image', None)
        allergies_str = validated_data.pop('allergies', '')
        diseases_str = validated_data.pop('diseases', '')

        user = get_user_model().objects.create_user(**validated_data)

        from core.models import HealthProfile, Allergy, Disease
        profile, _ = HealthProfile.objects.get_or_create(user=user)
        profile.age = age
        profile.height_cm = height_cm
        profile.weight_kg = weight_kg
        profile.is_onboarded = is_onboarded
        if image:
            profile.image = image
        profile.save()


        if allergies_str:
            allergy_names = [name.strip() for name in allergies_str.split(',') if name.strip()]
            for name in allergy_names:
                allergy, _ = Allergy.objects.get_or_create(name=name)
                profile.allergies.add(allergy)

        if diseases_str:
            disease_names = [name.strip() for name in diseases_str.split(',') if name.strip()]
            for name in disease_names:
                disease, _ = Disease.objects.get_or_create(name=name)
                profile.diseases.add(disease)

        return user

    def update(self, instance, validated_data):
        has_age = 'age' in validated_data
        has_height = 'height_cm' in validated_data
        has_weight = 'weight_kg' in validated_data
        has_onboarded = 'is_onboarded' in validated_data
        has_image = 'image' in validated_data
        has_allergies = 'allergies' in validated_data
        has_diseases = 'diseases' in validated_data

        age = validated_data.pop('age', None)
        height_cm = validated_data.pop('height_cm', None)
        weight_kg = validated_data.pop('weight_kg', None)
        is_onboarded = validated_data.pop('is_onboarded', None)
        image = validated_data.pop('image', None)
        allergies_str = validated_data.pop('allergies', None)
        diseases_str = validated_data.pop('diseases', None)

        password = validated_data.pop('password', None)
        user = super().update(instance, validated_data)

        if password:
            user.set_password(password)
            user.save()

        from core.models import HealthProfile, Allergy, Disease
        profile, _ = HealthProfile.objects.get_or_create(user=user)

        if has_age:
            profile.age = age
        if has_height:
            profile.height_cm = height_cm
        if has_weight:
            profile.weight_kg = weight_kg
        if has_onboarded:
            profile.is_onboarded = is_onboarded
        if has_image:
            profile.image = image
        profile.save()

        if has_allergies:
            profile.allergies.clear()
            if allergies_str:
                allergy_names = [name.strip() for name in allergies_str.split(',') if name.strip()]
                for name in allergy_names:
                    allergy, _ = Allergy.objects.get_or_create(name=name)
                    profile.allergies.add(allergy)

        if has_diseases:
            profile.diseases.clear()
            if diseases_str:
                disease_names = [name.strip() for name in diseases_str.split(',') if name.strip()]
                for name in disease_names:
                    disease, _ = Disease.objects.get_or_create(name=name)
                    profile.diseases.add(disease)

        return user


class AuthTokenSerializer(serializers.Serializer):
    # Serializer for user auth token
    email = serializers.EmailField()
    password = serializers.CharField(
        style={'input_type': 'password'},
        trim_whitespace=False,
    )

    def validate(self, attrs):
        # Validate and authenticate the user

        email = attrs.get('email')
        password = attrs.get('password')
        user = authenticate(
            request=self.context.get('request'),
            username=email,
            password=password
        )
        if not user:
            msg = ('Unable to authenticate with provided credentials')
            raise serializers.ValidationError(msg, code='authorization')

        attrs['user'] = user
        return attrs


class UserImageSerializer(serializers.Serializer):
    email = serializers.EmailField(read_only=True)
    image = serializers.ImageField(required=True)

    def update(self, instance, validated_data):
        image = validated_data.pop('image', None)
        from core.models import HealthProfile
        profile, _ = HealthProfile.objects.get_or_create(user=instance)
        if image:
            profile.image = image
            profile.save()
        return instance

    def to_representation(self, instance):
        ret = {
            'email': instance.email
        }
        health_profile = getattr(instance, 'healthprofile', None)
        if health_profile and health_profile.image:
            request = self.context.get('request')
            if request:
                ret['image'] = request.build_absolute_uri(health_profile.image.url)
            else:
                ret['image'] = health_profile.image.url
        else:
            ret['image'] = None
        return ret

