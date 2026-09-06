from rest_framework.permissions import BasePermission


class IsOrganizationUser(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user
            and request.user.is_authenticated
            and request.user.user_type == "organization"
        )


class IsStudentUser(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user
            and request.user.is_authenticated
            and request.user.user_type == "student"
        )
