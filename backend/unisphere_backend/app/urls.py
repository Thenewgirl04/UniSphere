from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from .views import (
    MyTokenObtainPairView,
    OrganizationRegisterView,
    StudentRegisterView,
    create_event,
    my_events,
    org_profile,
    post_event,
    posted_events,
)

urlpatterns = [
    path("register/", StudentRegisterView.as_view(), name="register"),
    path("org/register/", OrganizationRegisterView.as_view(), name="register_organization"),
    path("token/", MyTokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("events/posted/", posted_events, name="posted-events"),
    path("events/", create_event, name="create-event"),
    path("events/mine/", my_events, name="my-events"),
    path("events/<int:event_id>/post/", post_event, name="post-event"),
    path("org/profile/", org_profile, name="org-profile"),
]
