from rest_framework import status
from rest_framework.decorators import api_view, parser_classes, permission_classes
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import EventRequest, Organization
from .permissions import IsOrganizationUser
from .serializers import (
    EventRequestSerializer,
    MyTokenObtainPairSerializer,
    OrganizationProfileSerializer,
    OrganizationRegisterSerializer,
    StudentRegisterSerializer,
)


class StudentRegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = StudentRegisterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "User created successfully"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class OrganizationRegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OrganizationRegisterSerializer(data=request.data)
        if serializer.is_valid():
            org = serializer.save()
            return Response(
                {"message": "Organization registered successfully", "name": org.name},
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer


@api_view(["GET"])
@permission_classes([AllowAny])
def posted_events(request):
    events = EventRequest.objects.filter(status="posted")
    serializer = EventRequestSerializer(events, many=True)
    return Response(serializer.data)


@api_view(["POST"])
@permission_classes([IsAuthenticated, IsOrganizationUser])
def create_event(request):
    serializer = EventRequestSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(org=request.user, status="pending")
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET"])
@permission_classes([IsAuthenticated, IsOrganizationUser])
def my_events(request):
    org = request.user
    events = EventRequest.objects.filter(org=org)
    grouped = {
        "pending": EventRequestSerializer(events.filter(status="pending"), many=True).data,
        "approved": EventRequestSerializer(events.filter(status="approved"), many=True).data,
        "rejected": EventRequestSerializer(events.filter(status="rejected"), many=True).data,
        "posted": EventRequestSerializer(events.filter(status="posted"), many=True).data,
    }
    return Response(grouped)


@api_view(["POST"])
@permission_classes([IsAuthenticated, IsOrganizationUser])
@parser_classes([MultiPartParser, FormParser])
def post_event(request, event_id):
    try:
        event = EventRequest.objects.get(pk=event_id, org=request.user)
    except EventRequest.DoesNotExist:
        return Response({"error": "Event not found."}, status=status.HTTP_404_NOT_FOUND)

    if event.status != "approved":
        return Response(
            {"error": "Only approved events can be posted."},
            status=status.HTTP_400_BAD_REQUEST,
        )

    flyer = request.FILES.get("image")
    if flyer:
        event.flyer = flyer

    event.status = "posted"
    event.save()
    return Response(
        {"message": "Event posted successfully.", "event": EventRequestSerializer(event).data}
    )


@api_view(["GET", "PUT"])
@permission_classes([IsAuthenticated, IsOrganizationUser])
@parser_classes([MultiPartParser, FormParser])
def org_profile(request):
    org = request.user
    if request.method == "GET":
        serializer = OrganizationProfileSerializer(org)
        return Response(serializer.data)

    serializer = OrganizationProfileSerializer(org, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"message": "Profile updated successfully", "profile": serializer.data})
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
