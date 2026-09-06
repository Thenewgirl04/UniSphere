from django.contrib import admin

from .models import EventRequest, Organization


@admin.register(Organization)
class OrganizationAdmin(admin.ModelAdmin):
    ordering = ("email",)
    list_display = ("email", "name", "user_type", "category", "is_admin", "is_active")
    list_filter = ("user_type", "is_admin", "is_active")
    search_fields = ("email", "name")
    readonly_fields = ("last_login",)


@admin.register(EventRequest)
class EventRequestAdmin(admin.ModelAdmin):
    list_display = ("name", "org", "category", "date", "status", "created_at")
    list_filter = ("status", "category", "date")
    search_fields = ("name", "org__name", "org__email")
    readonly_fields = ("created_at",)
    actions = ["approve_events", "reject_events"]

    @admin.action(description="Approve selected events")
    def approve_events(self, request, queryset):
        updated = queryset.filter(status="pending").update(status="approved")
        self.message_user(request, f"{updated} event(s) approved.")

    @admin.action(description="Reject selected events")
    def reject_events(self, request, queryset):
        updated = queryset.filter(status="pending").update(status="rejected")
        self.message_user(request, f"{updated} event(s) rejected.")
