from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import Organization, EventRequest
from rest_framework import serializers
from django.contrib.auth import authenticate,get_user_model


User = get_user_model()

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        print("[DEBUG] validate() called with:", attrs)

        email = attrs.get('email')
        password = attrs.get('password')

        user = authenticate(request=self.context.get('request'), email=email, password=password)

        if not user:
            raise serializers.ValidationError('Invalid email or password.')

        refresh = self.get_token(user)

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'email': user.email,
            'first_name': user.name.split()[0],
            'last_name': user.name.split()[1],
            'user_type': user.user_type
        }
class OrganizationProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ['name', 'category', 'description', 'logo', 'user_type']

class OrganizationRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    user_type = serializers.ChoiceField(choices=Organization.USER_TYPE_CHOICES)

    class Meta:
        model = Organization
        fields = ['email', 'name', 'password']

    def create(self, validated_data):
        org = Organization.objects.create_user(
            email=validated_data['email'],
            name=validated_data['name'],
            password=validated_data['password'],
            user_type=validated_data['user_type']
        )
        return org

class EventRequestSerializer(serializers.ModelSerializer):
    org_name = serializers.CharField(source='org.name', read_only=True)

    class Meta:
        model = EventRequest
        fields = '__all__' 
        extra_kwargs = {
            'org': {'required': False},  # ✅ Tell it not to expect org from the client
        }
    
    