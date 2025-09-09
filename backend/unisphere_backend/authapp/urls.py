from django.urls import path
from .views import RegisterView, protected_view, MyTokenObtainPairView,submit_event_request
from .views import register_organization, org_login, admin_event_requests, approve_event, reject_event, organization_events, create_event_request, get_org_events_by_status, get_posted_events,post_event,admin_dashboard
from rest_framework_simplejwt.views import TokenRefreshView


urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('protected/', protected_view, name='protected'),
    path('org/login/', org_login, name="org_login"),
    path('org/register/', register_organization, name="register_organization"),
    path('org/events/',organization_events, name ="organization_events"),
    path('event-requests/', admin_event_requests, name='admin_event_requests'),
    path('event-requests/approve/<int:event_id>/', approve_event, name='approve_event'),
    path('event-requests/reject/<int:event_id>/', reject_event, name='reject_event'),
    path('submit-event/', submit_event_request, name='submit_event'),
    path('org/events/create/', create_event_request, name='create-event'),
    path('org/events/grouped/', get_org_events_by_status, name='org_events_by_status'),
    path('events/posted/', get_posted_events, name='posted-events'),
    path('org/events/post/<int:event_id>/', post_event),
    path('admin/dashboard/', admin_dashboard, name='admin_dashboard')
]
