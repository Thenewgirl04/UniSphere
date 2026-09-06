from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models


class OrgManager(BaseUserManager):
    def create_user(self, email, name, password=None, user_type="organization"):
        if not email:
            raise ValueError("User must have an email")
        email = self.normalize_email(email)
        user = self.model(email=email, name=name, user_type=user_type)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, password=None):
        user = self.create_user(email, name, password, user_type="organization")
        user.is_admin = True
        user.is_superuser = True
        user.save(using=self._db)
        return user


class Organization(AbstractBaseUser, PermissionsMixin):
    USER_TYPE_CHOICES = (
        ("student", "Student"),
        ("organization", "Organization"),
    )

    email = models.EmailField(unique=True)
    name = models.CharField(max_length=255)
    user_type = models.CharField(
        max_length=20, choices=USER_TYPE_CHOICES, default="organization"
    )
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    category = models.CharField(max_length=100, blank=True)
    description = models.TextField(blank=True)
    logo = models.ImageField(upload_to="org_logos/", blank=True, null=True)

    objects = OrgManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    def __str__(self):
        return self.name

    @property
    def is_staff(self):
        return self.is_admin


class EventRequest(models.Model):
    CATEGORY_CHOICES = [
        ("Technology", "Technology"),
        ("Arts", "Arts"),
        ("Health", "Health"),
        ("Sports", "Sports"),
    ]

    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("approved", "Approved"),
        ("rejected", "Rejected"),
        ("posted", "Posted"),
    ]

    name = models.CharField(max_length=100)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    description = models.TextField()
    date = models.DateField()
    time = models.TimeField()
    contact = models.CharField(max_length=100, blank=True)
    org = models.ForeignKey(
        Organization, on_delete=models.CASCADE, related_name="event_requests"
    )
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")
    flyer = models.ImageField(upload_to="flyers/", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} ({self.status})"

    class Meta:
        ordering = ["-created_at"]
