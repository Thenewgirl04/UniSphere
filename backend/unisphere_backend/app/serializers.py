from django.contrib.auth import authenticate, get_user_model
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import EventRequest, Organization

User = get_user_model()


def split_name(full_name: str) -> tuple[str, str]:
    parts = full_name.strip().split()
    first_name = parts[0] if parts else ""
    last_name = " ".join(parts[1:]) if len(parts) > 1 else ""
    return first_name, last_name


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get("email")
        password = attrs.get("password")

        user = authenticate(
            request=self.context.get("request"), email=email, password=password
        )
        if not user:
            raise serializers.ValidationError("Invalid email or password.")

        refresh = self.get_token(user)
        first_name, last_name = split_name(user.name)

        return {
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "email": user.email,
            "name": user.name,
            "first_name": first_name,
            "last_name": last_name,
            "user_type": user.user_type,
        }


class StudentRegisterSerializer(serializers.Serializer):
    full_name = serializers.CharField(max_length=255)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=6)

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("An account with this email already exists.")
        return value

    def create(self, validated_data):
        return Organization.objects.create_user(
            email=validated_data["email"],
            name=validated_data["full_name"],
            password=validated_data["password"],
            user_type="student",
        )


class OrganizationRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = Organization
        fields = ["email", "name", "password"]

    def validate_email(self, value):
        if Organization.objects.filter(email=value).exists():
            raise serializers.ValidationError("An account with this email already exists.")
        return value

    def create(self, validated_data):
        return Organization.objects.create_user(
            email=validated_data["email"],
            name=validated_data["name"],
            password=validated_data["password"],
            user_type="organization",
        )


class OrganizationProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ["name", "category", "description", "logo", "email", "user_type"]
        read_only_fields = ["email", "user_type"]


class EventRequestSerializer(serializers.ModelSerializer):
    org_name = serializers.CharField(source="org.name", read_only=True)

    class Meta:
        model = EventRequest
        fields = [
            "id",
            "name",
            "category",
            "description",
            "date",
            "time",
            "contact",
            "org",
            "org_name",
            "status",
            "flyer",
            "created_at",
        ]
        read_only_fields = ["org", "status", "created_at"]
        extra_kwargs = {"org": {"required": False}}
