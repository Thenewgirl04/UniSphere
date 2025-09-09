from django.shortcuts import render, get_object_or_404, redirect
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import MyTokenObtainPairSerializer, EventRequestSerializer
from .models import Organization
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.parsers import MultiPartParser, FormParser
from .serializers import OrganizationProfileSerializer, OrganizationRegisterSerializer
from rest_framework.decorators import parser_classes
from .models import EventRequest, PostedEvent
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User  # This forces the use of Django's built-in User model
from django.apps import apps

User = get_user_model()

class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self,request):
        full_name = request.data.get("full_name")
        email = request.data.get("email")
        password = request.data.get("password")
        

        if not full_name or not password or not email:
            return Response({"error": "All fields required"}, status=400)
        
        if User.objects.filter(email=email).exists():
            return Response({"error": "Username already exists with thsi email"}, status=400)
        
        names = full_name.strip().split()
        first_name = names[0]
        last_name = " ".join(names[1:]) if len(names) > 1 else ""
        
        user =Organization.objects.create_user(
            email=email,
            name=full_name,
            password=password,
            user_type='student')
        user.first_name= first_name
        user.last_name=last_name
        user.save()
        return Response({"message": "User created successfully"}, status=201)
    
class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

    def post(self, request, *args, **kwargs):
        print("[DEBUG] 🔐 Custom Token View is working.")
        print("[DEBUG] request.data:", request.data) 
        return super().post(request, *args, **kwargs)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def protected_view(request):
    return Response({
        "message": f"Hello {request.user.first_name}, your're authenticated!"
    })

@api_view(['POST'])
def register_organization(request):
    serializer = OrganizationRegisterSerializer(data=request.data)
    if serializer.is_valid():
        org = serializer.save()
        return Response({'message': 'Organization registered successfully', 'org': org.name},
                         status=201)
    return Response(serializer.errors, status=400)

@api_view(['POST'])
def org_login(request):
    email = request.data.get('email')
    password = request.data.get('password')
    org = authenticate(request, email=email, password=password)

    if org and org.user_type == 'organization':
        refresh = RefreshToken.for_user(org)
        return Response({
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "name": org.name,
            "user_type": org.user_type
        })
    return Response({"error": "Invalid credentials"}, status=400)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def update_org_profile(request):
    org = request.user
    serializer = OrganizationProfileSerializer(org, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'Profile updated successfully'}, status=200)
    return Response(serializer.errors, status=400)

def admin_event_requests(request):
    pending_events = EventRequest.objects.filter(status='pending').order_by('-created_at')
    approved_events = EventRequest.objects.filter(status='approved').order_by('-created_at')
    rejected_events = EventRequest.objects.filter(status='rejected').order_by('-created_at')
    return render(request, 'admin_dashboard.html', {
        'pending_events': pending_events,
        'approved_events': approved_events,
        'rejected_events': rejected_events,
    })

@api_view(['POST'])
@csrf_exempt
def approve_event(request, event_id):
    try:
        event = EventRequest.objects.get(pk=event_id)
        event.status = 'approved'
        event.save()
        return redirect('admin_dashboard') 
    except EventRequest.DoesNotExist:
        return Response({'error': 'Event not found'}, status=404)

@api_view(['POST'])
@csrf_exempt
def reject_event(request, event_id):
    try:
        event = EventRequest.objects.get(pk=event_id)
        event.status = 'rejected'
        event.save()
        return redirect('admin_dashboard')
    except EventRequest.DoesNotExist:
        return Response({'error': 'Event not found'}, status=404)
@csrf_exempt
@api_view(['POST'])
def submit_event_request(request):
    data= request.data
    print("Received data:", request.data)
    try:
        EventRequest.objects.create(
            name = data.get('name'),
            category = data.get('category'),
            description = data.get('description'),
            date = data.get('date'),
            time = data.get('time'),
            contact = data.get('contact'),
            org = data.get('org'),
        )
        return Response({'message': 'Request submitted'}, status=status.HTTP_201_CREATED)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_org_events_by_status(request):
    user = request.user
    try:
        org = Organization.objects.get(email=user.email)
    except Organization.DoesNotExist:
        return Response({'error': 'Organization not found'}, status=404)

    approved = EventRequest.objects.filter(org=org, status='approved')
    rejected = EventRequest.objects.filter(org=org, status='rejected')
    pending = EventRequest.objects.filter(org=org, status='pending')

    return Response({
        'approved': EventRequestSerializer(approved, many=True).data,
        'rejected': EventRequestSerializer(rejected, many=True).data,
        'pending': EventRequestSerializer(pending, many=True).data,
    })



@api_view(['GET'])
@permission_classes([IsAuthenticated])
def organization_events(request):
    org = request.user # adjust if needed
    events = EventRequest.objects.filter(org=org)
    serializer = EventRequestSerializer(events, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated]) 
def create_event_request(request):
    try:
        org = Organization.objects.get(email=request.user.email) # 👈 manually use the first org for now
    except Organization.DoesNotExist:
        return Response({"error": "No organizations found."}, status=400)
# because Organization is your user model

    serializer = EventRequestSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(org=org)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    print("Serializer errors:", serializer.errors)
    print("[DEBUG] user:", request.user)
    print("[DEBUG] auth:", request.auth)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# def post_event(request, event_id):
#     if request.method == 'POST':
#         event = get_object_or_404(EventRequest, pk = event_id)
#         image = request.FILES.get('image')

#         PostedEvent.objects.create(
#             name=event.name,
#             date=event.date,
#             time=event.time,
#             image=image,
#             org=event.org  # ✅ Include organization
#         )

# views.py
@api_view(['POST'])
@parser_classes([MultiPartParser])
@permission_classes([IsAuthenticated])
def post_event(request, event_id):
    try:
        event = EventRequest.objects.get(pk=event_id)
        if event.status != 'approved':
            return Response({'error': 'Only approved events can be posted.'}, status=400)

        flyer = request.FILES.get('image')
        if flyer:
            event.flyer = flyer

        event.status = 'posted'
        event.save()

        return Response({'message': 'Event posted successfully.'})
    except EventRequest.DoesNotExist:
        return Response({'error': 'Event not found.'}, status=404)

# views.py
@api_view(['GET'])
@permission_classes([AllowAny])
def get_posted_events(request):
    posted = EventRequest.objects.filter(status='posted')
    serializer = EventRequestSerializer(posted, many=True)
    return Response(serializer.data)

def admin_dashboard(request):
    events = EventRequest.objects.all()
    return render(request, 'admin_dashboard.html',{'events': events})
# Create your views here.
